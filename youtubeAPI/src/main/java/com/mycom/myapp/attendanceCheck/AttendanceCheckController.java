package com.mycom.myapp.attendanceCheck;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;

@Controller
@RequestMapping(value="/student/attendance")
public class AttendanceCheckController {
	@Autowired
	private Stu_ClassContentService classContentService;
	@Autowired
	private ClassContentService classInsContentService;
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInCheckService;
	
	private int studentID = 0;
	
	@ResponseBody
	@RequestMapping(value = "/forMyAttend", method = RequestMethod.POST)
	public List<String> forMyAttend(HttpServletRequest request, Model model, HttpSession session) throws Exception {
		int classID = Integer.parseInt(request.getParameter("classID"));
		studentID = (Integer)session.getAttribute("userID");
		
		ClassContentVO ccvo = new ClassContentVO ();
		AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();	
		List<String> stuOne = new ArrayList<String>();
		int dayNum = classContentService.getPlaylistCount(classID);
		//System.out.println("내가 수강하는 차시는 "  + dayNum);
		
		for(int j=0; j<dayNum; j++) { //차시의 개수 
			ccvo.setClassID(classID);
			ccvo.setDays(j);
			classContentService.getDaySeq(ccvo); //classContent에서 해당 차시에 수업 몇개있는지 (published가 1인거)
			

			aivo.setClassID(classID);
			aivo.setStudentID(studentID);
			aivo.setDays(j);
			//System.out.println("classID : " + classID + " days : " + j + " studentID : " + studentID);
			if(classContentService.getDaySeq(ccvo) == 0) {  //classContent에서 해당 차시에 수업 몇개있는지 (published가 1인거)
				continue; //publish된 것이 없다면 넘어가기 
			}
				
			else if(classContentService.getDaySeq(ccvo) == attendanceInCheckService.getAttendanceInCheck(aivo).size()) {
				for(int k=0; k<classContentService.getDaySeq(ccvo); k++) {
						
					if(attendanceInCheckService.getAttendanceInCheck(aivo).get(k).getInternal().equals("결석")) {
						stuOne.add("결석");
						break;
					}
					else if(attendanceInCheckService.getAttendanceInCheck(aivo).get(k).getInternal().equals("지각")) {
						if(k == classContentService.getDaySeq(ccvo)-1)
							stuOne.add("지각");
						continue;
					}
					else if(attendanceInCheckService.getAttendanceInCheck(aivo).get(k).getInternal().equals("출석")) {
						if(k == classContentService.getDaySeq(ccvo)-1)
							stuOne.add("출석");
						continue;
					}
					else {
							//미확인
						if(k == classContentService.getDaySeq(ccvo)-1)
							stuOne.add("미확인");
						continue;
					}
							
				}
	
					//이때 무조건 출석이 아니라, db에 있는 값들을 가져와야지,, 
			}
			else {
					//classContent테이블의 마감 시간과, 현재시간 
					//마감시간 > 현재시간 : 미확인
					//마감시간 < 현재시간 : 결석
					//마감시간이 하나라도 지난 것이 있으면 결석처리,, 
					
				for(int k=0; k<classInsContentService.getEndDate(ccvo).size(); k++) {
					if(classInsContentService.getEndDate(ccvo).get(k) == null) { //마감기한이 설정되어있지 않는 경우 
						stuOne.add("미확인");
						break;
					}
						
					String endString = classInsContentService.getEndDate(ccvo).get(k).getEndDate();
					endString =  endString.replace("T", " "); 
						//System.out.println("endDate : " +endString);
					Date endDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(endString);
					Date now = new Date();
						//System.out.println("endDate : " + endDate + " , now : " + now);
						
					int result = endDate.compareTo(now); 
						
					if(result == 0 || result == 1) {
						if(k == classInsContentService.getEndDate(ccvo).size()-1) {
							stuOne.add("미확인");
						}
						continue;
					}
					else {
						stuOne.add("결석");
						break;
					}
				}
			}
		}
				
				
		return stuOne;	
	}
	
	
	
	
	
}
