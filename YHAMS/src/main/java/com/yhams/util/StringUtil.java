package com.yhams.util;

public class StringUtil {

	
	public static String StringNVL(Object str) {
		if(str == null || "".equals(str.toString().trim())) {
			return null;
		}else if("undefined".equals(str.toString())){
			return null;
		}else{
			return str.toString();
		}
	}

	
	public Integer IntegerNVL(Object integer) {
		
		
		
		
		return null;
	}
	
}
