package com.selenium.util;

import java.util.Properties;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

import com.selenium.bean.Operation;

public class KeywordExecuter {
	WebDriver driver;

	public KeywordExecuter(WebDriver driver) {
		this.driver = driver;
	}

	public void perform(Properties p, String operation, String objectName,
			String objectType, String value) throws Exception {
		System.out.println("");
		Operation opr = Operation.valueOf(operation);
		switch (opr) {
		case CLICK:
			// Perform click
			driver.findElement(this.getObject(p, objectName, objectType))
					.click();
			break;
		case SETTEXT:
			// Set text on control
			driver.findElement(this.getObject(p, objectName, objectType))
					.sendKeys(value);
			break;

		case GOTOURL:
			// Get url of application
			driver.get(value);
			break;
		case GETTEXT:
			// Get text of an element
			driver.findElement(this.getObject(p, objectName, objectType))
					.getText();
			break;
		default:
			break;
		}
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
