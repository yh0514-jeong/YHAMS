package com.yhams.login;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginServiceImpl implements LoginService {
	
	@Autowired
	LoginMapper mapper;

	@Override
	public ArrayList<HashMap<String, Object>> getLogininfo(HashMap<String, Object> param) throws Exception {
		return mapper.getLogininfo(param);
	}

	@Override
	@Transactional
	public int insertUser(HashMap<String, Object> param) throws Exception {
		return mapper.insertUser(param);
	}

	@Override
	public String chkUserInfo(HashMap<String, Object> param) throws Exception {
		return mapper.chkUserInfo(param);
	}

	@Override
	public HashMap<String, Object> getUserInfo(HashMap<String, Object> param) throws Exception {
		return mapper.getUserInfo(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getUserMenuList(HashMap<String, Object> param) throws Exception {
		return mapper.getUserMenuList(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getSubMenuList(HashMap<String, Object> param) throws Exception {
		return mapper.getSubMenuList(param);
	}

}
