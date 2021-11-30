package com.mycom.myapp.login;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.social.connect.Connection;
import org.springframework.social.google.api.Google;
import org.springframework.social.google.api.impl.GoogleTemplate;
import org.springframework.social.google.api.plus.Person;
import org.springframework.social.google.api.plus.PlusOperations;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.mycom.myapp.classes.ClassesServiceImpl;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.member.MemberServiceImpl;
import com.mycom.myapp.student.takes.Stu_TakesServiceImpl;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Controller
@PropertySource("classpath:config.properties")
public class LoginController {
	
	final static String GOOGLE_AUTH_BASE_URL = "https://accounts.google.com/o/oauth2/v2/auth";
	final static String GOOGLE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/token";
	final static String GOOGLE_REVOKE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/revoke";
	
	@Autowired
	private MemberServiceImpl memberService;
	
	@Autowired
	private ClassesServiceImpl classesService;
	
	@Autowired
	private Stu_TakesServiceImpl takesService;
	
	@Value("${oauth.clientID}")
	private String clientID;
	@Value("${oauth.clientSecret}")
	private String clientSecret;
	
	private String loginMode = "";
	private String redirectURL = "https://learntube.kr/login/oauth2callback";
	// http://localhost:8080/myapp/login/oauth2callback // https://learntube.kr/login/oauth2callback
	
	private String entryCode = null;
	private ClassesVO classInfo;
	private Stu_TakesVO takes;
	public MemberVO loginVO;
	
	
	@RequestMapping(value="/enroll" , method = RequestMethod.GET)
	public String enroll(Model model) {
		//takes.setStudentID(loginvo.getId());
		takes.setClassName(classInfo.getClassName()); 
		takes.setStatus("pending");
		System.out.println("로그인된 상태에서 강의실 신청! " + takes.getStudentID());
		
		if(takesService.insertStudent(takes) == 1) {
			System.out.println("학생 등록 요청 완료~!");
			model.addAttribute("enroll", 1); // 
		}
		else {
			System.out.println("학생 등록 요청 실패");
		}
		
		return "redirect:/student/class/dashboard";
	}	
	
	@RequestMapping(value = "/login/signin", method = RequestMethod.GET)
	public String login() {
		return "intro/signin";
	}
	
	@RequestMapping(value = "/login/google", method = RequestMethod.POST)
	public String google(@RequestParam(value = "mode") String mode, @RequestParam(value="request", required=false)Integer request ) {
		System.out.println(mode);
		loginMode = mode;
		System.out.println(request);
		
		if(request == null) request = 0; // request가 null인 상태로 두면 에러나서 필요함. 		
		
		String url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + clientID + "&"
							+ "redirect_uri=" + redirectURL + "&response_type=code&scope=email%20profile%20openid&access_type=offline";
		return "redirect:" + url;
	}
	
	@RequestMapping(value = "/login/oauth2callback", method = RequestMethod.GET)
	public String googleAuth(Model model, @RequestParam(value = "code") String authCode, HttpServletRequest request,
		HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
		
		// HTTP Request를 위한 RestTemplate
		RestTemplate restTemplate = new RestTemplate();
	
		// Google OAuth Access Token 요청을 위한 파라미터 세팅
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId(clientID);
		googleOAuthRequestParam.setClientSecret(clientSecret);
		googleOAuthRequestParam.setCode(authCode);
		googleOAuthRequestParam.setRedirectUri(redirectURL);
		googleOAuthRequestParam.setGrantType("authorization_code");
	
		// JSON 파싱을 위한 기본값 세팅
		// 요청시 파라미터는 스네이크 케이스로 세팅되므로 Object mapper에 미리 설정해준다.
		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.setSerializationInclusion(Include.NON_NULL);
	
		// AccessToken 발급 요청
		ResponseEntity<String> resultEntity = restTemplate.postForEntity(GOOGLE_TOKEN_BASE_URL, googleOAuthRequestParam,
				String.class);
	
		// Token Request
		GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
		});
	
		// ID Token만 추출 (사용자의 정보는 jwt로 인코딩 되어있다)
		String jwtToken = result.getIdToken();
		String requestUrl = UriComponentsBuilder.fromHttpUrl("https://oauth2.googleapis.com/tokeninfo")
				.queryParam("id_token", jwtToken).toUriString();
	
		String resultJson = restTemplate.getForObject(requestUrl, String.class);
	
		Map<String, String> userInfo = mapper.readValue(resultJson, new TypeReference<Map<String, String>>() {
		});
		model.addAllAttributes(userInfo);
		model.addAttribute("token", result.getAccessToken()); //token 저장
        
		String email = userInfo.get("email");
		String name = userInfo.get("family_name") + userInfo.get("given_name");
		
		MemberVO checkvo = new MemberVO();
		MemberVO loginvo = new MemberVO();	//최종 로그인한 유저 정보 저장
		String returnURL = "";
		String mode = "";
		int userID = 0;
        
		if (session.getAttribute("login") != null) { 
			session.removeAttribute("login");
		}
		
		if(loginMode.equals("tea")) {
			mode = "lms_instructor";
			returnURL = "redirect:/dashboard";
		}
		else {
			mode = "lms_student";
			returnURL = "redirect:/student/class/dashboard"; // @RequestParam(required=false) Integer newlyEnrolled, 
		}
		checkvo.setMode(mode);
		checkvo.setEmail(email);
		
		loginvo = memberService.getMember(checkvo);
		if(loginvo == null) {
			loginvo = new MemberVO();
			loginvo.setName(name);
			loginvo.setEmail(email);
			loginvo.setMode(mode);
			userID = memberService.insertMember(loginvo);
			loginvo.setId(userID);
			if(userID > 0) 
				System.out.println("회원가입 성공:)");
			else {
				System.out.println("회원가입 실패:(");
				return "redirect:/login/signin";
			}
		}
		else {
			loginvo.setMode(mode);
		}
		
		session.setAttribute("userID", loginvo.getId());
		session.setAttribute("login", loginvo);
		
		//(jw)
		if(entryCode != null) {
			if(checkIfAlreadyEnrolled(loginvo, classInfo) == 0) {
				//takes.setStudentID(loginvo.getId());
				takes.setClassName(classInfo.getClassName());
				takes.setStatus("pending");
				if(takesService.insertStudent(takes) == 1) {
					System.out.println("학생 등록 요청 완료");
					model.addAttribute("enroll", 1);
				}
				else System.out.println("학생 등록 요청 실패");
			}
		}
		
		return returnURL;
	}
	
	@RequestMapping(value = "/invite/{entryCode}", method = RequestMethod.GET)
	public String entry(@PathVariable String entryCode, Model model, HttpSession session) { //@SessionAttribute("login") MemberVO loginVO) { //
		this.entryCode = entryCode;
		
		takes = new Stu_TakesVO();
		
		classInfo = classesService.getClassByEntryCode(entryCode);
		model.addAttribute("classInfo", classInfo);
		
		int flag=0; // 이미 등록되어 있는지 여부 확인용  
		loginVO = (MemberVO)session.getAttribute("login");
		if(loginVO != null) {
			System.out.println("로그인된 아이디 확인 => " + loginVO.getId());
			if(checkIfAlreadyEnrolled(loginVO, classInfo) == 0) {
				flag = 0;
			}
			else {
				flag = 1;
			}
		}
		model.addAttribute("login", loginVO);
		model.addAttribute("alreadyEnrolled", flag);

		return "intro/invite"; 
	}
	
	public int checkIfAlreadyEnrolled(MemberVO loginVO, ClassesVO classInfo) {
		System.out.println(classInfo.getId() + ": " + loginVO.getId());
		//Stu_TakesVO result = null;
		takes.setClassID(classInfo.getId());
		takes.setStudentID(loginVO.getId());
		System.out.println(takes.getClassID() + ": " + takes.getStudentID());
		Stu_TakesVO result  = takesService.checkIfAlreadyEnrolled(takes);
		if(loginVO.getMode().equals("lms_teacher")) { // result 결과는 학생만 확인함. 
			loginVO.setInstructorID(loginVO.getId());
			List<ClassesVO> classes = classesService.getAllMyClass(loginVO.getInstructorID());
			for(ClassesVO oneClass : classes) {
				if(oneClass.getId() == classInfo.getId()) return 1; 
			}
		}
		if(result == null) return 0;
		else return 1;
	}
	
	@RequestMapping(value = "/login/revoketoken") //토큰 무효화
	public Map<String, String> revokeToken(@RequestParam(value = "token") String token) throws JsonProcessingException {

		Map<String, String> result = new HashMap<>();
		RestTemplate restTemplate = new RestTemplate();
		final String requestUrl = UriComponentsBuilder.fromHttpUrl(GOOGLE_REVOKE_TOKEN_BASE_URL)
				.queryParam("token", token).encode().toUriString();
		
		String resultJson = restTemplate.postForObject(requestUrl, null, String.class);
		result.put("result", "success");
		result.put("resultJson", resultJson);
		return result;
	}
	
	@RequestMapping(value = "/login/signout")
	public String logout(HttpSession session) {
		session.removeAttribute("login");
		session.invalidate();
		System.out.println("logged out!");
		return "redirect:/login/signin";
	}
}
