package com.selenium.util;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.stereotype.Component;

import com.selenium.bean.DetailInfo;
import com.selenium.bean.FilterBean;
import com.selenium.bean.KeywordBean;
import com.selenium.bean.Operation;
import com.selenium.bean.SeleniumAutomationStatus;
import com.selenium.bean.TestCaseBean;
import com.selenium.bean.TestCaseResultBean;
import com.selenium.bean.TestCaseStep;
import com.selenium.bean.TestRunBean;
import com.selenium.bean.TestStepResultBean;
import com.selenium.dao.KeywordExecuterDao;
import com.selenium.dao.TestCaseDao;
import com.selenium.dao.TestCaseResultDao;
import com.selenium.dao.TestCaseStepDao;
import com.selenium.dao.TestRunResultDao;
import com.selenium.dao.TestStepResultDao;
import com.selenium.dao.UtilDao;

@Component
public class TestSuiteUtility {

	@Autowired
	TestCaseDao testCaseDao;

	@Autowired
	TestCaseStepDao testCaseStepDao;

	@Autowired
	TestRunResultDao testRunResultDao;

	@Autowired
	TestCaseResultDao testCaseResultDao;

	@Autowired
	TestStepResultDao testStepResultDao;

	@Autowired
	UtilDao utilDao;

	@Autowired
	KeywordExecuterDao keywordExecuterDao;

	@Autowired
	SeleniumLogger logger;
	
	@Autowired
	@Qualifier("seleniumlabel")
	ResourceBundleMessageSource resourceBundle;
	
	public void startTestRun(TestRunBean testRunBean) {
		String exePath = "/Drivers/chromedriver.exe";
		URL server = null;
		try {
			server = new URL("http://192.168.0.105:4444/wd/hub");
		} catch (MalformedURLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	    DesiredCapabilities capabilities = new DesiredCapabilities();
	    capabilities.setBrowserName("chrome");
	    WebDriver webdriver = new RemoteWebDriver(server, capabilities);
		// bean = new TestRunBean();
		// List<String> lst = new ArrayList<String>();
		// lst.add("TST001");
		// bean.setTestCaseIds(lst);
		testRunBean.setTestRunBy("Naresh");
		testRunBean.setStatus(SeleniumAutomationStatus.INPROGRESS);
		testRunBean.setTestRunID(utilDao.getUniqueId());
		testRunResultDao.addRecord(testRunBean);
		List<TestCaseBean> testCaseList = testCaseDao
				.readTestCaseList(testRunBean);
		try {
			startExecution(testCaseList, testRunBean, webdriver);
			webdriver.close();
		} catch (Exception e) {
			webdriver.close();
			e.printStackTrace();

		}
		testRunBean.setStatus(SeleniumAutomationStatus.COMPLETED);
		testRunResultDao.updateRecord(testRunBean);
	}

	public void startExecution(List<TestCaseBean> testCaseList,
			TestRunBean testRunBean, WebDriver webdriver) throws Exception {
		TestCaseResultBean testCaseResultBean = null;
		TestStepResultBean testStepResultBean = null;
		boolean testCaseSuccess = true;
		boolean success = true;
		Map<String, KeywordBean> keywordMap = this.getKeywordList(null);
		for (TestCaseBean bean : testCaseList) {
			testCaseSuccess = true;
			success = true;
			testCaseResultBean = new TestCaseResultBean();
			testCaseResultBean.setTestRunID(testRunBean.getTestRunID());
			testCaseResultBean.setTestCaseId(bean.getTestCaseId());
			testCaseResultBean.setRecordId(bean.getRecordId());
			testCaseResultBean.setStatus(SeleniumAutomationStatus.INPROGRESS);
			testCaseResultDao.addRecord(testCaseResultBean);
			List<TestCaseStep> steps = testCaseStepDao.readTestCaseSteps(bean
					.getRecordId());
			for (TestCaseStep step : steps) {
				testStepResultBean = new TestStepResultBean();
				testStepResultBean.setTestRunID(testCaseResultBean
						.getTestRunID());
				testStepResultBean.setTestCaseId(testCaseResultBean
						.getTestCaseId());
				testStepResultBean.setRecordId(step.getRecordId());
				testStepResultBean.setParentRecordKey(bean.getRecordId());
				testStepResultBean.setTestStepId(step.getTestStepId());
				testStepResultBean.setDetails(logger.logSuccess(testStepResultBean, step, keywordMap));
				KeywordExecuter executer = new KeywordExecuter(webdriver,
						keywordExecuterDao);
				try {
					executer.perform(null, step.getKeyword(),
							step.getObjectName(), step.getObjectType(),
							step.getInputData());
				} catch (NoSuchElementException exc) {
					success = false;
					testStepResultBean.setDetails(logger.logElementNotFound(testStepResultBean, step, keywordMap));
				} catch (Exception exc) {
					success = false;
				}
				if (success) {
					testStepResultBean
							.setStatus(SeleniumAutomationStatus.PASSED);
					testStepResultDao.addRecord(testStepResultBean);
				} else {
					testStepResultBean
							.setStatus(SeleniumAutomationStatus.FAILED);
					testCaseSuccess = false;
					testStepResultDao.addRecord(testStepResultBean);
					
					CommonFunctions.getscreenshot(webdriver, testRunBean.getTestRunID()+"_"+step.getTestStepId());
					
					break;
				}
			}
			if (testCaseSuccess) {
				testCaseResultBean.setStatus(SeleniumAutomationStatus.PASSED);
			} else {
				testCaseResultBean.setStatus(SeleniumAutomationStatus.FAILED);
			}
			testCaseResultDao.updateRecord(testCaseResultBean);
		}
	}

	public Map<String, KeywordBean> getKeywordList(FilterBean filterBean)
	{
		List<KeywordBean> keywordList = new ArrayList<KeywordBean>();
		Operation oprList[] = Operation.values();
		KeywordBean bean = null;
		Map<String, KeywordBean> keywordmap = new HashMap<String, KeywordBean>();
		for(Operation operation : oprList)
		{
			bean = new KeywordBean();
			try
			{
				bean.setKeyword(operation.getCode());
				bean.setDescription(operation.getDescription());
				bean.setReportSucessMessage(resourceBundle.getMessage("reportinfo.keyword."+operation.getCode()+".PASSED", null, null));
				bean.setReportErrorMessage(resourceBundle.getMessage("reportinfo.keyword."+operation.getCode()+".FAILED", null, null));
			}
			catch(Exception e)
			{
				
			}
			if(operation.isExternal())
				keywordList.add(bean);
		}
		List<FilterBean> lstresults = testCaseDao.getValueList("KEYWORD", filterBean);
		for(FilterBean fBean : lstresults)
		{
			bean = new KeywordBean();
			bean.setKeyword(fBean.getValue());
			bean.setDescription(fBean.getDescription());
			bean.setReportSucessMessage(fBean.getValue1());
			bean.setReportErrorMessage(fBean.getValue2());
			keywordList.add(bean);
		}
		
		for(KeywordBean fbean : keywordList)
		{
			keywordmap.put(fbean.getKeyword(), fbean);
		}
		return keywordmap;
	}
	
	public static void main(String a[]) {
		TestSuiteUtility t = new TestSuiteUtility();
		try {
			t.startExecution(null, null, null);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
