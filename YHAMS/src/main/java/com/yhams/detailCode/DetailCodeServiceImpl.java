package com.yhams.detailCode;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DetailCodeServiceImpl implements DetailCodeService{
	
	@Autowired
	DetailCodeMapper mapper;

	@Override
	public HashMap<String, Object> selectCodeCd(HashMap<String, Object> param) throws Exception {
		return mapper.selectCodeCd(param);
	}

	@Override
	public long dtlCodeCount(HashMap<String, Object> param) throws Exception {
		return mapper.dtlCodeCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> dtlCodeList(HashMap<String, Object> param) throws Exception {
		return mapper.dtlCodeList(param);
	}

	@Override
	public int insertDtlCode(HashMap<String, Object> param) throws Exception {
		return mapper.insertDtlCode(param);
	}

	@Override
	public int updateDtlCode(HashMap<String, Object> param) throws Exception {
		return mapper.updateDtlCode(param);
	}

}
