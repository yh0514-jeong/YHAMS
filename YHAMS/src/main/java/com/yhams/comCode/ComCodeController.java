package com.yhams.comCode;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.common.CommonService;
import com.yhams.util.PagingUtil;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/comCode")
public class ComCodeController {
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	ComCodeService comCodeService;
	
	@Autowired
	CommonService commonService;
	
	
	@RequestMapping(value = "/comCodeManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/comCode/comCodeList");
		return mv;
	}
	
	@RequestMapping(value = "/comCodeUpdate")
	public ModelAndView comCodeUpdate(@RequestParam(required = false) String CODE_ID, 
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		logger.info("/comCodeUpdate CODE_ID=>" + CODE_ID);
		
		ModelAndView mv           = new ModelAndView();
		HashMap<String, Object> r = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> useYnCodeList = new ArrayList<HashMap<String,Object>>();
		
		try {
			useYnCodeList = commonService.getCgList("CG_0003", "Y");
			if(CODE_ID != null &&  !"".equals(CODE_ID)){
				r = comCodeService.selectCodeId(CODE_ID);
				mv.addObject("result", r);
				mv.addObject("nav"   , "공통코드 수정");
			}else {
				mv.addObject("nav"   , "공통코드 등록");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("useYnCodeList", useYnCodeList);
		mv.setViewName("admin/comCode/comCodeUpdate");
		return mv;
	}
	
	@RequestMapping(value = "/updateComCode", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateComCode(@RequestParam HashMap<String, Object> param, 
			                                     HttpSession session,
			                                     HttpServletRequest request,
			                                     HttpServletResponse response){
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		int r = 0;
		try {
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			
			if(param.get("CODE_ID") == null || "".equals(param.get("CODE_ID"))){
				String CODE_ID = commonService.getNextCodeId();
				param.put("CODE_ID", CODE_ID);
				System.out.println("updateComCode insert param.toString()==>" + param.toString());
				r = comCodeService.insertComCode(param);
			}else {
				System.out.println("updateComCode update param.toString()==>" + param.toString());
				r = comCodeService.updateComCode(param);
			}
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		result.put("result", "success");
		return result;
	}
	
	
	@RequestMapping(value = "/comCodeListUp", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> comCodeListUp(@RequestParam HashMap<String, Object> param, 
															   HttpServletRequest  request,
															   HttpServletResponse response){
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		logger.info("param==>" + param.toString());
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = comCodeService.comCodeCount(param);
			list  = comCodeService.comCodeListUp(param);
			PagingUtil pagingUtil = new PagingUtil(10, cntPerPage, total);
			Map<String, Object> block = pagingUtil.getFixedBlock(curPage);
			result.put("block", block);
			result.put("total", total);
			result.put("list",  list);
			result.put("resultCode",  "success");
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  "fail");
		}
		
		return result;
	}
	

}