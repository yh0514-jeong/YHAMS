package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

public interface AssetService {

	long accountCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectAccount(String accountCd) throws Exception;

	int insertAccount(HashMap<String, Object> param) throws Exception;

	int updateAccount(HashMap<String, Object> param) throws Exception;

	int deleteAccount(HashMap<String, Object> param) throws Exception;

	long unearnedCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> unearnedListUp(HashMap<String, Object> param) throws Exception;

	int saveUnearnedList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectUnearned(String param) throws Exception;

	int updateUnearned(HashMap<String, Object> param) throws Exception;

	int deleteUnearedList(HashMap<String, Object> param) throws Exception;

	int saveSalaryList(HashMap<String, Object> param) throws Exception;

	long salaryCount(HashMap<String, Object> param)  throws Exception;

	ArrayList<HashMap<String, Object>> salaryListUp(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getPayDedList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> getSalSeqDate(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getLastSalary(HashMap<String, Object> param) throws Exception;

	int dupChkSalMonth(HashMap<String, Object> param) throws Exception;

	String chkYearlyAssetPlanExist(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> userYearlyPlanTemplate(HashMap<String, Object> param) throws Exception;

	int saveYearlyAssetPlanList(HashMap<String, Object> param) throws Exception;

	int deleteYearlyAssetPlanList(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> yearlyAssetPlanList(HashMap<String, Object> param) throws Exception;

}
