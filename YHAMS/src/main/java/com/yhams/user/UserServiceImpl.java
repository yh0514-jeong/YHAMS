package com.yhams.user;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService{
	
	@Autowired
	UserMapper mapper;

	@Override
	public ArrayList<HashMap<String, Object>> getUserList(HashMap<String, Object> param) throws Exception {
		return mapper.getUserList(param);
	}

}
