package com.yhams.exception;

public class YearlyPlanNotDefinedException extends RuntimeException {

	private static final long serialVersionUID = 1056485462073415471L;
	
	public YearlyPlanNotDefinedException(String stdYearMonth) {
		super("Yearly plan is not defined, stdYearMonth : " + stdYearMonth);
	}
	

}
