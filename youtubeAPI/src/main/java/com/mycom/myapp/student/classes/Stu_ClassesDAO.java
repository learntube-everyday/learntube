package com.mycom.myapp.student.classes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassesVO;

@Repository
public class Stu_ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public ClassesVO getClass(int id) {
		return sqlSession.selectOne("Stu_Classes.getClass", id);
	}
	
	public ClassesVO getClassInfo(int id) {
		return sqlSession.selectOne("Stu_Classes.getClassInfo", id);
	}
	
	public List<ClassesVO> getAllClass(ClassesVO vo){
		return sqlSession.selectList("Stu_Classes.getAllClass", vo);
	}
	
	public List<ClassesVO> getAllMyClass(int id){	//이거랑 아래 나중에지우기(위에껄로 대체!)
		return sqlSession.selectList("Stu_Classes.getAllMyClass", id);
	}
	
	public List<ClassesVO> getAllMyInactiveClass(int id){
		return sqlSession.selectList("Stu_Classes.getAllMyInactiveClass", id);
	}
	
	public int deleteClassroom(ClassesVO vo) {
		return sqlSession.delete("Stu_Classes.deleteClassroom", vo);
	}
	
	public int checkTakeClass(ClassesVO vo) {
		return sqlSession.selectOne("Stu_Classes.checkTakeClass", vo);
	}
}