package com.yhams.dashboard;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DashboardServiceImpl implements DashboardService {
	
	@Autowired
	private DashboardMapper dashboardMapper;
	
	@Override
	public ArrayList<String> getLabels() throws Exception {
		return dashboardMapper.getLabels();
	}

	@Override
	public ArrayList<Integer> getSalaryStatistics(HashMap<String, Object> param) throws Exception {
		return dashboardMapper.getSalaryStatistics(param);
	}

	@Override
	public ArrayList<Integer> getAssetStatistics(HashMap<String, Object> param) throws Exception {
		return dashboardMapper.getAssetStatistics(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getAssetConsistList(HashMap<String, Object> param) throws Exception {
		return dashboardMapper.getAssetConsistList(param);
	}

	@Override
	public ArrayList<Integer> getUnearnedStatList(HashMap<String, Object> param) throws Exception {
		return dashboardMapper.getUnearnedStatList(param);
	}

}
