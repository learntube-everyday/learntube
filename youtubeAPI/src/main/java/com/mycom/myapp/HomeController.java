package com.mycom.myapp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassesVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	private ClassesService classService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {

		return "home";
	}
	
	@RequestMapping(value = "/test", method = RequestMethod.GET)	//개발 test용
	public String test_home() {

		return "home";
	}
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String admin(Model model) {
		List<ClassesVO> classList = classService.getAllClassForAdmin();
		model.addAttribute("class", classList);
		return "admin";
	}
}