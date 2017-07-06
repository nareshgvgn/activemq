package com.selenium.util;

import java.util.Properties;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.selenium.bean.KeywordBean;
import com.selenium.bean.Operation;
import com.selenium.dao.KeywordExecuterDao;

public class KeywordExecuter {
	WebDriver driver;

	KeywordExecuterDao keywordExecuterDao;

	public KeywordExecuter(WebDriver driver,
			KeywordExecuterDao keywordExecuterDao) {
		this.driver = driver;
		this.keywordExecuterDao = keywordExecuterDao;
	}

	public void perform(Properties p, String keyword, String objectName,
			String objectType, String value) throws Exception {
		Operation opr = Operation.valueOfKeyword(keyword);
		switch (opr) {
		case CLICK:
			driver.findElement(this.getObject(p, objectName, objectType))
					.click();
			break;
			
		case SETTEXT:
			driver.findElement(this.getObject(p, objectName, objectType))
					.sendKeys(value);
			break;
		case GOTOURL:
			driver.get(value);
			
			break;
		case GETTEXT:
			driver.findElement(this.getObject(p, objectName, objectType))
					.getText();
			break;
		case VERIFY_TEXT :
			String textToVerify = value;
			if(textToVerify.startsWith("${")){
				textToVerify = p.getProperty(textToVerify);
			}
			if(!driver.findElement(this.getObject(p, objectName, objectType)).getText().equals(textToVerify))
				throw new Exception("Unable to verify the Texts");
			break;
		case WAITFORPAGELOAD:
			ExpectedCondition<Boolean> expectation = new ExpectedCondition<Boolean>() {
				public Boolean apply(WebDriver driver) {
					return ((JavascriptExecutor) driver)
							.executeScript("return document.readyState")
							.toString().equals("complete");
				}
			};
			try {
				Thread.sleep(1000);
				WebDriverWait wait = new WebDriverWait(driver, 500);
				wait.until(expectation);
			} catch (Throwable error) {
				throw new Exception(
						"Timeout waiting for Page Load Request to complete.");
			}
			break;
			
		case CUSTOM:
			KeywordBean kBean = keywordExecuterDao.getJavaCode(keyword);
			String javaCode = kBean.getJavaCode();
			CompileSourceInMemory.executeJavaCode(javaCode,
					kBean.getClassName(), driver);
			break;
		
		case CREATE_VARIABLE :
			createVariable(driver, p, objectName, objectType, value);
			break;
		default:
			break;
		}

	}

	private void createVariable(WebDriver driver, Properties props, String objectName, String objectType, String value) throws Exception 
	{
		WebElement element = driver.findElement(this.getObject(props, objectName, objectType));
		props.setProperty(value, element.getText());
	}

	/**
	 * Find element BY using object type and value
	 * 
	 * @param p
	 * @param objectName
	 * @param objectType
	 * @return
	 * @throws Exception
	 */
	private By getObject(Properties p, String objectName, String objectType)
			throws Exception {
		// Find by xpath
		if (objectType.equalsIgnoreCase("XPATH")) {

			return By.xpath(objectName);
		}
		// find by class
		else if (objectType.equalsIgnoreCase("CLASSNAME")) {

			return By.className(objectName);

		}
		// find by name
		else if (objectType.equalsIgnoreCase("NAME")) {

			return By.name(objectName);

		}
		// Find by css
		else if (objectType.equalsIgnoreCase("CSS")) {

			return By.cssSelector(objectName);

		}
		// find by link
		else if (objectType.equalsIgnoreCase("LINK")) {

			return By.linkText(objectName);

		} else if (objectType.equalsIgnoreCase("ID")) {

			return By.id(objectName);

		}
		// find by partial link
		else if (objectType.equalsIgnoreCase("PARTIALLINK")) {

			return By.partialLinkText(objectName);

		} else {
			throw new Exception("Wrong object type");
		}
	}
}
