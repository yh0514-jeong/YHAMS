package com.yhams.expend;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
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
import com.yhams.util.PagingUtil;

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
	
	
	@RequestMapping(value = "/depWithdralList", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> depWithdralList(@RequestParam(required = true) HashMap<String, Object> param,
															    HttpSession session,
																HttpServletRequest  request,
																HttpServletResponse response){
		logService.insertUserActLog(request, session);
	    Enumeration<String> p =  request.getAttributeNames();
	    while(p.hasMoreElements()) {
	    	logger.info("params : {}", p.nextElement());
	    }
	    
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = expendService.depWithdralCount(param);
			list = expendService.depWithdralList(param);
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
	
	
	@RequestMapping(value = "/deleteDepWithdrawalList", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> deleteDepWithdrawalList(@RequestParam HashMap<String, Object> param, 
					                                      HttpSession session,
					                                      HttpServletRequest request,
					                                      HttpServletResponse response){
		logService.insertUserActLog(request, session);
		HashMap<String, Object> result = new HashMap<String, Object>();
		int r = 0;
		try {
			String[] actSeqs = param.get("ACT_SEQ").toString().split(",");
			logger.info("actSeqs==>" + actSeqs);
			param.put("actSeqs", actSeqs);
			r = expendService.deleteDepWithdrawalList(param);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", CommonContraint.FAIL);
		}
		result.put("result", CommonContraint.SUCCEESS);
		return result;
	}
	
	
	
	@RequestMapping(value = "/updateDepWithdrawal")
	public ModelAndView updateDepWithdrawal(@RequestParam(required = true) String ACT_SEQ, 
								            HttpSession session,
								            HttpServletRequest request,
								            HttpServletResponse response) {
		
		
		logService.insertUserActLog(request, session);
		
		ModelAndView mv               = new ModelAndView();
		HashMap<String, Object> r     = new HashMap<String, Object>();
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> accounCdList = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> dwCate1List  = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> dwCate2List  = new ArrayList<HashMap<String,Object>>();
		
		try {
			
			r = expendService.selecteDepWithdrawal(ACT_SEQ);	
			
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			accounCdList = expendService.getAccountList(param);
			dwCate1List  = commonService.getCgList("CG_2005", "Y");
						
			Optional<?> maybeDwCate1 = Optional.ofNullable(r.get("DW_CATE1"));
			
			
			if(maybeDwCate1.isPresent()) {
				logger.info("maybeDwCate1.isPresent() : {}, maybeDwCate1 : {}", maybeDwCate1.isPresent(), maybeDwCate1.get().toString());	
				dwCate2List = commonService.getCgListByParCode("CG_2006", maybeDwCate1.get().toString(), "Y");
			}
			
			mv.addObject("accounCdList", accounCdList);
			mv.addObject("dwCate1List", dwCate1List);
			mv.addObject("dwCate2List", dwCate2List);
			
			mv.addObject("result", r);
			mv.addObject("nav"   , "입출금내역 수정");
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("expend/depWithdrawl/depWithdrawlUpdate");
		return mv;
	}
	
	
	@RequestMapping(value = "/updateDepWithdrawl", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateUnearned(@RequestParam HashMap<String, Object> param, 
			                                      HttpSession session,
			                                      HttpServletRequest request,
			                                      HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		HashMap<String, Object> result = new HashMap<String, Object>();
		int r = 0;
		try {
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			r = expendService.updateDepWithdrawl(param);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", CommonContraint.FAIL);
		}
		result.put("result", CommonContraint.SUCCEESS);
		return result;
	}
	
	
	
}
