package com.mycom.myapp.attendance;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mycom.myapp.attendanceCheck.AttendanceCheckService;
import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/attendance")
public class AttendanceController {
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private ClassContentService classInsContentService;
	
	@Autowired
	private Stu_ClassContentService classContentService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private AttendanceService attendanceService;
	
	@Autowired
	private AttendanceCheckService attendanceCheckService;
	
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInCheckService;
	
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	
	
	private int instructorID = 0;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)	//접근권한 추가하기!!!
	public String attendancehome(@PathVariable("classId") int classId, Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		
		ClassesVO vo = new ClassesVO();
		vo.setId(classId);
		vo.setInstructorID(instructorID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		if(classService.checkAccessClass(vo) == 0) {
			System.out.println("접근권한 없음!");
			return "accessDenied";
		}
		
		classID = classId;
		
		List<Stu_TakesVO> studentTakes = stu_takesService.getStudentTakes(classID);
		model.addAttribute("takes", JSONArray.fromObject(studentTakes));	
		model.addAttribute("takesNum", studentTakes.size());
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("classDays", JSONArray.fromObject(classService.getClass(classID).getDays()));
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //여기 수정 
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		
		// 학생 정보 (jw)
		model.addAttribute("studentInfo", stu_takesService.getStudentInfo(classId));
		
		// attendance csv (hy)
		List<AttendanceVO> id = attendanceService.getAttendanceList(classID); //해당 classID를 가진 attribute의 개수 (해당 수업에서 업로드된 파일의 개수) 
		//List<Stu_TakesVO> takes = stu_takesService.getStudentNum(classID); //해당 classID를 가진 수업을 수강하는 학생 수 
		List<List<String>> file = new ArrayList<List<String>>();
		List<String> fileList = new ArrayList<String>();
		
		AttendanceCheckVO avo = new AttendanceCheckVO();
		for(int i=0; i<id.size(); i++) { 
			
			int attendanceID = id.get(i).getId(); // 7, 8, 9, 10
			avo.setAttendanceID(attendanceID);
			if(attendanceService.getAttendance(attendanceID).getFileName() == null) 
				continue; 
			List<AttendanceCheckVO> takes = attendanceCheckService.getAttendanceCheckList(attendanceID); 
				for(int j=0; j<takes.size(); j++) { 
						//takes.size()로하면 에러가 나는 이유, 1차시에는 3명에 대한 출석을 업데이트했는데 그 이후에 학생한명이 더 들어온다 -> 4명
						//그럼 indexOutOfBoundsException이 발생한다.
						//attendanceCheck에서 id가 같은 것들 가져오기 
					//takeService.getStudentTakes(classID).get(j).getStudentID() -> 이 sutentID와 attendanceCheck
					avo.setStudentID(stu_takesService.getStudentTakes(classID).get(j).getStudentID());
					if(attendanceCheckService.getAttendanceCheck(avo) != null && !attendanceCheckService.getAttendanceCheck(avo).getExternal().equals("") ) {
						System.out.println("studentID : " + stu_takesService.getStudentTakes(classID).get(j).getStudentID());
						fileList.add(attendanceCheckService.getAttendanceCheckList(attendanceID).get(j).getExternal());
						file.add(fileList);
					//가져올 때 student table과 join해서 학생 이름순으로 가져올 수 있도록 하기 
					}
					else {
						fileList.add("");
					}
				}
		}
		model.addAttribute("file", file);
		
		if(file.size() == 0)
			model.addAttribute("fileNum",file.size());
		else
			model.addAttribute("fileNum", attendanceCheckService.getAttendanceCheckListCount(classID));
		return "class/attendance";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {	
		
		return stu_takesService.getStudentTakes(Integer.parseInt(request.getParameter("classID")));
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forDays", method = RequestMethod.POST)
	public List<List<String>> forDays(HttpServletRequest request, Model model) throws Exception { //출결 보여주기 위함 
		ClassContentVO ccvo = new ClassContentVO ();
		AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
		List<Stu_TakesVO> takes = stu_takesService.getStudentTakes(classID);  //classID
		List<List<String>> stuAttend = new ArrayList<List<String>>();
		int dayNum = classInsContentService.getClassDaysNum(classID);
		
		ccvo.setClassID(classID);
		aivo.setClassID(classID);
		
		for(int i=0; i<stu_takesService.getStudentNum(classID); i++) {
			List<String> stuOne = new ArrayList<String>();
			
			for(int j=0; j<dayNum; j++) { //차시의 개수 

				ccvo.setDays(j);
				
				int studentID = takes.get(i).getStudentID();
				//System.out.println("aivo에 들어가는 건데 " + classID + ", studnetID :" +studentID+ " days : " +j);
				aivo.setStudentID(studentID);
				aivo.setDays(j);
				if(classContentService.getDaySeq(ccvo) == 0) { //차시 내 수업이 없을 때 
					break;
				}
				
				else if(classContentService.getDaySeq(ccvo) == attendanceInCheckService.getAttendanceInCheckExistedNum(aivo)) {
					//차시 내 수업의 개수와, 학생이 시청한 수업의 개수가 같은 경우 	
					for(int k=0; k<classContentService.getDaySeq(ccvo); k++) {
						
						if(attendanceInCheckService.getAttendanceInCheckExisted(aivo).get(k).getInternal().equals("결석")) {		
							stuOne.add("결석");
							break;
						}
						else if(attendanceInCheckService.getAttendanceInCheckExisted(aivo).get(k).getInternal().equals("지각")) {
							if(k == classContentService.getDaySeq(ccvo)-1)
								stuOne.add("지각");
							continue;
						}
						else if(attendanceInCheckService.getAttendanceInCheckExisted(aivo).get(k).getInternal().equals("출석")) {
							if(k == classContentService.getDaySeq(ccvo)-1)
								stuOne.add("출석");
							continue;
						}
						else {
							//미확인
							if(k == classContentService.getDaySeq(ccvo)-1)
								stuOne.add("미확인");
							continue;
						}
							
					}
	
					//이때 무조건 출석이 아니라, db에 있는 값들을 가져와야지,, 
				}
				else {
					//차시 내 수업의 개수와, 학생이 시청한 수업의 개수가 다른 경우 
					//classContent테이블의 마감 시간과, 현재시간 
					//마감시간 > 현재시간 : 미확인
					//마감시간 < 현재시간 : 결석
					//마감시간이 하나라도 지난 것이 있으면 결석처리,, 
					Date now = new Date();
					
					for(int k=0; k<classContentService.getDaySeq(ccvo); k++) {
						if(classInsContentService.getEndDate(ccvo).get(k) == null) { //마감기한이 설정되어있지 않는 경우 
							//System.out.println("1번 미확인 ");
							stuOne.add("미확인");
							break;
						}
						
						String endString = classInsContentService.getEndDate(ccvo).get(k).getEndDate();
						endString =  endString.replace("T", " "); 
						Date endDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(endString);
						
						int result = endDate.compareTo(now); 
						
						if(result != 0 && result != 1) {
							stuOne.add("결석");
							break;
						}
						else {
							if(k == classInsContentService.getEndDate(ccvo).size()-1) {
								stuOne.add("미확인");
							}
							continue;
						}
					}
				}
				
				
			}
			stuAttend.add(stuOne);
		}
		
			
		return stuAttend;
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forWatchedCount", method = RequestMethod.POST)
	public List<List<Integer>> forWatchedCount(HttpServletRequest request, Model model) throws Exception { //수강 퍼센트 
	    List<List<Integer>> stuWatched = new ArrayList<List<Integer>>();
	    
	    int dayNum = classInsContentService.getClassDaysNum(classID);
	    List<Stu_TakesVO> takes = stu_takesService.getStudentTakes(classID);  //classID
	    ClassContentVO ccvo = new ClassContentVO ();
	    Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
	    
	    ccvo.setClassID(classID);
	    pcvo.setClassID(classID);
	    
	    for(int i=0; i<takes.size(); i++) {
	    	List<Integer> stuOne = new ArrayList<Integer>();
	    	int studentID = takes.get(i).getStudentID();
	    	
	    	for(int j=0; j<dayNum; j++) {
				ccvo.setDays(j);
				pcvo.setStudentID(studentID);
				pcvo.setDays(j);
				 
				if(classContentService.getDaySeq(ccvo) == 0)
					stuOne.add(-1);
				else {
					stuOne.add(playlistcheckService.getCompletePlaylistWithDays(pcvo).size() / classContentService.getDaySeq(ccvo) * 100);
				}
		    }
	    	
	    	stuWatched.add(stuOne);
	    }
	    
		
	    return stuWatched;
	}

	@ResponseBody
	@RequestMapping(value = "/uploadCSV", method = RequestMethod.POST)
	public List<List<String>> uploadCSV(MultipartHttpServletRequest request, Model model) throws Exception {
		//업로드된 파일에서 리스트 뽑은거랑, takes테이블에서 학생이름 가져오기
		//데이터는 함수를 또 만들어서 넘겨주기 
		
		MultipartFile file = request.getFile("file");
		
		int start_h = Integer.parseInt(request.getParameter("start_h"));
		int start_m = Integer.parseInt(request.getParameter("start_m"));
		int end_h = Integer.parseInt(request.getParameter("end_h"));
		int end_m = Integer.parseInt(request.getParameter("end_m"));
		int days = Integer.parseInt(request.getParameter("daySeq"));
		//start_h ~ seq모두 jsp파일에서 받아오기 --> done!done!
		
		UUID uuid = UUID.randomUUID();
		String saveName = uuid + "_" + file.getOriginalFilename();

		List<List<String>> csvList = new ArrayList<List<String>>();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/csv/"); //이런식으로 경로지정을 하는건지 ?? 
		System.out.println("realPath : " + realPath); 
		File saveFile = new File(realPath, saveName);
		
		try{
			file.transferTo(saveFile);
		}
		catch(IOException e) {
			e.printStackTrace();
			return null;
		}
		
		
		//db(Attendace테이블)에 insert하기
		AttendanceVO avo = new AttendanceVO();
		avo.setClassID(classID);
		avo.setDays(days);
		avo.setFileName(saveName);
		if(attendanceService.getAttendanceID(avo) != null) { //이미 해당 날짜에 대한 파일이 업로드되어있으면 업데이트 
			System.out.println("already updated!");
			attendanceService.updateAttendance(avo);
		}
		else {
			if(attendanceService.insertAttendance(avo) != 0) { //없으면 insert 
				System.out.println("attendance insert성공!");
			}
			else {
				System.out.println("attendance insert실패!");
			}
		}
		
		List<Integer> csvStartH = new ArrayList<Integer>();
		List<Integer> csvStartM = new ArrayList<Integer>();
		List<Integer> csvEndH = new ArrayList<Integer>();
		List<Integer> csvEndM = new ArrayList<Integer>();
		List<List<String>> finalTakes = new ArrayList<List<String>>();
		 
		File dir = new File(realPath);
		if(!dir.exists()) dir.mkdirs();
		try {
			String line;
			BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), "UTF-8"));
			//int idx = 0;
			while((line=br.readLine()) != null) { 
				List<String> aLine = new ArrayList<String>();
                String[] lineArr = line.split(","); 
                aLine = Arrays.asList(lineArr);
                csvList.add(aLine);
                //idx++;
			}
			
            List<Stu_TakesVO> data = stu_takesService.getStudentTakes(classID); //db에서 학생정보 가져오기 classID임의로 넣음 
            List<String> stuNameArr = new ArrayList<String>();
            for(int i=0; i<data.size(); i++) {
            	stuNameArr.add(data.get(i).getName()); //이 수업을 듣는 학생들의 목록을 조회 (db의 takes 테이블로부터) 
            }
            

    		List<String> attendStu = new ArrayList<String>();
    		List<String> absentStu = new ArrayList<String>();
    		List<String> annonyStu = new ArrayList<String>();
            
    		//int stuNum = 0;
            for(int i=4; i<csvList.size(); i++) {
    			for(int j=0; j<stuNameArr.size(); j++) {
    				if(csvList.get(i).get(0).contains(stuNameArr.get(j)) ) { //csv파일 내에 이름이 있는 학생의 경우와
    					//결석보다는 출석한 학생이 많으므로 우선 출석으로 넣어두고
    					attendStu.add(stuNameArr.get(j));
    					
    					csvStartH.add( Integer.parseInt(csvList.get(i).get(2).charAt(11) + "" + csvList.get(i).get(2).charAt(12)));
                    	csvEndH.add( Integer.parseInt(csvList.get(i).get(3).charAt(11) + "" + csvList.get(i).get(3).charAt(12)));
                    	
                    	csvStartM.add( Integer.parseInt(csvList.get(i).get(2).charAt(14) + "" + csvList.get(i).get(2).charAt(15)));
                    	csvEndM.add( Integer.parseInt(csvList.get(i).get(3).charAt(14) + "" + csvList.get(i).get(3).charAt(15)));
                    	
    					//stuNum++;
    				}
    				else { // 미확인 학생들 
    					continue;
    				}
    	
    			}
    		}
            //분으로 환산해서 하기
            int count = 0;
            for(int i=0; i<attendStu.size(); i++) {
            	if(start_h > csvStartH.get(i) ) {
            		if(end_h < csvEndH.get(i)) {
            			continue;
        				//출석 
        			}
            		
            		else if(end_h == csvEndH.get(i)){ 
            			if(end_m <= csvEndM.get(i)) {
            				continue;
            				// 출석 
        				}
            			else {
            				//결석 
            				//출석에서 빼고 결석에 넣기
            				// i번째의 학생이 attendStu의 list에서는 몇번재인지.,
            				absentStu.add(attendStu.get(i));
            				attendStu.remove(i);
            				
            			}
            		}
            		
            		else {
    					//결석 
            			//출석에서 빼고 결석에 넣기 
            			absentStu.add(attendStu.get(i));
            			attendStu.remove(i);
    				}
            	}
            	else if(start_h == csvStartH.get(i)) {
            		if(start_m >= csvStartM.get(i)) {
            			if(end_h < csvEndH.get(i)) {
            				continue;
            				//출석 
            			}
                		
                		else if(end_h == csvEndH.get(i)){ 
                			if(end_m <= csvEndM.get(i)) {
                				continue;
                				// 출석 
            				}
                			else {
                				//결석 
                    			//출석에서 빼고 결석에 넣기 
                				absentStu.add(attendStu.get(i));
                				attendStu.remove(count);
                			}
                		}
                		
                		else {
                			//결석 
                			//출석에서 빼고 결석에 넣기 
                			absentStu.add(attendStu.get(i));
                			attendStu.remove(i);
            				//absentStu.add(attendStu.get(i));
                		}
            		}
            		
            		else {
            			//결석 
            			//출석에서 빼고 결석에 넣기 
            			absentStu.add(attendStu.get(i));
            			attendStu.remove(i);
            		}
            		
            	}
            	else {
            		//결석 
        			//출석에서 빼고 결석에 넣기 
            		absentStu.add(attendStu.get(i));
            		attendStu.remove(i);
    				//absentStu.add(attendStu.get(i));
            	}
            	
            	count++;
            }
            
            for(int i=0; i<stuNameArr.size(); i++) {
            	if(!attendStu.contains(stuNameArr.get(i)) && !absentStu.contains(stuNameArr.get(i)))
            		annonyStu.add(stuNameArr.get(i));
            	else
            		continue;
            }
            finalTakes.add(attendStu);
            finalTakes.add(absentStu);
            finalTakes.add(annonyStu);
            
			br.close();
			
			file.transferTo(new File(realPath, file.getOriginalFilename()));
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return finalTakes;
	}

	@RequestMapping(value = "/entryCode", method = RequestMethod.GET)
	public String entry(Model model) {

		return "entryCode";
	}
	
	@ResponseBody
	@RequestMapping(value = "/whichAttendance", method = RequestMethod.POST)
	public int whichAttendance(HttpServletRequest request, @RequestParam(value="finalTakes[]")String[] finalTakes, @RequestParam(value="finalInternalTakes[]")String[] finalInternalTakes)  {
		int attendanceID = Integer.parseInt(request.getParameter("attendanceID"));
		int days = Integer.parseInt(request.getParameter("days"));
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID);
		ccvo.setDays(days);

		List<Stu_TakesVO> takes = stu_takesService.getStudentTakes(classID);  //classID
		
		for(int i=0; i<finalInternalTakes.length; i++) { //internal에 대해서 
			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setStudentID(takes.get(i).getStudentID());
			aivo.setClassID(classID);
			aivo.setDays(days);
			
			for(int j=0; j<classContentService.getDaySeq(ccvo); j++) {
				aivo.setClassContentID(classInsContentService.getClassContentID(ccvo).get(j).getId());
				aivo.setInternal(finalInternalTakes[i]);
				
				if(attendanceInCheckService.getAttendanceInCheckByIDExisted(aivo) == null) {
					attendanceInCheckService.insertAttendanceInCheck(aivo);
					System.out.println("선생님이 inner 삽입  ");
				}
				else {
					attendanceInCheckService.updateAttendanceInCheck(aivo);
					System.out.println("선생님이 inner 수정  ");
				}
			}
		}
		
		for(int i=0; i<finalTakes.length; i++) {//external에 대해서 
			AttendanceCheckVO avo = new AttendanceCheckVO();
			avo.setAttendanceID(attendanceID);
			avo.setExternal(finalTakes[i]);
			avo.setStudentID(takes.get(i).getStudentID()); //takes테이블에서 바로가져오도록 하면 될듯 
			
			
			if(attendanceCheckService.getAttendanceCheck(avo) != null) {
				attendanceCheckService.updateExAttendanceCheck(avo);
			}
			else {
				System.out.println("insert!");
				attendanceCheckService.insertExAttendanceCheck(avo);
				
			}
		}
		
		
		return 1;
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/forAttendance", method = RequestMethod.POST)
	public int forAttendance(HttpServletRequest request)  {
		//int classID = Integer.parseInt(request.getParameter("classID"));
		int days = Integer.parseInt(request.getParameter("days"));
		AttendanceVO avo = new AttendanceVO();
		avo.setClassID(classID);
		avo.setDays(days);
		
		if(attendanceService.getAttendanceID(avo) != null)
			return attendanceService.getAttendanceID(avo).getId();
		else {
			return attendanceService.insertAttendanceNoFile(avo); //insert를 해서 그에 대한 Id를 가져와보기 (파일 업로드없이 출결사항을 업데이트) 
		}
		
		
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/getfileName", method = RequestMethod.POST)
	public List<AttendanceVO> getfileName(HttpServletRequest request)  {
		return attendanceService.getAttendanceFileName(classID); //classID
		
	}
	
} 