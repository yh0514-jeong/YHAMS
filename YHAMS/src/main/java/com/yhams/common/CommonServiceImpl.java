package com.yhams.common;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommonServiceImpl implements CommonService {
	
	private static final Logger log = LoggerFactory.getLogger(CommonServiceImpl.class);

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
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("codeGrp", codeGrp);
		param.put("useYn", useYn);
		log.info("getCgList param : {}", param.toString());
		return mapper.getCgList(param);
	}

	@Override
	public String getNextAccountCd() throws Exception {
		return mapper.getNextAccountCd();
	}

	@Override
	public String getNextUedSeq() throws Exception {
		return mapper.getNextUedSeq();
	}

	@Override
	public ArrayList<HashMap<String, Object>> getCgListByParCode(String codeGrp, String parCode, String useYn) throws Exception {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("codeGrp", codeGrp);
		param.put("parCode", parCode);
		param.put("useYn", useYn);
		log.info("getCgListByParCode param : {}", param.toString());
		return mapper.getCgListByParCode(param);
	}

}
