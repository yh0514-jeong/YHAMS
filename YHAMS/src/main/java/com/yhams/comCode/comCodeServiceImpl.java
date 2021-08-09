package com.yhams.comCode;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class comCodeServiceImpl implements comCodeService {
	
	@Autowired
	comCodeMapper mapper;

	@Override
	public int insertComCode(HashMap<String, Object> param) throws Exception {
		return mapper.insertComCode(param);
	}

	@Override
	public int updateComCode(HashMap<String, Object> param) throws Exception {
		return mapper.updateComCode(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> comCodeListUp(HashMap<String, Object> param) throws Exception {
		return mapper.comCodeListUp(param);
	}

	@Override
	public int comCodeCount(HashMap<String, Object> param) throws Exception {
		return mapper.comCodeCount(param);
	}

	@Override
	public HashMap<String, Object> selectCodeId(String codeId) throws Exception {
		return mapper.selectCodeId(codeId);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getComCodeUseList() throws Exception {
		return mapper.getComCodeUseList();
	}

	
}
