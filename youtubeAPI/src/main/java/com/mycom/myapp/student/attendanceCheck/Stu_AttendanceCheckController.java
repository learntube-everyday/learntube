package com.mycom.myapp.student.attendanceCheck;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/attendance")
public class Stu_AttendanceCheckController {
	@Autowired
	private Stu_ClassesService classesService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private Stu_ClassContentService classContentService;
	
	@Autowired
	private Stu_AttendanceCheckService stu_attendanceCheckService;
	
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	
	private int studentID = 01;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)
	public String attendancehome(@PathVariable("classId") int classId, Model model, HttpSession session) {
		studentID = (Integer)session.getAttribute("userID");
		classID = classId;
		
		ClassesVO vo = new ClassesVO();
		vo.setId(classId);
		vo.setStudentID(studentID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(studentID)));
		
		if(classesService.checkTakeClass(vo) == 0) {
			System.out.println("수강중인 과목이 아님!");
			return "accessDenied_stu";
		}
		
		model.addAttribute("classInfo", classesService.getClass(classID)); 
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); 
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		
		List<Stu_TakesVO> studentTakes = stu_takesService.getStudentTakes(classID);
		model.addAttribute("takes", studentTakes);
		model.addAttribute("takesNum", studentTakes.size());
		List<String> file = new ArrayList<String>();
		Stu_TakesVO stu_avo = new Stu_TakesVO();
		
		stu_avo.setStudentID(studentID);
		stu_avo.setClassID(classID);
		//vo말고 map의 형태로 넘겨주기 
		//stu_attendanceCheckService.getStuAttendanceCheckList(stu_avo);
		System.out.println("studentID : " + studentID + " classID : " + classID);
		for(int i=0; i<stu_attendanceCheckService.getStuAttendanceCheckList(stu_avo).size(); i++) {
			System.out.println(i + " : " +stu_attendanceCheckService.getStuAttendanceCheckList(stu_avo).get(i).getExternal());
			file.add(stu_attendanceCheckService.getStuAttendanceCheckList(stu_avo).get(i).getExternal());
		}
		model.addAttribute("file", file);
		
		return "class/attendance_Stu";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {
		
		return stu_takesService.getStudentTakes(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/forWatchedCount", method = RequestMethod.POST)
	public int forWatchedCount(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		int classContentID = Integer.parseInt(request.getParameter("classContentID")); //이거 지우면 안된다, 
		System.out.println("watch");
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
	    vo.setPlaylistID(playlistID);
	    vo.setStudentID(studentID);
	    vo.setClassContentID(classContentID);
	    
	    int count = 0;
	    for(int i=0; i<videoCheckService.getWatchedCheck(vo).size(); i++) {
	    	if(videoCheckService.getWatchedCheck(vo).get(i).getWatched() == 1)
	    		count++;
	    }
	    return count;
	}
}
