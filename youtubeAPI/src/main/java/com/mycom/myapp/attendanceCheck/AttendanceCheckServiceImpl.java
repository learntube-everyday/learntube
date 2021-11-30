package com.mycom.myapp.attendanceCheck;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Service
public class AttendanceCheckServiceImpl implements AttendanceCheckService {
	@Autowired
	AttendanceCheckDAO attendanceCheckDAO;
	
	@Override
	public int insertExAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.insertExAttendanceCheck(vo);
	}
	
	@Override
	public int insertAttendanceCheck(AttendanceCheckVO vo){
		return attendanceCheckDAO.insertAttendanceCheck(vo);
	}
	
	@Override
	public int updateExAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.updateExAttendanceCheck(vo);
	}
	
	@Override
	public int updateInAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.updateInAttendanceCheck(vo);
	}
	
	@Override
	public int updateAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.updateAttendanceCheck(vo);
	}
	
	@Override
	public int deleteAttendanceCheck(Stu_TakesVO vo) {
		return attendanceCheckDAO.deleteAttendanceCheck(vo);
	}
	
	@Override
	public AttendanceCheckVO getAttendanceCheck(AttendanceCheckVO vo){
		return attendanceCheckDAO.getAttendanceCheck(vo);
	}
	
	@Override
	public List<AttendanceCheckVO> getAttendanceCheckList(int attendanceID){
		return attendanceCheckDAO.getAttendanceCheckList(attendanceID);
	}
	
	@Override
	public int getAttendanceCheckListCount(int classID) {
		//System.out.println("몇개 ? " + attendanceCheckDAO.getAttendanceCheckListCount(classID));
		return attendanceCheckDAO.getAttendanceCheckListCount(classID);
	}
	
	/*@Override
	public List<AttendanceVO> getAttendanceList(AttendanceVO vo){
		return attendanceCheckDAO.getAttendanceList(vo);
	}*/
}
