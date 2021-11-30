package com.mycom.myapp.classContent;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassContentVO;

@Repository
public class ClassContentDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertContent(ClassContentVO vo) {
		int result = sqlSession.insert("ClassContent.insertContent", vo);
		return result;
	}
	
	public int insertURLContent(ClassContentVO vo) {
		int result = sqlSession.insert("ClassContent.insertURLContent", vo);
		return result;
	}
	
	public int updateContent(ClassContentVO vo) {
		int result = sqlSession.update("ClassContent.updateContent", vo);
		return result;
	}
	
	public int updatePublished(ClassContentVO vo) {
		int result = sqlSession.update("ClassContent.updatePublished", vo);
		return result;
	}
	
	public int deleteContent(int id) { 
		int result = sqlSession.delete("ClassContent.deleteContent", id);
		return result;
	}
	
	public int deleteContentList(ClassContentVO vo) { 
		int result = sqlSession.delete("ClassContent.deleteContentList", vo);
		return result;
	}
	
	public List<ClassContentVO> getDaySeq(ClassContentVO vo) {
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getDaySeq", vo);
 		return result;
 	}
	
	public int getDaySeqNum(ClassContentVO vo) {
 		int result = sqlSession.selectOne("ClassContent.getDaySeqNum", vo);
 		return result;
 	}
	
	public int getClassNum(int classID) {	//생성된 강의 컨텐츠의 갯수 가져오기
		int result = sqlSession.selectOne("ClassContent.getClassNum", classID);
		return result;
		//System.out.println("여기는DAO, result " + result);
		/*if (result != null) 
			return result;
		else
			return 0;*/
	}
	
	public List<ClassContentVO> getEndDate(ClassContentVO vo) {
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getEndDate", vo);
		return result;
	}
	
	public int getClassDaysNum(int classID) {
		int result = sqlSession.selectOne("ClassContent.getClassDaysNum", classID);
		return result;
	}
	
	public int getBiggestUsedDay(int classID) {	//각 차시별 강의 컨텐츠가 하나라도 생성된것 중 가장 큰 차시 정보 가져오기
		Integer result =  sqlSession.selectOne("ClassContent.getBiggestUsedDay", classID);
		if (result != null) 
			return result+1;
		else
			return 0;
	}
	
	public ClassContentVO getOneContentInstructor(int id) {
		ClassContentVO result = sqlSession.selectOne("ClassContent.getOneContentInstructor", id);
		return result;
	}
	
	
	public ClassContentVO getOneContent(int id) {
		ClassContentVO result = sqlSession.selectOne("ClassContent.getOneContent", id);
		return result;
	}
	
	public List<ClassContentVO> getAllClassContent(int classID){
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getAllClassContent", classID);
		return result;
	}
	
	public List<ClassContentVO> getFileClassContent(int classID){
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getFileClassContent", classID);
		return result;
	}
	
	public List<ClassContentVO> getRealAll(int classID){
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getRealAll", classID);
		return result;
	}
	
	public List<ClassContentVO> getAllClassContentForCopy(int classID){
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getAllClassContentForCopy", classID);
		return result;
	}
	
	public int insertCopiedClassContents(List<ClassContentVO> list) {
		return sqlSession.insert("ClassContent.insertCopiedClassContents", list);
	}
	
	public List<ClassContentVO> getClassContentID(ClassContentVO vo) {
		return sqlSession.selectList("ClassContent.getClassContentID", vo);
	}
}
