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
		System.out.println("???????????? ???????????? ????????? ??????! " + takes.getStudentID());
		
		if(takesService.insertStudent(takes) == 1) {
			System.out.println("?????? ?????? ?????? ??????~!");
			model.addAttribute("enroll", 1); // 
		}
		else {
			System.out.println("?????? ?????? ?????? ??????");
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
		
		if(request == null) request = 0; // request??? null??? ????????? ?????? ???????????? ?????????. 		
		
		String url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + clientID + "&"
							+ "redirect_uri=" + redirectURL + "&response_type=code&scope=email%20profile%20openid&access_type=offline";
		return "redirect:" + url;
	}
	
	@RequestMapping(value = "/login/oauth2callback", method = RequestMethod.GET)
	public String googleAuth(Model model, @RequestParam(value = "code") String authCode, HttpServletRequest request,
		HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
		
		// HTTP Request??? ?????? RestTemplate
		RestTemplate restTemplate = new RestTemplate();
	
		// Google OAuth Access Token ????????? ?????? ???????????? ??????
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId(clientID);
		googleOAuthRequestParam.setClientSecret(clientSecret);
		googleOAuthRequestParam.setCode(authCode);
		googleOAuthRequestParam.setRedirectUri(redirectURL);
		googleOAuthRequestParam.setGrantType("authorization_code");
	
		// JSON ????????? ?????? ????????? ??????
		// ????????? ??????????????? ???????????? ???????????? ??????????????? Object mapper??? ?????? ???????????????.
		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.setSerializationInclusion(Include.NON_NULL);
	
		// AccessToken ?????? ??????
		ResponseEntity<String> resultEntity = restTemplate.postForEntity(GOOGLE_TOKEN_BASE_URL, googleOAuthRequestParam,
				String.class);
	
		// Token Request
		GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
		});
	
		// ID Token??? ?????? (???????????? ????????? jwt??? ????????? ????????????)
		String jwtToken = result.getIdToken();
		String requestUrl = UriComponentsBuilder.fromHttpUrl("https://oauth2.googleapis.com/tokeninfo")
				.queryParam("id_token", jwtToken).toUriString();
	
		String resultJson = restTemplate.getForObject(requestUrl, String.class);
	
		Map<String, String> userInfo = mapper.readValue(resultJson, new TypeReference<Map<String, String>>() {
		});
		model.addAllAttributes(userInfo);
		model.addAttribute("token", result.getAccessToken()); //token ??????
        
		String email = userInfo.get("email");
		String name = userInfo.get("family_name") + userInfo.get("given_name");
		
		MemberVO checkvo = new MemberVO();
		MemberVO loginvo = new MemberVO();	//?????? ???????????? ?????? ?????? ??????
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
				System.out.println("???????????? ??????:)");
			else {
				System.out.println("???????????? ??????:(");
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
					System.out.println("?????? ?????? ?????? ??????");
					model.addAttribute("enroll", 1);
				}
				else System.out.println("?????? ?????? ?????? ??????");
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
		
		int flag=0; // ?????? ???????????? ????????? ?????? ?????????  
		loginVO = (MemberVO)session.getAttribute("login");
		if(loginVO != null) {
			System.out.println("???????????? ????????? ?????? => " + loginVO.getId());
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
		if(loginVO.getMode().equals("lms_teacher")) { // result ????????? ????????? ?????????. 
			loginVO.setInstructorID(loginVO.getId());
			List<ClassesVO> classes = classesService.getAllMyClass(loginVO.getInstructorID());
			for(ClassesVO oneClass : classes) {
				if(oneClass.getId() == classInfo.getId()) return 1; 
			}
		}
		if(result == null) return 0;
		else return 1;
	}
	
	@RequestMapping(value = "/login/revoketoken") //?????? ?????????
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
