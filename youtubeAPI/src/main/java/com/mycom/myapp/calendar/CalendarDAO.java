package com.mycom.myapp.calendar;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mycom.myapp.commons.CalendarVO;

@Repository
public class CalendarDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertEvent(CalendarVO vo) {
		sqlSession.insert("Calendar.insertEvent", vo);
		return vo.getId();
	}
	
	public int updateEvent(CalendarVO vo) {
		return sqlSession.update("Calendar.updateEvent", vo);
	}
	
	public int changeDate(CalendarVO vo) {
		return sqlSession.update("Calendar.changeDate", vo);
	}
	
	public int deleteEvent(int id) {
		return sqlSession.delete("Calendar.deleteEvent", id);
	}
	
	public List<CalendarVO> getScheduleList(int classID){
		return sqlSession.selectList("Calendar.getScheduleList", classID);
	}
	
	public int insertCopiedCalendar(List<CalendarVO> list) {
		return sqlSession.insert("Calendar.insertCopiedCalendar", list);
	}
}
