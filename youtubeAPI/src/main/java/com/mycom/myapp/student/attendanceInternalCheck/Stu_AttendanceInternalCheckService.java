package com.mycom.myapp.student.attendanceInternalCheck;

import java.util.List;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

public interface Stu_AttendanceInternalCheckService {
	public int insertAttendanceInCheck(AttendanceInternalCheckVO vo);
	public int updateAttendanceInCheck(AttendanceInternalCheckVO vo);
	public int deleteAttendanceInCheck(AttendanceInternalCheckVO vo);
	public List<AttendanceInternalCheckVO> getAttendanceInCheck(AttendanceInternalCheckVO vo);
	public int getAttendanceInCheckNum(AttendanceInternalCheckVO vo) ;
	public List<AttendanceInternalCheckVO> getAttendanceInCheckExisted(AttendanceInternalCheckVO vo);
	public int getAttendanceInCheckExistedNum(AttendanceInternalCheckVO vo);
	public AttendanceInternalCheckVO getAttendanceInCheckByID(AttendanceInternalCheckVO vo) ;
	public int getAttendanceInCheckByIDNum(AttendanceInternalCheckVO vo);
	public AttendanceInternalCheckVO getAttendanceInCheckByIDExisted(AttendanceInternalCheckVO vo);
	public int getAttendanceInCheckByIDExistedNum(AttendanceInternalCheckVO vo);
	public int deleteInternalAttendanceCheck(Stu_TakesVO vo);
	
}
