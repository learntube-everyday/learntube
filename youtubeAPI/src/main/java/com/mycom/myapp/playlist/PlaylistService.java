package com.mycom.myapp.playlist;

import java.util.List;

import com.mycom.myapp.commons.PlaylistVO;

public interface PlaylistService {
	public int addPlaylist(PlaylistVO vo);
	public int updatePlaylist(PlaylistVO vo);
	public int updateThumbnailID(int playlistID);
	public int setThumbnailID(PlaylistVO vo);
	public int changeSeq(PlaylistVO vo);
	public int deletePlaylist(int id);
	public PlaylistVO getPlaylist(int id);
	public List<PlaylistVO> getAllPlaylist();
	public List<PlaylistVO> getAllMyPlaylist(int instructorID);
	public int getCount();
	public int updateCount(int id);
	public int updateTotalVideoLength(int id); 
	public List<PlaylistVO> getPlaylistForInstructor(PlaylistVO vo);
	public List<PlaylistVO> searchPlaylist(PlaylistVO vo);
}
