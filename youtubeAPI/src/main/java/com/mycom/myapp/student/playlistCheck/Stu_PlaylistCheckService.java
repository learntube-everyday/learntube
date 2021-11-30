package com.mycom.myapp.student.playlistCheck;

import java.util.List;

import com.mycom.myapp.student.takes.Stu_TakesVO;

public interface Stu_PlaylistCheckService  {
	public int insertPlaylist(Stu_PlaylistCheckVO vo);
	
	public int insertNoPlaylistID(Stu_PlaylistCheckVO vo);

	public int deletePlaylist(Stu_TakesVO vo) ;
	
	public int updatePlaylist(Stu_PlaylistCheckVO vo);
	
	public int updateTotalWatched(Stu_PlaylistCheckVO vo);
	
	public Stu_PlaylistCheckVO getPlaylist(int playlistID);
	
	public Stu_PlaylistCheckVO getPlaylistByContentStu(Stu_PlaylistCheckVO vo);
	
	public Stu_PlaylistCheckVO getPlaylistByPlaylistID(Stu_PlaylistCheckVO vo);
	
	public int getTotalVideo(int playlistID);
	
	public int getHowMany(Stu_PlaylistCheckVO vo);
	
	public List<Stu_PlaylistCheckVO> getCompletePlaylist(Stu_PlaylistCheckVO vo);
	
	public List<Stu_PlaylistCheckVO> getCompletePlaylistWithDays(Stu_PlaylistCheckVO vo);
	
	public List<Stu_PlaylistCheckVO> getAllPlaylist();
}
