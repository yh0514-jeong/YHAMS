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

    var MENU_ID = '${result.MENU_ID}';
    var ACTION  =  MENU_ID != null && MENU_ID != '' ? "UPDATE" : "INSERT";

	$(document).ready(function(){
		if(ACTION == "UPDATE"){
			$("#btnUpdate").html('수정');
		}else{
			$("#btnUpdate").html('등록');
		}
	});

	
	function updateMenu(){
	
		if($("#MENU_NM").val().trim().length == 0){
			alert('메뉴명을 확인해주세요.');
			return;
		}	
		
		if($("#MENU_NM_EN").val().trim().length == 0){
			alert('메뉴영문명을 확인해주세요.');
			return;
		}
		
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
		    	alert(JSON.stringify(result));
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
	    <label for="inputEmail3" class="col-sm-2 col-form-label">메뉴ID</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="MENU_ID"  value="${result.MENU_ID}" disabled="disabled">
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">상위메뉴</label>
	    <div class="col-sm-10">
	      <select id="PAR_MENU_ID" class="form-select" aria-label="Default select example">
	          		<option value="">선택</option>
	          <c:forEach items="${menuList}" var="item">
	          		<option value="${item.MENU_ID}" <c:if test ="${result.PAR_MENU_ID eq item.MENU_ID}"> selected="selected"</c:if>>${item.MENU_NM}</option>
	          </c:forEach>
			</select>
	    </div>	
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">메뉴명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="MENU_NM" value="${result.MENU_NM}">
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">메뉴영문명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="MENU_NM_EN" value="${result.MENU_NM_EN}">
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">메뉴URL</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="MENU_URL" value="${result.MENU_URL}">
    	</div>
	</div>
	
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateMenu();" type="button" class="btn btn-primary">
	</button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary">닫기</button>
</div>
</body>    
</html>
