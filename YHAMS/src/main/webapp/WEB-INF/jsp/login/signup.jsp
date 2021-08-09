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
    <title><spring:message code="com.yhmas"/></title>

<script type="text/javascript">

	$(document).ready(function(){
		$("#signUpSave").on("click", function(){
			goSave();
		});
	});
	
	
	function goSave(){
		
		if($("#user_id").val().trim().length == 0){
			alert('아이디는 필수 입력항목입니다.');
			$("#user_id").focus();
			return;
		}
		
		if($("#user_pw").val().trim().length == 0){
			alert('비밀번호는 필수 입력항목입니다.');
			$("#user_pw").focus();
			return;
		}
		
		if($("#user_nm").val().trim().length == 0){
			alert('이름은 필수 입력항목입니다.');
			$("#user_nm").focus();
			return;
		}
		
		if($("#user_nm_en").val().trim().length == 0){
			alert('영문이름은 필수 입력항목입니다.');
			$("#user_nm_en").focus();
			return;
		}
		
		if($("#user_nm_en").val().trim().length == 0){
			alert('영문이름은 필수 입력항목입니다.');
			$("#user_nm_en").focus();
			return;
		}
		
		var param = {
			'USER_ID'    : $("#user_id").val(),	
			'USER_PW'    : $("#user_pw").val(),	
			'USER_NM'    : $("#user_nm").val(),	
			'USER_NM_EN' : $("#user_nm_en").val(),	
			'USER_EMAIL' : $("#user_email").val(),
			'USER_ADRS'  : $("#user_adrs").val(),	
			'USER_PHONE' : $("#user_phone").val()	
		}
		
		$.ajax({
		    type : 'post',
		    url : '/signUpSave', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.resultcode == "success"){
		        	alert('등록 성공! 로그인 페이지로 이동합니다.');
		        	window.location.href = "/login";
		        }
		    },
		    error : function(request, status, error) { 
		        alert('등록 실패!!');
		    }
		});
		
	
	}

</script>
<link rel="stylesheet" href="/css/bootstrap.min.css">
</head>
<body class="bg-primary">
        <div id="layoutAuthentication">
            <div id="layoutAuthentication_content">
                <main>
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-7">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header" align="center"><img src="/img/logo.png" width="40%"></div>
                                    <div class="card-header"><h4 class="text-center font-weight-light my-4"><spring:message code="com.txt.signup"/></h4></div> <!--회원가입 -->
                                    <div class="card-body">
                                        <form id="signUpCategory">
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3 mb-md-0">
                                                        <input class="form-control" id="user_id" name="user_id" type="text" placeholder="<spring:message code="com.txt.id"/>" />
                                                        <label for="user_id"><spring:message code="com.txt.id"/></label><!--ID -->
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input class="form-control" id="user_pw" name="user_pw" type="password" placeholder="<spring:message code="com.txt.password"/>" />
                                                        <label for="user_pw"><spring:message code="com.txt.password"/></label><!-- Password -->
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input class="form-control" id="user_pw_cfrm" name="user_pw_cfrm" type="password" placeholder="<spring:message code="com.txt.password.confirm"/>" />
                                                        <label for="user_pw_cfrm"><spring:message code="com.txt.password.confirm"/></label><!-- 비밀번호 확인 -->
                                                    </div>
                                                </div>
                                            </div> 
                                            <div class="row mb-3">
                                            </div>    
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="user_nm" name="user_nm" type="text" placeholder="<spring:message code="com.txt.name"/>" />
                                                <label for="user_nm"><spring:message code="com.txt.name"/></label><!-- 이름 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="user_nm_en" name="user_nm_en" type="text" placeholder="<spring:message code="com.txt.name.en"/>" />
                                                <label for="user_nm_en"><spring:message code="com.txt.name.en"/></label><!-- 영문이름 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="user_email" name="user_email"  type="email" placeholder="<spring:message code="com.txt.email"/>" />
                                                <label for="user_email"><spring:message code="com.txt.email"/></label><!-- 이메일 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="user_adrs" type="text" placeholder="<spring:message code="com.txt.address"/>" />
                                                <label for="user_adrs"><spring:message code="com.txt.address"/></label><!-- 주소 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="user_phone" type="text" placeholder="<spring:message code="com.txt.phone"/>" />
                                                <label for="user_adrs"><spring:message code="com.txt.phone"/></label><!-- 전화번호 -->
                                            </div>
                                            <div id="signUpSave" class="mt-4 mb-0">
                                                <div class="d-grid"><a class="btn btn-primary btn-block"><spring:message code="com.txt.finish"/></a></div><!-- 완료 -->
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer text-center py-3">
                                        <div class="small"><a href="/login"><spring:message code="login.page.redirect"/></a></div>
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
