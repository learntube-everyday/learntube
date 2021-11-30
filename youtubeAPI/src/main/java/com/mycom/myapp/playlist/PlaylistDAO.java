package com.mycom.myapp.playlist;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.PlaylistVO;

@Repository
public class PlaylistDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public int addPlaylist(PlaylistVO vo) {
		int result = sqlSession.insert("Playlist.addPlaylist", vo);
		return result;
	}
	
	public int updatePlaylist(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.updatePlaylist", vo);
		return result;
	}
	
	public int updateThumbnailID(int playlistID) {
		int result = sqlSession.update("Playlist.updateThumbnailID", playlistID);
		return result;
	}
	
	public int setThumbnailID(PlaylistVO vo) {
		return sqlSession.update("Playlist.setThumbnailID", vo);
	}
	
	public int changeSeq(PlaylistVO vo) {
		int result = sqlSession.update("Playlist.changeSeq", vo);
		return result;
	}
	
	public int deletePlaylist(int id) {
		int result = sqlSession.delete("Playlist.deletePlaylist", id);
		return result;
	}
	
	public PlaylistVO getPlaylist(int id) {
		PlaylistVO result = sqlSession.selectOne("Playlist.getPlaylist", id);
		return result;
	}
	
	public List<PlaylistVO> getAllPlaylist(){ //이부분 public 된것만 가져오도록 변경 필요!! (lms내 다른사람이 만든거 검색할때 사용)
		List<PlaylistVO> result = sqlSession.selectList("Playlist.getAllPlaylist");
		return result;
	}
	
	public List<PlaylistVO> getAllMyPlaylist(int instructorID){ //내가 만든 playlist만 가져올 때
		List<PlaylistVO> result = sqlSession.selectList("Playlist.getAllMyPlaylist", instructorID);
		return result;
	}
	
	public int getCount() {
		int result = sqlSession.selectOne("Playlist.getPlaylistCount");
		return result;
	}
	
	public int updateCount(int id) { //totalVideo 업데이트
		int result = sqlSession.update("Playlist.updateCount", id);
		return result;
	}
	public int updateTotalVideoLength(int id) {
		int result = sqlSession.update("Playlist.updateTotalVideoLength", id);
		return result;
	}
	
	public List<PlaylistVO> getPlaylistForInstructor(PlaylistVO vo){ //선생님 contentsDetail페이지에서 선택한 플레이리스트에 대한 영상 보여주기 위한 코드
		List<PlaylistVO> result = sqlSession.selectList("Playlist.getPlaylistForInstructor", vo);
		return result;
	}
	
	public List<PlaylistVO> searchPlaylist(PlaylistVO vo){
		List<PlaylistVO> result = sqlSession.selectList("Playlist.searchPlaylist", vo);
		return result;
	}

}