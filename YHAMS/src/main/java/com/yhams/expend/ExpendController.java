package com.yhams.expend;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Optional;

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

@Controller
@RequestMapping("/expend")
public class ExpendController {
	
	private static final Logger logger = LoggerFactory.getLogger(ExpendController.class);
	
	@Autowired
	ExpendService expendService;
	
	@Autowired
	LogService logService;
	
	@Autowired
	CommonService commonService;
	
	
	@RequestMapping(value = "/expendPlan")
	public ModelAndView accountManageMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("expend/plan/expendPlanList");
		return mv;
	}
	
	
	@RequestMapping(value = "/depWithdrlManageMain")
	public ModelAndView depWithdrlManageMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("expend/depWithdrawl/depWithdrawlList");
		return mv;
	}
	
	@RequestMapping(value = "/depWithdrAdd")
	public ModelAndView depWithdrAdd() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("expend/depWithdrawl/depWithdrawlAdd");
		return mv;
	}
	
	
	@RequestMapping(value = "/getAccountList", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<HashMap<String, Object>> getAccountList(HttpSession session,
															 HttpServletRequest  request,
															 HttpServletResponse response){
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		HashMap<String, Object> param = new HashMap<String,Object>();
		try {
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			list = expendService.getAccountList(param);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	@RequestMapping(value = "/getDwCateList", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<HashMap<String, Object>> getDwCateList(@RequestParam(required = true) HashMap<String, Object> param,
															 HttpSession session,
															 HttpServletRequest  request,
															 HttpServletResponse response){
		logService.insertUserActLog(request, session);
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		Optional<Object> parCode;
		
		try {
			parCode = Optional.ofNullable(param.get("parCode"));
			if(parCode.isPresent()) {
				list = commonService.getCgListByParCode("CG_2006", parCode.get().toString(), "Y");
			}else{
				list  = commonService.getCgList("CG_2005", "Y");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	@RequestMapping(value = "/saveDepWithdralList", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> saveDepWithdralList( @RequestParam(required = true) HashMap<String, Object> param,
													     HttpSession session,
														 HttpServletRequest  request,
														 HttpServletResponse response){
		logService.insertUserActLog(request, session);
		HashMap<String, Object> map = new HashMap<String,Object>();
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		int result = 0;
		logger.info("param : {}", param.toString());
		try {
			result = expendService.saveDepWithdralList(param);
			if(result >= 0) {
				map.put("result", CommonContraint.SUCCEESS);
			}else {
				map.put("result", CommonContraint.FAIL);
			}
		}catch (Exception e) {
			e.printStackTrace();
			map.put("result", "fail");
		}
		return map;
	}
	
	
}
