package com.yhams.menu;

import java.util.ArrayList;
import java.util.HashMap;

public interface MenuService {

	ArrayList<HashMap<String, Object>> getMenuList() throws Exception;

	long menuCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> menuList(HashMap<String, Object> param) throws Exception;

}
