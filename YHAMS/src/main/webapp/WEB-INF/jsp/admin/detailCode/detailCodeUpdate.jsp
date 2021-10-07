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

    var CODE_ID = '${result.CODE_ID}';
    var CODE_CD = '${result.CODE_CD}';
    var ACTION  =  (CODE_ID != null && CODE_ID != '') && (CODE_CD != null && CODE_CD != '') ? "UPDATE" : "INSERT";

	$(document).ready(function(){
		if(ACTION == "UPDATE"){
			$("#btnUpdate").html('<spring:message code="com.txt.update"/>');
		}else{
			$("#btnUpdate").html('<spring:message code="com.txt.register"/>');
		}
	});

	
	function updateDetailCode(){
		
		if($("#CODE_ID").val().trim().length == 0){
			alert('<spring:message code="com.dtlCode.chkComCode"/>');  // 공통코드를 확인해주세요.
			return;
		}
		
		if($("#CODE_CD").val().trim().length == 0){
			alert('<spring:message code="com.dtlCode.chkDtlCodeNm"/>'); // 상세코드명을 확인해주세요.
			return;
		}
	
		if($("#CODE_NM").val().trim().length == 0){
			alert('<spring:message code="com.comCode.chkCodeNm"/>');  // 코드명을 확인해주세요.
			return;
		}	
		
		if($("#CODE_ORDR").val().trim().length == 0){
			alert('<spring:message code="com.dtlCode.chkCodeOrdr"/>');  // 코드순서를 확인해주세요.
			return;
		}	
		
		if($("#USE_YN").val().trim().length == 0){
			alert('<spring:message code="com.comCode.chkUseYn"/>');  // 사용여부를 선택해주세요.
			return;
		}
		
		var param = {
				ACTION    : ACTION,
				CODE_ID   : $("#CODE_ID").val().trim(),
				CODE_CD   : $("#CODE_CD").val().trim(),
				CODE_NM   : $("#CODE_NM").val().trim(),
				CODE_ORDR : $("#CODE_ORDR").val().trim(),
				USE_YN    : $("#USE_YN").val()
		}
		
		$.ajax({
		    type : 'post',
		    url : '/dtlCode/updateDtlCode', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.result == "success"){
		        	if(ACTION == "UPDATE"){
			        	alert('<spring:message code="com.msg.updateSuccess"/>');  // 수정 성공!
		        	}else{
			        	alert('<spring:message code="com.msg.registerSuccess"/>');  // 등록 성공!
		        	}
		        	opener.parent.list(1); 
		        	window.close();
		        }
		    },
		    error : function(request, status, error) { 
		        alert('<spring:message code="com.msg.registerfail"/>');  // 등록 실패!!
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
	    <label for="inputEmail3" class="col-sm-2 col-form-label"><spring:message code="com.comCode.comCode"/></label><!-- 공통코드 -->
	    <div class="col-sm-10">
		    <select id="CODE_ID" class="form-select" aria-label="Default select example" <c:if test="${result.CODE_ID ne null}">disabled="disabled"</c:if>>
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${comCodeList}" var="item">
	          		<option value="${item.CODE_ID}" <c:if test ="${result.CODE_ID eq item.CODE_ID}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label"><spring:message code="com.dtlCode.dtlCode"/></label><!-- 상세코드 -->
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="CODE_CD"  value="${result.CODE_CD}" <c:if test="${result.CODE_CD ne null}">disabled="disabled"</c:if>>
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.comCode.codeNm"/></label> <!-- 코드명 -->
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="CODE_NM" value="${result.CODE_NM}">
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.dtlCode.codeOrdr"/></label> <!-- 코드순서 -->
	    <div class="col-sm-10">
	      <input type="number" class="form-control" id="CODE_ORDR" value="${result.CODE_ORDR}">
    	</div>
	</div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.comCode.useYn"/></label> <!-- 사용여부 -->
	    <div class="col-sm-10">
	      <select id="USE_YN" class="form-select" aria-label="Default select example">
	          <c:forEach items="${useYnCodeList}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.USE_YN eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
	    </div>	
    </div>
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateDetailCode();" type="button" class="btn btn-primary">
	</button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary"><spring:message code="com.btn.close"/></button> <!-- 닫기 -->
</div>
</body>    
</html>
