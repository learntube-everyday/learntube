package com.mycom.myapp.calendar;

import java.util.List;

import com.mycom.myapp.commons.CalendarVO;

public interface CalendarService {
	public int insertEvent(CalendarVO vo);
	public int updateEvent(CalendarVO vo);
	public int changeDate(CalendarVO vo);
	public int deleteEvent(int id);
	public List<CalendarVO> getScheduleList(int classID);
	public int insertCopiedCalendar(List<CalendarVO> list);
}
