package com.mycom.myapp.student.classes;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;
import com.mycom.myapp.attendanceCheck.AttendanceCheckService;
import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/class")	//class 지우기!!
public class Stu_ClassController{
	@Autowired
	private ClassesService classService;	//나중에 아래랑 이름 구분하기! 
	
	@Autowired
	private ClassContentService classInsContentService;
	
	@Autowired
	private Stu_ClassesService classesService;
	
	@Autowired
	private Stu_ClassContentService classContentService;
	
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private Stu_NoticeService noticeService;
	
	@Autowired
	private Stu_TakesService takesService;
	
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInCheckService;
	
	@Autowired
	private AttendanceCheckService attendanceCheckService;
	
	

	private int studentId = 0;
	
	@RequestMapping(value = "/test/dashboard/{studentID}",  method = RequestMethod.GET)	//개발 test용.
	public String dashboard_Test(@PathVariable("studentID") int id, Model model, HttpSession session) {
		MemberVO checkvo = new MemberVO();
		String email= "";
		
		if(id == 1) email = "jinwoo@gmail.com";
		else email = "hayeong@gmail.com";
		
		checkvo.setEmail(email);
		checkvo.setMode("lms_student");
		MemberVO vo = memberService.getMember(checkvo);
		vo.setMode("lms_student");
		
		session.setAttribute("login", vo);
		session.setAttribute("userID", id);
		studentId = id;
		
		Stu_TakesVO takesvo = new Stu_TakesVO();
		takesvo.setStudentID(studentId);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentId)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(studentId)));
		model.addAttribute("allPendingClass", JSONArray.fromObject(takesService.getPendingClass(studentId)));
		return "class/dashboard_Stu";
	}
	
	@RequestMapping(value = "/dashboard", method =  {RequestMethod.GET,RequestMethod.POST})	//선생님 controller랑 합치기!
	public String dashboard(HttpSession session, Model model) {
		// select id, className, startDate from lms_class where instructorID=#{instructorID}
		// 여러 선생님의 강의를 듣는 경우에는 어떻게 되는거지?? instructorID가 여러개인 경
		// takes테이블을 통해 가져올 수 있도록 해야겠다..
		studentId = (Integer)session.getAttribute("userID");
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentId)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(studentId)));
		model.addAttribute("allPendingClass", JSONArray.fromObject(takesService.getPendingClass(studentId)));
		return "class/dashboard_Stu";
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllClass", method = RequestMethod.POST)
	public Object getAllInactiveNotices(
							@RequestParam(value = "active") int active,
							@RequestParam(value = "order") String order) {
		ClassesVO vo = new ClassesVO();
		vo.setStudentID(studentId);
		vo.setActive(active);
		vo.setOrder(order);

		List<ClassesVO> list = classesService.getAllClass(vo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllMyClass", method = RequestMethod.POST)
	public Object getAllNotices() {
		List<ClassesVO> list = classesService.getAllMyClass(studentId);
		List<ClassesVO> inactiveList = classesService.getAllMyInactiveClass(studentId);
		
		for(int i=0; i<list.size(); i++) {
			int classID = list.get(i).getId();
			NoticeVO tmp = new NoticeVO();
			tmp.setId(classID);
			tmp.setStudentID(studentId);
			
			if(noticeService.countNotice(classID) != noticeService.countNoticeCheck(tmp))
				list.get(i).setNewNotice(1);
			else
				list.get(i).setNewNotice(0);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("active", list);
		map.put("inactive", inactiveList);
		return map;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") int classID) {	
		//학생의 강의실 상세보기 modal에 띄어질 내용 가져오기
		ClassesVO vo = classesService.getClassInfo(classID);
		return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteClassroom", method = RequestMethod.POST)
	public void deleteClassroom(@RequestParam(value = "id") int id) {	
		ClassesVO vo = new ClassesVO();
		vo.setId(id);
		vo.setStudentID(studentId);
		
		Stu_TakesVO stvo = new Stu_TakesVO();
		stvo.setClassID(id);
		stvo.setStudentID(studentId);
		
		if(attendanceCheckService.deleteAttendanceCheck(stvo) == 0) {
			System.out.println("삭제할 zoom 출석 데이터가 없습니다.");
		}
		if(attendanceInCheckService.deleteInternalAttendanceCheck(stvo) == 0) {
			System.out.println("삭제할 LMS 출석 데이터가 없습니다.");
		}
		if(noticeService.deleteNoticeCheck(stvo) == 0) {
			System.out.println("삭제할 공지 데이터가 없습니다.");
		}
		if(playlistcheckService.deletePlaylist(stvo) == 0) {
			System.out.println("삭제할 playlist 데이터가 없습니다.");
		}
		if(videoCheckService.deleteTime(stvo) == 0) {
			System.out.println("삭제할 videoCheck 데이터가 없습니다.");
		}		
		
		if(classesService.deleteClassroom(vo) != 0)
			System.out.println("강의실 나가기 성공!");
		else
			System.out.println("강의실 나가기 실패!");
		//(jw)
		if(classService.updateTotalStudent(id) == 1)
			System.out.println("totalStudent 업데이트 성공! ");
		else
			System.out.println("totalStudent 업데이트 실패 ");
		
	}
	
	
	
	
	
	/*@ResponseBody
	@RequestMapping(value = "/forWatchedCount", method = RequestMethod.POST)
	public List<Stu_VideoCheckVO> forWatchedCount(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		int classContentID = Integer.parseInt(request.getParameter("classContentID")); //이거 지우면 안된다, 
		System.out.println("watch");
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
	    vo.setPlaylistID(playlistID);
	    vo.setStudentID(studentId);
	    vo.setClassContentID(classContentID);
	    System.out.println("하나의 classContent , playlist내 영상 개수 : "+ videoCheckService.getWatchedCheck(vo).size());
	    return videoCheckService.getWatchedCheck(vo);
	} *///이렇게하면 videoCheck에 없는 영상에 대한 정보는 가져오지 못함 ..... 
	
	@ResponseBody
	@RequestMapping(value = "/forWatchedCount", method = RequestMethod.POST)
	public int forWatchedCount(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		int classContentID = Integer.parseInt(request.getParameter("classContentID")); //이거 지우면 안된다, 
		System.out.println("watch");
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
	    vo.setPlaylistID(playlistID);
	    vo.setStudentID(studentId);
	    vo.setClassContentID(classContentID);
	    
	    int count = 0;
	    
	    if(playlistID == 0) { //playlistID 없는 강의 컨텐츠에 대한 것 
	    	Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
	    	pcvo.setClassContentID(classContentID);
	    	pcvo.setPlaylistID(playlistID);
	    	pcvo.setStudentID(studentId);
	    	
	    	if(playlistcheckService.getPlaylistByContentStu(pcvo) != null)
	    		count = 1;
	    }
	    else {
	    	for(int i=0; i<videoCheckService.getWatchedCheck(vo).size(); i++) {
		    	if(videoCheckService.getWatchedCheck(vo).get(i).getWatched() == 1)
		    		count++;
		    }
	    }
	    //System.out.println("classContentID : " + classContentID + " playlistID " + playlistID + " studentID : " + studentId + " count : "  + count);
	    return count;
	}
	
	
	
	@ResponseBody
	@RequestMapping(value = "/forStudentContentDetail", method = RequestMethod.POST)
	public Map<Integer, Object> forStudentContentDetail(HttpServletRequest request, Model model) throws Exception {
		//List<Map<Integer, Object>> listMap = new ArrayList<Map<Integer, Object>>();
		Map<Integer, Object> map = new HashMap<Integer, Object>();
		
		int classID = Integer.parseInt(request.getParameter("classID"));
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID);
		List<ClassContentVO> VOlist = new ArrayList<ClassContentVO>();
		VOlist = classContentService.getWeekClassContent(classID);
		
		for(int i=0; i<VOlist.size(); i++) {
			map.put(i, VOlist.get(i));
			//listMap.add(map);
		}
	    return map;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/forClassInformation", method = RequestMethod.POST)
	public ClassContentVO ajaxTest(HttpServletRequest request, Model model) throws Exception {
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
	   
	    return classContentService.getOneContent(classPlaylistID);
	}
	
	//dashboard_Stu에서 사용
	@RequestMapping(value = "/competePlaylistCount", method = RequestMethod.POST)
	@ResponseBody
	public List<Integer> progressbarInDash(HttpServletRequest request) {
		//takes테이블에서 studentID의 모든 classID를 가져온다.
		//classID를 pcvo에 넣어서 해당 classID에서 완료한 Playlist들을 담는다.
		//이 리스트를 리스트안에 넣어준다.
		//리스트의 리스트를 리턴한다. 
		List<Integer> completePlaylist = new ArrayList<Integer>();
		
		int howManyTakes = takesService.getAcceptedStudentNum(studentId);
		for(int i=0; i<howManyTakes; i++) { //주어진 studentID를 가진 학생이 수강하는 수업에 대해 
			int howManyDays = classContentService.getPlaylistCount(takesService.getAcceptedStudent(studentId).get(i).getClassID());
			int count = 0;
			for(int j=0; j<howManyDays; j++) {
				
				AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
				aivo.setClassID(takesService.getAcceptedStudent(studentId).get(i).getClassID());
				aivo.setDays(j);
				aivo.setStudentID(studentId);
				
				ClassContentVO ccvo = new ClassContentVO();
				ccvo.setClassID(takesService.getAcceptedStudent(studentId).get(i).getClassID());
				ccvo.setDays(j);
				
				System.out.println(j+ "차시내 수업 개수 : " + classContentService.getDaySeq(ccvo) + " 학생이 다들은 수업 개수 : " + attendanceInCheckService.getAttendanceInCheckNum(aivo) + "classID : " + takesService.getAcceptedStudent(studentId).get(i).getClassID() + " days : "+ j + " studentID : " + studentId);
				if(attendanceInCheckService.getAttendanceInCheckNum(aivo) == classContentService.getDaySeq(ccvo)) {
					count ++;
				}
				//System.out.println("classID : " + takesService.getAcceptedStudent(studentId).get(i).getClassID() + " days : "+ j + " studentID : " + studentId);
			} 
			System.out.println("classID : " + takesService.getAcceptedStudent(studentId).get(i).getClassID() + " 완료된 차시는 " + count);
			completePlaylist.add(count);
		}
		return completePlaylist;
	}
	
	@RequestMapping(value = "/classTotalPlaylistCount", method = RequestMethod.POST)
	@ResponseBody
	public List<Integer> classTotalPlaylistCount(HttpServletRequest request) {
		//ClassContentVO ccvo= new ClassContentVO ();

		List<Integer> allPlaylist = new ArrayList<Integer>();
		int howManyTakes = takesService.getAcceptedStudentNum(studentId);
		for(int i=0; i<howManyTakes; i++) { //주어진 studentID를 가진 학생이 수강하는 수업에 대해 
			int howManyDays = classContentService.getPlaylistCount(takesService.getAcceptedStudent(studentId).get(i).getClassID());
			allPlaylist.add(howManyDays);
			//System.out.println("전체 차시는 : " + howManyDays);
		}
		return allPlaylist;
	}



}