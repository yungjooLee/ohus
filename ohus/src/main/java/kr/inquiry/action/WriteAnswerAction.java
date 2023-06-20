package kr.inquiry.action;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;

import kr.controller.Action;
import kr.inquiry.dao.InquiryDAO;
import kr.inquiry.vo.InquiryAnswerVO;

public class WriteAnswerAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String> mapAjax = new HashMap<String, String>();
		
		//로그인 여부 체크
		HttpSession session = request.getSession();
		Integer user_num = (Integer)session.getAttribute("user_num");
		if(user_num == null) { //로그인 되지 않은 경우
			mapAjax.put("result", "logout");
		} else {
			/*
			 * Integer user_auth = (Integer)session.getAttribute("user_auth"); if(user_auth
			 * < 9) { //관리자가 아닌 경우 return "/WEB-INF/views/common/notice.jsp"; //잘못된 접근입니다
			 * 메시지 표시 }
			 */
						
			//관리자로 로그인 된 경우
			//전송된 데이터 인코딩 처리
			request.setCharacterEncoding("utf-8");
			
			InquiryAnswerVO answer = new InquiryAnswerVO();
			answer.setMem_num(user_num); //댓글 작성한 관리자 회원번호
			answer.setAns_content(request.getParameter("ans_content"));
			answer.setInq_num(Integer.parseInt(request.getParameter("inq_num")));
			
			InquiryDAO dao = InquiryDAO.getInstance();
			dao.insertAnswer(answer);
			
			mapAjax.put("result", "success");
		}
		
		//JSON 데이터 생성
		ObjectMapper mapper = new ObjectMapper();
		String ajaxData = mapper.writeValueAsString(mapAjax);
		
		request.setAttribute("ajaxData", ajaxData);
		
		//JSP 경로 반환
		return "/WEB-INF/views/common/ajax_view.jsp";
	}

}
