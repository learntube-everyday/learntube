package com.mycom.myapp.student.playlistCheck;

import java.util.Date;

public class Stu_PlaylistCheckVO  {
	
	private int id;
	private int studentID;
	private int playlistID;
	private int classContentID;
	private int classID;
	private int days;
	private int totalVideo;
	private double totalWatched;
	private String regdate;
	private String updateWatched;
	
	private int videoID; //이거 mapper에서 videoID사용해서 추가하는 
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getStudentID() {
		return studentID;
	}
	public void setStudentID(int studentID) {
		this.studentID = studentID;
	}
	public int getPlaylistID() {
		return playlistID;
	}
	public void setPlaylistID(int playlistID) {
		this.playlistID = playlistID;
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
	public int getTotalVideo() {
		return totalVideo;
	}
	public void setTotalVideo(int totalVideo) {
		this.totalVideo = totalVideo;
	}
	public double getTotalWatched() {
		return totalWatched;
	}
	public void setTotalWatched(double totalWatched) {
		this.totalWatched = totalWatched;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getUpdateWatched() {
		return updateWatched;
	}
	public void setUpdateWatched(String updateWatched) {
		this.updateWatched = updateWatched;
	}
	public int getVideoID() {
		return videoID;
	}
	public void setVideoID(int videoID) {
		this.videoID = videoID;
	}
}
