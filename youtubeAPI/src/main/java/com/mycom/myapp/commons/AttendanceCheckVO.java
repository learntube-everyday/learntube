package com.mycom.myapp.commons;

public class AttendanceCheckVO {
	private int id;
	private int attendanceID;
	private String external;
	private int internal;
	private int studentID;
	private int days; //없어도 될듯
	private String date; //없어도 될듯 
	
	public int getID() {
		return id;
	}
	public void setID(int id) {
		this.id = id;
	}
	public int getAttendanceID() {
		return attendanceID;
	}
	public void setAttendanceID(int attendanceID) {
		this.attendanceID = attendanceID;
	}
	public String getExternal() {
		return external;
	}
	public void setExternal(String external) {
		this.external = external;
	}
	public int getInternal() {
		return internal;
	}
	public void setInternal(int internal) {
		this.internal = internal;
	}
	public int getStudentID() {
		return studentID;
	}
	public void setStudentID(int studentID) {
		this.studentID = studentID;
	}
	public int getDays() {
		return days;
	}
	public void setDays(int days) {
		this.days = days;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	
	
	

}
