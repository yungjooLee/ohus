package kr.member.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.controller.Action;
import kr.order.dao.OrderDAO;
import kr.order.vo.OrderVO;
import kr.util.PageUtil;

public class AdminPageOrderAction implements Action{

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		Integer user_num = (Integer)session.getAttribute("user_num");
		if(user_num==null) {
			return "redirect:/member/loginForm.do";
		}
		
		Integer user_auth = (Integer)session.getAttribute("user_auth");
		if(user_auth < 9) {
			return "/WEB-INF/views/common/notice.jsp";
		}
		
		// 관리자로 접속한 경우
		String pageNum = request.getParameter("pageNum");
		if(pageNum==null) pageNum = "1";
		
		String keyfield = request.getParameter("keyfield");
		String keyword = request.getParameter("keyword");
		
		OrderDAO dao = OrderDAO.getInstance();
		int count = dao.getOrderCount(keyfield, keyword);
		
		//페이지 처리
		PageUtil page = new PageUtil(keyfield,keyword,Integer.parseInt(pageNum), count,20,10,"adminPageOrder.do");
		
		List<OrderVO> list = null;
		if(count > 0) {
			list = dao.getListOrder(page.getStartRow(),page.getEndRow(),keyfield,keyword);
		}
		request.setAttribute("page", page.getPage());
		request.setAttribute("count", count);
		request.setAttribute("list", list);
		
		
		return "/WEB-INF/views/member/adminPageOrder.jsp";
	}

}
