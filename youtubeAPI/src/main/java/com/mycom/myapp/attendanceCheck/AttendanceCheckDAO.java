package com.mycom.myapp.attendanceCheck;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Repository
public class AttendanceCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertExAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.insert("AttendanceCheck.insertExAttendanceCheck", vo);
		return result;
	}
	
	public int insertAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.insert("AttendanceCheck.insertAttendanceCheck", vo);
		return result;
	}
	
	public int updateExAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.update("AttendanceCheck.updateExAttendanceCheck", vo);
		return result;
	}
	
	public int updateInAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.update("AttendanceCheck.updateInAttendanceCheck", vo);
		return result;
	}
	
	public int updateAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.update("AttendanceCheck.updateAttendanceCheck", vo);
		return result;
	}
	
	public int deleteAttendanceCheck(Stu_TakesVO vo){
		int result = sqlSession.update("AttendanceCheck.deleteAttendanceCheck", vo);
		return result;
	}
	
	public AttendanceCheckVO getAttendanceCheck(AttendanceCheckVO vo) {
		AttendanceCheckVO result = sqlSession.selectOne("AttendanceCheck.getAttendanceCheck", vo);
		return result;
	}
	
	public List<AttendanceCheckVO> getAttendanceCheckList(int attendanceID) {
		List<AttendanceCheckVO> result = sqlSession.selectList("AttendanceCheck.getAttendanceCheckList", attendanceID);
		//System.out.println("dao : " +result.size());
		return result;
	}
	
	public int getAttendanceCheckListCount(int classID) {
		//System.out.println("classID : " + classID);
		int vo = sqlSession.selectOne("AttendanceCheck.getAttendanceCheckListCount", classID);
		//System.out.println("몇개 ? " +vo);
		return vo;
	}
	
	/*public List<AttendanceVO> getAttendanceList(AttendanceVO vo){
		List<AttendanceVO> result = sqlSession.selectList("Attendance.getAttendanceList", vo);
		return result;
	}*/
	
}
