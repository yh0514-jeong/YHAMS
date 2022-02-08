package com.yhams.dashboard;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yhams.log.LogService;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
	
	@Autowired
	private LogService logService;
	
	@Autowired
	private DashboardService dashboardService;
	
	
	@GetMapping("/getSalaryStatistics")
	@ResponseBody
	public HashMap<String, Object> getSalaryStatistics(HttpServletRequest request,
			                                           HttpServletResponse response,
			                                           HttpSession session){
		
		logService.insertUserActLog(request, session);
		HashMap<String, Object> param = new HashMap<>();
		HashMap<String, Object> result = new HashMap<>();
		ArrayList<String> labels = new ArrayList<>();
		ArrayList<Integer> salaryStatList = new ArrayList<>();
		ArrayList<Integer> assetStatList = new ArrayList<>();
		ArrayList<HashMap<String, Object>> assetConsistList = new ArrayList<>();
		
		try {
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			labels = dashboardService.getLabels();
			salaryStatList = dashboardService.getSalaryStatistics(param);
			assetStatList = dashboardService.getAssetStatistics(param);
			assetConsistList = dashboardService.getAssetConsistList(param);
			
			HashMap<String, Object> assetConsistMap = new HashMap<>();
			
			LinkedList<String> assetConsistLabel = new LinkedList<>();
			LinkedList<Integer> assetConsistValue = new LinkedList<>();
			
			for(HashMap<String, Object> arr : assetConsistList) {
				assetConsistLabel.push(arr.get("ACCOUNT_NM").toString());
				assetConsistValue.push(Integer.parseInt(arr.get("ASSET").toString()));
			}
			
			assetConsistMap.put("label", assetConsistLabel);
			assetConsistMap.put("value", assetConsistValue);
			
			result.put("labels", labels);
			result.put("salaryStatList", salaryStatList);
			result.put("assetStatList", assetStatList);
			result.put("assetConsistList", assetConsistMap);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return result;
	}
	
	
	
}
