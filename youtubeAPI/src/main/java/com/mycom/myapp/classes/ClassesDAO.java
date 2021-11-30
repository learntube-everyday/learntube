package com.mycom.myapp.classes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassesVO;

@Repository
public class ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertClassroom(ClassesVO vo) {
		int result = sqlSession.insert("Classes.insertClassroom", vo);
		if (result > 0) {
			return vo.getId();	//새로 생성된 classID 
		}
		return -1;
	}
	
	public int updateClassroom(ClassesVO vo) {
		return sqlSession.update("Classes.updateClassroom", vo);
	}
	
	public int updateDays(ClassesVO vo){
		return sqlSession.update("Classes.updateDays", vo);
	}
	
	public int deleteDay(int id){
		return sqlSession.update("Classes.deleteDay", id);
	}
	
	public int updateInstructorNull(ClassesVO vo) {	//선생님이 강의실 나갔을 때
		return sqlSession.update("Classes.updateInstructorNull", vo);
	}
	
	public int updateActive(int id) {
		return sqlSession.update("Classes.updateActive", id);
	}
	
	public int deleteClassroom(int id) {
		return sqlSession.delete("Classes.deleteClassroom", id);
	}
	
	public int updateTotalStudent(int id) {
		return sqlSession.update("Classes.updateTotalStudent", id);
	}
	
	public String getClassName(int id) {
		return sqlSession.selectOne("Classes.getClassName", id);
	}
	
	public ClassesVO getClass(int id) {
		return sqlSession.selectOne("Classes.getClass", id);
	}
	
	public ClassesVO getClassInfoForCopy(int id) {
		return sqlSession.selectOne("Classes.getClassInfoForCopy", id);
	}
	
	public ClassesVO getClassByEntryCode(String entryCode) {
		return sqlSession.selectOne("Classes.getClassByEntryCode", entryCode);
	}
	
	public List<ClassesVO> getAllClass(ClassesVO vo){	//아래 함수를 중복사용가능한 ver.
		return sqlSession.selectList("Classes.getAllClass", vo);
	}
	
	public List<ClassesVO> getAllMyActiveClass(int instructorID){
		return sqlSession.selectList("Classes.getAllMyActiveClass", instructorID);
	}
	
	public List<ClassesVO> getAllMyInactiveClass(int instructorID){
		return sqlSession.selectList("Classes.getAllMyInactiveClass", instructorID);
	}
	
	public List<ClassesVO> getAllMyClass(int instructorID){	//이것도 나중에 지워야할듯?!!
		return sqlSession.selectList("Classes.getAllMyClass", instructorID);
	}
	
	public List<ClassesVO> getAllClassForAdmin(){
		return sqlSession.selectList("Classes.getAllClassForAdmin");
	}

	public List<String> getAllEntryCodes() {
		return sqlSession.selectList("Classes.getAllEntryCodes");
	}
	
	public int checkAccessClass(ClassesVO vo) {
		return sqlSession.selectOne("Classes.checkAccessClass", vo);
	}
	
	public List<ClassesVO> getClassesToBeClosed(String endDate){
		System.out.println("dao!!" + endDate);
		return sqlSession.selectList("Classes.getClassesToBeClosed", endDate);
	}

}

