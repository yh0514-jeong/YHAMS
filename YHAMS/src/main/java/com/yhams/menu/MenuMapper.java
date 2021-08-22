package com.yhams.menu;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MenuMapper {

	ArrayList<HashMap<String, Object>> getMenuList() throws Exception;

}
