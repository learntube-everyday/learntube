package com.mycom.myapp.commons;

public class AttendanceInternalCheckVO {
	private int id;
	private String internal;
	private int classContentID;
	private int classID;
	private int days;
	private int studentID;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getInternal() {
		return internal;
	}
	public void setInternal(String internal) {
		this.internal = internal;
	}
	public int getClassContentID() {
		return classContentID;
	}
	public void setClassContentID(int classContentID) {
		this.classContentID = classContentID;
	}
	public int getClassID() {
		return classID;
	}
	public void setClassID(int classID) {
		this.classID = classID;
	}
	public int getDays() {
		return days;
	}
	public void setDays(int days) {
		this.days = days;
	}
	public int getStudentID() {
		return studentID;
	}
	public void setStudentID(int studentID) {
		this.studentID = studentID;
	}
	
	
}
