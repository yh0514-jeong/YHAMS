<%@ include file="../../../include/include-header.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
   <meta charset="utf-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>YHAMS Main</title>
</head>
<script type="text/javascript">

    var ACCOUNT_CD = '${result.ACCOUNT_CD}';

	$(document).ready(function(){
		if(ACCOUNT_CD != null && ACCOUNT_CD != ''){
			$("#btnUpdate").html('<spring:message code="com.txt.update"/>');
		}else{
			$("#btnUpdate").html('<spring:message code="com.txt.register"/>');
		}
	});


	function updateAccount(){
		
		if($("#ACCOUNT_NM").val().trim().length == 0){
			alert('<spring:message code="com.acccount.chkAccountNm"/>');    // 계좌명을 확인해주세요.
			return;
		}
		
		if($("#ACCOUNT_CTG").val().trim().length == 0){
			alert('<spring:message code="com.acccount.chkAccountCtg"/>');    // 계좌 종류를 확인해주세요.
			return;
		}
		
		if($("#ISUE_AGY").val().trim().length == 0){
			alert('<spring:message code="com.acccount.chkIsueAgy"/>');       // 발급기관을 확인해주세요.
			return;
		}
		
		if($("#ACCOUNT_HRDR").val().trim().length == 0){
			alert('<spring:message code="com.acccount.chkAcccountHrdr"/>');  // 예금주를 확인해주세요.
			return;
		}
		
		var param = {
				ACCOUNT_NM   : $("#ACCOUNT_NM").val().trim(),
				ACCOUNT_CTG  : $("#ACCOUNT_CTG").val().trim(),
				ISUE_AGY     : $("#ISUE_AGY").val().trim(),
				ACCOUNT_HRDR : $("#ACCOUNT_HRDR").val().trim()
		}
		
		if(ACCOUNT_CD != null && ACCOUNT_CD != ''){
			param.ACCOUNT_CD = ACCOUNT_CD;
		}

		$.ajax({
		    type : 'post',
		    url : '/asset/updateAccount', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.result == "success"){
		        	if(ACCOUNT_CD != null && ACCOUNT_CD != ''){
			        	alert('<spring:message code="com.msg.updateSuccess"/>');    // 수정 성공!
		        	}else{
			        	alert('<spring:message code="com.msg.registerSuccess"/>');  // 등록 성공!
		        	}
		        	opener.parent.list(); 
		        	window.close();
		        }
		    },
		    error : function(request, status, error) { 
		        alert('<spring:message code="com.msg.registerfail"/>');  // 등록 실패
		    }
		});		
	}
	

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">${nav}</h5>
  </div>
</div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label"><spring:message code="com.acccount.accountNm"/></label><!-- 계좌명 -->
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="ACCOUNT_NM" value="${result.ACCOUNT_NM}">
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.acccount.acccountCtg"/></label><!-- 계좌종류 -->
	    <div class="col-sm-10">
	    	 <select id="ACCOUNT_CTG" class="form-select" aria-label="Default select example">
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${actTypeList}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.ACCOUNT_CTG eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.acccount.isueAgy"/></label><!-- 발급기관 -->
	    <div class="col-sm-10">
	       <select id="ISUE_AGY" class="form-select" aria-label="Default select example">
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${isuOrgList}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.ISUE_AGY eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.acccount.acccountHrdr"/></label><!-- 예금주 -->
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id=ACCOUNT_HRDR value="${result.ACCOUNT_HRDR}">
    	</div>
	</div>
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateAccount();" type="button" class="btn btn-primary">
	</button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary"><spring:message code="com.btn.close"/></button> <!-- 닫기 -->
</div>
</body>    
</html>
