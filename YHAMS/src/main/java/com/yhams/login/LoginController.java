package com.yhams.login;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.common.CommonService;
import com.yhams.exception.SaveUserInfoException;
import com.yhams.util.CommonContraint;
import com.yhams.util.Encryption;

@Controller
@RequestMapping
public class LoginController {
	
	private static final Logger log = LoggerFactory.getLogger(LoginController.class);
	
	@Autowired
	private LoginService loginservice;
	
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value = "/main")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("main");
		return mv;
	}
	
	
	@RequestMapping(value = "/login")
	public ModelAndView login() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("login/login");
		return mv;
	}
	
	
	@RequestMapping(value = "/signUp")
	public ModelAndView signUp() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("login/signup");
		return mv;
	}
	
	
	@GetMapping(value = "/idDupChk")
	@ResponseBody
	public HashMap<String, Object> idDupChk(@RequestParam HashMap<String, Object> param, 
											  HttpServletRequest request, 
											  HttpServletResponse response){
	
		HashMap<String, Object> result = new HashMap<>();
		try {
			String idDupChk = loginservice.idDupChk(param);
			if("TRUE".equals(idDupChk)) {
				result.put("result", true);
			}else{
				result.put("result", false);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	@RequestMapping(value = "/signUpSave", method = RequestMethod.POST)
	@ResponseBody
	@SuppressWarnings("unused")
	public HashMap<String, Object> signUpSave(@RequestParam HashMap<String, Object> param, 
											  HttpServletRequest request, 
											  HttpServletResponse response){
		HashMap<String, Object> result = new HashMap<String, Object>();
		int res = 0;
		try {
			res = loginservice.insertUser(param);
			if(res == -1) throw new SaveUserInfoException(param.get("USER_ID").toString());
			result.put("resultcode", CommonContraint.SUCCEESS);
		}catch (Exception e) {
			result.put("resultcode", CommonContraint.FAIL);
			e.printStackTrace();
		}
		return result;
	}
	
	
	@RequestMapping(value = "/loginCheck", method = RequestMethod.POST)
	@ResponseBody
	@SuppressWarnings("all")
	public ModelAndView loginCheck(@RequestParam HashMap<String, Object> param, 
										HttpServletRequest request, 
										HttpServletResponse response, 
										HttpSession session){
		ModelAndView mv = new ModelAndView();
		System.out.println("param.toString()==>" + param.toString());
		String result = null;
		ArrayList<HashMap<String, Object>> menuList = new ArrayList<HashMap<String,Object>>();
		HashMap<String, Object> userInfo            = new HashMap<String, Object>();
		
		try {
			param.put("USER_PW", Encryption.encryptPassword(param.get("USER_PW").toString()));
			result = loginservice.chkUserInfo(param);
			
			if("TRUE".equals(result)) {
				
				mv.setViewName("main");
				
				userInfo = loginservice.getUserInfo(param);
				
				session.setAttribute("USER_SEQ",      userInfo.get("USER_SEQ"));
				session.setAttribute("USER_ID",       userInfo.get("USER_ID"));
				session.setAttribute("USER_NM",       userInfo.get("USER_NM"));
				session.setAttribute("USER_NM_EN",    userInfo.get("USER_NM_EN"));
				session.setAttribute("USER_EMAIL",    userInfo.get("USER_EMAIL"));
				session.setAttribute("ROLE_ID",       userInfo.get("ROLE_ID"));
				
				System.out.println("userInfo session==>" + session.toString());
				 
				menuList = loginservice.getUserMenuList(userInfo);
				mv.addObject("menuList", menuList);
				
			}else {
				request.setCharacterEncoding("UTF-8");   
				response.setCharacterEncoding("UTF-8");   
				response.getWriter().write("<script> alert('아이디와 비밀번호를 다시 한 번 확인해주세요.'); </script>");
				response.getWriter().flush();
				mv.setViewName("login/login");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			mv.setViewName("login/login");
		}
		
		return mv;
	}
	
	@RequestMapping("/getSubMenuList")
	@ResponseBody
	@SuppressWarnings("all")
	public ArrayList<HashMap<String, Object>> getSubMenuList(@RequestParam HashMap<String, Object> param, 
																		   HttpServletRequest request, 
																		   HttpServletResponse response, 
																		   HttpSession session){
		
		ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
		
		try {
			param.put("PAR_MENU_ID", param.get("PAR_MENU_ID"));
			param.put("USER_SEQ",    session.getAttribute("USER_SEQ"));
			subMenuList = loginservice.getSubMenuList(param);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return subMenuList;
	}
	
	
	@GetMapping(value = "/logout")
	@SuppressWarnings("all")
	public ModelAndView logout(HttpServletRequest request, 
							   HttpServletResponse response, 
							   HttpSession session){
		ModelAndView mv = new ModelAndView();
		
		try {
			session.invalidate();
		}catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("login/login");
		return mv;
	}
	
}
