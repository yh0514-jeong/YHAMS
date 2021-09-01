package com.yhams.user;

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

@Controller
@RequestMapping("/user")
public class UserController {
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	UserService userService;
	
	@Autowired
	CommonService commonService;
	
	@RequestMapping(value = "/userManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/user/userList");
		return mv;
	}
	
	@RequestMapping(value = "/userListUp", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> userListUp(@RequestParam HashMap<String, Object> param, 
															HttpServletRequest  request,
															HttpServletResponse response){
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = userService.userCount(param);
			list  = userService.userList(param);
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
	
	
	@RequestMapping(value = "/userUpdate")
	public ModelAndView menuUpdate(@RequestParam(required = false) String USER_SEQ, 
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		logger.info("/userUpdate USER_SEQ=>" + USER_SEQ);
		
		ModelAndView mv               = new ModelAndView();
		HashMap<String, Object> r     = new HashMap<String, Object>();
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> actStList = new ArrayList<HashMap<String,Object>>();
		
		try {
			actStList = commonService.getCgList("CG_0004", "Y");
			param.put("USER_SEQ", USER_SEQ);
			if(USER_SEQ != null &&  !"".equals(USER_SEQ)){
				r = userService.getUserInfo(USER_SEQ);
				mv.addObject("result", r);
				mv.addObject("nav"   , "사용자 수정");
			}else {
				mv.addObject("nav"   , "사용자 등록");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("actStList", actStList);
		mv.setViewName("admin/user/userUpdate");
		
		return mv;
	}
	
	
	@RequestMapping(value = "/getUserList", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> comCodeListUp(@RequestParam HashMap<String, Object> param, 
															   HttpServletRequest  request,
															   HttpServletResponse response){
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		logger.info("param==>" + param.toString());
		logger.info(request.getRequestURL());
		
		try {
			list  = userService.getUserList(param);
			result.put("list",  list);
			result.put("resultCode",  "success");
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  "fail");
		}
		
		return result;
	}
	

}
