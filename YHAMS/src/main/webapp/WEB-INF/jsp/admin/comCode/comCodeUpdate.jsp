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

	$(document).ready(function(){
		if(CODE_ID != null && CODE_ID != ''){
			$("#btnUpdate").html('수정');
		}else{
			$("#btnUpdate").html('등록');
		}
	});


	function updateComCode(){
	
		if($("#CODE_NM").val().trim().length == 0){
			alert('코드명을 확인해주세요.');
			return;
		}	
		
		if($("#CODE_DC").val().trim().length == 0){
			alert('코드설명을 확인해주세요.');
			return;
		}	
		
		if($("#USE_YN").val().trim().length == 0){
			alert('사용여부를 선택해주세요.');
			return;
		}
		
		var param = {
				CODE_NM : $("#CODE_NM").val().trim(),
				CODE_DC : $("#CODE_DC").val().trim(),
				USE_YN  : $("#USE_YN").val()
		}
		
		if(CODE_ID != null && CODE_ID != ''){
			param.CODE_ID = CODE_ID;
		}

		$.ajax({
		    type : 'post',
		    url : '/comCode/updateComCode', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.result == "success"){
		        	if(CODE_ID != null && CODE_ID != ''){
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
	    <label for="inputEmail3" class="col-sm-2 col-form-label">공통코드</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="CODE_ID" disabled="disabled" value="${result.CODE_ID}">
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">코드명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="CODE_NM" value="${result.CODE_NM}">
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">코드설명</label>
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="CODE_DC" value="${result.CODE_DC}">
    	</div>
	</div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label">사용여부</label>
	    <div class="col-sm-10">
	      <select id="USE_YN" class="form-select" aria-label="Default select example">
	          <c:forEach items="${useYnCodeList}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.USE_YN eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
	    </div>	
    </div>
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateComCode();" type="button" class="btn btn-primary">
	</button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary">닫기</button>
</div>
</body>    
</html>
