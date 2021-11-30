package com.mycom.myapp.classContent;

import java.util.List;

import com.mycom.myapp.commons.ClassContentVO;

public interface ClassContentService {
	public int insertContent(ClassContentVO vo);
	public int insertURLContent(ClassContentVO vo);
	public int updateContent(ClassContentVO vo);
	public int updatePublished(ClassContentVO vo);
	public int deleteContent(int id);
	public int deleteContentList(ClassContentVO vo);
	public List<ClassContentVO> getDaySeq(ClassContentVO vo);
	public int getDaySeqNum(ClassContentVO vo) ;
	public int getClassNum(int classID);
	public List<ClassContentVO> getEndDate(ClassContentVO vo);
	public int getClassDaysNum(int classID);
	public int getBiggestUsedDay(int classID);
	public ClassContentVO getOneContentInstructor(int id);
	public ClassContentVO getOneContent(int id);
	public List<ClassContentVO> getAllClassContent(int classID);
	public List<ClassContentVO> getFileClassContent(int classID);
	public List<ClassContentVO> getRealAll(int classID);
	public List<ClassContentVO> getAllClassContentForCopy(int classID);
	public int insertCopiedClassContents(List<ClassContentVO> list);
	public List<ClassContentVO> getClassContentID(ClassContentVO vo);
}
