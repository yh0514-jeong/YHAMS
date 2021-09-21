package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AssetServiceImpl implements AssetService {
	
	@Autowired
	AssetMapper mapper;

	@Override
	public long accountCount(HashMap<String, Object> param) throws Exception {
		return mapper.accountCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception {
		return mapper.accountListUp(param);
	}

	@Override
	public HashMap<String, Object> selectAccount(String ACCOUNT_CD) throws Exception {
		return mapper.selectAccount(ACCOUNT_CD);
	}

	@Override
	public int insertAccount(HashMap<String, Object> param) throws Exception {
		return mapper.insertAccount(param);
	}

	@Override
	public int updateAccount(HashMap<String, Object> param) throws Exception {
		return mapper.updateAccount(param);
	}

	@Override
	public int deleteAccount(HashMap<String, Object> param) throws Exception {
		return mapper.deleteAccount(param);
	}

}
