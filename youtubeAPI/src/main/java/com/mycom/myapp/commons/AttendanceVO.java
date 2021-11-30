package com.mycom.myapp.commons;

public class AttendanceVO {
	private int id;
	private int classID;
	private int days;
	private String fileName;
	private String regDate;
	private String modDate;

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
	public int getDays() {
		return days;
	}
	public void setDays(int days) {
		this.days = days;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getModDate() {
		return modDate;
	}
	public void setModDate(String modDate) {
		this.modDate = modDate;
	}
		
}
