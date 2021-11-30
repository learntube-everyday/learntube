package com.mycom.myapp.student.notice;

import java.util.List;

import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

public interface Stu_NoticeService {
	public List<NoticeVO> getAllNotice(NoticeVO vo);
	public List<NoticeVO> getAllPin(NoticeVO vo);
	public int insertView(NoticeVO vo);
	public int updateViewCount(int id);
	public int countNotice(int classID);
	public int countNoticeCheck(NoticeVO vo);
	public int deleteNoticeCheck(Stu_TakesVO vo);
	public List<NoticeVO> searchNotice(NoticeVO vo);
}
