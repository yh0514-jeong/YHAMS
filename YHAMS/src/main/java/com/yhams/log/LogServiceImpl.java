package com.yhams.log;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yhams.common.CommonMapper;
import com.yhams.common.CommonService;

@Service
public class LogServiceImpl implements LogService {
	
	private static final Logger logger = LoggerFactory.getLogger(LogServiceImpl.class);
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	LogMapper mapper;
	

	@Override
	public void insertUserActLog(HttpServletRequest request, HttpSession session) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		try {
			param.put("ACT_LOG_SEQ", commonService.getNextActLogSeq());
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			param.put("MENU_URL", request.getRequestURI());
			param.put("IP_ADDR",  request.getRemoteAddr());
			mapper.insertUserActLog(param);
		}catch (Exception e) {
			logger.info("insertUserActLog fail....");
			e.printStackTrace();
		}finally {
			logger.info("insertUserActLog, param()==>" + param.toString());
		}
		
	}

}
