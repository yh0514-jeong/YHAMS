package com.yhams.common;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommonServiceImpl implements CommonService {
	
	@Autowired
	CommonMapper mapper;

	@Override
	public String getUserNextSeq() throws Exception {
		return mapper.getUserNextSeq();
	}

	@Override
	public String getNextCodeId() throws Exception {
		return mapper.getNextCodeId();
	}

	@Override
	public ArrayList<HashMap<String, Object>> getCgList(String codeGrp, String useYn) throws Exception {
		return mapper.getCgList(codeGrp, useYn);
	}


}
