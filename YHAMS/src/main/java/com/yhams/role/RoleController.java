package com.yhams.role;

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
import com.yhams.menu.MenuService;
import com.yhams.util.Constant;
import com.yhams.util.PagingUtil;

@Controller
@RequestMapping(value = "/role")
public class RoleController {
	
	private static final Logger logger = LoggerFactory.getLogger(RoleController.class);
	
	@Autowired
	RoleService roleservice;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	MenuService menuService;
	
	@Autowired
	LogService logService;
	
	@RequestMapping(value = "/roleManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/role/roleList");
		return mv;
	}
	
	
	@RequestMapping(value = "/roleListUp", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> roleListUp(@RequestParam HashMap<String, Object> param,
			                                                HttpSession session,
														    HttpServletRequest  request,
															HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		logger.info("roleListUp param.toString()==>" + param.toString());
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = roleservice.roleCount(param);
			list  = roleservice.roleList(param);
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

	
	@RequestMapping(value = "/roleUpdate")
	public ModelAndView roleUpdate(@RequestParam(required = false) String ROLE_ID,
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		logService.insertUserActLog(request, session);
		
		logger.info("/roleUpdate ==> ROLE_ID " +  ROLE_ID);
		
		ModelAndView mv                = new ModelAndView();
		HashMap<String, Object> result = new HashMap<String, Object>();

		ArrayList<HashMap<String, Object>> useYnCodeList = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> comCodeList = new ArrayList<HashMap<String,Object>>();
		
		HashMap<String, Object> param  = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> roleList = new ArrayList<HashMap<String,Object>>();
		
		try {
			useYnCodeList = commonService.getCgList("CG_0003", "Y");
			if(ROLE_ID != null && ROLE_ID != "undefined" && ROLE_ID != "") {
				param.put("ROLE_ID", ROLE_ID);
				result = roleservice.selectRole(param);
				logger.info("result==>" + result.toString());
				mv.addObject("ROLE_ID", ROLE_ID);
				mv.addObject("result" , result);
				mv.addObject("nav"    , "권한 수정");
			}else{
				mv.addObject("nav"    , "권한 등록");
			}
			
			roleList = roleservice.getRoleList(param);
			mv.addObject("roleList", roleList);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("comCodeList"  ,  comCodeList);
		mv.addObject("useYnCodeList", useYnCodeList);
		mv.setViewName("admin/role/roleUpdate");
		return mv;
	}
	
	
	
	
	@RequestMapping(value = "/updateRole", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateRole(@RequestParam HashMap<String, Object> param, 
			                                     HttpSession session,
			                                     HttpServletRequest request,
			                                     HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		int r = 0;
		try {
			
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			
			if("INSERT".equals(param.get("ACTION"))){
				String ROLE_ID = commonService.getNextRoleId();
				param.put("ROLE_ID", ROLE_ID);
				System.out.println("updateRole insert param.toString()==>" + param.toString());
				r = roleservice.insertRole(param);
			}else {
				System.out.println("updateRole update param.toString()==>" + param.toString());
				r = roleservice.updateRole(param);
			}
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", Constant.FAIL);
		}
		result.put("result", Constant.SUCCEESS);
		return result;
	}
	
	
	
	@RequestMapping(value = "/roleMenuMap")
	public ModelAndView roleMenuMap(@RequestParam(required = true) String ROLE_ID,
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		logService.insertUserActLog(request, session);
		
		ModelAndView mv                 = new ModelAndView();
		HashMap<String, Object> r       = new HashMap<String, Object>();
		HashMap<String, Object> param   = new HashMap<String, Object>();
		HashMap<String, Object> roleMap = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> menuList        = new ArrayList<HashMap<String,Object>>();
		ArrayList<HashMap<String, Object>> roleMenuMapList = new ArrayList<HashMap<String,Object>>();
		
		try {
			
			menuList = menuService.getMenuList();
			param.put("ROLE_ID", ROLE_ID);
			roleMap = roleservice.selectRole(param);
			roleMenuMapList = roleservice.getRoleMenuMapList(param);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("roleMap", roleMap);
		mv.addObject("menuList", menuList);
		mv.addObject("roleMenuMapList", roleMenuMapList);
		mv.setViewName("admin/role/roleMenuMap");
		
		return mv;
	}
	
	
	@RequestMapping(value = "/updateRoleMenuMap", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateRoleMenuMap(@RequestParam HashMap<String, Object> param,
													  HttpSession session,
													  HttpServletRequest  request,
													  HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		int r = 0;
		
		try {
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			
			r = roleservice.updateRoleMenuMap(param);
			
			result.put("resultCode",  Constant.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  Constant.FAIL);
		}
		
		return result;
	}
	
	
	
	@RequestMapping(value = "/roleUserMap")
	public ModelAndView roleUserMap(@RequestParam(required = true) String ROLE_ID,
									HttpSession session,
									HttpServletRequest request,
									HttpServletResponse response) {
		logService.insertUserActLog(request, session);
		
		ModelAndView mv               = new ModelAndView();
		HashMap<String, Object> param = new HashMap<String, Object>();
		HashMap<String, Object> roleMap = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> roleUserMapList = new ArrayList<HashMap<String,Object>>();
		
		try {
			
			param.put("ROLE_ID", ROLE_ID);
			roleMap = roleservice.selectRole(param);
			roleUserMapList = roleservice.getRoleUserMapList(param);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("roleMap", roleMap);
		mv.addObject("roleUserMapList", roleUserMapList);
		mv.setViewName("admin/role/roleUserMap");
		
		return mv;
	}
	
	
	@RequestMapping(value = "/updateRoleUserMap", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateRoleUserMap(@RequestParam HashMap<String, Object> param,
													  HttpSession session,
													  HttpServletRequest  request,
													  HttpServletResponse response){
		
		logService.insertUserActLog(request, session);
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		int r = 0;
		
		try {
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			
			r = roleservice.updateRoleUserMap(param);
			
			result.put("resultCode",  Constant.SUCCEESS);
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode",  Constant.FAIL);
		}
		
		return result;
	}
	
}
