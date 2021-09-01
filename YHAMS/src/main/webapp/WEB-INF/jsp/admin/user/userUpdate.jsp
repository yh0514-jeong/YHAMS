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

    var USER_SEQ = '${result.USER_SEQ}';
    var ACTION  =  USER_SEQ != null && USER_SEQ != '' ? "UPDATE" : "INSERT";

	$(document).ready(function(){
		if(ACTION == "UPDATE"){
			$("#btnUpdate").html('수정');
		}else{
			$("#btnUpdate").html('등록');
		}
	});

	
	function updateMenu(){
		
		var param = {
				ACTION        : ACTION,
				MENU_ID       : $("#MENU_ID").val(),
				PAR_MENU_ID   : $("#PAR_MENU_ID").val(),
				MENU_NM       : $("#MENU_NM").val(),
				MENU_NM_EN    : $("#MENU_NM_EN").val(),
				MENU_URL      : $("#MENU_URL").val()
		}
		
		$.ajax({
		    type : 'post',
		    url : '/menu/updateMenu', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.result == "success"){
		        	if(ACTION == "UPDATE"){
			        	alert('수정 성공!');
		        	}else{
			        	alert('등록 성공!');
		        	}
		        	opener.parent.list(); 
		        	window.close();
		        }
		    },
		    error : function(request, status, error) { 
		        alert('등록 실패!!');
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
	    <label for="inputEmail3" class="col-sm-2 col-form-label">사용자ID</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="USER_ID"  value="${result.USER_ID}" disabled="disabled">
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">활동상태</label>
	    <div class="col-sm-10">
	      <select id="ACT_ST" class="form-select" aria-label="Default select example">
	          		<option value="">선택</option>
	          <c:forEach items="${actStList}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.ACT_ST eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
	    </div>	
    </div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label">사용자명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="USER_NM"  value="${result.USER_NM}">
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label">사용자 영문명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="USER_NM_EN"  value="${result.USER_NM_EN}">
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label">주소</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="USER_ADRS"  value="${result.USER_ADRS}">
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label">E-mail</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="USER_EMAIL"  value="${result.USER_EMAIL}">
	    </div>
    </div>
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateMenu();" type="button" class="btn btn-primary">
	</button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary">닫기</button>
</div>
</body>    
</html>
