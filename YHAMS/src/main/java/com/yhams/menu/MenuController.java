package com.yhams.menu;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yhams.util.PagingUtil;

@Controller
@RequestMapping("/menu")
public class MenuController {
	
	@Autowired
	MenuService menuService;
	
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

}
