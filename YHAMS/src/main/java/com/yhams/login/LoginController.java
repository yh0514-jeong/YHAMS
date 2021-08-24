package com.yhams.login;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.common.CommonService;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping
public class LoginController {
	
	@Autowired
	LoginService loginservice;
	
	@Autowired
	CommonService commonService;
	
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
	
	
	
	@RequestMapping(value = "/signUpSave", method = RequestMethod.POST)
	@ResponseBody
	@SuppressWarnings("unused")
	public HashMap<String, Object> signUpSave(@RequestParam HashMap<String, Object> param, HttpServletRequest request, HttpServletResponse response){
		HashMap<String, Object> result = new HashMap<String, Object>();
		int res = 0;
		try {
			String nextUserSeq = commonService.getUserNextSeq();
			param.put("USER_SEQ", nextUserSeq);
			param.put("USER_PW", encryptPassword(param.get("USER_PW").toString()));
			res = loginservice.insertUser(param);
		}catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("param.toString()==>" + param.toString());
		result.put("resultcode", "success");
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
			param.put("USER_PW", encryptPassword(param.get("USER_PW").toString()));
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


	private String encryptPassword(String pwd) throws Exception {
		String encrypted = null;
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512");
	        md.update(pwd.getBytes(StandardCharsets.UTF_8));
	        byte[] bytes = md.digest(pwd.getBytes(StandardCharsets.UTF_8));
	        StringBuilder sb = new StringBuilder();
	        for(int i=0; i< bytes.length ;i++){
	            sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
	        }
	        encrypted = sb.toString();
		}catch(NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		
		return encrypted;
	}
	
	
	
	
}
