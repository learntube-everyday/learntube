package com.mycom.myapp.student.attendanceCheck;

import java.util.List;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

public interface Stu_AttendanceCheckService {
	public List<AttendanceCheckVO> getStuAttendanceCheckList(Stu_TakesVO vo);
}
