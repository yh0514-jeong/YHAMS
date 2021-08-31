package com.yhams.user;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/user")
public class UserController {
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	UserService userService;
	
	@RequestMapping(value = "/userManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/user/userList");
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
