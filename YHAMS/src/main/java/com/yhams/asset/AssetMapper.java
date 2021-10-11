package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AssetMapper {

	long accountCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectAccount(String ACCOUNT_CD) throws Exception;

	int insertAccount(HashMap<String, Object> param) throws Exception;

	int updateAccount(HashMap<String, Object> param) throws Exception;

	int deleteAccount(HashMap<String, Object> param) throws Exception;

	long unearnedCount(HashMap<String, Object> param)  throws Exception;

	ArrayList<HashMap<String, Object>> unearnedListUp(HashMap<String, Object> param) throws Exception;

	int saveUnearned(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectUnearned(String param) throws Exception;

	int updateUnearned(HashMap<String, Object> param) throws Exception;

	int deleteUnearedList(HashMap<String, Object> param) throws Exception;

	int deleteSalSeq(HashMap<String, Object> param) throws Exception;

	int saveSalaryList(HashMap<String, Object> map) throws Exception;

	long salaryCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> salaryListUp(HashMap<String, Object> param) throws Exception;
}
