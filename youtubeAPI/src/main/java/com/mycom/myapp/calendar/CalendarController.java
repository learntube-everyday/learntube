package com.mycom.myapp.calendar;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.CalendarVO;
import com.mycom.myapp.commons.ClassesVO;

@Controller
@RequestMapping(value="/calendar")
public class CalendarController {
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private CalendarService calendarService;
	
	private int instructorID = 0;
	
	@RequestMapping(value="/{classID}", method = {RequestMethod.GET, RequestMethod.POST})
	public String calendar(@PathVariable(value="classID") int class_id, Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		
		ClassesVO vo = new ClassesVO();
		vo.setId(class_id);
		vo.setInstructorID(instructorID);
		
		if(classService.checkAccessClass(vo) == 0) {
			System.out.println("접근권한 없음!");
			return "accessDenied";
		}
		model.addAttribute("classID", class_id);
		model.addAttribute("allMyClass", classService.getAllMyActiveClass(instructorID));
		model.addAttribute("allMyInactiveClass", classService.getAllMyInactiveClass(instructorID));
		model.addAttribute("className", classService.getClassName(class_id));
		return "class/calendar";
	}
	
	@RequestMapping(value="/insertEvent", method = RequestMethod.POST)
	@ResponseBody
	public int insertEvent(@ModelAttribute CalendarVO vo) {
		int newID = calendarService.insertEvent(vo);
		if(newID > 0) 
			System.out.println("event 생성 성공:)");
		else 
			System.out.println("event 생성 실패:(");
		return newID;
	}
	
	@RequestMapping(value="/updateEvent", method = RequestMethod.POST)
	@ResponseBody
	public void updateEvent(@ModelAttribute CalendarVO vo) {
		 if(calendarService.updateEvent(vo) > 0) 
			 System.out.println("event 수정 성공:)");
		 else 
			 System.out.println("event 수정 실패:(");
	}
	
	@RequestMapping(value="/changeDate", method = RequestMethod.POST)
	@ResponseBody
	public void changeDate(@ModelAttribute CalendarVO vo) {
		 if(calendarService.changeDate(vo) > 0) 
			 System.out.println("event 수정 성공:)");
		 else 
			 System.out.println("event 수정 실패:(");
	}
	
	@RequestMapping(value="/deleteEvent", method = RequestMethod.POST)
	@ResponseBody
	public void deleteEvent(@RequestParam(value="id") int id) {
		 if(calendarService.deleteEvent(id) > 0) 
			 System.out.println("event 삭제 성공:)");
		 else 
			 System.out.println("event 삭제 실패:(");
	}
	
	@RequestMapping(value="/getScheduleList/{classID}", method = RequestMethod.GET)
	@ResponseBody
	public List<CalendarVO> getScheduleList(@PathVariable(value="classID") int classID) {
		 List<CalendarVO> result = calendarService.getScheduleList(classID);
		 if(result != null) 
			 System.out.println("schedule list 가져오기 성공:)");
		 else 
			 System.out.println("schedule list 가져오기 실패:(");
		 
		return result;
	}

}
