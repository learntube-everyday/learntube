package com.mycom.myapp.classes;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.annotation.Schedules;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.calendar.CalendarService;
import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.commons.CalendarVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;

import net.sf.json.JSONArray;

@Controller
public class ClassController {
	
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private CalendarService calendarService;
	
	@Autowired
	private ClassContentService classContentService;
	
	@Autowired
	private Stu_ClassContentService stu_classContentService;
	
	@Autowired
	private MemberService memberService;
	
	private int instructorID = 0;
	
	@RequestMapping(value = "/test/dashboard",  method = {RequestMethod.GET,RequestMethod.POST})	//개발 test용.
	public String dashboard_Test(Model model, HttpSession session) {
		MemberVO checkvo = new MemberVO();
		checkvo.setEmail("21800702@handong.edu");
		checkvo.setMode("lms_instructor");
		MemberVO vo = memberService.getMember(checkvo);
		vo.setMode("lms_instructor");
		
		session.setAttribute("login", vo);
		session.setAttribute("userID", 1); //instructorID = 1은 test용
		instructorID = 1;
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		return "class/dashboard";
	}

	@RequestMapping(value = "/dashboard",  method = {RequestMethod.GET,RequestMethod.POST})	//학생이랑 선생님 같이 사용하도록 바꾸기!!
	public String dashboard(Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		return "class/dashboard";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forPublished",  method = RequestMethod.POST)	//학생이랑 선생님 같이 사용하도록 바꾸기!!
	public int forPubished(HttpServletRequest request, Model model) throws Exception {
		int classID = Integer.parseInt(request.getParameter("classID"));
		int count = 0;
		for(int i=0; i<stu_classContentService.getPlaylistCount(classID); i++) { //차시 개
			//차시 내의 영상개수만큼반복해서
			//모두 published 되었다면 count증가 
			ClassContentVO ccvo = new ClassContentVO ();
			ccvo.setClassID(classID);
			ccvo.setDays(i);
			
			for(int j=0; j<classContentService.getDaySeqNum(ccvo); j++) {
				if(classContentService.getDaySeq(ccvo).get(j).getPublished() == 0) {
					break;
				}
				else {
					if(j == classContentService.getDaySeqNum(ccvo)-1) //모두 publish된 경우 
						count++;
					continue;
				}
			}
			
			//(classContentService.get) // classID랑 days, published = 1인거 
		}
		return count; //published된 차시 
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forAll",  method = RequestMethod.POST)	//학생이랑 선생님 같이 사용하도록 바꾸기!!
	public int forAll(HttpServletRequest request, Model model) throws Exception {
		int classID = Integer.parseInt(request.getParameter("classID"));
		return classService.getClass(classID).getDays(); //전체 차시
	}	
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") int classID) {
		ClassesVO vo = classService.getClass(classID);
		return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllMyClass", method = RequestMethod.POST)
	public Object getAllNotices(HttpSession session) {
		//instructorID = (Integer)session.getAttribute("userID");
		List<ClassesVO> list = classService.getAllMyActiveClass(instructorID);
		List<ClassesVO> inactiveList = classService.getAllMyInactiveClass(instructorID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("active", list);
		map.put("inactive", inactiveList);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllClass", method = RequestMethod.POST)
	public Object getAllInactiveNotices(
							@RequestParam(value = "active") int active,
							@RequestParam(value = "order") String order) {	//active, inactive 선택적으로 가져오는 함수 (위에꺼 나중에 이걸로 사용?!)
		ClassesVO vo = new ClassesVO();
		vo.setInstructorID(instructorID);
		vo.setActive(active);
		vo.setOrder(order);

		List<ClassesVO> list = classService.getAllClass(vo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		return map;
	}
	
	@RequestMapping(value = "/addDays", method = RequestMethod.POST) 
	public String addContent(ClassesVO vo) {
		if (classService.updateDays(vo) != 0)
			System.out.println("addDays 성공");
		else
			System.out.println("addDays 실패");
		
		return "ok";
	}

	public String createEntryCode() {
		List<String> list = classService.getAllEntryCodes();
		StringBuilder entryCode = new StringBuilder();
		String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ";
		int flag = 1;
		Random rand = new Random();
		
		while(true) {
			for(int i=0; i<6; i++) {
				entryCode.append(chars.charAt(rand.nextInt(36)));
			}
			for(String codes : list) {
				if(codes.toString().equals(entryCode.toString())) {
					flag = 0;
				}
			}
			if(flag == 1) break;
		}
		String result = entryCode.toString();
		
		return result;
	}
	
	@RequestMapping(value="/insertClassroom", method = {RequestMethod.GET,RequestMethod.POST})
	public String insertClassroom(@ModelAttribute ClassesVO vo) {
		if(vo.getCloseDate() == "") vo.setCloseDate(null);
		vo.setInstructorID(instructorID);
		vo.setEntryCode(createEntryCode());

		if (classService.insertClassroom(vo) >= 0) 
			System.out.println("controller 강의실 생성 성공"); 
		else 
			System.out.println("controller 강의실 생성 실패");
		return "class/dashboard";
		
	}
	
	@ResponseBody
	@RequestMapping(value="/editClassroom", method = RequestMethod.POST)
	public String editClassroom(@ModelAttribute ClassesVO vo) {
		if(vo.getCloseDate() == "") vo.setCloseDate(null);
		if (classService.updateClassroom(vo) != 0) {
			System.out.println("controller 강의실 수정 성공");
			return "ok";
		}
		else {
			System.out.println("controller 강의실 수정 실패");
			return "error";
		}	
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteForMe", method = RequestMethod.POST)
	public void deleteClassroomForMe(
			@RequestParam(value = "id") int classID,
			@RequestParam(value = "date") String date) {
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setCloseDate(date);
		
		if(classService.updateInstructorNull(vo) != 0) {
			System.out.println("controller instructor null 성공");
			
			if(classService.updateActive(classID) != 0) {
				System.out.println("controller class active null 성공");
			}
		}
		else System.out.println("controller delete classroom for me 업데이트 실패");
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteForAll", method = RequestMethod.POST)
	public void deleteClassroomForAll(@RequestParam(value = "id") int classID) {
		// lms_class row 
			//(+ takes, classContent, playlistCheck, videoCheck, attnedance, attendanceCheck 도 한번에) 삭제
		if(classService.deleteClassroom(classID) != 0) 
			System.out.println("controller delete classroom 성공");
		else
			System.out.println("controller delete classroom 실패");
	}
	
	@ResponseBody
	@RequestMapping(value="/copyClassroom", method = RequestMethod.POST)
	public int copyClassroom(
			@RequestParam(value = "id") int classID,
			@RequestParam(value = "calendar") int calendar,
			@RequestParam(value = "content") int content
			) {	
		
		ClassesVO vo = classService.getClassInfoForCopy(classID);	//Copy할 기존 강의실 데이터 가져오기
		String name = vo.getClassName() + "-1";
		vo.setClassName(name);
		vo.setEntryCode(createEntryCode());
		
		int newClassID = classService.insertClassroom(vo); //새로 생성된 classID 저장
		if(newClassID >= 0)	//복사한 classContents 각 row에 설정된 nextClassID와 같은지 check
			System.out.println("Class 생성 성공");
		else {
			System.out.println("Class 생성 실패");
			return 0;
		}
		
		if(calendar != 0) {
			List<CalendarVO> original = calendarService.getScheduleList(classID);
			
			if (original.size() != 0) {
				for (int i=0; i<original.size(); i++) {	
					original.get(i).setClassID(newClassID);	//newClassID 로 설정
					if(original.get(i).getAllday() == null) original.get(i).setAllday(0);
				}	
				if(calendarService.insertCopiedCalendar(original) != 0)
					System.out.println("class calendar 복사 완료!");
				else {
					System.out.println("class calendar 복사 실패!");
					return 0;
				}
			}
			
		}
		
		// lms_classContent에 기존 classID의 내용 가져오기
			// days, daySeq, title, description, playlistID만 가져오기
		if(content != 0) {
			List<ClassContentVO> original = classContentService.getAllClassContentForCopy(classID);
			if(original.size() != 0) {
				for (int i=0; i<original.size(); i++) {	
					original.get(i).setClassID(newClassID);
					//if(original.get(i).getPublished() == null) original.get(i).setAllday(0);
				}	
			
				if(classContentService.insertCopiedClassContents(original) != 0)
					System.out.println("class contents 복사 완료!");
				else {
					System.out.println("class contents 복사 실패!");
					return 0;
				}
			}
			
		}
		
		return 1;
	}


}
