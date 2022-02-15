package com.yhams.expend;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.common.CommonService;
import com.yhams.exception.StdYearNotFoundException;
import com.yhams.exception.YearlyPlanNotDefinedException;
import com.yhams.log.LogService;
import com.yhams.util.Constant;
import com.yhams.util.PagingUtil;

@Controller
@RequestMapping("/expend")
public class ExpendController {
	
	private static final Logger log = LoggerFactory.getLogger(ExpendController.class);
	
	@Autowired
	ExpendService expendService;
	
	@Autowired
	LogService logService;
	
	@Autowired
	CommonService commonService;
	
	
	@RequestMapping(value = "/dailyExpendPlan")
	public ModelAndView accountManageMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("expend/dailyExpendPlan/dailyExpendPlanList");
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
	
	
	@GetMapping(value = "/getAccountList")
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
	
	
	@GetMapping(value = "/getDwCateList")
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
	
	
	@GetMapping(value = "/depWithdralList")
	@ResponseBody
	public HashMap<String, Object> depWithdralList(@RequestParam(required = true) HashMap<String, Object> param,
															    HttpSession session,
																HttpServletRequest  request,
																HttpServletResponse response){
		logService.insertUserActLog(request, session);
	    Enumeration<String> p =  request.getAttributeNames();
	    while(p.hasMoreElements()) {
	    	log.info("params : {}", p.nextElement());
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
			result.put("resultCode",  Constant.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  Constant.FAIL);
		}
		return result;
	}
	
	
	@PostMapping(value = "/saveDepWithdralList")
	@ResponseBody
	public HashMap<String, Object> saveDepWithdralList( @RequestParam(required = true) HashMap<String, Object> param,
														HttpSession session,
														HttpServletRequest  request,
														HttpServletResponse response){
		logService.insertUserActLog(request, session);
		HashMap<String, Object> map = new HashMap<String,Object>();
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		int result = 0;
		log.info("param : {}", param.toString());
		try {
			result = expendService.saveDepWithdralList(param);
			if(result >= 0) {
				map.put("result", Constant.SUCCEESS);
			}else {
				map.put("result", Constant.FAIL);
			}
		}catch (Exception e) {
			e.printStackTrace();
			map.put("result", "fail");
		}
		return map;
	}
	
	
	@PostMapping(value = "/deleteDepWithdrawalList")
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
			log.info("actSeqs==>" + actSeqs);
			param.put("actSeqs", actSeqs);
			r = expendService.deleteDepWithdrawalList(param);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", Constant.FAIL);
		}
		result.put("result", Constant.SUCCEESS);
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
		ArrayList<HashMap<String, Object>> useYnCodeList = new ArrayList<HashMap<String,Object>>();
		
		try {
			
			r = expendService.selecteDepWithdrawal(ACT_SEQ);	
			
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			accounCdList = expendService.getAccountList(param);
			dwCate1List  = commonService.getCgList("CG_2005", "Y");
						
			Optional<?> maybeDwCate1 = Optional.ofNullable(r.get("DW_CATE1"));
			
			
			if(maybeDwCate1.isPresent()) {
				log.info("maybeDwCate1.isPresent() : {}, maybeDwCate1 : {}", maybeDwCate1.isPresent(), maybeDwCate1.get().toString());	
				dwCate2List = commonService.getCgListByParCode("CG_2006", maybeDwCate1.get().toString(), "Y");
			}
			
			useYnCodeList = commonService.getCgList("CG_0003", "Y");
			
			mv.addObject("accounCdList", accounCdList);
			mv.addObject("dwCate1List", dwCate1List);
			mv.addObject("dwCate2List", dwCate2List);
			mv.addObject("useYnCodeList", useYnCodeList);
			
			mv.addObject("result", r);
			mv.addObject("nav"   , "입출금내역 수정");
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("expend/depWithdrawl/depWithdrawlUpdate");
		return mv;
	}
	
	
	@PostMapping(value = "/updateDepWithdrawl")
	@ResponseBody
	public HashMap<String, Object> updateDepWithdrawl(@RequestParam HashMap<String, Object> param, 
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
			result.put("result", Constant.FAIL);
		}
		result.put("result", Constant.SUCCEESS);
		return result;
	}
	
	
	
	@RequestMapping(value = "/dailyExpendPlanUpdate")
	public ModelAndView expendPlanUpdate(@RequestParam(required = false) String STD_YEAR_MONTH, 
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		logService.insertUserActLog(request, session);
		
		ModelAndView mv = new ModelAndView();
		
		ArrayList<HashMap<String, Object>> r = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		
		
		try {
			
			if(STD_YEAR_MONTH != null &&  !"".equals(STD_YEAR_MONTH)){
				param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
				param.put("STD_YEAR_MONTH", STD_YEAR_MONTH);
				param.put("STD_YEAR", STD_YEAR_MONTH.split("-")[0]);
				param.put("STD_MONTH", STD_YEAR_MONTH.split("-")[1]);
				param.put("CATE", "EXP");
				
				log.info("expendPlanUpdate, param : {}", param.toString());
				
				mv.addObject("STD_YEAR_MONTH", STD_YEAR_MONTH);
				r = expendService.selectExpendPlanList(param);
				JSONArray rJson = new JSONArray(r);
				mv.addObject("existYearlyPlanAmount", expendService.existYearlyPlanAmount(param));
				mv.addObject("result", rJson);
				mv.addObject("nav"   , "일단위지출계획 수정");
			}else {
				mv.addObject("nav"   , "일단위지출계획 등록");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("expend/dailyExpendPlan/dailyExpendPlanUpdate");
		return mv;
		
	}
	
	
	
	
	@GetMapping(value = "/chkDupYearMonth")
	@ResponseBody
	public HashMap<String, Object> chkDupYearMonth(@RequestParam HashMap<String, Object> param,
													HttpSession session,
												    HttpServletRequest request, 
												    HttpServletResponse response){
		
		HashMap<String, Object> result = new HashMap<>();
		String isExist = "";
		try {
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			isExist = expendService.chkDupYearMonth(param);
			result.put("isExist", isExist);
		}catch (Exception e) {
			result.put("result", Constant.FAIL);
		}
		return result;
	}
	
	
	
	@GetMapping(value = "/chkExistOfDailyExpendPlan")
	@ResponseBody
	public HashMap<String, Object> chkExistOfDailyExpendPlan(@RequestParam HashMap<String, Object> param,
																HttpSession session,
															    HttpServletRequest request, 
															    HttpServletResponse response){
		
		HashMap<String, Object> result = new HashMap<>();
		log.info("chkExistOfDailyExpendPlan called... param : {}", param.toString());
		
		try {
			
			Optional<? extends Object> maybeStdYearMonth =  Optional.ofNullable(param.get("STD_YEAR_MONTH"));
			if(maybeStdYearMonth.isPresent()) {
				param.put("STD_YEAR_MONTH", maybeStdYearMonth.get().toString());
				param.put("USER_SEQ"      , session.getAttribute("USER_SEQ"));
								
				long dailyExpendPlanCount = expendService.getDailyExpendPlanCount(param);
				
				if(dailyExpendPlanCount > 0) {
					result.put("isExist", true);
				}else {
					result.put("isExist", false);
				}
				result.put("resultCode", Constant.SUCCEESS);
			}else{
				throw new StdYearNotFoundException(maybeStdYearMonth.toString());
			}
		}catch (Exception e) {
			result.put("resultCode", Constant.FAIL);
		}
		
		return result;
	}
	
	
	@GetMapping(value = "/chkExistOfYearlyExpendPlan")
	@ResponseBody
	public HashMap<String, Object> chkExistOfYearlyExpendPlan(@RequestParam HashMap<String, Object> param,
																HttpSession session,
															    HttpServletRequest request, 
															    HttpServletResponse response){
		
		HashMap<String, Object> result = new HashMap<>();
		log.info("chkExistOfYearlyExpendPlan called... param : {}", param.toString());
		
		try {
			Optional<? extends Object> maybeStdYearMonth =  Optional.ofNullable(param.get("STD_YEAR_MONTH"));
			
			if(maybeStdYearMonth.isPresent()) {
			
				String[] stdYearMonth = maybeStdYearMonth.get().toString().split("-");
				param.put("STD_YEAR",  stdYearMonth[0]);
				param.put("STD_MONTH", stdYearMonth[1]);
				param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
				
				log.info("chkExistOfYearlyExpendPlan, stdYearMonth : {}, param : {}", stdYearMonth.toString(), param.toString());
				
				long existYearlyPlanCount = expendService.getExistYearlyPlanCountByStdYearAndStdMonth(param);
				if(existYearlyPlanCount > 0) {
					param.put("CATE", "EXP");
					long existYearlyPlanAmount = expendService.existYearlyPlanAmount(param);
					result.put("existYearlyPlanAmount", existYearlyPlanAmount);
				}
				result.put("existYearlyPlanCount", existYearlyPlanCount);
				result.put("resultCode", Constant.SUCCEESS);
				
			}else{
				throw new StdYearNotFoundException(maybeStdYearMonth.toString());
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", Constant.FAIL);
		}
		
		return result;
	}
	
	
	
	@PostMapping(value = "/saveDailyExpendPlanList")
	@ResponseBody
	public HashMap<String, Object> saveDailyExpendPlanList(@RequestParam HashMap<String, Object> param,
															HttpSession session,
														    HttpServletRequest request, 
														    HttpServletResponse response){
		
		log.info("saveDailyExpendPlanList called... param : {}", param.toString());
		HashMap<String, Object> result = new HashMap<>();
		
		try {
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			int r = expendService.saveDailyExpendPlanList(param);
			if(r > -1){
				result.put("resultCode", Constant.SUCCEESS);
			}else{
				result.put("resultCode", Constant.FAIL);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", Constant.FAIL);
		}
		
		return result;
	}
	
	
	@GetMapping(value = "/dailyExpendPlanList")
	@ResponseBody
	public HashMap<String, Object> dailyExpendPlanList(@RequestParam HashMap<String, Object> param,
														HttpSession session,
														HttpServletRequest request, 
														HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
	    Enumeration<String> p =  request.getAttributeNames();
	    while(p.hasMoreElements()) {
	    	log.info("dailyExpendPlanList called... params : {}", p.nextElement());
	    }
	    
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = expendService.dailyExpendPlanCount(param);
			list = expendService.dailyExpendPlanList(param);
			
			PagingUtil pagingUtil = new PagingUtil(10, cntPerPage, total);
			Map<String, Object> block = pagingUtil.getFixedBlock(curPage);
			result.put("block", block);
			result.put("total", total);
			result.put("list",  list);
			result.put("resultCode",  Constant.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  Constant.FAIL);
		}
		return result;
	}
	
	
	@PostMapping(value = "/deleteDailyPlanList")
	@ResponseBody
	public HashMap<String, Object> deleteDailyPlanList(@RequestParam HashMap<String, Object> param,
														HttpSession session,
														HttpServletRequest request, 
														HttpServletResponse response){
		HashMap<String, Object> result = new HashMap<>();
		
		try {
			param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
			int r = expendService.deleteDailyPlanList(param);
			if(r == -1) {
				throw new Exception();
			}
			result.put("resultCode",  Constant.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  Constant.FAIL);
		}
		return result;
	}
	
}
