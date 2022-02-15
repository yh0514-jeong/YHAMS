package com.yhams.detailCode;

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

import com.yhams.comCode.ComCodeService;
import com.yhams.common.CommonService;
import com.yhams.log.LogService;
import com.yhams.util.Constants;
import com.yhams.util.PagingUtil;
import com.yhams.util.StringUtil;

@Controller
@RequestMapping("/dtlCode")
public class DetailCodeController {
	
	private static final Logger log = LoggerFactory.getLogger(DetailCodeController.class);
	
	@Autowired
	private DetailCodeService dtlCodeService;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private ComCodeService comCodeService;
	
	@Autowired
	private LogService logService;
	
	
	@RequestMapping(value = "/dtlCodeManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/detailCode/detailCodeList");
		return mv;
	}
	
	@RequestMapping(value = "/dtlCodeUpdate")
	public ModelAndView dtlCodeUpdate(@RequestParam(required = false) String CODE_ID,
			                          @RequestParam(required = false) String CODE_CD,   
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		logService.insertUserActLog(request, session);
		
		ModelAndView mv               = new ModelAndView();
		HashMap<String, Object> r     = new HashMap<String, Object>();

		ArrayList<HashMap<String, Object>> useYnCodeList = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> comCodeList = new ArrayList<HashMap<String,Object>>();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		try {
			comCodeList   = comCodeService.getComCodeUseList();
			useYnCodeList = commonService.getCgList("CG_0003", "Y");
			if(CODE_ID != null &&  CODE_CD != null){
				param.put("CODE_ID", CODE_ID);
				param.put("CODE_CD", CODE_CD);
				r = dtlCodeService.selectCodeCd(param);
				mv.addObject("result", r);
				mv.addObject("nav"   , "상세코드 수정");
			}else {
				mv.addObject("nav"   , "상세코드 등록");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("comCodeList"  ,  comCodeList);
		mv.addObject("useYnCodeList", useYnCodeList);
		mv.setViewName("admin/detailCode/detailCodeUpdate");
		return mv;
	}
	
	
	@RequestMapping(value = "/updateDtlCode", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateDtlCode(@RequestParam HashMap<String, Object> param, 
			                                     HttpSession session,
			                                     HttpServletRequest request,
			                                     HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		log.info("/updateDtlCode, param.toString()==>" + param.toString());
		int r = 0;
		try {
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			
			if("INSERT".equals(StringUtil.StringNVL(param.get("ACTION")))){ 
				r =	dtlCodeService.insertDtlCode(param); 
			}else { 
				r =	dtlCodeService.updateDtlCode(param); 
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", Constants.FAIL);
		}
		result.put("result", Constants.SUCCEESS);
		return result;
	}
	
	
	
	@RequestMapping(value = "/dtlCodeListUp", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> comCodeListUp(@RequestParam HashMap<String, Object> param, 
			                                                   HttpSession session,
															   HttpServletRequest  request,
															   HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = dtlCodeService.dtlCodeCount(param);
			list  = dtlCodeService.dtlCodeList(param);
			PagingUtil pagingUtil = new PagingUtil(10, cntPerPage, total);
			Map<String, Object> block = pagingUtil.getFixedBlock(curPage);
			result.put("block", block);
			result.put("total", total);
			result.put("list",  list);
			result.put("resultCode",  Constants.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", Constants.FAIL);
		}
		
		return result;
	}

}
