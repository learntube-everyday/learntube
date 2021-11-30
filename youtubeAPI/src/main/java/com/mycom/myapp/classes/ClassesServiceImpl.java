package com.mycom.myapp.classes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.ClassesVO;

@Service
public class ClassesServiceImpl implements ClassesService {
	@Autowired
	ClassesDAO classesDAO;
	
	@Override
	public int insertClassroom(ClassesVO vo) {
		return classesDAO.insertClassroom(vo);
	}
	
	@Override
	public int updateClassroom(ClassesVO vo) {
		return classesDAO.updateClassroom(vo);
	}
	
	@Override
	public int updateDays(ClassesVO vo) {
		return classesDAO.updateDays(vo);
	}
	
	@Override
	public int deleteDay(int id) {
		return classesDAO.deleteDay(id);
	}
	
	@Override
	public int updateInstructorNull(ClassesVO vo) {
		return classesDAO.updateInstructorNull(vo);
	}
	
	@Override
	public int updateActive(int active) {
		return classesDAO.updateActive(active);
	}
	
	@Override
	public int deleteClassroom(int id) {
		return classesDAO.deleteClassroom(id);
	}

	@Override
	public int updateTotalStudent(int id) {
		return classesDAO.updateTotalStudent(id);
	}
	
	@Override
	public String getClassName(int id) {
		return classesDAO.getClassName(id);
	}
	
	@Override
	public ClassesVO getClass(int id) {
		return classesDAO.getClass(id);
	}
	
	@Override
	public ClassesVO getClassInfoForCopy(int id) {
		return classesDAO.getClassInfoForCopy(id);
	}
	
	@Override
	public ClassesVO getClassByEntryCode(String entryCode) {
		return classesDAO.getClassByEntryCode(entryCode);
	}
	
	@Override
	public List<ClassesVO> getAllClass(ClassesVO vo){
		return classesDAO.getAllClass(vo);
	}
	
	@Override
	public List<ClassesVO> getAllMyActiveClass(int instructorID){
		return classesDAO.getAllMyActiveClass(instructorID);
	}
	
	@Override
	public List<ClassesVO> getAllMyInactiveClass(int instructorID){
		return classesDAO.getAllMyInactiveClass(instructorID);
	}
	
	@Override
	public List<ClassesVO> getAllMyClass(int instructorID){
		return classesDAO.getAllMyClass(instructorID);
	}
	
	@Override
	public List<ClassesVO> getAllClassForAdmin(){
		return classesDAO.getAllClassForAdmin();
	}

	@Override
	public List<String> getAllEntryCodes() {
		return classesDAO.getAllEntryCodes();
	}
	
	@Override
	public int checkAccessClass(ClassesVO vo) {
		return classesDAO.checkAccessClass(vo);
	}
	
	@Override
	public List<ClassesVO> getClassesToBeClosed(String endDate){
		System.out.println(endDate);
		return classesDAO.getClassesToBeClosed(endDate);
	}

}

