package com.yhams.dashboard;

import java.util.ArrayList;
import java.util.HashMap;

public interface DashboardService {
	
	ArrayList<String> getLabels() throws Exception;

	ArrayList<Integer> getSalaryStatistics(HashMap<String, Object> param) throws Exception;

	ArrayList<Integer> getAssetStatistics(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getAssetConsistList(HashMap<String, Object> param) throws Exception;

}
