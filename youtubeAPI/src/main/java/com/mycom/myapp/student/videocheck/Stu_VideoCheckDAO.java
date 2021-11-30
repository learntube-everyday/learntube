package com.mycom.myapp.student.videocheck;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.student.takes.Stu_TakesVO;

@Repository
public class Stu_VideoCheckDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;
	
	public int insertTime(Stu_VideoCheckVO vo) {
		int result = sqlSession.insert("Stu_videoCheck.insertTime", vo);
		return result;
	}
	
	public int deleteTime(Stu_TakesVO vo) {
		int result = sqlSession.delete("Stu_videoCheck.deleteTime", vo);
		return result;
	}
	
	public int updateTime(Stu_VideoCheckVO vo) {
		int result = sqlSession.update("Stu_videoCheck.updateTime", vo);
		return result;
	}
	
	public int updateWatch(Stu_VideoCheckVO vo) {
		int result = sqlSession.update("Stu_videoCheck.updateWatch", vo);
		return result;
	}
	
	public Stu_VideoCheckVO getTime(int id) {
		//System.out.println("2번방문!");
		return sqlSession.selectOne("Stu_videoCheck.getTime", id);
	}
	
	public Stu_VideoCheckVO getTime(Stu_VideoCheckVO vo) {
		//System.out.println(sqlSession.selectOne("Video.getTime2", vo));
		return sqlSession.selectOne("Stu_videoCheck.getTime2", vo);
	}
	
	public List<Stu_VideoCheckVO> getWatchedCheck(Stu_VideoCheckVO vo) {
		return sqlSession.selectList("Stu_videoCheck.getWatchedCheck", vo);
	}
	
	public List<Stu_VideoCheckVO> getTimeList() {
		List<Stu_VideoCheckVO> result = sqlSession.selectList("Stu_videoCheck.getTimeList");
		return result;
	}
}

//db table에 마지막으로 시청한 시간을 추가하도록 VideoDAO.java에 insertTime추가.