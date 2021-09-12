package com.yhams.user;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.stereotype.Service;

@Service
public interface UserService {

	ArrayList<HashMap<String, Object>> getUserList(HashMap<String, Object> param) throws Exception;

	long userCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> userList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> getUserInfo(String userSeq) throws Exception;

	void updateUser(HashMap<String, Object> param) throws Exception;

	void initPwd(HashMap<String, Object> param) throws Exception;

}
