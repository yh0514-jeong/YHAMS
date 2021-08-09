<%@ include file="../../include/include-header.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title><spring:message code="com.yhmas"/></title> <!-- YHAMS 자산관리시스템 -->
    </head>
    <script type="text/javascript">

    	function goLogin(){
    		document.loginForm.submit();
    	}
    
    
    </script>
    <body class="bg-primary" onkeypress="if(event.keyCode == 13){ goLogin(); return; }">
        <div id="layoutAuthentication">
            <div id="layoutAuthentication_content">
                <main>
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-5">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header" align="center"><img src="/img/logo.png" width="70%"></div>
                                    <div class="card-body">
                                        <form id="loginForm" name="loginForm" action="/loginCheck" method="post">
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_ID" name="USER_ID" type="text" placeholder="<spring:message code="com.txt.id"/>"/>
                                                <label for="user_id"><spring:message code="com.txt.id"/></label> <!-- ID -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_PW" name="USER_PW" type="password" placeholder="<spring:message code="com.txt.password"/>" />
                                                <label for="user_pw"><spring:message code="com.txt.password"/></label><!-- Password -->
                                            </div>
                                            <div class="form-check mb-3">
                                                <input class="form-check-input" id="inputRememberPassword" type="checkbox" value="" />
                                                <label class="form-check-label" for="inputRememberPassword"><spring:message code="login.id.remember"/></label><!-- 아이디 기억하기 -->
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                                                <a class="small" href="password.html"><spring:message code="login.password.find"/></a>
                                                <a class="btn btn-primary" onclick="javscript:goLogin();"><spring:message code="com.txt.login"/></a><!-- 로그인 -->
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer text-center py-3">
                                        <div class="small"><a href="/signUp"><spring:message code="com.txt.signup"/></a></div><!-- 회원가입 -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
