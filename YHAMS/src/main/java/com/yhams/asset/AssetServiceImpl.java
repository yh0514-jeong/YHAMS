package com.yhams.asset;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.UUID;
import java.util.stream.IntStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yhams.common.CommonMapper;
import com.yhams.expend.ExpendMapper;

@Service
public class AssetServiceImpl implements AssetService {
	
	private static final Logger log = LoggerFactory.getLogger(AssetServiceImpl.class);
	
	@Autowired
	AssetMapper assetMapper;
	
	@Autowired
	ExpendMapper expendMapper;
	
	@Autowired
	CommonMapper commonMapper;
	
	@Override
	public long accountCount(HashMap<String, Object> param) throws Exception {
		return assetMapper.accountCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception {
		return assetMapper.accountListUp(param);
	}

	@Override
	public HashMap<String, Object> selectAccount(String ACCOUNT_CD) throws Exception {
		return assetMapper.selectAccount(ACCOUNT_CD);
	}

	@Override
	public int insertAccount(HashMap<String, Object> param) throws Exception {
		return assetMapper.insertAccount(param);
	}

	@Override
	public int updateAccount(HashMap<String, Object> param) throws Exception {
		return assetMapper.updateAccount(param);
	}

	@Override
	public int deleteAccount(HashMap<String, Object> param) throws Exception {
		return assetMapper.deleteAccount(param);
	}

	@Override
	public long unearnedCount(HashMap<String, Object> param) throws Exception {
		return assetMapper.unearnedCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> unearnedListUp(HashMap<String, Object> param) throws Exception {
		return assetMapper.unearnedListUp(param);
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
				r = assetMapper.saveUnearned(map);
			}
		}catch (Exception e) {
			e.printStackTrace();
			r = -1;
		}
		return r;
	}

	@Override
	public HashMap<String, Object> selectUnearned(String param) throws Exception {
		return assetMapper.selectUnearned(param);
	}

	@Override
	public int updateUnearned(HashMap<String, Object> param) throws Exception {
		return assetMapper.updateUnearned(param);
	}

	@Override
	public int deleteUnearedList(HashMap<String, Object> param) throws Exception {
		return assetMapper.deleteUnearedList(param);
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
				int delResult = assetMapper.deleteSalSeq(param);
			}
			
			for(int i=0; i<list.size(); i++) {
			   HashMap<String, Object> map = list.get(i);
			   map.put("SAL_SEQ"     ,  SAL_SEQ);
			   map.put("SAL_DTL_SEQ" ,  i+1);
			   map.put("USER_SEQ"    ,  param.get("USER_SEQ"));
			   map.put("CREATE_ID"   ,  param.get("USER_SEQ"));
			   map.put("UPDATE_ID"   ,  param.get("USER_SEQ"));
			   log.info("map.toString()==>" + map.toString());
			   result = result + assetMapper.saveSalaryList(map);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			result = -1;
		}
		return result;
	}

	@Override
	public long salaryCount(HashMap<String, Object> param) throws Exception {
		return assetMapper.salaryCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> salaryListUp(HashMap<String, Object> param) throws Exception {
		return assetMapper.salaryListUp(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getPayDedList(HashMap<String, Object> param) throws Exception {
		return assetMapper.getPayDedList(param);
	}

	@Override
	public HashMap<String, Object> getSalSeqDate(HashMap<String, Object> param) throws Exception {
		return assetMapper.getSalSeqDate(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getLastSalary(HashMap<String, Object> param) throws Exception {
		return assetMapper.getLastSalary(param);
	}

	@Override
	public int dupChkSalMonth(HashMap<String, Object> param) throws Exception {
		return assetMapper.dupChkSalMonth(param);
	}

	@Override
	public String chkYearlyAssetPlanExist(HashMap<String, Object> param) throws Exception {
		return assetMapper.chkYearlyAssetPlanExist(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> userYearlyPlanTemplate(HashMap<String, Object> param) throws Exception {
		return assetMapper.userYearlyPlanTemplate(param);
	}

	@Override
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor = Exception.class)
	public int saveYearlyAssetPlanList(HashMap<String, Object> param) throws Exception {
		
		ArrayList<HashMap<String, Object>> list  = new ArrayList<HashMap<String,Object>>();
		ObjectMapper mpr = new ObjectMapper();
		int result = 0;
		
		try {
			log.info("AssetServiceImpl saveYearlyAssetPlanList... param.toString() : {}", param.toString());
			result = assetMapper.deleteYearlyAssetPlanList(param);
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
				result = result + assetMapper.saveYearlyAssetPlanList(p);
				result++;
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public ArrayList<HashMap<String, Object>> yearlyAssetPlanList(HashMap<String, Object> param) throws Exception {
		return assetMapper.yearlyAssetPlanList(param);
	}

	@Override
	public long yearlyAssetPlanListCount(HashMap<String, Object> param) throws Exception {
		return assetMapper.yearlyAssetPlanListCount(param);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int deleteYearlyAssetPlanList(HashMap<String, Object> param) throws Exception {
		
		String[] years = param.get("STD_YEAR").toString().split(",");
		int result = 0;
		
	    try {
	    	for(int i=0; i<years.length; i++) {
	    		param.put("STD_YEAR", years[i]);
	    		
	    		// 해당연도 일자산계획 삭제
	    		result += expendMapper.deleteDailyPlanListByYear(param);
	    		
	    		// 연자산계획 삭제
	    		result += assetMapper.deleteYearlyAssetPlanList(param);
			}
	    }catch (Exception e) {
	    	e.printStackTrace();
	    	result =  -1;
		}
	    
		return result;
	}

}
