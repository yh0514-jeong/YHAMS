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

    var ROLE_ID = '${result.ROLE_ID}';
    var ACTION  =  ROLE_ID != null && ROLE_ID != '' ? "UPDATE" : "INSERT";

	$(document).ready(function(){
		if(ACTION == "UPDATE"){
			$("#btnUpdate").html('수정');
		}else{
			$("#btnUpdate").html('등록');
		}
	});

	
	function updateDetailCode(){
		
		if($("#ROLE_NM").val().trim().length == 0){
			alert('권한명을 확인해주세요.');
			return;
		}	
		
	
		if($("#ROLE_DC").val().trim().length == 0){
			alert('권한 설명을 확인해주세요.');
			return;
		}	
		
		var param = {
				ACTION        : ACTION,
				ROLE_ID       : $("#ROLE_ID").val().trim(),
				PAR_ROLE_ID   : $("#PAR_ROLE_ID").val().trim(),
				ROLE_NM       : $("#ROLE_NM").val().trim(),
				ROLE_DC       : $("#ROLE_DC").val().trim()
		}
		
		$.ajax({
		    type : 'post',
		    url : '/role/updateRole', 
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
	    <label for="inputEmail3" class="col-sm-2 col-form-label">권한코드</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="ROLE_ID"  value="${result.ROLE_ID}" disabled="disabled">
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">상위권한</label>
	    <div class="col-sm-10">
	      <select id="PAR_ROLE_ID" class="form-select" aria-label="Default select example">
	          		<option value="">선택</option>
	          <c:forEach items="${roleList}" var="item">
	          		<option value="${item.ROLE_ID}" <c:if test ="${result.PAR_ROLE_ID eq item.ROLE_ID}"> selected="selected"</c:if>>${item.ROLE_NM}</option>
	          </c:forEach>
			</select>
	    </div>	
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">권한명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="ROLE_NM" value="${result.ROLE_NM}">
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">권한설명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="ROLE_DC" value="${result.ROLE_DC}">
    	</div>
	</div>
	
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateDetailCode();" type="button" class="btn btn-primary">
	</button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary">닫기</button>
</div>
</body>    
</html>
