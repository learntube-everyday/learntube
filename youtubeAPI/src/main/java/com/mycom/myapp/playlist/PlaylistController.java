package com.mycom.myapp.playlist;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.PlaylistVO;
import com.mycom.myapp.member.MemberService;

import net.sf.json.JSONArray;


@Controller
@RequestMapping(value="/playlist")
public class PlaylistController {
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private ClassesService classService;
	
	private int instructorID = 0;
	
	@RequestMapping(value = "/myPlaylist", method = {RequestMethod.GET, RequestMethod.POST}) 
	public String myPlaylist(Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		return "playlist/myPlaylist_noShare";
	}
	
	@RequestMapping(value = "/addPlaylist", method = RequestMethod.POST)
	@ResponseBody
	public void addPlaylist(@ModelAttribute PlaylistVO vo) {
		vo.setInstructorID(instructorID);

		if(playlistService.addPlaylist(vo) != 0) 
			System.out.println("playlist 추가 성공! ");
		else
			System.out.println("playlist 추가 실패! ");
	}
	
	@RequestMapping(value = "/updatePlaylist", method = RequestMethod.POST)
	@ResponseBody
	public void updatePlaylist(@ModelAttribute PlaylistVO vo) {

		if(playlistService.updatePlaylist(vo) != 0) 
			System.out.println("playlist 수정 성공! ");
		else
			System.out.println("playlist 수정 실패! ");
	}
	
	@RequestMapping(value = "/deletePlaylist", method = RequestMethod.POST)
	@ResponseBody
	public void deletePlaylist(@RequestParam(value="playlistID") int id) {

		if(playlistService.deletePlaylist(id) != 0) 
			System.out.println("playlist 삭제 성공! ");
		else
			System.out.println("playlist 삭제 실패! ");
	}
	

	@RequestMapping(value = "/getAllMyPlaylist", method = RequestMethod.POST) 
	@ResponseBody
	public Object getAllMyPlaylist(HttpSession session) {
		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
		instructorID = (Integer)session.getAttribute("userID");
		playlists = playlistService.getAllMyPlaylist(instructorID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allMyPlaylist", playlists);
		
		return map;
	}
	
	// LMS내 영상 검색에 사용. 모든 playlist 가져오기
	@RequestMapping(value = "/getAllPlaylist", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllPlaylist() {
		List<PlaylistVO> playlists = playlistService.getAllPlaylist();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allPlaylist", playlists);
		map.put("code", "ok");
		
		return map;
	}
	
	@RequestMapping(value = "/searchPlaylist", method = RequestMethod.POST) 
	@ResponseBody
	public Object searchPlaylist(@ModelAttribute PlaylistVO vo ) {
		System.out.println("타입, 키워드 값 확인!" + vo.getSearchType()  + vo.getKeyword());
		
		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
		
		// 전체 검색, Playlist 이름, video 제목, 태그 
		
		vo.setInstructorID(instructorID);;
		
		if(vo.getSearchType() == 0) {
			System.out.println("check1");
			playlists = playlistService.searchPlaylist(vo);
			
			System.out.println(playlists);
			System.out.println("check2");
		}
		else if(vo.getSearchType() == 1 && vo.getKeyword() == null) {
			//playlists = playlistService.
		}
//		else if(vo.getSearchType() == 1) {
//			
//		}
		 
		//playlists = playlistService.searchPlaylist(vo);
		System.out.println(playlists.size());
		
		Map<String, Object> map = new HashMap<String, Object>();
		for (int i = 0; i < playlists.size(); i++) {
			  System.out.println("플레이리스트 아이디 확인! => " + playlists.get(i).getId());
		}
		map.put("searched", playlists);
		
		return map;
	}
	
	//선택한 playlist의 자세한정보 가져오기
	@RequestMapping(value = "/getPlaylistInfo", method = RequestMethod.POST)
	@ResponseBody
	public PlaylistVO getPlaylistInfo(@RequestParam(value = "playlistID") String playlistID) {
		PlaylistVO vo = playlistService.getPlaylist(Integer.parseInt(playlistID));
		return vo;
	}
	
	@RequestMapping(value = "/player", method = RequestMethod.POST)
	public String player(Model model,
			@RequestParam(required = false) String playerId,
			@RequestParam(required = false) String playerTitle,
			@RequestParam(required = false) String playerDuration,
			@RequestParam(required = false) String keyword) throws Exception{
		
		System.out.println(playerId);
		
		model.addAttribute("id", playerId);
		model.addAttribute("title", playerTitle);
		model.addAttribute("duration", playerDuration);
		
		return "player";
	}

}

