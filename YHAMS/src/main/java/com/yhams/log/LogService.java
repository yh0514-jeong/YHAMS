package com.yhams.log;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public interface LogService {

	void insertUserActLog(HttpServletRequest request, HttpSession session);

}
