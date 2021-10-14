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
	public ModelAndView accountManageMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("asset/account/accountList");
		return mv;
	}
	
	@RequestMapping(value = "/unearnedManagementMain")
	public ModelAndView unearnedManagementMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("asset/unearned/unearnedList");
		return mv;
	}
	
	@RequestMapping(value = "/unearnedAdd")
	public ModelAndView unearnedAdd() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("asset/unearned/unearnedAdd");
		return mv;
	}
	
	
	@RequestMapping(value = "/salaryManageMain")
	public ModelAndView payrollManageMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("asset/salary/salaryList");
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
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")    == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		
		logger.info("param==>" + param.toString());
		
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
	
	
	@RequestMapping(value = "/updateAccount", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateAccount(@RequestParam HashMap<String, Object> param, 
			                                     HttpSession session,
			                                     HttpServletRequest request,
			                                     HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		HashMap<String, Object> result = new HashMap<String, Object>();

		int r = 0;
		try {
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			param.put("USER_SEQ",  session.getAttribute("USER_SEQ"));
			
			if(param.get("ACCOUNT_CD") == null || "".equals(param.get("ACCOUNT_CD"))){
				String ACCOUNT_CD = commonService.getNextAccountCd();
				param.put("ACCOUNT_CD", ACCOUNT_CD);
				System.out.println("updateAccount insert param.toString()==>" + param.toString());
				r = assetService.insertAccount(param);
			}else {
				System.out.println("updateAccount update param.toString()==>" + param.toString());
				r = assetService.updateAccount(param);
			}
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", CommonContraint.FAIL);
		}
		result.put("result", CommonContraint.SUCCEESS);
		return result;
	}
	
	
	@RequestMapping(value = "/deleteAccount", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> deleteAccount(@RequestParam HashMap<String, Object> param, 
			                                     HttpSession session,
			                                     HttpServletRequest request,
			                                     HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		HashMap<String, Object> result = new HashMap<String, Object>();

		int r = 0;
		try {
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			logger.info("deleteAccount param.toString()==>" + param.toString());
			r = assetService.deleteAccount(param);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", CommonContraint.FAIL);
		}
		result.put("result", CommonContraint.SUCCEESS);
		return result;
	}
	
	
	
	@RequestMapping(value = "/unearnedList", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> unearnedList(@RequestParam   HashMap<String, Object> param, 
											                    HttpSession session,
															    HttpServletRequest  request,
															    HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")    == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		
		logger.info("param==>" + param.toString());
		
		try {
			total = assetService.unearnedCount(param);
			list  = assetService.unearnedListUp(param);
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
	
	
	@RequestMapping(value = "/uedCtgList", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<HashMap<String, Object>> uedCtgList(HttpSession session,
														 HttpServletRequest  request,
														 HttpServletResponse response){
		logService.insertUserActLog(request, session);
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		try {
			list  = commonService.getCgList("CG_1005", "Y");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	@RequestMapping(value = "/saveUnearnedList", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> saveUnearnedList( @RequestParam(required = true) HashMap<String, Object> param,
												     HttpSession session,
													 HttpServletRequest  request,
													 HttpServletResponse response){
		logService.insertUserActLog(request, session);
		HashMap<String, Object> map = new HashMap<String,Object>();
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		int result = 0;
		try {
			result = assetService.saveUnearnedList(param);
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
	
	
	@RequestMapping(value = "/unearnedUpdate")
	public ModelAndView unearnedUpdate(@RequestParam String UED_SEQ,
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		
		logService.insertUserActLog(request, session);
		
		ModelAndView mv           = new ModelAndView();
		HashMap<String, Object> r = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> uedCtgList  = new ArrayList<HashMap<String,Object>>();
		
		try {
			uedCtgList = commonService.getCgList("CG_1005", "Y") ;
			r = assetService.selectUnearned(UED_SEQ);
			mv.addObject("result"    , r               );
			mv.addObject("nav"       , "불로소득 내역 수정" );
			mv.addObject("uedCtgList", uedCtgList      );
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("asset/unearned/unearnedUpdate");
		return mv;
	}

	
	
	@RequestMapping(value = "/updateUnearned", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateUnearned(@RequestParam HashMap<String, Object> param, 
			                                      HttpSession session,
			                                      HttpServletRequest request,
			                                      HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		HashMap<String, Object> result = new HashMap<String, Object>();
		int r = 0;
		try {
			r = assetService.updateUnearned(param);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", CommonContraint.FAIL);
		}
		result.put("result", CommonContraint.SUCCEESS);
		return result;
	}
	
	
	@RequestMapping(value = "/deleteUnearedList", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> deleteUnearedList(@RequestParam HashMap<String, Object> param, 
			                                      HttpSession session,
			                                      HttpServletRequest request,
			                                      HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		HashMap<String, Object> result = new HashMap<String, Object>();
		int r = 0;
		try {
			String[] uedSeqs = param.get("UED_SEQS").toString().split(",");
			logger.info("uedSeqs==>" + uedSeqs);
			param.put("uedSeqs", uedSeqs);
			r = assetService.deleteUnearedList(param);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", CommonContraint.FAIL);
		}
		result.put("result", CommonContraint.SUCCEESS);
		return result;
	}
	
	
	
	@RequestMapping(value = "/salaryUpdate")
	public ModelAndView salaryUpdate(@RequestParam(required = false) String SAL_SEQ,
									 HttpSession session,
									 HttpServletRequest request,
									 HttpServletResponse response) {
		
		logService.insertUserActLog(request, session);
		
		ModelAndView mv           = new ModelAndView();
		HashMap<String, Object> r = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> paySelectList = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> dedSelectList = new ArrayList<HashMap<String,Object>>();
		
		
		
		try {

			if(!"".equals(SAL_SEQ) && SAL_SEQ != null) {
				
				paySelectList = commonService.getCgList("CG_1007", "Y");
				dedSelectList = commonService.getCgList("CG_1008", "Y");
				
				HashMap<String, Object> param = new HashMap<String, Object>();
				param.put("SAL_SEQ"  , SAL_SEQ);
				param.put("PAY_DEDUC", "PAY");
				
				ArrayList<HashMap<String, Object>> payList = assetService.getPayDedList(param);
				param.put("PAY_DEDUC", "DED");
				ArrayList<HashMap<String, Object>> dedList = assetService.getPayDedList(param);
                
				HashMap<String, Object> result = assetService.getSalSeqDate(param);
				
				mv.addObject("paySelectList", paySelectList);
				mv.addObject("dedSelectList", dedSelectList);
				mv.addObject("payList"      , payList);
				mv.addObject("dedList"      , dedList);
				mv.addObject("result"       , result);
				mv.addObject("nav"   , "급여 내역 수정");
				
			}else {
				mv.addObject("nav"   , "급여 내역 등록");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("asset/salary/salaryUpdate");
		return mv;
	}
	
	
	@RequestMapping(value = "/payDeducDtlList", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<HashMap<String, Object>> payDeducDtlList(@RequestParam(required = true) HashMap<String, Object> param,
													          HttpSession session,
															  HttpServletRequest  request,
															  HttpServletResponse response){
		logService.insertUserActLog(request, session);
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		String type = null;
		try {
			type = param.get("type").toString();
			if("PAY".equals(type)) {
				list  = commonService.getCgList("CG_1007", "Y");
			}else if("DED".equals(type)){
				list  = commonService.getCgList("CG_1008", "Y");
			}else {
				list = null;
			}
		}catch (Exception e) {
			e.printStackTrace();
			list = null;
		}
		return list;
	}
	
	
	@RequestMapping(value = "/saveSalaryList", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> saveSalaryList( @RequestParam(required = true) HashMap<String, Object> param,
												   HttpSession session,
												   HttpServletRequest  request,
												   HttpServletResponse response){
		logService.insertUserActLog(request, session);
		HashMap<String, Object> map = new HashMap<String,Object>();
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		int result = 0;
		try {
			result = assetService.saveSalaryList(param);
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
	
	
	@RequestMapping(value = "/salaryList", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> salaryList(@RequestParam    HashMap<String, Object> param, 
											                   HttpSession session,
															   HttpServletRequest  request,
															   HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")    == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		param.put("USER_SEQ", session.getAttribute("USER_SEQ"));
		
		logger.info("param==>" + param.toString());
		
		try {
			total = assetService.salaryCount(param);
			list  = assetService.salaryListUp(param);
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

	
}
