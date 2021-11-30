package com.mycom.myapp.student.classes;

import java.util.List;

import com.mycom.myapp.commons.ClassesVO;

public interface Stu_ClassesService {
	public ClassesVO getClass(int id);
	public ClassesVO getClassInfo(int id);
	public List<ClassesVO> getAllClass(ClassesVO vo);
	public List<ClassesVO> getAllMyClass(int id);
	public List<ClassesVO> getAllMyInactiveClass(int id);
	public int deleteClassroom(ClassesVO vo);
	public int checkTakeClass(ClassesVO vo);
}
