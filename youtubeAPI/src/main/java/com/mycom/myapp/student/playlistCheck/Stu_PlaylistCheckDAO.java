package com.mycom.myapp.student.playlistCheck;


import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.student.takes.Stu_TakesVO;


@Repository
public class Stu_PlaylistCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertPlaylist(Stu_PlaylistCheckVO vo) {
		int result = sqlSession.insert("Stu_PlaylistCheck.insertPlaylist", vo);
		return result;
	}
	
	public int insertNoPlaylistID(Stu_PlaylistCheckVO vo) {
		int result = sqlSession.insert("Stu_PlaylistCheck.insertNoPlaylistID", vo);
		return result;
	}
	
	public int updatePlaylist(Stu_PlaylistCheckVO vo) {
		int result = sqlSession.update("Stu_PlaylistCheck.updatePlaylist", vo);
		return result;
	}
	
	public int updateTotalWatched(Stu_PlaylistCheckVO vo) {
		int result = sqlSession.update("Stu_PlaylistCheck.updateTotalWatched", vo);
		return result;
	}
	
	public int deletePlaylist(Stu_TakesVO vo) {
		int result = sqlSession.delete("Stu_PlaylistCheck.deletePlaylist", vo);
		return result;
	}
	
	public Stu_PlaylistCheckVO getPlaylist(int id) {
		return sqlSession.selectOne("Stu_PlaylistCheck.getPlaylist", id);
	}
	
	public Stu_PlaylistCheckVO getPlaylistByContentStu(Stu_PlaylistCheckVO vo) {
		return sqlSession.selectOne("Stu_PlaylistCheck.getPlaylistByContentStu", vo);
	}
	
	public Stu_PlaylistCheckVO getPlaylistByPlaylistID(Stu_PlaylistCheckVO vo) {
		return sqlSession.selectOne("Stu_PlaylistCheck.getPlaylistByPlaylistID", vo);
	}
	
	public int getTotalVideo(int playlistID) {
		return sqlSession.selectOne("Stu_PlaylistCheck.getTotalVideo", playlistID);
	}
	
	public int getHowMany(Stu_PlaylistCheckVO vo) {
		return sqlSession.selectOne("Stu_PlaylistCheck.getHowMany", vo);
	}
	
	public List<Stu_PlaylistCheckVO> getCompletePlaylist(Stu_PlaylistCheckVO vo) {
		return sqlSession.selectList("Stu_PlaylistCheck.getCompletePlaylist", vo);
	}
	
	public List<Stu_PlaylistCheckVO> getCompletePlaylistWithDays(Stu_PlaylistCheckVO vo) {
		return sqlSession.selectList("Stu_PlaylistCheck.getCompletePlaylistWithDays", vo);
	}

	public List<Stu_PlaylistCheckVO> getAllPlaylist() {
		//System.out.println("dao!");
		return sqlSession.selectList("Stu_PlaylistCheck.getAllPlaylist");
	}
//	public PlaylistVO getPlaylist (int id) {
//		return sqlSession.selectOne("Playlist.getPlaylist", id);
//	}
}
