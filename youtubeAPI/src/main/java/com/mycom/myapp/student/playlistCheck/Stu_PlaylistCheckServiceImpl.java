package com.mycom.myapp.student.playlistCheck;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.student.takes.Stu_TakesVO;


@Service
public class Stu_PlaylistCheckServiceImpl implements Stu_PlaylistCheckService{
	
	@Autowired
	Stu_PlaylistCheckDAO playlistcheckDAO;
	
	@Override
	public int insertPlaylist(Stu_PlaylistCheckVO vo) {
		return  playlistcheckDAO.insertPlaylist(vo);
	}
	
	@Override
	public int insertNoPlaylistID(Stu_PlaylistCheckVO vo) {
		return  playlistcheckDAO.insertNoPlaylistID(vo);
	}
	
	@Override
	public int deletePlaylist(Stu_TakesVO vo) {
		return playlistcheckDAO.deletePlaylist(vo);
	}
	
	@Override
	public int updatePlaylist(Stu_PlaylistCheckVO vo) {
		return playlistcheckDAO.updatePlaylist(vo);
	}
	
	@Override
	public int updateTotalWatched(Stu_PlaylistCheckVO vo) {
		return playlistcheckDAO.updateTotalWatched(vo);
	}
	
	@Override
	public Stu_PlaylistCheckVO getPlaylist(int id) {
		return playlistcheckDAO.getPlaylist(id);
	}
	
	@Override
	public Stu_PlaylistCheckVO getPlaylistByContentStu(Stu_PlaylistCheckVO vo) {
		return playlistcheckDAO.getPlaylistByContentStu(vo);
	}
	
	@Override
	public Stu_PlaylistCheckVO getPlaylistByPlaylistID(Stu_PlaylistCheckVO vo) {
		return playlistcheckDAO.getPlaylistByPlaylistID(vo);
	}
	
	@Override
	public int getTotalVideo(int playlistID) {
		return playlistcheckDAO.getTotalVideo(playlistID);
	}
	
	@Override
	public int getHowMany(Stu_PlaylistCheckVO vo) {
		return playlistcheckDAO.getHowMany(vo);
	}
	
	@Override
	public List<Stu_PlaylistCheckVO> getCompletePlaylist(Stu_PlaylistCheckVO vo){
		return playlistcheckDAO.getCompletePlaylist(vo);
	}
	
	@Override
	public List<Stu_PlaylistCheckVO> getCompletePlaylistWithDays(Stu_PlaylistCheckVO vo) {
		return playlistcheckDAO.getCompletePlaylistWithDays(vo);
	}
	
	@Override
	public List<Stu_PlaylistCheckVO> getAllPlaylist(){
		return playlistcheckDAO.getAllPlaylist();
	}
}
