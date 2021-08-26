package com.yhams.menu;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MenuServiceImpl implements MenuService {
	
	@Autowired
	MenuMapper menuMapper;

	@Override
	public ArrayList<HashMap<String, Object>> getMenuList() throws Exception {
		return menuMapper.getMenuList();
	}

	@Override
	public long menuCount(HashMap<String, Object> param) throws Exception {
		return menuMapper.menuCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> menuList(HashMap<String, Object> param) throws Exception {
		return menuMapper.menuList(param);
	}

}
