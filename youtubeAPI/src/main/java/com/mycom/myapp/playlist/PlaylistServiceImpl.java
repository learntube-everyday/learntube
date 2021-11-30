package com.mycom.myapp.playlist;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.PlaylistVO;

@Service
public class PlaylistServiceImpl implements PlaylistService{
	@Autowired
	PlaylistDAO playlistDAO;
	
	@Override
	public int addPlaylist(PlaylistVO vo) {
		return playlistDAO.addPlaylist(vo);
	}
	
	@Override
	public int updatePlaylist(PlaylistVO vo) {
		return playlistDAO.updatePlaylist(vo);
	}
	
	@Override
	public int updateThumbnailID(int playlistID) {
		return playlistDAO.updateThumbnailID(playlistID);
	}
	
	@Override
	public int setThumbnailID(PlaylistVO vo) {
		return playlistDAO.setThumbnailID(vo);
	}
	
	@Override
	public int changeSeq(PlaylistVO vo) {
		return playlistDAO.changeSeq(vo);
	}
	
	@Override
	public int deletePlaylist(int playlistID) {
		return playlistDAO.deletePlaylist(playlistID);
	}
	
	@Override
	public PlaylistVO getPlaylist(int playlistID) {
		return playlistDAO.getPlaylist(playlistID);
	}
	
	@Override
	public List<PlaylistVO> getAllPlaylist() {
		return playlistDAO.getAllPlaylist();
	}
	
	@Override
	public List<PlaylistVO> getAllMyPlaylist(int instructorID){
		return playlistDAO.getAllMyPlaylist(instructorID);
	}
	
	@Override
	public int getCount() {
		return playlistDAO.getCount();
	}
	
	@Override
	public int updateCount(int id) {
		return playlistDAO.updateCount(id);
	}

	@Override
	public int updateTotalVideoLength(int id) {
		return playlistDAO.updateTotalVideoLength(id);
	}
	
	@Override
	public List<PlaylistVO> getPlaylistForInstructor(PlaylistVO vo) {
		return playlistDAO.getPlaylistForInstructor(vo);
	}

	@Override
	public List<PlaylistVO> searchPlaylist(PlaylistVO vo) {
		return playlistDAO.searchPlaylist(vo);
	}

}
