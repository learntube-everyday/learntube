package com.mycom.myapp.student.notice;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/notice")
public class Stu_NoticeController {
	
	@Autowired
	private Stu_NoticeService noticeService;
	@Autowired
	private ClassesService classService;
	@Autowired
	private Stu_ClassesService classService_stu;
	@Autowired
	private MemberService memberService;
	
	private int studentID = 0;
	
	@RequestMapping(value="/{classID}", method = RequestMethod.GET)
	public String studentNotice(@PathVariable(value="classID") int classID, Model model, HttpSession session) {
		studentID = (Integer)session.getAttribute("userID");
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setStudentID(studentID);
		
		//accessDenied 페이지에서 아래부분 사용하기때문에 순서 바꾸지 말기!
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(studentID)));	
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(studentID)));
		
		if(classService_stu.checkTakeClass(vo) == 0) {
			System.out.println("수강중인 과목이 아님!");
			return "accessDenied_stu";
		}
		
		model.addAttribute("classID", classID);
		model.addAttribute("className", classService.getClassName(classID));
		return "class/notice_Stu";
	}
	
	@RequestMapping(value = "/getAllNotice", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllNotices(@RequestParam(value="classID") int id) {
		NoticeVO vo = new NoticeVO();
		vo.setClassID(id);
		vo.setStudentID(studentID);
		List<NoticeVO> list = noticeService.getAllNotice(vo);
		
		if(list != null) 
			System.out.println("notice list가져오기 성공!");
		
		Map<String, Object> map = new HashMap<String, Object>();	//굳이 map에 넣어서 보내지 않아도 됨!!!변경!!
		map.put("notices", list);
		
		return map;
	}
	
	@RequestMapping(value = "/getAllPin", method = RequestMethod.POST)
	@ResponseBody
	public List<NoticeVO> getAllPin(@RequestParam(value="classID") int id) {
		NoticeVO vo = new NoticeVO();
		vo.setClassID(id);
		vo.setStudentID(studentID);
		List<NoticeVO> list = noticeService.getAllPin(vo);
		
		if(list != null) 
			System.out.println("notice pin list가져오기 성공!");
		
		return list;
	}
	
	@RequestMapping(value = "/insertView", method = RequestMethod.POST)
	@ResponseBody
	public void updateView(@RequestParam(value="noticeID") int id) {
		NoticeVO vo = new NoticeVO();
		vo.setId(id);
		vo.setStudentID(studentID);
		if(noticeService.insertView(vo) != 0) {
			System.out.println("insert view 성공!");
			if(noticeService.updateViewCount(id) != 0)	//pass the noticeID
				System.out.println("viewCount업데이트 성공!");
		}
	}
	
	@RequestMapping(value = "/searchNotice", method = RequestMethod.POST)
	@ResponseBody
	public List<NoticeVO> searchNotice(@ModelAttribute NoticeVO vo) throws UnsupportedEncodingException {
		vo.setKeyword(URLDecoder.decode(vo.getKeyword(), "UTF-8"));
		vo.setStudentID(studentID);
		
		System.out.println("st kwd ==>"+vo.getKeyword());
		System.out.println("st classID ==>"+vo.getClassID());
		System.out.println("st id ==>"+  vo.getStudentID());
		
		List<NoticeVO> list = noticeService.searchNotice(vo);
		
		System.out.println(list.size());
		
		return list;
	}	
	
}
