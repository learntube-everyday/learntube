package com.mycom.myapp.classContent;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.ClassContentVO;

@Service
public class ClassContentServiceImpl implements ClassContentService{

	@Autowired
	ClassContentDAO ClassContentDAO;
	
	@Override
	public int insertContent(ClassContentVO vo) {
		return ClassContentDAO.insertContent(vo);
	}
	
	@Override
	public int insertURLContent(ClassContentVO vo) {
		return ClassContentDAO.insertURLContent(vo);
	}
	
	@Override
	public int updateContent(ClassContentVO vo) {
		return ClassContentDAO.updateContent(vo);
	}
	
	@Override
	public int updatePublished(ClassContentVO vo) {
		return ClassContentDAO.updatePublished(vo);
	}
	
	@Override
	public int deleteContent(int id) {
		return ClassContentDAO.deleteContent(id);
	}
	
	@Override
	public int deleteContentList(ClassContentVO vo) {
		return ClassContentDAO.deleteContentList(vo);
	}
	
	@Override
	public List<ClassContentVO> getDaySeq(ClassContentVO vo){
		return ClassContentDAO.getDaySeq(vo);
	}
	
	@Override
	public int getDaySeqNum(ClassContentVO vo) {
		return ClassContentDAO.getDaySeqNum(vo);
	}
	
	@Override
	public int getClassNum(int classID) {
		return ClassContentDAO.getClassNum(classID);
	}
	
	@Override
	public List<ClassContentVO> getEndDate(ClassContentVO vo){
		return ClassContentDAO.getEndDate(vo);
	}
	
	@Override
	public int getClassDaysNum(int classID) {
		return ClassContentDAO.getClassDaysNum(classID);
	}
	
	@Override
	public int getBiggestUsedDay(int classID) {
		return ClassContentDAO.getBiggestUsedDay(classID);
	}
	
	@Override
	public ClassContentVO getOneContentInstructor(int id) {
		return ClassContentDAO.getOneContentInstructor(id);
	}
	
	@Override
	public ClassContentVO getOneContent(int id) {
		return ClassContentDAO.getOneContent(id);
	}
	
	@Override
	public List<ClassContentVO> getAllClassContent(int classID){
		return ClassContentDAO.getAllClassContent(classID);
	}
	
	@Override
	public List<ClassContentVO> getFileClassContent(int classID){
		return ClassContentDAO.getFileClassContent(classID);
	}
	
	@Override
	public List<ClassContentVO> getRealAll(int classID){
		return ClassContentDAO.getRealAll(classID);
	}
	
	@Override
	public List<ClassContentVO> getAllClassContentForCopy(int classID){
		return ClassContentDAO.getAllClassContentForCopy(classID);
	}
	
	@Override
	public int insertCopiedClassContents(List<ClassContentVO> list){
		return ClassContentDAO.insertCopiedClassContents(list);
	}
	
	@Override
	public List<ClassContentVO> getClassContentID(ClassContentVO vo) {
		return ClassContentDAO.getClassContentID(vo);
	}
}
