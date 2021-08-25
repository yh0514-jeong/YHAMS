package com.yhams.user;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.stereotype.Service;

@Service
public interface UserService {

	ArrayList<HashMap<String, Object>> getUserList(HashMap<String, Object> param) throws Exception;

}
