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


}
