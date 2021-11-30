package com.mycom.myapp.student.video;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

@Repository
public class Stu_VideoDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	
	public VideoVO getVideo(int playlistID) {
		return sqlSession.selectOne("Stu_Video.getVideo", playlistID);
	}
	
	public List<VideoVO> getVideoList(VideoVO vo) {
		return sqlSession.selectList("Stu_Video.getVideoList", vo);
	}
	
	public List<VideoVO> getVideoCheckList(Stu_VideoCheckVO vo) {
		return sqlSession.selectList("Stu_Video.getVideoCheckList", vo);
	}
	/*public PlaylistVO getPlaylist (int id) {
		return sqlSession.selectOne("Playlist.getPlaylist", id);
	}*/
	
}