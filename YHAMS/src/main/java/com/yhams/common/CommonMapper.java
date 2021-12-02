package com.yhams.common;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommonMapper {

	String getUserNextSeq() throws Exception;

	String getNextCodeId() throws Exception;

	String getNextRoleId() throws Exception;
	
	String getNextMenuId() throws Exception;
	
	String getNextAccountCd() throws Exception;

	String getNextUedSeq() throws Exception;

	String getNextSalSeq() throws Exception;
	
	long getNextActLogSeq() throws Exception;
	
	ArrayList<HashMap<String, Object>> getCgList(HashMap<String, Object> param) throws Exception;

	void insertUserActLog(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getCgListByParCode(HashMap<String, Object> param) throws Exception;

}
