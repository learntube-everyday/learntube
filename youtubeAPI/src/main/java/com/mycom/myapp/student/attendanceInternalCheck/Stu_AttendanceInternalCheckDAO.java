package com.mycom.myapp.student.attendanceInternalCheck;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Repository
public class Stu_AttendanceInternalCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return sqlSession.insert("AttendanceInternalCheck.insertAttendanceInCheck", vo);
	}
	
	public int updateAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return sqlSession.update("AttendanceInternalCheck.updateAttendanceInCheck", vo);
	}
	
	public int deleteAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return sqlSession.delete("AttendanceInternalCheck.deleteAttendanceInCheck", vo);
	}
	
	//internal이 출석인거 
	public List<AttendanceInternalCheckVO> getAttendanceInCheck(AttendanceInternalCheckVO vo) {
		List<AttendanceInternalCheckVO> result = sqlSession.selectList("AttendanceInternalCheck.getAttendanceInCheck", vo);
		return result;
	}
	
	public int getAttendanceInCheckNum(AttendanceInternalCheckVO vo) {
		int result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckNum", vo);
		return result;
	}
	
	//그냥 전체 
	public List<AttendanceInternalCheckVO> getAttendanceInCheckExisted(AttendanceInternalCheckVO vo) {
		List<AttendanceInternalCheckVO> result = sqlSession.selectList("AttendanceInternalCheck.getAttendanceInCheckExisted", vo);
		return result;
	}
	
	public int getAttendanceInCheckExistedNum(AttendanceInternalCheckVO vo) {
		int result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckExistedNum", vo);
		return result;
	}
	
	//internal이 출석인거 (근데 classContentID)
	public AttendanceInternalCheckVO getAttendanceInCheckByID(AttendanceInternalCheckVO vo) {
		AttendanceInternalCheckVO result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckByID", vo);
		return result;
	}
	
	public int getAttendanceInCheckByIDNum(AttendanceInternalCheckVO vo) {
		int result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckByIDNum", vo);
		return result;
	}
	
	//그냥 전체( 근데 classContentID)
	public AttendanceInternalCheckVO getAttendanceInCheckByIDExisted(AttendanceInternalCheckVO vo) {
		AttendanceInternalCheckVO result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckByIDExisted", vo);
		return result;
	}
	
	public int getAttendanceInCheckByIDExistedNum(AttendanceInternalCheckVO vo) {
		int result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckByIDExistedNum", vo);
		return result;
	}
	
	public int deleteInternalAttendanceCheck(Stu_TakesVO vo) {
		return sqlSession.delete("AttendanceInternalCheck.deleteInternalAttendanceCheck", vo);
	}
}
