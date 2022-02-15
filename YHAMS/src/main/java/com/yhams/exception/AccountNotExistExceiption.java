package com.yhams.exception;

public class AccountNotExistExceiption extends RuntimeException{
	
	private static final long serialVersionUID = -3563027447699525063L;

	public AccountNotExistExceiption() {
		  super("Account does not exist");
	} 

}
