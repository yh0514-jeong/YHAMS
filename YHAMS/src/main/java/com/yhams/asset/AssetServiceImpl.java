package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yhams.common.CommonMapper;
import com.yhams.common.CommonService;

@Service
public class AssetServiceImpl implements AssetService {
	
	private static final Logger logger = LoggerFactory.getLogger(AssetServiceImpl.class);
	
	@Autowired
	AssetMapper mapper;
	
	@Autowired
	CommonMapper commonMapper;
	
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

	@Override
	public long unearnedCount(HashMap<String, Object> param) throws Exception {
		return mapper.unearnedCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> unearnedListUp(HashMap<String, Object> param) throws Exception {
		return mapper.unearnedListUp(param);
	}

	@Override
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public int saveUnearnedList(HashMap<String, Object> param) throws Exception {
		int r = 0;
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		ObjectMapper mpr = new ObjectMapper();
		logger.info("param.toString()==>" + param.toString());
		try {
			list = mpr.readValue(param.get("list").toString(), ArrayList.class);
			for(int i=0; i<list.size(); i++) {
				HashMap<String, Object> map = list.get(i);
				map.put("UED_SEQ"  , commonMapper.getNextUedSeq());
				map.put("USER_SEQ" , param.get("USER_SEQ").toString());
				map.put("CREATE_ID", param.get("USER_SEQ").toString());
				map.put("UPDATE_ID", param.get("USER_SEQ").toString());
				r = mapper.saveUnearned(map);
			}
		}catch (Exception e) {
			e.printStackTrace();
			r = -1;
		}
		return r;
	}

}
