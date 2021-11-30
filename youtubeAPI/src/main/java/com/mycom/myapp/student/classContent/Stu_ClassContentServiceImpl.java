package com.mycom.myapp.student.classContent;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.ClassContentVO;

@Service
public class Stu_ClassContentServiceImpl implements Stu_ClassContentService{

	@Autowired
	Stu_ClassContentDAO classContentDAO;
	
	@Override
	public ClassContentVO getOneContent(int id) {
		return classContentDAO.getOneContent(id);
	}
	
	@Override
	public int getPlaylistCount(int classID) {
		return classContentDAO.getPlaylistCount(classID);
	}
	
	@Override
	public List<ClassContentVO> getWeekClassContent(int classID){
		return classContentDAO.getWeekClassContent(classID);
	}
	
	@Override
	public List<ClassContentVO> getSamePlaylistID(ClassContentVO vo) {
		return classContentDAO.getSamePlaylistID(vo);
	}
	
	@Override
	public List<ClassContentVO> getAllClassContent(int classID){
		return classContentDAO.getAllClassContent(classID);
	}
	
	@Override
	public int getDaySeq(ClassContentVO vo) {
		return classContentDAO.getDaySeq(vo);
	}
	
	@Override
	public String getCompleteClassContent(ClassContentVO vo) {
		return classContentDAO.getCompleteClassContent(vo);
	}
	
}