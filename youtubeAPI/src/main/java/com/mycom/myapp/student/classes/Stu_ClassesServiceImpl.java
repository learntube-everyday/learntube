package com.mycom.myapp.student.classes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.ClassesVO;

@Service
public class Stu_ClassesServiceImpl implements Stu_ClassesService{
	@Autowired
	Stu_ClassesDAO classesDAO;
	
	@Override
	public ClassesVO getClass(int id) {
		return classesDAO.getClass(id);
	}
	
	@Override
	public ClassesVO getClassInfo(int id) {
		return classesDAO.getClassInfo(id);
	}
	
	@Override
	public List<ClassesVO> getAllClass(ClassesVO vo){
		return classesDAO.getAllClass(vo);
	}
	
	@Override
	public List<ClassesVO> getAllMyClass(int id){
		return classesDAO.getAllMyClass(id);
	}
	
	@Override
	public List<ClassesVO> getAllMyInactiveClass(int id){
		return classesDAO.getAllMyInactiveClass(id);
	}
	
	@Override
	public int deleteClassroom(ClassesVO vo) {
		return classesDAO.deleteClassroom(vo);
	}
	
	@Override
	public int checkTakeClass(ClassesVO vo) {
		return classesDAO.checkTakeClass(vo);
	}
}
