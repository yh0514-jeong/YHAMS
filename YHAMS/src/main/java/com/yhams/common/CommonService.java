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
	
	/*
	 * @Description 코드그룹 리스트 가져오기
	 * @Param codeGrp : 코드그룹,
	 *        useYn   : 사용여부  - ALL(y,n 상관없이 모두 다), Y(y만), N(n만) 
	 * 
	 */
	ArrayList<HashMap<String, Object>> getCgList(String codeGrp, String useYn) throws Exception;

	

}
