package com.yhams.user;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {

	ArrayList<HashMap<String, Object>> getUserList(HashMap<String, Object> param) throws Exception;

	long userCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> userList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> getUserInfo(String param) throws Exception;

}
