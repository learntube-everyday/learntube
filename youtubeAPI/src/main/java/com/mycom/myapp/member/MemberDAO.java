package com.mycom.myapp.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.MemberVO;

@Repository
public class MemberDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertMember(MemberVO vo) {
		if(sqlSession.insert("Member.insertMember", vo) >= 0)
			return vo.getId();
		return -1;
	}
		
	public MemberVO getMember(MemberVO vo) {
		return sqlSession.selectOne("Member.getMember", vo);
	}
	
	public int updateName(MemberVO vo) {
		return sqlSession.update("Member.updateName", vo);
	}
	
	public int deleteMember(MemberVO vo) {
		return sqlSession.delete("Member.deleteMember", vo);
	}
}
