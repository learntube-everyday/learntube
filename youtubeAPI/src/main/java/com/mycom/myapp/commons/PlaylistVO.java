package com.mycom.myapp.commons;

import java.util.Date;

public class PlaylistVO {
	private int id;
	private String playlistName;
	private String description;
	private String tag;
	private String thumbnailID;
	private int instructorID;	//새로추가
	private int totalVideo;
	private int totalVideoLength;
	private int seq;	//playlist seq
	private int exposed;
	private String modDate;
	
	private String youtubeID; //이거 영상재생할 때 진짜 필요하다
	private String title;
	private String newTitle;
	private double start_s;
	private double end_s;
	private double duration;
	private int searchType;
	private String keyword;
	
	public int getId() { 
		return id;
	}
	public void setId(int id) { //playlist 정렬 순서 바꿀때 사용
		this.id = id;
	}
	public String getPlaylistName() {
		return playlistName;
	}
	public void setPlaylistName(String playlistName) {
		this.playlistName = playlistName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public String getThumbnailID() {
		return thumbnailID;
	}
	public void setThumbnailID(String thumbnailID) {
		this.thumbnailID = thumbnailID;
	}
	public int getInstructorID() {
		return instructorID;
	}
	public void setInstructorID(int instructorID) {
		this.instructorID = instructorID;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getExposed() {
		return exposed;
	}
	public void setExposed(int exposed) {
		this.exposed = exposed;
	}
	public int getTotalVideo() {
		return totalVideo;
	}
	public void setTotalVideo(int totalVideo) {
		this.totalVideo = totalVideo;
	}
	public int getTotalVideoLength() {
		return totalVideoLength;
	}
	public void setTotalVideoLength(int totalVideoLength) {
		this.totalVideoLength = totalVideoLength;
	}
	public String getModDate() {
		return modDate;
	}
	public void setModDate(String modDate) {
		this.modDate = modDate;
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
	public String getNewtTitle() {
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
	public double getDuration() {
		return duration;
	}
	public void setDuration(double duration) {
		this.duration = duration;
	}

	public int getSearchType() {
		return searchType;
	}
	public void setSearchType(int searchType) {
		this.searchType = searchType;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
}
