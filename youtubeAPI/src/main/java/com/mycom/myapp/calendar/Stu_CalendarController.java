package com.mycom.myapp.calendar;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.student.classes.Stu_ClassesService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/calendar")

public class Stu_CalendarController {
	@Autowired
	private ClassesService classService;
	@Autowired
	private Stu_ClassesService classService_stu;
	@Autowired
	private CalendarService calendarService;
	
	@RequestMapping(value="/{classID}", method = RequestMethod.GET)
	public String calendar(@PathVariable(value="classID") int classID, Model model, HttpSession session) {	
		int studentID = (Integer)session.getAttribute("userID");
		
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setStudentID(studentID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(studentID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(studentID)));
		
		if(classService_stu.checkTakeClass(vo) == 0) {
			System.out.println("수강중인 과목이 아님!");
			return "accessDenied_stu";
		}
		
		model.addAttribute("classID", classID);
		model.addAttribute("className", classService.getClassName(classID));
		return "class/calendar_Stu";
	}
}
