package com.yhams.exception;

public class AccoutnNotExistExceiption extends RuntimeException{
	
	private static final long serialVersionUID = -3563027447699525063L;

	public AccoutnNotExistExceiption() {
		  super("Account does not exist");
	} 

}
