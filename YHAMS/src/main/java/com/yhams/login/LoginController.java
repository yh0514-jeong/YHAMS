package com.yhams.login;

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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.common.CommonService;
import com.yhams.exception.SaveUserInfoException;
import com.yhams.util.Constant;
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
			result.put("resultcode", Constant.SUCCEESS);
		}catch (Exception e) {
			result.put("resultcode", Constant.FAIL);
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
		String result = null;
		ArrayList<HashMap<String, Object>> menuList = new ArrayList<HashMap<String,Object>>();
		Optional<HashMap<String, Object>> userInfo  = Optional.empty();
		Optional<HashMap<String, Object>> maybeLoginFailInfo = Optional.empty();
		Optional<String> maybeActSt = Optional.empty();
		
		try {
			param.put("USER_PW", Encryption.encryptPassword(param.get("USER_PW").toString()));
			param.put("PWD_FAIL_CNT", Constant.PWD_FAIL_CNT);
			log.info("loginCheck Invoked... input userInfo : {}", param.toString());

			
			userInfo = Optional.ofNullable(loginservice.getUserInfo(param));
			maybeActSt = Optional.ofNullable(loginservice.getActiveStatus(param));
			log.info("loginCheck Invoked... selected UserInfo : {}, actSt : {}", userInfo.toString(), maybeActSt.toString());
			
			request.setCharacterEncoding("UTF-8");   
			response.setCharacterEncoding("UTF-8"); 
			
			if(userInfo.isPresent()) {
				if(Constant.ACTIVE.equals(maybeActSt.get())) {
					loginservice.updateLastLoginTime(userInfo.get());
					 
					 session.setAttribute("USER_SEQ",      userInfo.get().get("USER_SEQ"));
					 session.setAttribute("USER_ID",       userInfo.get().get("USER_ID"));
					 session.setAttribute("USER_NM",       userInfo.get().get("USER_NM"));
					 session.setAttribute("USER_NM_EN",    userInfo.get().get("USER_NM_EN"));
					 session.setAttribute("USER_EMAIL",    userInfo.get().get("USER_EMAIL"));
					 session.setAttribute("ROLE_ID",       userInfo.get().get("ROLE_ID"));
					 
					 menuList = loginservice.getUserMenuList(userInfo.get());
					 mv.addObject("menuList", menuList);
					 mv.setViewName("/main");
				
				}else {
					switch (maybeActSt.get()) {
						case Constant.INACTIVE:
							response.getWriter().write("<script> alert('계정이 비활성화 상태입니다. 관리자에게 문의해주세요.'); </script>");
							break;
						
						case Constant.LOCK:
							response.getWriter().write("<script> alert('계정이 잠금 상태입니다. 관리자에게 문의해주세요.'); </script>"); 
							break;
					}
					response.getWriter().flush();
					mv.setViewName("login/login");
				}
			}else{
				// 로그인 실패시, 실패 횟수 증가
				maybeLoginFailInfo = Optional.ofNullable(loginservice.increaseFailCount(param));
				
				StringBuffer message = new StringBuffer("<script>alert('");
				
				if(maybeLoginFailInfo.isPresent()) {
					
					String actSt   = maybeLoginFailInfo.get().get("ACT_ST").toString();
					int pwdFailCnt = Integer.parseInt(maybeLoginFailInfo.get().get("PWD_FAIL_CNT").toString());
					
					switch (actSt) {
						case Constant.LOCK :
							message.append("계정이 잠금 상태입니다. 관리자에게 문의해주세요.");
							break;
							
						case Constant.INACTIVE :
							message.append("계정이 비활성화 상태입니다. 관리자에게 문의해주세요.");
							break;
							
						case Constant.ACTIVE : 
							message.append("아이디와 비밀번호를 다시 한 번 확인해주세요. (총 ");
							message.append(Constant.PWD_FAIL_CNT);
							message.append("회이상 잘못 입력시 계정이 잠금 상태로 전환, 현재까지 시도 회수 : ");
							message.append(pwdFailCnt);
							break;
							
						default :
							message.append("아이디와 비밀번호를 다시 한 번 확인해주세요.");
							break;
							
					}
				
				}else{
					message.append("아이디와 비밀번호를 다시 한 번 확인해주세요.");
				}
				message.append("');</script>");
				response.getWriter().write(message.toString());
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
