package com.mycom.myapp.notice;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.commons.PlaylistVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;

import net.sf.json.JSONArray;

@Controller
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	@Autowired
	private ClassesService classService;

	private int instructorID = 0;
	
	@RequestMapping(value="/notice/{classID}", method = {RequestMethod.GET, RequestMethod.POST})
	public String notice(@PathVariable(value="classID") int classID, Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setInstructorID(instructorID);
		
		//accessDenied 페이지에서 아래부분 사용하기때문에 순서 바꾸지 말기!
		model.addAttribute("allMyClass", classService.getAllMyActiveClass(instructorID));
		model.addAttribute("allMyInactiveClass", classService.getAllMyInactiveClass(instructorID));
		
		if(classService.checkAccessClass(vo) == 0) {
			System.out.println("접근권한 없음!");
			return "accessDenied";
		}
		model.addAttribute("classID", classID);
		model.addAttribute("className", classService.getClassName(classID));
		return "class/notice";
	}
	
	@RequestMapping(value = "/addNotice", method = RequestMethod.POST)
	@ResponseBody
	public void addNotice(@ModelAttribute NoticeVO vo) {
		int noticeID = noticeService.insertNotice(vo);
		
		if(noticeID > 0) 
			System.out.println(noticeID + " notice 추가 성공! ");
		else
			System.out.println("notice 추가 실패! ");
	}
	
	@RequestMapping(value = "/updateNotice", method = RequestMethod.POST)
	@ResponseBody
	public void upateNotice(@ModelAttribute NoticeVO vo) {
		if(noticeService.updateNotice(vo) != 0) 
			System.out.println("notice 추가 성공! ");
		else
			System.out.println("notice 추가 실패! ");
	}
	
	
	@RequestMapping(value = "/deleteNotice", method = RequestMethod.POST)
	@ResponseBody
	public void deleteNotice(@RequestParam(value="id") int id) {
		if(noticeService.deleteNotice(id) != 0) 
			System.out.println("notice 삭제 성공! ");
		else
			System.out.println("notice 삭제 실패! ");
	}
	
	@RequestMapping(value = "/getAllNotice", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllNotice(@RequestParam(value="classID") int id) {
		List<NoticeVO> list = noticeService.getAllNotice(id);
		
		if(list != null) 
			System.out.println("teacher_notice list가져오기 성공!");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("notices", list);
		
		return map;
	}
	
	@RequestMapping(value = "/getAllPin", method = RequestMethod.POST)
	@ResponseBody
	public List<NoticeVO> getAllPin(@RequestParam(value="classID") int id) {
		List<NoticeVO> list = noticeService.getAllPin(id);
		
		if(list != null) 
			System.out.println("teacher_notice list가져오기 성공!");
		
		return list;
	}
	
	@RequestMapping(value = "/setPin", method = RequestMethod.POST)
	@ResponseBody
	public void setPin(@RequestParam(value="id") int id) {
		if(noticeService.setPin(id) != 0) 
			System.out.println("set pin 성공! ");
		else
			System.out.println("set pin 실패! ");
	}
	
	@RequestMapping(value = "/unsetPin", method = RequestMethod.POST)
	@ResponseBody
	public void unsetPin(@RequestParam(value="id") int id) {
		if(noticeService.unsetPin(id) != 0) 
			System.out.println("unset pin 성공! ");
		else
			System.out.println("unset pin 실패! ");
	}
	
	@RequestMapping(value = "/notice/searchNotice", method = RequestMethod.POST)
	@ResponseBody
	public List<NoticeVO> searchNotice(@ModelAttribute NoticeVO vo) throws UnsupportedEncodingException {
		vo.setKeyword(URLDecoder.decode(vo.getKeyword(), "UTF-8"));
		System.out.println(vo.getKeyword());
		System.out.println(vo.getClassID());
		
		List<NoticeVO> list = noticeService.searchNotice(vo);
		
		return list;
	}	
	
}
