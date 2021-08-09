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
<script type="text/javascript" src='<c:url value="/js/paging.js"/>'></script>
<script type="text/javascript">

 $(document).ready(function(){
	 list();
 });
 
 
 function list(){
	 
	 var param = {
		CODE_ID    : $("#CODE_ID").val().trim(),
		CODE_NM    : $("#CODE_NM").val().trim(),
		CODE_DC    : $("#CODE_DC").val().trim(),
		cntPerPage : $("#cntPerPage").val(),
		curPage    : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/comCode/comCodeListUp', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	if(result.resultCode == "success"){
		    		$("#list").empty();
		    		var data = result.list;
		    		console.log(JSON.stringify(result.block));
		    		drawPaging(result.block);
			    	var html = "";
			    	if(data.length == 0){
				    		html += '<tr align="center">';
				    		html += '    <th scope="row" colspan="8">조회된 결과가 없습니다.</th>';
				    		html += '</tr>';
			    	}else{
			    		for(var i=0; i<data.length; i++){
			    			html += '<tr align="center">';
				    		html += '    <td scope="row"><input type="checkbox"></td>';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_ID + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_DC + '</td>';
				    		html += '    <td scope="row">' + data[i].USE_YN + '</td>';
				    		html += '    <td scope="row">' + data[i].CREATE_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].CREATE_DATE + '</td>';
				    		html += '    <td scope="row"><button type="button" class="btn btn-danger" onclick=\"javascript:goNew(\'' + data[i].CODE_ID +  '\');\">' + '수정</button></td>';
				    		html += '</tr>';
				    	}
			    	}
			    	$("#list").append(html);
		    	}else{
				   alert("로드 실패!");		    		
		    	}
		    },
		    error : function(request, status, error) { 
		        alert('등록 실패!!');
		    }
		});		
	 
 }
 
 function goNew(codeId){
	 var url    = (codeId == null || typeof codeId == 'undefined') ? "/comCode/comCodeUpdate" : "/comCode/comCodeUpdate?CODE_ID=" + codeId ;
	 var name   = (codeId == null || typeof codeId == 'undefined') ? "공통코드 등록": "공통코드 수정";
	 var option = "width = 500, height = 500, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 function goDel(){
	alert('delete');	 
 }

function enterkey(){
	if (window.event.keyCode == 13) { list(); }
}

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">공통코드 관리</h5>
  </div>
  <div class="panel-body">
    관리자 > 공통코드 관리
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">코드</div>
    </div>
    <input type="text" class="form-control" id="CODE_ID"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">코드명</div>
    </div>
    <input type="text" class="form-control" id="CODE_NM"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">코드설명</div>
    </div>
    <input type="text" class="form-control" id="CODE_DC"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <button type="button" class="btn btn-primary" onclick="javascript:list();">검색</button>
  &nbsp;
</div>
<!-- Paging Util Parameter Start -->
<input id="cntPerPage"     name="cntPerPage"     type="hidden"   value="10">
<input id="curPage"        name="curPage"        type="hidden"   value="1">
<!-- Paging Util Parameter End -->
<br>
<br>
<div style="float: left;">
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-success">등록</button> 
</div>
<div class="table table-hover">
	<table class="table">
	  <thead>
	    <tr>
	      <th scope="col"></th>
	      <th scope="col">No.</th>
	      <th scope="col">코드</th>
	      <th scope="col">코드명</th>
	      <th scope="col">코드설명</th>
	      <th scope="col">사용여부</th>
	      <th scope="col">등록자</th>
	      <th scope="col">생성일</th>
	      <th scope="col"></th>
	    </tr>
	  </thead>
	  <tbody id="list">
	   </tbody>
	</table>
</div>
<!-- 페이징 처리 -->
<div id="pagination"></div>
<select id='postPerPage' onchange='javascript:changePerPage(this.value);' style='float:center;'>
		<option value='10'>10</option>
		<option value='20'>20</option>
		<option value='30'>30</option>
		<option value='50'>50</option>
		<option value='100'>100</option>
</select>                 
</body>    
</html>
