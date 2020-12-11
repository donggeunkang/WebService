<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="file.FileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID=(String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('please login')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		else{
			System.out.println(bbs.getBbsTitle());
			System.out.println(bbs.getBbsContent());
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('fill the blank.')");
					script.println("history.back()");
					script.println("</script>");
				}
			else{
				BbsDAO BbsDAO = new BbsDAO();
				int result = BbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbs.getFileName(), bbs.getFileRealName());	
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패 하였습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					PrintWriter script = response.getWriter();
					
					String directory = application.getRealPath("/upload");
					int maxSize = 1024 * 1024 * 100;
					String encoding = "UTF-8";
					MultipartRequest multipartRequest= 
							new MultipartRequest(request, directory, maxSize, encoding,
									new DefaultFileRenamePolicy());
					bbs.setBbsTitle(multipartRequest.getParameter("title"));
					bbs.setBbsContent(multipartRequest.getParameter("Content"));
					String fileName = multipartRequest.getOriginalFileName("file");
					String fileRealName = multipartRequest.getFilesystemName("file");
					new FileDAO().upload(fileName, fileRealName);
					
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
				}
				
		}
		
	%>
</body>
</html>