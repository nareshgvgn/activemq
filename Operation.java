package com.selenium.bean;

public enum Operation {

	CUSTOM(null, "", false), CLICK("CLICK", "Click", true), SETTEXT("SETTEXT",
			"Set Text", true), GOTOURL("GOTOURL", "Go to Url", true), GETTEXT(
			"GETTEXT", "Get Text", true), WAITFORPAGELOAD("WAITFORPAGELOAD",
			"Wait For Page Load", true),VERIFY_TEXT("VERIFY_TEXT","Verify text", true),CREATE_VARIABLE("CREATE_VARIABLE", "Create Variable", true);

	String code;
	String description;
	boolean isExternal;

	Operation(String code, String description, boolean isExternal) {
		this.code = code;
		this.description = description;
		this.isExternal = isExternal;
	}

	public static Operation valueOfKeyword(String keyword) {
		Operation result = null;
		try {
			result = Operation.valueOf(keyword);
		} catch (Exception exc) {
			result = Operation.CUSTOM;
		}
		return result;
	}

	public String getCode() {
		return code;
	}

	public String getDescription() {
		return description;
	}

	public boolean isExternal() {
		return isExternal;
	}
}
