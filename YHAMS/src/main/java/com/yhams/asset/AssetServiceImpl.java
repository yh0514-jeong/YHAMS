package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yhams.common.CommonMapper;

@Service
public class AssetServiceImpl implements AssetService {
	
	private static final Logger log = LoggerFactory.getLogger(AssetServiceImpl.class);
	
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
		log.info("param.toString()==>" + param.toString());
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

	@Override
	public HashMap<String, Object> selectUnearned(String param) throws Exception {
		return mapper.selectUnearned(param);
	}

	@Override
	public int updateUnearned(HashMap<String, Object> param) throws Exception {
		return mapper.updateUnearned(param);
	}

	@Override
	public int deleteUnearedList(HashMap<String, Object> param) throws Exception {
		return mapper.deleteUnearedList(param);
	}

	
	
	@Override
	@SuppressWarnings("all")
	@Transactional(rollbackFor = Exception.class)
	public int saveSalaryList(HashMap<String, Object> param) throws Exception {
		
		String SAL_SEQ = null;
		int result     = 0;
		
		try{
			SAL_SEQ = param.get("SAL_SEQ").toString();
		}catch (NullPointerException ne) {
			SAL_SEQ = null;
		}
		
		ArrayList<HashMap<String, Object>> list  = new ArrayList<HashMap<String,Object>>();
		ObjectMapper mpr = new ObjectMapper();
		
		try {
			list = mpr.readValue(param.get("list").toString(), ArrayList.class);
			
			// insert
			if(SAL_SEQ == null) {
				SAL_SEQ = commonMapper.getNextSalSeq();
			// update
			}else{
				int delResult = mapper.deleteSalSeq(param);
			}
			
			for(int i=0; i<list.size(); i++) {
			   HashMap<String, Object> map = list.get(i);
			   map.put("SAL_SEQ"     ,  SAL_SEQ);
			   map.put("SAL_DTL_SEQ" ,  i+1);
			   map.put("USER_SEQ"    ,  param.get("USER_SEQ"));
			   map.put("CREATE_ID"   ,  param.get("USER_SEQ"));
			   map.put("UPDATE_ID"   ,  param.get("USER_SEQ"));
			   log.info("map.toString()==>" + map.toString());
			   result = result + mapper.saveSalaryList(map);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			result = -1;
		}
		return result;
	}

	@Override
	public long salaryCount(HashMap<String, Object> param) throws Exception {
		return mapper.salaryCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> salaryListUp(HashMap<String, Object> param) throws Exception {
		return mapper.salaryListUp(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getPayDedList(HashMap<String, Object> param) throws Exception {
		return mapper.getPayDedList(param);
	}

	@Override
	public HashMap<String, Object> getSalSeqDate(HashMap<String, Object> param) throws Exception {
		return mapper.getSalSeqDate(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getLastSalary(HashMap<String, Object> param) throws Exception {
		return mapper.getLastSalary(param);
	}

	@Override
	public int dupChkSalMonth(HashMap<String, Object> param) throws Exception {
		return mapper.dupChkSalMonth(param);
	}

	@Override
	public String chkYearlyAssetPlanExist(HashMap<String, Object> param) throws Exception {
		return mapper.chkYearlyAssetPlanExist(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> userYearlyPlanTemplate(HashMap<String, Object> param) throws Exception {
		return mapper.userYearlyPlanTemplate(param);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int saveYearlyAssetPlanList(HashMap<String, Object> param) throws Exception {
		
	
		
		ArrayList<HashMap<String, Object>> list  = new ArrayList<HashMap<String,Object>>();
		ObjectMapper mpr = new ObjectMapper();
		int result = 0;
		
		try {
			
			result = mapper.deleteYearlyAssetPlanList(param);
			
			list = mpr.readValue(param.get("list").toString(), ArrayList.class);
			
			for(int i=0; i<list.size(); i++) {
				HashMap<String, Object> p = new HashMap<>();
				p.put("ASSET_PLAN_SEQ", UUID.randomUUID().toString());
				p.put("USER_SEQ"      , param.get("USER_SEQ"));
				p.put("STD_YEAR"      , list.get(i).get("STD_YEAR"));
				p.put("STD_MONTH"     , Integer.parseInt(list.get(i).get("STD_MONTH").toString().replace("MONTH_", "")));
				p.put("MAIN_CTG"      , list.get(i).get("MAIN_CTG"));
				p.put("SUB_CTG"       , list.get(i).get("SUB_CTG"));
				p.put("AMOUNT"        , list.get(i).get("AMOUNT"));
				p.put("CREATE_ID"     , param.get("USER_SEQ"));
				p.put("UPDATE_ID"     , param.get("USER_SEQ"));
				log.info("p==>{}", p);
				result = result + mapper.saveYearlyAssetPlanList(p);
				result++;
			}
			
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return 0;
	}

	@Override
	public int deleteYearlyAssetPlanList(HashMap<String, Object> param) throws Exception {
		return mapper.deleteYearlyAssetPlanList(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> yearlyAssetPlanList(HashMap<String, Object> param) throws Exception {
		return mapper.yearlyAssetPlanList(param);
	}

}
