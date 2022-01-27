package com.yhams.exception;

public class StdYearNotFoundException extends RuntimeException {
	
	private static final long serialVersionUID = 9168189618199763562L;
	
	public StdYearNotFoundException(String stdYearMonth) {
		  super("stdYearMonth is not defined, stdYearMonth : " + stdYearMonth);
	} 

}
