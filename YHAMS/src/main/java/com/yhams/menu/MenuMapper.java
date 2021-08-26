package com.yhams.menu;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MenuMapper {

	ArrayList<HashMap<String, Object>> getMenuList() throws Exception;

	long menuCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> menuList(HashMap<String, Object> param)  throws Exception;

}
