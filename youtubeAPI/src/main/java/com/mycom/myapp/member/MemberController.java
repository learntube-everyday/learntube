package com.mycom.myapp.member;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.attendance.AttendanceService;
import com.mycom.myapp.attendanceCheck.AttendanceCheckService;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.student.attendanceCheck.Stu_AttendanceCheckService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;

@Controller
@RequestMapping(value = "/member")
public class MemberController {
	@Autowired
	private MemberServiceImpl memberService;
	
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private Stu_NoticeService stu_noticeService;
	
	@Autowired
	private AttendanceCheckService attendanceCheckService;
	
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInternalCheckService;
	
	@Autowired
	private Stu_PlaylistCheckService stu_playlistCheckService;
	
	@Autowired
	private Stu_VideoCheckService stu_videoCheckService; 
	
	@ResponseBody
	@RequestMapping(value = "/updateName", method = RequestMethod.POST)
	public void updateName(@RequestParam(value = "name") String name, HttpSession session) {
		MemberVO loginvo = (MemberVO)session.getAttribute("login");
		MemberVO vo = new MemberVO();
		vo.setId((Integer)session.getAttribute("userID"));
		vo.setName(name);
		vo.setMode(loginvo.getMode());
		
		if(memberService.updateName(vo) != 0) {
			System.out.println("이름 업데이트 성공!");
			loginvo.setName(name);
			session.setAttribute("loginvo", loginvo);
		}
			
		else
			System.out.println("이름 업데이트 실패!");
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteMember", method = RequestMethod.POST)	
	public void deleteMember(HttpSession session) {
		MemberVO loginvo = (MemberVO)session.getAttribute("login");
		
		if(memberService.deleteMember(loginvo) != 0) {
			if(loginvo.getMode().equals("lms_instructor")) {
				//class 자동삭제 -> attendance(+check) & classContent & notice(+check) & playlistCheck & videoCheck & takes 자동삭제
				//playlist(+check) 자동삭제 -> video(+check)
				System.out.println("선생남 탈퇴 완료!");
			}
			else {
				//takes & attendanceCK & noticeCK & playlistCK & videoCK 자동삭제
				System.out.println("학생 탈퇴 완료!");
			}
		}
	}
	
	//(jw) 
	@ResponseBody
	@RequestMapping(value ="/allowTakes", method = RequestMethod.POST)
	public int allowTakes(@RequestBody Stu_TakesVO vo) {
		int result = stu_takesService.updateStatus(vo);
		
		if(classService.updateTotalStudent(vo.getClassID()) == 1) 
			System.out.println("totalStudent 업데이트 성공!");
		else 
			System.out.println("totalStudent 업데이트 실패 ");

		return result;
	}
	
	// 학생 삭제시 필요한 정보: 학생ID, 수업ID 
	@ResponseBody
	@RequestMapping(value ="/deleteTakes" , method = RequestMethod.POST)
	public int deleteTakes(@RequestBody Stu_TakesVO vo) {
		System.out.println(vo.getClassID() + vo.getStudentID());
		int result = stu_takesService.deleteTakes(vo);
		
		//1. attendance테이블에서 classID에 해당하는 attendanceID구하기) => 여러개임. 
		//2. attendanceID 하나씩 꺼내와서 해당 출석ID와 studentID 를 가지는 attendanceCheck 지우기. => 
//		List<AttendanceVO> IDList = new ArrayList<AttendanceVO>();
//		IDList = attendanceService.getAttendanceID2(vo.getClassID());
//		
//		HashMap<String, Object> map = new HashMap<String, Object>();
//		map.put("IDList", IDList);
//		attendanceCheckService.deleteAttendanceCheck(vo, map);
		
		attendanceCheckService.deleteAttendanceCheck(vo);
		attendanceInternalCheckService.deleteInternalAttendanceCheck(vo);
		stu_noticeService.deleteNoticeCheck(vo);
		stu_playlistCheckService.deletePlaylist(vo);
		stu_videoCheckService.deleteTime(vo);		
	
		if(classService.updateTotalStudent(vo.getClassID()) == 1) 
			System.out.println("totalStudent 업데이트 성공!");
		else
			System.out.println("totalStudent 업데이트 실패 ");	
				
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value ="/cancelEnroll" , method = RequestMethod.POST)
	public int cancelEnroll (@RequestBody Stu_TakesVO vo) {
		return stu_takesService.deleteTakes(vo);
	}
	
	@ResponseBody
	@RequestMapping(value="/updateTakesList", method = RequestMethod.GET)
	public Object updateList(@RequestParam(value = "classID") int classID, Model model) {
//			model.addAttribute("classInfo", classService.getClass(classID));
//			model.addAttribute("studentInfo", stu_takesService.getStudentInfo(classID));
		
		List<Stu_TakesVO> takesList = new ArrayList<Stu_TakesVO>();
		takesList = stu_takesService.getStudentInfo(classID);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("studentInfo", takesList);

		return map; 
	}
	
	@ResponseBody
	@RequestMapping(value = "/forHowManyTakes", method = RequestMethod.POST)
	public int forHowManyTakes(HttpServletRequest request, Model model) throws Exception {
		int classID = Integer.parseInt(request.getParameter("id"));
		System.out.println("classID : " + classID);
		return stu_takesService.getStudentNum(classID);
	}
	
}
