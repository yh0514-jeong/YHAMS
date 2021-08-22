package com.yhams.detailCode;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DetailCodeMapper {


	HashMap<String, Object> selectCodeCd(HashMap<String, Object> param) throws Exception;

	long dtlCodeCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> dtlCodeList(HashMap<String, Object> param)  throws Exception;

	int insertDtlCode(HashMap<String, Object> param) throws Exception;

	int updateDtlCode(HashMap<String, Object> param) throws Exception;

}
