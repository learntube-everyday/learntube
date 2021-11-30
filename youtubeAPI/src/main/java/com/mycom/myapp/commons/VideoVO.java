package com.mycom.myapp.commons;

import java.util.List;

public class VideoVO {
	private int id;	
	private String youtubeID; 
	private String title;
	private String newTitle;
	private double start_s;
	private double end_s;
	private int playlistID;
	private int seq;
	private String tag;
	private String regdate;
	private List<Integer> playlistArr; 
	private double maxLength;
	private float duration;
	
	//아래는 Student Video
	private int classPlaylistID;
	private double lastTime;
	private double timer;
	private int watched;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getYoutubeID() {
		return youtubeID;
	}
	public void setYoutubeID(String youtubeID) {
		this.youtubeID = youtubeID;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNewTitle() {
		return newTitle;
	}
	public void setNewTitle(String newTitle) {
		this.newTitle = newTitle;
	}
	public double getStart_s() {
		return start_s;
	}
	public void setStart_s(double start_s) {
		this.start_s = start_s;
	}
	public double getEnd_s() {
		return end_s;
	}
	public void setEnd_s(double end_s) {
		this.end_s = end_s;
	}
	public int getPlaylistID() {
		return playlistID;
	}
	public void setPlaylistID(int playlistID) {
		this.playlistID = playlistID;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public List<Integer> getPlaylistArr() {
		return playlistArr;
	}
	public void setPlaylistArr(List<Integer> playlistArr) {
		this.playlistArr = playlistArr;
	}
	public double getmaxLength() {
		return maxLength;
	}
	public void setmaxLength(double maxLength) {
		this.maxLength = maxLength;
	}
	public float getDuration() {
		return duration;
	}
	public void setDuration(float duration) {
		this.duration = duration;
	}
	
	public int getClassPlaylistID() {
		return classPlaylistID;
	}
	public void setClassPlaylistID(int classPlaylistID) {
		this.classPlaylistID = classPlaylistID;
	}
	public double getLastTime() {
		return lastTime;
	}
	public void setLastTime(double lastTime) {
		this.lastTime = lastTime;
	}
	public double getTimer() {
		return timer;
	}
	public void setTimer(double timer) {
		this.timer = timer;
	}
	public int getWatched() {
		return watched;
	}
	public void setWatched(int watched) {
		this.watched = watched;
	}
}
