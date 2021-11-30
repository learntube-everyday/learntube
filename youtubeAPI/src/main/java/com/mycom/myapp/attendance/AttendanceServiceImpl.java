package com.mycom.myapp.attendance;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceVO;

@Service
public class AttendanceServiceImpl implements AttendanceService {
	@Autowired
	AttendanceDAO attendanceDAO;
	
	@Override
	public int insertAttendanceNoFile(AttendanceVO vo) {
		return attendanceDAO.insertAttendanceNoFile(vo);
	}
	
	@Override
	public int insertAttendance(AttendanceVO vo){
		return attendanceDAO.insertAttendance(vo);
	}
	
	@Override
	public int updateAttendance(AttendanceVO vo) {
		return attendanceDAO.updateAttendance(vo);
	}
	
	@Override
	public int deleteAttendance(AttendanceVO vo) {
		return attendanceDAO.deleteAttendance(vo);
	}
	
	@Override
	public AttendanceVO getAttendance(int id){
		return attendanceDAO.getAttendance(id);
	}
	
	@Override
	public AttendanceVO getAttendanceID(AttendanceVO vo){
		return attendanceDAO.getAttendanceID(vo);
	}
	
	@Override
	public List<AttendanceVO> getAttendanceID2(int classID) {
		return attendanceDAO.getAttendanceID2(classID);
	}
	
	@Override
	public List<AttendanceVO> getAttendanceList(int classID){
		return attendanceDAO.getAttendanceList(classID);
	}
	
	@Override
	public int getAttendanceListCount(int classID) {
		return attendanceDAO.getAttendanceListCount(classID);
	}
	
	@Override
	public List<AttendanceVO> getAttendanceFileName(int classID){
		return attendanceDAO.getAttendanceFileName(classID);
	}

	
}
