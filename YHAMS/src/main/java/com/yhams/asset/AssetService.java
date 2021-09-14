package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

public interface AssetService {

	long accountCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectAccount(String aCCOUNT_CD) throws Exception;

}
