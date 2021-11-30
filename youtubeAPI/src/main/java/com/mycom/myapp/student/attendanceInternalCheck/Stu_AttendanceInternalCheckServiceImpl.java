package com.mycom.myapp.student.attendanceInternalCheck;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Service
public class Stu_AttendanceInternalCheckServiceImpl implements Stu_AttendanceInternalCheckService{
	@Autowired
	Stu_AttendanceInternalCheckDAO stuAttendanceCheckDAO;
	
	@Override
	public int insertAttendanceInCheck(AttendanceInternalCheckVO vo){
		return stuAttendanceCheckDAO.insertAttendanceInCheck(vo);
	}
	
	@Override
	public int updateAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.updateAttendanceInCheck(vo);
	}
	
	@Override
	public int deleteAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.deleteAttendanceInCheck(vo);
	}
	
	@Override
	public List<AttendanceInternalCheckVO> getAttendanceInCheck(AttendanceInternalCheckVO vo)  {
		return stuAttendanceCheckDAO.getAttendanceInCheck(vo);
	}
	
	@Override
	public int getAttendanceInCheckNum(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.getAttendanceInCheckNum(vo);
	}
	
	@Override
	public List<AttendanceInternalCheckVO> getAttendanceInCheckExisted(AttendanceInternalCheckVO vo){
		return stuAttendanceCheckDAO.getAttendanceInCheckExisted(vo);
	}
	
	@Override
	public int getAttendanceInCheckExistedNum(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.getAttendanceInCheckExistedNum(vo);
	}
	
	@Override
	public AttendanceInternalCheckVO getAttendanceInCheckByID(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.getAttendanceInCheckByID(vo);
	}
	
	@Override
	public int getAttendanceInCheckByIDNum(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.getAttendanceInCheckByIDNum(vo);
	}
	
	@Override
	public AttendanceInternalCheckVO getAttendanceInCheckByIDExisted(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.getAttendanceInCheckByIDExisted(vo);
	}
	
	@Override
	
	public int getAttendanceInCheckByIDExistedNum(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.getAttendanceInCheckByIDExistedNum(vo);
	}

	@Override
	public int deleteInternalAttendanceCheck(Stu_TakesVO vo) {
		return stuAttendanceCheckDAO.deleteInternalAttendanceCheck(vo);
	}
	
}
