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
	    ACCOUNT_NM    : $("#ACCOUNT_NM").val().trim(),
	    ACCOUNT_CTG   : $("#ACCOUNT_CTG").val().trim(),
	    ISUE_AGY      : $("#ISUE_AGY").val().trim(),
		cntPerPage    : $("#cntPerPage").val(),
		curPage       : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/asset/accountList', 
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
				    		html += '    <th scope="row" colspan="6"><spring:message code="com.txt.noresult"/></th>';
				    		html += '</tr>';
			    	}else{
			    		for(var i=0; i<data.length; i++){
			    			html += '<tr align="center">';
				    		html += '    <td scope="row"><input type="checkbox"></td>';
				    		html += '    <td scope="row">' + data[i].ACCOUNT_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].ACCOUNT_CTG + '</td>';
				    		html += '    <td scope="row">' + data[i].ISUE_AGY + '</td>';
				    		html += '    <td scope="row">' + data[i].ISUE_AGY + '</td>';
				    		html += '    <td scope="row"><button type="button" class="btn btn-danger" onclick=\"javascript:goNew(\'' + data[i].ACCOUNT_CD +  '\');\">' + '<spring:message code="com.txt.update"/></button></td>';
				    		html += '</tr>';
				    	}
			    	}
			    	$("#list").append(html);
		    	}else{
				   alert('<spring:message code="com.msg.loadfail"/>');		    		
		    	}
		    },
		    error : function(request, status, error) { 
		        alert('<spring:message code="com.msg.registerfail"/>');
		    }
		});		
	 
 }
 
 function goNew(accountCd){
	 var url    = (codeId == null || typeof codeId == 'undefined') ? "/asset/accountUpdate" : "/asset/accountUpdate?ACCOUNT_CD=" + accountCd ;
	 var name   = (codeId == null || typeof codeId == 'undefined') ? '계좌 등록': '계좌 수정';
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
    <h5 class="panel-title">계좌관리</h5>
  </div>
  <div class="panel-body">
    자산관리 > 계좌관리
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">계좌명</div><!-- 계좌명 -->
    </div>
    <input type="text" class="form-control" id="ACCOUNT_NM"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">계좌종류</div><!-- 계좌종류 -->
    </div>
    <input type="text" class="form-control" id="ACCOUNT_CTG"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">발급기관</div><!-- 발급기관 -->
    </div>
    <input type="text" class="form-control" id="ISUE_AGY"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <button type="button" class="btn btn-primary" onclick="javascript:list();"><spring:message code="com.btn.search"/></button> <!-- 검색 -->
  &nbsp;
</div>
<!-- Paging Util Parameter Start -->
<input id="cntPerPage"     name="cntPerPage"     type="hidden"   value="10">
<input id="curPage"        name="curPage"        type="hidden"   value="1">
<!-- Paging Util Parameter End -->
<br>
<br>
<div style="float: left;">
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-success"><spring:message code="com.btn.register"/></button><!-- 등록 -->
</div>
<div class="table table-hover">
	<table class="table">
	  <thead align="center">
	    <tr>
	      <th scope="col"></th>
	      <th scope="col"><spring:message code="com.txt.number"/></th><!-- No. -->
	      <th scope="col">계좌명</th>
	      <th scope="col">계좌종류</th>
	      <th scope="col">발급기관</th>
	      <th scope="col"></th>
	    </tr>
	  </thead>
	  <tbody id="list">
	   </tbody>
	</table>
</div>
<!-- 페이징 처리 -->
<div id="pagination"></div>
</body>    
</html>
