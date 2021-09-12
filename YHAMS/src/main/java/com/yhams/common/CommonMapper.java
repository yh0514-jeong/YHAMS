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
	
	long getNextActLogSeq() throws Exception;
	
	ArrayList<HashMap<String, Object>> getCgList(String codeGrp, String useYn) throws Exception;

	void insertUserActLog(HashMap<String, Object> param) throws Exception;

	

}
