package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.common.CommonService;
import com.yhams.log.LogService;
import com.yhams.util.CommonContraint;
import com.yhams.util.PagingUtil;

@Controller
@RequestMapping("/asset")
public class AssetController {
	
	private static final Logger logger = LoggerFactory.getLogger(AssetController.class);
	
	@Autowired
	AssetService assetService;
	
	@Autowired
	LogService logService;
	
	@Autowired
	CommonService commonService;
	
	@RequestMapping(value = "/accountManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("asset/account/accountList");
		return mv;
	}
	
	
	@RequestMapping(value = "/accountList", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> accountList(@RequestParam   HashMap<String, Object> param, 
											                   HttpSession session,
															   HttpServletRequest  request,
															   HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		logger.info("param==>" + param.toString());
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = assetService.accountCount(param);
			list  = assetService.accountListUp(param);
			PagingUtil pagingUtil = new PagingUtil(10, cntPerPage, total);
			Map<String, Object> block = pagingUtil.getFixedBlock(curPage);
			result.put("block", block);
			result.put("total", total);
			result.put("list",  list);
			result.put("resultCode",  CommonContraint.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  CommonContraint.FAIL);
		}
		
		return result;
	}
	
	
	@RequestMapping(value = "/accountUpdate")
	public ModelAndView accountUpdate(@RequestParam(required = false) String ACCOUNT_CD, 
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		
		logService.insertUserActLog(request, session);
		
		ModelAndView mv           = new ModelAndView();
		HashMap<String, Object> r = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> actTypeList = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> isuOrgList  = new ArrayList<HashMap<String,Object>>();
		
		try {
			actTypeList = commonService.getCgList("CG_0005", "Y");
			isuOrgList  = commonService.getCgList("CG_0006", "Y");
			
			if(ACCOUNT_CD != null &&  !"".equals(ACCOUNT_CD)){
				r = assetService.selectAccount(ACCOUNT_CD);
				mv.addObject("result", r);
				mv.addObject("nav"   , "계좌 수정");
			}else {
				mv.addObject("nav"   , "계좌 등록");
			}
			
			mv.addObject("actTypeList", actTypeList);
			mv.addObject("isuOrgList",  isuOrgList);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("asset/account/accountUpdate");
		return mv;
	}

}
