package com.mocktest;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SplitTest {

	public static void main(String[] args) {
		Pattern p = Pattern.compile("[1-9]{1,2}.Version");
		 String str ="12.VersionFirstReleaseIdDisplayName2.VersionReleaseIdDisplayName";
		Matcher m = p.matcher(str );
		 List<String> lstVersions = new LinkedList<String>();
		 while(m.find()) {
			 System.out.println(m.group(0));
			 lstVersions.add(m.group(0).replaceAll(".Version", ""));
		 }
		 Map<String, String> versionMap = new HashMap<String, String>();
		 for(int i = 0; i < lstVersions.size(); i++) {
			 String tempStr = str;
			 int start = tempStr.indexOf(lstVersions.get(i)+".Version");
			 int end = 0;
			 tempStr = tempStr.replace(lstVersions.get(i)+".Version", "");
			 if(i+1 == lstVersions.size()) {
				 end = tempStr.length() - 1;
			 }
			 else {
				 end = tempStr.indexOf(lstVersions.get(i+1)+".Version");
			 }
			 versionMap.put(lstVersions.get(i), tempStr.substring(start,end));
		 }
		 
		 
		String lineStr = "12.VersionFirstReleaseIdDisplayName2.VersionReleaseIdDisplayName";
		String lines[] = lineStr.split("[1-9]{1,2}.Version");
		for(String line : lines) {
			System.out.println(line);
		}
	}
}
