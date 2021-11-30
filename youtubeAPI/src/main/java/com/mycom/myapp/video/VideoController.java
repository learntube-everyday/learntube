package com.mycom.myapp.video;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.PlaylistVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.playlist.PlaylistService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/video")
@PropertySource("classpath:config.properties")
public class VideoController {

	@Autowired
	private VideoService videoService;
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private ClassesService classService;
	
	@Value("${youtube.key}")
	private String youtubeKey;
	
	private int instructorID = 0;
	
	//video 수정/재생page 이동
	@RequestMapping(value = "/detail", method = RequestMethod.POST)
	public String getSelectedPlaylistVideos(@RequestParam("playlistID") int playlistID, 
			@RequestParam("videoID") int videoID, Model model, HttpSession session){
		instructorID = (Integer)session.getAttribute("userID");
		model.addAttribute("videoID", videoID);	//가장 먼저 플레이어에 띄워지는 비디오
		model.addAttribute("playlistID", playlistID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		return "playlist/selectedPlaylist";
	}
		
	@RequestMapping(value = "/youtube", method = RequestMethod.GET)
	public String youtube(Model model, String keyword, HttpSession session) {
		//model.addAttribute("accessToken", accessToken);			--> 다시 사용하려면 homecontroller 확인하기
		instructorID = (Integer)session.getAttribute("userID");
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		System.out.println("유투브 키 확인 =>" + youtubeKey);
		model.addAttribute("youtubeKey", youtubeKey);
		return "video/youtube";
	}
	
	//선택한 playlist에 속한 video list 가져오기
	@RequestMapping(value = "/getOnePlaylistVideos", method = RequestMethod.POST)
	@ResponseBody
	public Object getOnePlaylist(@RequestParam(value = "id") String playlistID) {
		List<VideoVO> videos = new ArrayList<VideoVO>();
		videos = videoService.getVideoList(Integer.parseInt(playlistID));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allVideo", videos);
		
		return map;
	}
	
	@RequestMapping(value = "/updateVideo", method = {RequestMethod.GET, RequestMethod.POST}) 
	@ResponseBody
	public String updateVideo(@ModelAttribute VideoVO videoVo) {
		if(videoService.updateVideo(videoVo) != 0) {
			System.out.println("video 수정 성공!");
	
			int playlistID = videoVo.getPlaylistID();
			updateTotalLength(playlistID);
		}
		else
			System.out.println("video 수정 실패!");
		return "";
	}
	
	@RequestMapping(value = "/deleteVideo", method = RequestMethod.POST)
	@ResponseBody
	public String deleteVideo(HttpServletRequest request) {
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int seq = Integer.parseInt(request.getParameter("seq"));
		
		if( videoService.deleteVideo(videoID) != 0) {
			System.out.println("controller video 삭제 성공! "); 
			updateTotalVideo(playlistID); //totalVideo 업데이트 
			updateTotalLength(playlistID); //totalVideoLength 업데이트
			
			//삭제한 seq가 0이면 thumbnail update!
			if(seq == 0) playlistService.updateThumbnailID(playlistID);
		}
		else
			System.out.println("controller video 삭제 실패! ");
		
		return "ok";
	}
	
	@RequestMapping(value = "/changeVideosOrder", method = RequestMethod.POST) //video 순서 변경될때
	@ResponseBody
	public String changeVideosOrder(
			@RequestParam(value = "changedList[]") List<String> changedList,
			@RequestParam(value = "playlistID") int playlistID) {
		int size = changedList.size()-1;
		for(String order : changedList) {
			VideoVO vo = new VideoVO();
			vo.setId(Integer.parseInt(order));
			vo.setSeq(size);
			
			if (videoService.changeSeq(vo) != 0) {
				if(size == 0) {
					playlistService.updateThumbnailID(playlistID);
				}
				size-=1;
			}
		}

		if (size == -1)
			System.out.println("video 순서 변경 성공! ");
		else
			System.out.println("video 순서 변경 실패! ");
		return "ok";
	}
	
	public void updateTotalVideo (int playlistID) {
		if (playlistService.updateCount(playlistID) != 0)
			System.out.println(playlistID + " : totalVideo업데이트 성공! ");
		else
			System.out.println("totalVideo 업데이트 실패! ");
		
	}
	
	public void updateTotalLength (int playlistID) {
		if (playlistService.updateTotalVideoLength(playlistID) != 0)
			System.out.println(playlistID + " : totalVideoLength 업데이트 성공! ");
		else
			System.out.println("totalVideoLength 업데이트 실패! ");
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/addToPlaylist", method = RequestMethod.POST)
	public String addToPlaylist(Model model, @RequestBody String paramData) { //, @RequestBody VideoVO vo
		//List<Integer> playlistArr = vo.getPlaylistArr();
		//System.out.println("controller: maxLength!!->" + vo.getmaxLength());
		
//		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
//		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));

		// (jw) totalVideoLength 추가를 위한 코드 (21/08/09) 
			
		// 2차
//		JSONArray arr = JSONArray.fromObject(paramData);
//		
//		System.out.println("size of array" + " : " + arr.size());
//		
//		//List<Map<String, Object>> resendList = new ArrayList<Map<String, Object>>();
//		 for(int i=0; i<arr.size(); i++){
//		           
//		        JSONObject obj = (JSONObject)arr.get(i);
////		        Map<String, Object> resendMap = new HashMap<String, Object>();
////		        resendMap.put("Nation", obj.get("Nation"));
////		        resendMap.put("Brand", obj.get("Brand"));
////		            
////		        resendList.add(resendMap);
//		        System.out.println(obj.get("playlistID") + " : " + obj.get("title"));
//		  }
		String result= "";
		List<Map<String,Object>> resultMap = new ArrayList<Map<String,Object>>();
	    resultMap = JSONArray.fromObject(paramData);

	    for (Map<String, Object> map : resultMap) {

	        int playlistID = Integer.parseInt(map.get("playlistID").toString());
	        String youtubeID = map.get("youtubeID").toString();
 			int count = videoService.getTotalCount(playlistID);
 			
 			PlaylistVO pvo = new PlaylistVO();
 			pvo.setId(playlistID);
 			pvo.setThumbnailID(youtubeID);
 			
 			if(count == 0) {
 				if(playlistService.setThumbnailID(pvo) != 0) 
 					System.out.println("playlist 썸네일 추가 성공! ");
 				else 
 					System.out.println("playlist 썸네일 추가 실패! ");
 			}
 			
 			float duration = Float.parseFloat(map.get("duration")+"");
 			
 			String tag;
 			if(map.get("tag")==null) {
 				tag = null;
 			}
 			else {
 				tag = map.get("tag").toString();
 			}
	    	VideoVO vo = new VideoVO();
			vo.setSeq(videoService.getTotalCount(playlistID)); 
			vo.setPlaylistID(playlistID);
			vo.setTitle(map.get("title").toString());
			vo.setNewTitle(map.get("newTitle").toString()); 
			vo.setStart_s(Double.parseDouble(map.get("start_s").toString()));
			vo.setEnd_s(Double.parseDouble(map.get("end_s").toString()));
			vo.setYoutubeID(map.get("youtubeID").toString());
			vo.setmaxLength(Double.parseDouble(map.get("maxLength").toString()));
			vo.setDuration(duration); 
			vo.setTag(tag);
			 
			// 동영상 DB에 추가하기 
			if(videoService.insertVideo(vo) != 0) {
				System.out.println(map.get("title").toString() + " 비디오 추가 성공!! ");
				updateTotalVideo(playlistID);
				updateTotalLength(playlistID);
				
			}
			else {
				System.out.println("비디오 추가 실패 ");
				result = "error";
			}
	    }
		return result;
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/addVideo", method = RequestMethod.POST)
	public String addVideo(Model model, @ModelAttribute VideoVO vo) {
		List<Integer> playlistArr = vo.getPlaylistArr();
		System.out.println("controller: maxLength!!->" + vo.getmaxLength());
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));

		// (jw) 이거 지워도 되는지 확인 
		double length = vo.getDuration();
		
		for(int i=0; i<playlistArr.size(); i++) {
			int playlistID = playlistArr.get(i);
			int count = videoService.getTotalCount(playlistID);
			
			if(count == 0) {
				if(playlistService.updateThumbnailID(playlistID) != 0) {
					System.out.println("playlist 썸네일 추가 성공! ");
				}
				else {
					System.out.println("playlist 썸네일 추가 실패! ");
				}
			}
			
			//새로운 video의 seq 구하기
			vo.setSeq(videoService.getTotalCount(playlistID)); 
			//playlistID 설정하기 
			vo.setPlaylistID(playlistID);
			
			// 동영상 DB에 추가하기 
			if(videoService.insertVideo(vo) != 0) {
				System.out.println("title: " + vo.getTitle());
				System.out.println(playlistID + "번 비디오 추가 성공!! ");
				
				updateTotalVideo(playlistID);
				updateTotalLength(playlistID);
				
			}
			else 
				System.out.println("비디오 추가 실패 ");
		}
		
		return "youtube";
	}

}