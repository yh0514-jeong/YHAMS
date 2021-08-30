package com.yhams.menu;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MenuMapper {

	ArrayList<HashMap<String, Object>> getMenuList() throws Exception;

	long menuCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> menuList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectMenu(String param) throws Exception;

	int insertMenu(HashMap<String, Object> param) throws Exception;

	int updatetMenu(HashMap<String, Object> param) throws Exception;

}
