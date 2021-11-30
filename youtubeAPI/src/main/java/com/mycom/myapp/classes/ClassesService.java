package com.mycom.myapp.classes;

import java.util.List;

import com.mycom.myapp.commons.ClassesVO;

public interface ClassesService {
	
	public int insertClassroom(ClassesVO vo);
	public int updateClassroom(ClassesVO vo);
	public int updateDays(ClassesVO vo);
	public int deleteDay(int id);
	public int updateInstructorNull(ClassesVO vo);
	public int updateActive(int id);
	public int deleteClassroom(int id);
	public int updateTotalStudent(int id);
	public String getClassName(int id);
	public ClassesVO getClass(int id);
	public ClassesVO getClassInfoForCopy(int id);
	public ClassesVO getClassByEntryCode(String entryCode);
	public List<ClassesVO> getAllClass(ClassesVO vo);
	public List<ClassesVO> getAllMyActiveClass(int instructorID);
	public List<ClassesVO> getAllMyInactiveClass(int instructorID);
	public List<ClassesVO> getAllMyClass(int instructorID);
	public List<ClassesVO> getAllClassForAdmin();
	public List<String> getAllEntryCodes();
	public int checkAccessClass(ClassesVO vo);
	public List<ClassesVO> getClassesToBeClosed(String endDate);
}
