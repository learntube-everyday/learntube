package com.mycom.myapp.attendance;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassesVO;

@Repository
public class AttendanceDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertAttendanceNoFile(AttendanceVO vo) {
		int result = sqlSession.insert("Attendance.insertAttendanceNoFile", vo);
		if(result > 0)
			return vo.getId();
		return result;
	}
	
	public int insertAttendance(AttendanceVO vo) {
		int result = sqlSession.insert("Attendance.insertAttendance", vo);
		return result;
	}
	
	public int updateAttendance(AttendanceVO vo) {
		int result = sqlSession.update("Attendance.updateAttendance", vo);
		return result;
	}
	
	public int deleteAttendance(AttendanceVO vo){
		int result = sqlSession.update("Attendance.deleteAttendance", vo);
		return result;
	}
	
	public AttendanceVO getAttendance(int id) {
		AttendanceVO vo = sqlSession.selectOne("Attendance.getAttendance", id);
		return vo;
	}
	
	public AttendanceVO getAttendanceID(AttendanceVO vo) {
		AttendanceVO result = sqlSession.selectOne("Attendance.getAttendanceID", vo);
		return result;
	}
	
	public List<AttendanceVO> getAttendanceID2(int classID) {
		List<AttendanceVO> result = sqlSession.selectList("Attendance.getAttendanceID", classID);
		return result;
	}
	
	public List<AttendanceVO> getAttendanceList(int classID){
		List<AttendanceVO> result = sqlSession.selectList("Attendance.getAttendanceList", classID);
		return result;
	}
	
	public int getAttendanceListCount(int classID){
		int result = sqlSession.selectOne("Attendance.getAttendanceListCount", classID);
		return result;
	}
	
	public List<AttendanceVO> getAttendanceFileName(int classID){
		List<AttendanceVO> result = sqlSession.selectList("Attendance.getAttendanceFileName", classID);
		return result;
	}
	
}
