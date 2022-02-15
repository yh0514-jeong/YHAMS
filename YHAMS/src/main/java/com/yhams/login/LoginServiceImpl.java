package com.yhams.login;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yhams.common.CommonService;
import com.yhams.util.Encryption;

@Service
public class LoginServiceImpl implements LoginService {
	
	private static final Logger log = LoggerFactory.getLogger(LoginServiceImpl.class);
	
	@Autowired
	private LoginMapper loginMapper;

	
	@Autowired
	private CommonService commonService;
	
	
	@Override
	public ArrayList<HashMap<String, Object>> getLogininfo(HashMap<String, Object> param) throws Exception {
		return loginMapper.getLogininfo(param);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int insertUser(HashMap<String, Object> param) throws Exception {

		int result = 0;
		
		try {
			
			String nextUserSeq = commonService.getUserNextSeq();
			param.put("USER_SEQ", nextUserSeq);
			param.put("USER_PW", Encryption.encryptPassword(param.get("USER_PW").toString()));
			
			// 사용자 기본 정보 입력
			result = loginMapper.insertUser(param);
			
			// 사용자 기본 권한 적용
			result = result + loginMapper.insertDefaultRole(param);
			
		}catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		return result;
	}

	@Override
	public String chkUserInfo(HashMap<String, Object> param) throws Exception {
		return loginMapper.chkUserInfo(param);
	}

	@Override
	public HashMap<String, Object> getUserInfo(HashMap<String, Object> param) throws Exception {
		return loginMapper.getUserInfo(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getUserMenuList(HashMap<String, Object> param) throws Exception {
		return loginMapper.getUserMenuList(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getSubMenuList(HashMap<String, Object> param) throws Exception {
		return loginMapper.getSubMenuList(param);
	}

	@Override
	public String idDupChk(HashMap<String, Object> param) throws Exception {
		return loginMapper.idDupChk(param);
	}

	@Override
	public String getActiveStatus(HashMap<String, Object> param) throws Exception {
		return loginMapper.getActiveStatus(param);
	}

	@Override
	public void updateLastLoginTime(HashMap<String, Object> param) throws Exception {
		loginMapper.updateLastLoginTime(param);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> increaseFailCount(HashMap<String, Object> param) throws Exception {
		 loginMapper.increaseFailCount(param);
		 HashMap<String, Object> result = loginMapper.getStatusAndFailureCnt(param);
		 return result; 
	}

}
