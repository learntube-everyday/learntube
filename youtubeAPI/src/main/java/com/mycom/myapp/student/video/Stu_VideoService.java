package com.mycom.myapp.student.video;

import java.util.List;

import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

public interface Stu_VideoService {
	
	public VideoVO getVideo(int playlistID);
	//public List<PlaylistVO> getVideoList(int playlistID);
	public List<VideoVO> getVideoList(VideoVO vo);
	public List<VideoVO> getVideoCheckList(Stu_VideoCheckVO vo);
//	public PlaylistVO getPlaylist(int id);

}