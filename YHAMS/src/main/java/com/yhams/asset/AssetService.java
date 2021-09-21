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

}
