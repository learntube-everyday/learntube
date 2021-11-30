package com.mycom.myapp.student.classContent;

import java.util.List;

import com.mycom.myapp.commons.ClassContentVO;

public interface Stu_ClassContentService {
	public ClassContentVO getOneContent(int id);
	public int getPlaylistCount(int classID);
	public List<ClassContentVO> getWeekClassContent(int classID); //추가
	public List<ClassContentVO> getSamePlaylistID(ClassContentVO vo); //추가
	public List<ClassContentVO> getAllClassContent(int classID);
	public int getDaySeq(ClassContentVO vo);
	public String getCompleteClassContent(ClassContentVO vo);
}
