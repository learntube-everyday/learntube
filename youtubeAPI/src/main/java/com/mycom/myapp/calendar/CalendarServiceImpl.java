package com.mycom.myapp.calendar;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.CalendarVO;

@Service
public class CalendarServiceImpl implements CalendarService{
	@Autowired
	CalendarDAO calendarDAO;
	
	@Override
	public int insertEvent(CalendarVO vo) {
		return calendarDAO.insertEvent(vo);
	}
	
	@Override
	public int updateEvent(CalendarVO vo) {
		return calendarDAO.updateEvent(vo);
	}
	
	@Override
	public int changeDate(CalendarVO vo) {
		return calendarDAO.changeDate(vo);
	}
	
	@Override
	public int deleteEvent(int id) {
		return calendarDAO.deleteEvent(id);
	}
	
	@Override
	public List<CalendarVO> getScheduleList(int classID){
		return calendarDAO.getScheduleList(classID);
	}
	
	@Override
	public int insertCopiedCalendar(List<CalendarVO> list) {
		return calendarDAO.insertCopiedCalendar(list);
	}
}
