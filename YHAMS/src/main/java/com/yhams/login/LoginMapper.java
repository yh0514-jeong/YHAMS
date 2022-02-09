package com.yhams.login;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginMapper {

	ArrayList<HashMap<String, Object>> getLogininfo(HashMap<String, Object> param) throws Exception;

	int insertUser(HashMap<String, Object> param)  throws Exception;

	String chkUserInfo(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> getUserInfo(HashMap<String, Object> param)  throws Exception;

	ArrayList<HashMap<String, Object>> getUserMenuList(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getSubMenuList(HashMap<String, Object> param) throws Exception;

	String idDupChk(HashMap<String, Object> param) throws Exception;

	int insertDefaultRole(HashMap<String, Object> param) throws Exception;

}
