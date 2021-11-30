package com.mycom.myapp.attendanceCheck;

import java.util.HashMap;
import java.util.List;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

public interface AttendanceCheckService {
	public int insertExAttendanceCheck(AttendanceCheckVO vo);
	public int insertAttendanceCheck(AttendanceCheckVO vo);
	public int updateExAttendanceCheck(AttendanceCheckVO vo);
	public int updateInAttendanceCheck(AttendanceCheckVO vo);
	public int updateAttendanceCheck(AttendanceCheckVO vo);
	public int deleteAttendanceCheck(Stu_TakesVO vo);
	public AttendanceCheckVO getAttendanceCheck(AttendanceCheckVO vo);
	public List<AttendanceCheckVO> getAttendanceCheckList(int attendanceID);
	public int getAttendanceCheckListCount(int classID) ;
}
