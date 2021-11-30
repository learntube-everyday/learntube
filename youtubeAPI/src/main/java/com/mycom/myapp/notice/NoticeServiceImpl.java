package com.mycom.myapp.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.NoticeVO;

@Service
public class NoticeServiceImpl implements NoticeService{
	@Autowired
	NoticeDAO noticeDAO;
	
	@Override
	public int insertNotice(NoticeVO vo) {
		return noticeDAO.insertNotice(vo);
	}
	
	@Override
	public int updateNotice(NoticeVO vo) {
		return noticeDAO.updateNotice(vo);
	}
	
	@Override
	public int deleteNotice(int id) {
		return noticeDAO.deleteNotice(id);
	}
	
	@Override
	public List<NoticeVO> getAllNotice(int id){
		return noticeDAO.getAllNotice(id);
	}
	
	@Override
	public List<NoticeVO> getAllPin(int id){
		return noticeDAO.getAllPin(id);
	}
	
	@Override
	public int setPin(int id) {
		return noticeDAO.setPin(id);
	}
	
	@Override
	public int unsetPin(int id) {
		return noticeDAO.unsetPin(id);
	}

	@Override
	public List<NoticeVO> searchNotice(NoticeVO vo) {
		return noticeDAO.searchNotice(vo);
	}
}
