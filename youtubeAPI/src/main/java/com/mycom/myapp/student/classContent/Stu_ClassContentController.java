package com.mycom.myapp.student.classContent;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
import com.mycom.myapp.student.video.Stu_VideoService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;
import com.mycom.myapp.video.VideoService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/class")
public class Stu_ClassContentController {
	@Autowired
	private ClassesService classService;	
	@Autowired
	private Stu_ClassesService classService_stu;
	@Autowired
	private Stu_ClassContentService classContentService;
	@Autowired
	private ClassContentService classInsContentService;
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	@Autowired
	private Stu_VideoService videoService;
	@Autowired
	private VideoService insVideoService;
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInCheckService;
	
	private int studentID = 0;
	private int classID = 0;
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)	
	public String contentList(@PathVariable("classID") int classId, Model model, HttpSession session) {
		studentID = (Integer)session.getAttribute("userID");
		classID = classId;
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setStudentID(studentID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(studentID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(studentID)));
		
		if(classService_stu.checkTakeClass(vo) == 0) {
			System.out.println("수강중인 과목이 아님!");
			return "accessDenied_stu";
		}
		
		//ClassContentVO ccvo = new ClassContentVO();
		//ccvo.setClassID(classID); 
		model.addAttribute("classInfo", classService_stu.getClass(classID)); //class테이블에서 classID가 같은 모든 것을 가져온다.
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		//지금 studentID가 제대로 안들어간다..
		//해당 플레이리스트에서 watched가 1인거 ..
		
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //여기 수정 
		
		model.addAttribute("playlistCheck", JSONArray.fromObject(playlistcheckService.getAllPlaylist()));
		model.addAttribute("className", classService.getClassName(classID));
		return "class/contentsList_Stu";
	}
	
	@RequestMapping(value = "/contentDetail", method = RequestMethod.POST) //class contents 전체 보여주기
	public String contentDetail(@RequestParam("playlistID") int playlistID, 
								@RequestParam("id") int id, 
								@RequestParam("daySeq") int day, Model model, HttpSession session) {

		//아래는 Stu_ClassController에 이함수가 있을 때 있떤건데 없어도될것같다
		//playlistID = playlistId;
		//id = ID;
		//classID = classId;
		//daySeq = day;
		
		studentID = (Integer)session.getAttribute("userID");
		
		
		VideoVO pvo = new VideoVO();
		
		//여기서 playlistID==0이면 playlistCHeck테이블에 넣어주기 
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		pcvo.setStudentID(studentID);
		pcvo.setClassContentID(id);
		pcvo.setClassID(classID);
		pcvo.setDays(classContentService.getOneContent(id).getDays());
		pcvo.setTotalVideo(0);
		
		System.out.println("id : " + id + " days : " + day);
		if(playlistID == 0 && playlistcheckService.getPlaylistByContentStu(pcvo) == null) {
			if(playlistcheckService.insertNoPlaylistID(pcvo) != 0) {
				System.out.println("playlistID 0 insert success!");
			}
			

			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setClassContentID(id);
			aivo.setStudentID(studentID);
			
			System.out.println(attendanceInCheckService.getAttendanceInCheckByID(aivo));
			if(attendanceInCheckService.getAttendanceInCheckByID(aivo) == null) {
				aivo.setInternal("출석"); //넣을 때 시간 비교해서 넣어야함 ..... 
				aivo.setClassID(classID);
				aivo.setDays(classContentService.getOneContent(id).getDays());
				if( attendanceInCheckService.insertAttendanceInCheck(aivo) != 0)
					System.out.println("playlistID 0 insert sucess AttendanceInternal");
			}
			//해단 id를가지고  classID, 
		}
		
		//
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setPlaylistID(playlistID);
		ccvo.setId(id);
		ccvo.setClassID(classID); 
		classContentService.getOneContent(id).getDays();
		
		if(classContentService.getDaySeq(ccvo) == playlistcheckService.getCompletePlaylistWithDays(pcvo).size()) {
			//이거는 영상을 다 봤을 때자나,,
			//근데 문서는 아직 안보고 영상만 다본 상태일수도 있자나 
			System.out.println("똑같은데 ,,,");
			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			//aivo.setClassContentID(classPlaylistID);
			aivo.setStudentID(studentID);
			//aivo.setInternal("출석");
			aivo.setClassID(classID);
			System.out.println("studentID : " + studentID  + "classID : " + classID);
			for(int i=0; i<classContentService.getDaySeq(ccvo); i++) {
				int classContentID = classInsContentService.getClassContentID(ccvo).get(i).getId();
				aivo.setClassContentID(classContentID);
				aivo.setDays(classContentService.getOneContent(classContentID).getDays());
				System.out.println("classContentID : " + classContentID  + "days : " + classContentService.getOneContent(classContentID).getDays());
				String endString = classContentService.getOneContent(classContentID).getEndDate();
				String stuCompleteString = playlistcheckService.getPlaylistByPlaylistID(pcvo).getRegdate();
				
				SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
				
				Date endDate = null;
				try {
					endDate = format.parse(endString);
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				Date stuCompleteDate = null;
				try {
					stuCompleteDate = format.parse(stuCompleteString);
				} catch (ParseException e) {
					e.printStackTrace();
				}

				int result = endDate.compareTo(stuCompleteDate); 
				
				//0 이거나 1이면 출석 (endDate >= stuCompleteDate) 기간 내에 들음, 아니면 결석 
				System.out.println("null이 아니여 ? result는 " + result);
				if(attendanceInCheckService.getAttendanceInCheckByID(aivo) == null) {
					System.out.println("null이 아니여 ?2 " );
					if(result == 0 || result == 1)
						aivo.setInternal("출석");
					else //-1 
						aivo.setInternal("결석");
					attendanceInCheckService.insertAttendanceInCheck(aivo);
					System.out.println("출석도 잘넣어보았다 ");
					
					
				}
			}
			
		
			
		}
		
		//model.addAttribute("allMyClass", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("classInfo", classService_stu.getClass(classID)); 
		//model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("vo", classContentService.getOneContent(id));
		model.addAttribute("playlist", JSONArray.fromObject(videoService.getVideoList(pvo)));
		model.addAttribute("playlistSameCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); 
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(classID))); // 1=>classID
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(classID))); 
		
		model.addAttribute("id", id);
		model.addAttribute("daySeq", day);
		return "class/contentsDetail_Stu";	
	}
		
	@ResponseBody
	@RequestMapping(value = "/weekContents", method = RequestMethod.POST)
	public List<ClassContentVO> weekContents(HttpServletRequest request, Model model) throws Exception {
		System.out.println("classID : " + classID);
	    return classContentService.getWeekClassContent(classID); // 정해진 classID를 가지고 Publish된 수업들 가져오기 (classContent와 Playlist테이블 join)
		//return classContentService.getAllClassContent(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<VideoVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		//int id = Integer.parseInt(request.getParameter("id"));
	    VideoVO vo = new VideoVO();
	    vo.setPlaylistID(playlistID);
	    //vo.setId(id);
	    //System.out.println("size : " +videoService.getVideoList(vo).size() + "playlistID : " + playlistID);
	    return insVideoService.getVideoList(playlistID);
	}
	
	@ResponseBody
	@RequestMapping(value = "/forWatched", method = RequestMethod.POST)
	public List<VideoVO> forWatched(HttpServletRequest request, Model model, HttpSession session) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		int classContentID = Integer.parseInt(request.getParameter("classContentID")); //이거 지우면 안된다, 
		
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		studentID = (Integer)session.getAttribute("userID");
		
		pcvo.setStudentID(studentID);
		pcvo.setClassContentID(classContentID);
		pcvo.setClassID(classID);
		pcvo.setDays(classContentService.getOneContent(classContentID).getDays());
		pcvo.setTotalVideo(0);
		
		if(playlistID == 0 && playlistcheckService.getPlaylistByContentStu(pcvo) == null) {
			if(playlistcheckService.insertNoPlaylistID(pcvo) != 0) {
				System.out.println("changing, playlistID 0 insert success!");
			}
			

			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setClassContentID(classContentID);
			aivo.setStudentID(studentID);
			
			System.out.println(attendanceInCheckService.getAttendanceInCheckByID(aivo));
			if(attendanceInCheckService.getAttendanceInCheckByID(aivo) == null) {
				aivo.setInternal("출석");
				aivo.setClassID(classID);
				aivo.setDays(classContentService.getOneContent(classContentID).getDays());
				if( attendanceInCheckService.insertAttendanceInCheck(aivo) != 0)
					System.out.println("changing, playlistID 0 insert sucess AttendanceInternal");
			}
			//해단 id를가지고  classID, 
		}
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
	    vo.setPlaylistID(playlistID);
	    vo.setStudentID(studentID);
	    vo.setClassContentID(classContentID);
	    return videoService.getVideoCheckList(vo);
	} //이렇게하면 videoCheck에 없는 영상에 대한 정보는 가져오지 못함 ..... ..
	

	@ResponseBody
	@RequestMapping(value = "/changeID", method = RequestMethod.POST)
	public ClassContentVO changeID(HttpServletRequest request, Model model) throws Exception {
		ClassContentVO vo = classContentService.getOneContent(Integer.parseInt(request.getParameter("id")));
	    
	    return vo;////
	}
	
	@RequestMapping(value = "/changevideo", method = RequestMethod.POST)
	@ResponseBody
	public List<Stu_VideoCheckVO> changeVideoOK(HttpServletRequest request, HttpSession session) {
		double lastTime = Double.parseDouble(request.getParameter("lastTime"));
		double timer = Double.parseDouble(request.getParameter("timer"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		studentID = (Integer)session.getAttribute("userID");
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		
		vo.setLastTime(lastTime);
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		vo.setTimer(timer);
		vo.setPlaylistID(playlistID);
		vo.setClassID(classID);
		vo.setClassContentID(classPlaylistID);
		
		if (videoCheckService.updateTime(vo) == 0) {
			System.out.println("데이터 업데이트 실패 -> insert할 것 ");
			videoCheckService.insertTime(vo);

		}
		else
			System.out.println("데이터 업데이트 성공!!!");
		
		return videoCheckService.getTimeList();
	}
	
	@RequestMapping(value = "/videocheck", method = RequestMethod.POST)
	@ResponseBody
	public double videoCheck(HttpServletRequest request, HttpSession session) {
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		studentID = (Integer)session.getAttribute("userID");
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		if (videoCheckService.getTime(vo) != null) {
			return videoCheckService.getTime(vo).getLastTime();
		}
		else {
			return -1.0;
		}
	}
	
	@RequestMapping(value = "/changewatch", method = RequestMethod.POST)
	@ResponseBody
	public String changeWatchOK(HttpServletRequest request, HttpSession session) {
		double lastTime = Double.parseDouble(request.getParameter("lastTime"));
		double timer = Double.parseDouble(request.getParameter("timer"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int watch = Integer.parseInt(request.getParameter("watch"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		int totalVideo = Integer.parseInt(request.getParameter("totalVideo"));

		studentID = (Integer)session.getAttribute("userID");
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		vo.setLastTime(lastTime);
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		vo.setTimer(timer);
		vo.setClassID(classID);
		vo.setClassContentID(classPlaylistID);
		vo.setPlaylistID(playlistID);
		vo.setWatched(watch);
		
		//우선 현재 db테이블의 getWatched를 가져온다. 이때 가져온 값이 0이다
		//vo.setWatched를 한다.
		//vo.getWatched했는데 1이다.
		//이럴때 playlistcheck테이블의 totalWatched업데이트 시켜주기
		//totalVideo랑 playlist의 개수가 똑같고, watch가 모두 1이면 ==> playlistCheck insert 
		
		if (videoCheckService.updateWatch(vo) == 0) { //하나도 안멈추고 처음부터 끝까지 보는 경우
			videoCheckService.insertTime(vo);	
		}
		else { //업데이트가 성공하면 
			System.out.println("changeWatch 업데이트 성공 ");
		}
		
		int count = 0;
		//if(totalVideo == playlistService.getPlaylist(playlistID).getTotalVideo()) {
			//System.out.println("이거 출력되면 안돼,,,,,,,,"); //이거 출력되면 watch 1인거 다 확인해주어야 함 
		for(int i= 0; i<videoCheckService.getWatchedCheck(vo).size(); i++) {
			if(videoCheckService.getWatchedCheck(vo).get(i).getWatched() == 1) {
				count++;
			}
			else {
				break;
			}
		}
			
		if(count == playlistService.getPlaylist(playlistID).getTotalVideo()) {
			System.out.println("playlistCheck insert!");
			Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
			
			pcvo.setStudentID(studentID);
			pcvo.setPlaylistID(playlistID);
			pcvo.setClassContentID(classPlaylistID);
			pcvo.setClassID(classID);
			pcvo.setDays(classContentService.getOneContent(classPlaylistID).getDays());
			pcvo.setTotalVideo(playlistService.getPlaylist(playlistID).getTotalVideo());
			pcvo.setTotalWatched(0.0);
			
			if(playlistcheckService.getPlaylistByPlaylistID(pcvo) == null) {
				if(playlistcheckService.insertPlaylist(pcvo) != 0) {
					System.out.println("changewatch good insert");
					//playlistCheck에 insert될 때, attendanceInternalCheck에도 insert시키기 
					//get했을 때 null이면 insert, 
					//마감일보다 playlistCheck에 insert된 시간이 먼저거나 갘으면 true(출석)
					//그렇지 않으면 결석 
					//playlistCheck에서 classID, days, studentID가 같은 것의 개수와
					//classContent에서 classID, days가 같은 것의 개수가 같을 때
					ClassContentVO ccvo = new ClassContentVO();
					ccvo.setClassID(classID);
					ccvo.setDays(classContentService.getOneContent(classPlaylistID).getDays()); 
					ccvo.setPlaylistID(playlistID);
					//attendanceInCheckService에 insert한다 
					
					//0 이거나 1이면 출석 (endDate >= stuCompleteDate) 기간 내에 들음, 아니면 결석 
				
					if(classContentService.getDaySeq(ccvo) == playlistcheckService.getCompletePlaylistWithDays(pcvo).size()) {
						AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
						aivo.setStudentID(studentID);
						aivo.setClassID(classID);
						
						for(int i=0; i<classContentService.getDaySeq(ccvo); i++) {
							int classContentID = classInsContentService.getClassContentID(ccvo).get(i).getId();
							aivo.setClassContentID(classContentID);
							aivo.setDays(classContentService.getOneContent(classContentID).getDays());
							String endString = classContentService.getOneContent(classContentID).getEndDate();
							String stuCompleteString = playlistcheckService.getPlaylistByPlaylistID(pcvo).getRegdate();
							
							SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
							
							Date endDate = null;
							try {
								endDate = format.parse(endString);
							} catch (ParseException e) {
								e.printStackTrace();
							}
							
							Date stuCompleteDate = null;
							try {
								stuCompleteDate = format.parse(stuCompleteString);
							} catch (ParseException e) {
								e.printStackTrace();
							}

							int result = endDate.compareTo(stuCompleteDate); 
							
							//0 이거나 1이면 출석 (endDate >= stuCompleteDate) 기간 내에 들음, 아니면 결석 
							if(attendanceInCheckService.getAttendanceInCheckByID(aivo) == null) {
								if(result == 0 || result == 1)
									aivo.setInternal("출석");
								else //-1 
									aivo.setInternal("결석");
								attendanceInCheckService.insertAttendanceInCheck(aivo);
								System.out.println("출석도 잘넣어보았다 ");
								
								
							}
						}
						
					
						
					}
					
				}
				else
					System.out.println("changewatch insert 실패");
			}
			else {
				System.out.println("추후에 시간 업데이트가 일어날 수 있도록 ,, ");
			}
		}
		
		return "redirect:/"; // 이것이 ajax 성공시 파라미터로 들어가는구만!!
	}
	
	
	
}




