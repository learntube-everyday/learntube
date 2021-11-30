package com.mycom.myapp.member;

import com.mycom.myapp.commons.MemberVO;

public interface MemberService {
	public int insertMember(MemberVO vo);
	public MemberVO getMember(MemberVO vo);
	public int updateName(MemberVO vo);
	public int deleteMember(MemberVO vo);
}
