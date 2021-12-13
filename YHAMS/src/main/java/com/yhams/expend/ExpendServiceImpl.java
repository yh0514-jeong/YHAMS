package com.yhams.expend;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ExpendServiceImpl implements ExpendService{
	
	private static final Logger logger = LoggerFactory.getLogger(ExpendServiceImpl.class);
	
	@Autowired
	ExpendMapper mapper;


	@Override
	@Transactional
	public int saveDepWithdralList(HashMap<String, Object> param) throws Exception {
		int r = 0;
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		ObjectMapper mpr = new ObjectMapper();
		logger.info("param.toString()==>" + param.toString());
		try {
			list = mpr.readValue(param.get("list").toString(), ArrayList.class);
			for(int i=0; i<list.size(); i++) {
				HashMap<String, Object> map = list.get(i);
				map.put("ACT_SEQ"  , UUID.randomUUID().toString());
				map.put("USER_SEQ", param.get("USER_SEQ").toString());
				map.put("CREATE_ID", param.get("USER_SEQ").toString());
				map.put("UPDATE_ID", param.get("USER_SEQ").toString());
				logger.info("saveDepWithdralList map==> {}", map.toString());
				r = mapper.saveDepWithdralList(map);
			}
		}catch (Exception e) {
			e.printStackTrace();
			r = -1;
		}
		return r;
		
	}


	@Override
	public ArrayList<HashMap<String, Object>> getAccountList(HashMap<String, Object> param) throws Exception {
		return mapper.getAccountList(param);
	}


	@Override
	public ArrayList<HashMap<String, Object>> depWithdralList(HashMap<String, Object> param) throws Exception {
		return mapper.depWithdralList(param);
	}


	@Override
	public long depWithdralCount(HashMap<String, Object> param) throws Exception {
		return mapper.depWithdralCount(param);
	}


	@Override
	public int deleteDepWithdrawalList(HashMap<String, Object> param) throws Exception {
		return mapper.deleteDepWithdrawalList(param);
	}


	@Override
	public HashMap<String, Object> selecteDepWithdrawal(String ACT_SEQ) throws Exception {
		return mapper.selecteDepWithdrawal(ACT_SEQ);
	}

}
