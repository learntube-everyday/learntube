package com.mycom.myapp.student.videocheck;

import java.util.List;

import com.mycom.myapp.student.takes.Stu_TakesVO;


public interface Stu_VideoCheckService {
	public int insertTime(Stu_VideoCheckVO vo);

	public int deleteTime(Stu_TakesVO vo) ;
	
	public int updateTime(Stu_VideoCheckVO vo);
	
	public int updateWatch(Stu_VideoCheckVO vo);
	
	public Stu_VideoCheckVO getTime(int id) ;
	
	public Stu_VideoCheckVO getTime(Stu_VideoCheckVO vo) ;
	
	public List<Stu_VideoCheckVO> getWatchedCheck(Stu_VideoCheckVO vo);
	
	public List<Stu_VideoCheckVO> getTimeList();
}
