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

    let dupChkYn = false;

	$(document).ready(function(){
		$("#signUpSave").on("click", function(){
			goSave();
		});
	});
	
	function goSave(){
		
		if($("#USER_ID").val().trim().length == 0){
			alert('<spring:message code="signup.chkId"/>');  // 아이디를 확인해주세요.
			$("#USER_ID").focus();
			return;
		}
		
		if(!dupChkYn){
			alert('<spring:message code="signup.chkIdDupChk"/>');  // 아이디 중복체크를 완료해주세요.
			return;
		}
		
		if($("#USER_PW").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserPw"/>');  // 비밀번호를 확인해주세요.
			$("#USER_PW").focus();
			return;
		}
		
		if($("#USER_PW_CFRM").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserPwCfrm"/>');  // 비밀번호 확인란에 비밀번호를 입력해주세요.
			$("#USER_PW_CFRM").focus();
			return;
		}
		
		if($("#USER_PW").val() != $("#USER_PW_CFRM").val()){
			alert('<spring:message code="signup.chkchkUserPwAndUserPwCfrmNotEqual"/>');  // 비밀번호와 비밀번호 확인란에 있는 값이 다릅니다. 다시 한 번 확인해주세요.
			$("#USER_PW_CFRM").focus();
			return;
		}
		
		if($("#USER_NM").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserNm"/>');  // 이름을 확인해주세요.
			$("#USER_NM").focus();
			return;
		}
		
		if($("#USER_NM_EN").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserNmEn"/>');  // 영문이름을 확인해주세요.
			$("#USER_NM_EN").focus();
			return;
		}
		
		if($("#USER_EMAIL").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserEmail"/>');  // 이메일을 확인해주세요.
			$("#USER_EMAIL").focus();
			return;
		}
		
		if($("#USER_ADRS").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserAdrs"/>');  // 주소를 확인해주세요.
			$("#USER_ADRS").focus();
			return;
		}
		
		if($("#USER_PHONE").val().trim().length == 0){
			alert('<spring:message code="signup.chkUserAdrs"/>');  // 전화번호를 확인해주세요.
			$("#USER_PHONE").focus();
			return;
		}
		
		var param = {
			'USER_ID'    : $("#USER_ID").val(),	
			'USER_PW'    : $("#USER_PW").val(),	
			'USER_NM'    : $("#USER_NM").val(),	
			'USER_NM_EN' : $("#USER_NM_EN").val(),	
			'USER_EMAIL' : $("#USER_EMAIL").val(),
			'USER_ADRS'  : $("#USER_ADRS").val(),	
			'USER_PHONE' : $("#USER_PHONE").val()	
		}
		
		$.ajax({
		    type : 'post',
		    url : '/signUpSave', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.resultcode == "success"){
		        	alert('<spring:message code="signup.successAndRedirectToLoginPage"/>'); // 등록 성공! 로그인 페이지로 이동합니다.
		        	window.location.href = "/login";
		        }else{
		        	alert('<spring:message code="signup.fail"/>');  // 회원가입 실패!
		        	return;
		        }
		    },
		    error : function(request, status, error) { 
		    	alert('<spring:message code="com.msg.askToManager"/>');  // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
	        	return;
		    }
		});
	}
	
	function idDupChk(){
		if($("#USER_ID").val().trim().length == 0){
			alert('<spring:message code="signup.chkId"/>');  // 아이디를 확인해주세요.
		}else{
			let param = {
			 	'USER_ID' : $("#USER_ID").val()	
			}
			$.ajax({
			    type : 'get',
			    url : '/idDupChk', 
			    dataType : 'json', 
			    data : param,
			    success : function(result) { 
			    	if(result.result == true){
			    		alert('<spring:message code="signup.isUsingId"/>');  // 이미 사용중인 아이디입니다.
			    		dupChkYn = false;
			    		return;
			    	}else{
			    		alert('<spring:message code="signup.isUsableId"/>');  // 사용 가능한 아이디입니다.
			    		dupChkYn = true;
			    		return;
			    	}
			    },
			    error : function(request, status, error) { 
			    	alert('<spring:message code="com.msg.askToManager"/>');  // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
		        	return;
			    }
			});
		}
	}
	
	function userIdChaged(){
		dupChkYn = false;
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
                                                	<div class="form-floating">
                                                        <input class="form-control" id="USER_ID" name="USER_ID" type="text" onchange="userIdChaged();" placeholder="<spring:message code="com.txt.id"/>"/>
                                                        <label for="USER_ID"><spring:message code="com.txt.id"/></label><!--ID -->
                                                     </div>
                                                </div>
                                                <div class="col-md-6">
                                                   	<div class="form-floating">
                                                     	<button id="btnIdDupChk" onclick="javascript:idDupChk();" type="button" class="btn btn-primary"><spring:message code="signup.idDupChk"/></button> <!-- 아이디 중복검사 --> 
                                                   	</div> 
                                                 </div>
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input class="form-control" id="USER_PW" name="USER_PW" type="password" placeholder="<spring:message code="com.txt.password"/>" />
                                                        <label for="USER_PW"><spring:message code="com.txt.password"/></label><!-- Password -->
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input class="form-control" id="USER_PW_CFRM" name="USER_PW_CFRM" type="password" placeholder="<spring:message code="com.txt.password.confirm"/>" />
                                                        <label for="USER_PW_CFRM"><spring:message code="com.txt.password.confirm"/></label><!-- 비밀번호 확인 -->
                                                    </div>
                                                </div>
                                            </div> 
                                            <div class="row mb-3">
                                            </div>    
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_NM" name="USER_NM" type="text" placeholder="<spring:message code="com.txt.name"/>" />
                                                <label for="USER_NM"><spring:message code="com.txt.name"/></label><!-- 이름 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_NM_EN" name="USER_NM_EN" type="text" placeholder="<spring:message code="com.txt.name.en"/>" />
                                                <label for="USER_NM_EN"><spring:message code="com.txt.name.en"/></label><!-- 영문이름 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_EMAIL" name="USER_EMAIL"  type="email" placeholder="<spring:message code="com.txt.email"/>" />
                                                <label for="USER_EMAIL"><spring:message code="com.txt.email"/></label><!-- 이메일 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_ADRS" type="text" placeholder="<spring:message code="com.txt.address"/>" />
                                                <label for="USER_ADRS"><spring:message code="com.txt.address"/></label><!-- 주소 -->
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="USER_PHONE" type="text" placeholder="<spring:message code="com.txt.phone"/>" />
                                                <label for="USER_ADRS"><spring:message code="com.txt.phone"/></label><!-- 전화번호 -->
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
