package com.yhams.common;

import java.util.ArrayList;
import java.util.HashMap;

public interface CommonService {

	String getUserNextSeq() throws Exception;

	String getNextCodeId() throws Exception;
	
	String getNextRoleId() throws Exception;
	
	String getNextMenuId() throws Exception;
	
	long getNextActLogSeq() throws Exception;
	
	String getNextAccountCd() throws Exception;
	
	String getNextUedSeq() throws Exception;
	
	ArrayList<HashMap<String, Object>> getCgList(String codeGrp, String useYn) throws Exception;

	ArrayList<HashMap<String, Object>> getCgListByParCode(String codeGrp, String parCode, String useYn) throws Exception;

}
