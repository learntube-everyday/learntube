package com.mycom.myapp.classes;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.mycom.myapp.commons.ClassesVO;

@Component
public class ScheduleList {
	@Autowired
	private ClassesService classService;
	
	@Scheduled(cron = "0 0 0 * * *")	//초 분 시 일 월 요일 연도
	public void closeClassroom() {
		System.out.println("close 되어야하는 강의실 가져오는중!!");
		SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
		Date time = new Date();
		String now = format1.format(time);
		System.out.println(now + "now");
		List<ClassesVO> result = classService.getClassesToBeClosed(format1.format(new Date()));
		
		for(int i=0; i<result.size(); i++) {
			System.out.println(i + " -> id" + result.get(i).getId() + " / " + result.get(i).getClassName());
		}
	}
}
