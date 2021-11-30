package com.mycom.myapp.commons;

public class CalendarVO {
	private int id;
	private int classID;
	private String name;
	private String date;
	private Integer allday;
	private String memo;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getClassID() {
		return classID;
	}
	public void setClassID(int classID) {
		this.classID = classID;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public Integer getAllday() {
		return allday;
	}
	public void setAllday(Integer allday) {
		this.allday = allday;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
}
