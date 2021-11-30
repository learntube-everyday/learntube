package com.mycom.myapp.student.classContent;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassContentVO;

@Repository
 public class Stu_ClassContentDAO {
 	@Autowired
 	SqlSession sqlSession;
 	
 	public int getDaySeq(ClassContentVO vo) {
 		int result = sqlSession.selectOne("Stu_ClassContent.getDaySeq", vo);
 		return result;
 	}
 	
 	public ClassContentVO getOneContent(int id) {
 		ClassContentVO result = sqlSession.selectOne("Stu_ClassContent.getOneContent", id);
 		return result;
 	}
 	
 	public int getPlaylistCount(int classID) {
 		int result = sqlSession.selectOne("Stu_ClassContent.getPlaylistCount", classID);
 		return result;
 	}
 	
 	public List<ClassContentVO> getWeekClassContent(int classID){
 		List<ClassContentVO> result = sqlSession.selectList("Stu_ClassContent.getWeekClassContent", classID);
 		return result;
 	}
 	
 	public List<ClassContentVO> getSamePlaylistID(ClassContentVO vo) {
 		List<ClassContentVO> result = sqlSession.selectList("Stu_ClassContent.getSamePlaylistID", vo);
 		return result;
 	}
 	
 	public List<ClassContentVO> getAllClassContent(int classID){
 		List<ClassContentVO> result = sqlSession.selectList("Stu_ClassContent.getAllClassContent", classID);
 		return result;
 	}
 	
 	public String getCompleteClassContent(ClassContentVO vo){
 		return  sqlSession.selectOne("Stu_ClassContent.getAllClassContent", vo);
 	}
 }