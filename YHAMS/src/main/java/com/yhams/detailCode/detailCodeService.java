package com.yhams.detailCode;

import java.util.ArrayList;
import java.util.HashMap;

public interface detailCodeService {

	HashMap<String, Object> selectCodeCd(HashMap<String, Object> param) throws Exception;

	long dtlCodeCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> dtlCodeList(HashMap<String, Object> param) throws Exception;

	int insertDtlCode(HashMap<String, Object> param) throws Exception;

	int updateDtlCode(HashMap<String, Object> param) throws Exception;

}
