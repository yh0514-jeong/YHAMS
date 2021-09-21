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
	public String getNextRoleId() throws Exception {
		return mapper.getNextRoleId();
	}
	
	@Override
	public String getNextMenuId() throws Exception {
		return mapper.getNextMenuId();
	}
	
	@Override
	public long getNextActLogSeq() throws Exception {
		return mapper.getNextActLogSeq();
	}

	@Override
	public ArrayList<HashMap<String, Object>> getCgList(String codeGrp, String useYn) throws Exception {
		return mapper.getCgList(codeGrp, useYn);
	}

	@Override
	public String getNextAccountCd() throws Exception {
		return mapper.getNextAccountCd();
	}

}
