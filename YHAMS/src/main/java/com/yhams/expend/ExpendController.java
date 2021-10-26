package com.yhams.expend;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/expend")
public class ExpendController {
	
	private static final Logger logger = LoggerFactory.getLogger(ExpendController.class);
	
	@Autowired
	ExpendService service;
	
	@RequestMapping(value = "/expendPlan")
	public ModelAndView accountManageMain() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("expend/plan/expendPlanList");
		return mv;
	}
}
