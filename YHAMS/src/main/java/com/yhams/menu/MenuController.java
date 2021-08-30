package com.yhams.menu;

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
import com.yhams.util.PagingUtil;
import com.yhams.util.StringUtil;

@Controller
@RequestMapping("/menu")
public class MenuController {
	
	private static final Logger logger = LoggerFactory.getLogger(MenuController.class);

	@Autowired
	MenuService menuService;
	
	@Autowired
	CommonService commonService;
	
	@RequestMapping(value = "/menuManageMain")
	public ModelAndView main() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/menu/menuList");
		return mv;
	}
	
	@RequestMapping(value = "/menuListUp", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> menuListUp(@RequestParam HashMap<String, Object> param, 
															HttpServletRequest  request,
															HttpServletResponse response){
		
		HashMap<String, Object> result          = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		
		long total       = 0;
		int cntPerPage   = param.get("cntPerPage") == null ? 10 : Integer.parseInt(param.get("cntPerPage").toString());
		int curPage      = param.get("curPage")  == null ? 1 : Integer.parseInt(param.get("curPage").toString());
		
		try {
			total = menuService.menuCount(param);
			list  = menuService.menuList(param);
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
	
	
	@RequestMapping(value = "/menuUpdate")
	public ModelAndView menuUpdate(@RequestParam(required = false) String MENU_ID, 
							            HttpSession session,
							            HttpServletRequest request,
							            HttpServletResponse response) {
		
		logger.info("/menuUpdate MENU_ID=>" + MENU_ID);
		
		ModelAndView mv               = new ModelAndView();
		HashMap<String, Object> r     = new HashMap<String, Object>();
		HashMap<String, Object> param = new HashMap<String, Object>();
		ArrayList<HashMap<String, Object>> menuList = new ArrayList<HashMap<String,Object>>();
		
		
		try {
			param.put("MENU_ID", MENU_ID);
			menuList = menuService.getMenuList();
			if(MENU_ID != null &&  !"".equals(MENU_ID)){
				r = menuService.selectMenu(MENU_ID);
				
				mv.addObject("result", r);
				mv.addObject("nav"   , "메뉴 수정");
			}else {
				mv.addObject("nav"   , "메뉴 등록");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("menuList", menuList);
		mv.setViewName("admin/menu/menuUpdate");
		
		return mv;
	}
	
	
	
	@RequestMapping(value = "/updateMenu", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> updateMenu(@RequestParam HashMap<String, Object> param, 
			                                     HttpSession session,
			                                     HttpServletRequest request,
			                                     HttpServletResponse response){
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		logger.info("/updateMenu, param.toString()==>" + param.toString());
		int r = 0;
		try {
			param.put("CREATE_ID", session.getAttribute("USER_SEQ"));
			param.put("UPDATE_ID", session.getAttribute("USER_SEQ"));
			
			if("INSERT".equals(StringUtil.StringNVL(param.get("ACTION")))){ 
				String MENU_ID = commonService.getNextMenuId();
				param.put("MENU_ID", MENU_ID);
				r =	menuService.insertMenu(param);
			}else { 
				r =	menuService.updatetMenu(param); 
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			result.put("result", "fail");
		}
		result.put("result", "success");
		return result;
	}
	

}
