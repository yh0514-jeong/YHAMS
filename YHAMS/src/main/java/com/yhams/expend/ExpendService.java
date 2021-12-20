package com.yhams.expend;

import java.util.ArrayList;
import java.util.HashMap;

public interface ExpendService {

	int saveDepWithdralList(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getAccountList(HashMap<String, Object> param) throws Exception;

	long depWithdralCount(HashMap<String, Object> param) throws Exception;
	
	ArrayList<HashMap<String, Object>> depWithdralList(HashMap<String, Object> param) throws Exception;

	int deleteDepWithdrawalList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selecteDepWithdrawal(String ACT_SEQ) throws Exception;

	int updateDepWithdrawl(HashMap<String, Object> param) throws Exception;

	String chkDupYearMonth(HashMap<String, Object> param) throws Exception;

}
