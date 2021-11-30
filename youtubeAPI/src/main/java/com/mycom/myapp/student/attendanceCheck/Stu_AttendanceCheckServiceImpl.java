package com.mycom.myapp.student.attendanceCheck;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Service
public class Stu_AttendanceCheckServiceImpl implements Stu_AttendanceCheckService{
	@Autowired
	Stu_AttendanceCheckDAO stuAttendanceCheckDAO;
	
	@Override
	public List<AttendanceCheckVO> getStuAttendanceCheckList(Stu_TakesVO vo){
		return stuAttendanceCheckDAO.getStuAttendanceCheckList(vo);
	}
}
