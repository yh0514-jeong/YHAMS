package com.yhams.exception;

public class SaveUserInfoException extends RuntimeException {
	
	private static final long serialVersionUID = 8531299714306544036L;

	public SaveUserInfoException(String userId) {
		  super("Fail to SAve UserInfo, userId : " + userId);
	} 

}
