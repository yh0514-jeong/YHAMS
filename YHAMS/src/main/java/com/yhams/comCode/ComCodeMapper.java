package com.yhams.comCode;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ComCodeMapper {

	int insertComCode(HashMap<String, Object> param) throws Exception;

	int updateComCode(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> comCodeListUp(HashMap<String, Object> param) throws Exception;

	int comCodeCount(HashMap<String, Object> param)  throws Exception;

	HashMap<String, Object> selectCodeId(String codeId) throws Exception;

	ArrayList<HashMap<String, Object>> getComCodeUseList() throws Exception;

}
