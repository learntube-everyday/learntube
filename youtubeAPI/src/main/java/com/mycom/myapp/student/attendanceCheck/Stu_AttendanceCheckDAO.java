package com.mycom.myapp.student.attendanceCheck;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Repository
public class Stu_AttendanceCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public List<AttendanceCheckVO> getStuAttendanceCheckList(Stu_TakesVO vo) {
		List<AttendanceCheckVO> result = sqlSession.selectList("StuAttendanceCheck.getStuAttendanceCheckList", vo);
		//System.out.println("dao : " +result.size());
		return result;
	}
}
