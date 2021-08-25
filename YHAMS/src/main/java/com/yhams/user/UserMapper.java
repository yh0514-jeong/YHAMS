package com.yhams.user;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {

	ArrayList<HashMap<String, Object>> getUserList(HashMap<String, Object> param) throws Exception;

}
