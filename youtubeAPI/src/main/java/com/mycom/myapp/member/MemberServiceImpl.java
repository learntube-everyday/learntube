package com.mycom.myapp.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.MemberVO;

@Service
public class MemberServiceImpl implements MemberService{
	@Autowired
	MemberDAO memberDAO;
	
	@Override
	public int insertMember(MemberVO vo){
		return memberDAO.insertMember(vo);
	}
	
	@Override
	public MemberVO getMember(MemberVO vo) {
		return memberDAO.getMember(vo);
	}
	
	@Override
	public int updateName(MemberVO vo) {
		return memberDAO.updateName(vo);
	}
	
	@Override
	public int deleteMember(MemberVO vo) {
		return memberDAO.deleteMember(vo);
	}
}
