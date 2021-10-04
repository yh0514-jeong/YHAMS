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

  $(function() {
	 initDatePicker();
	 list();
  });

 
 function list(){
	 
	 var param = {
	    START_DATE    : $("#START_DATE").val().trim(),
	    END_DATE      : $("#END_DATE").val().trim(),
	    UEN_SOURCE    : $("#UEN_SOURCE").val().trim(),
	    UEN_CTG       : $("#UEN_CTG").val().trim(),
		cntPerPage    : $("#cntPerPage").val(),
		curPage       : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/asset/unearnedList', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	if(result.resultCode == "success"){
		    		$("#list").empty();
		    		var data = result.list;
		    		drawPaging(result.block);
			    	var html = "";
			    	if(data.length == 0){
				    		html += '<tr align="center">';
				    		html += '    <th scope="row" colspan="7"><spring:message code="com.txt.noresult"/></th>';
				    		html += '</tr>';
			    	}else{
			    		for(var i=0; i<data.length; i++){
			    			html += '<tr align="center">';
				    		html += '    <td scope="row"><input type="checkbox"></td>';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].ACCOUNT_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].ACCOUNT_CTG_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].ISUE_AGY_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].ACCOUNT_HRDR + '</td>';
				    		html += '    <td scope="row">';
				    		html += '       <button type="button" class="btn btn-success" onclick=\"javascript:goNew(\'' + data[i].ACCOUNT_CD +  '\');\">' + '<spring:message code="com.txt.update"/></button>';
				    		html += '       <button type="button" class="btn btn-danger"  onclick=\"javascript:goDel(\'' + data[i].ACCOUNT_CD +  '\');\">' + '<spring:message code="com.txt.delete"/></button>';
				    		html += '    </td>';
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
 
 function goNew(){
	 var url    = "/asset/unearnedAdd";
	 var option = "width = 850, height = 500, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 function goDel(accountCd){
	 
	 if(!confirm('<spring:message code="com.acccount.cfrmAccountDelete"/>')) return;   // 해당 계좌를 삭제하시겠습니까?
	 
	 var param = {
			    ACCOUNT_CD    : accountCd
			 };
	 
	 $.ajax({
		    type : 'POST',
		    url : '/asset/deleteAccount', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	if(result.result == "success"){
		    		alert('<spring:message code="com.msg.deleteSuccess"/>');  // 삭제 성공!
		    		list();
		    	}else{
		    		alert('<spring:message code="com.msg.deleteFail"/>');   // 삭제 실패!
		    	}
		    },
		    error : function(request, status, error) { 
		    	alert('<spring:message code="com.msg.deleteFail"/>');   // 삭제 실패!
		    }
		});			 
 }

function enterkey(){
	if (window.event.keyCode == 13) { list(); }
}

function initDatePicker(){
	$("#START_DATE,#END_DATE").datepicker("destroy");
	$("#START_DATE,#END_DATE").datepicker();
}

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">불로소득관리</h5>
  </div>
  <div class="panel-body">
    자산관리 > 불로소득관리
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">기간</div><!--기간 -->
    </div>
    <input type="text" class="form-control" id="START_DATE" style="width: 150px;">&nbsp;~&nbsp;
    <input type="text" class="form-control" id="END_DATE"   style="width: 150px;">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">수입처</div><!-- 수입처 -->
    </div>
    <input type="text" class="form-control" id="UEN_SOURCE"  onkeyup="javascript:enterkey();" style="width: 150px;">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">수입분류</div><!-- 수입분류 -->
    </div>
    <input type="text" class="form-control" id="UEN_CTG"  onkeyup="javascript:enterkey();" style="width: 150px;">
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
	      <th scope="col" width="5%"></th>
	      <th scope="col" width="10%"><spring:message code="com.txt.number"/></th><!-- No. -->
	      <th scope="col" width="15%">수입일</th><!-- 수입일 -->
	      <th scope="col" width="15%">금액</th><!-- 금액 -->
	      <th scope="col" width="15%">수입처</th><!-- 수입처 -->
	      <th scope="col" width="15%">수입분류</th><!-- 수입분류 -->
	      <th scope="col" width="*"></th>
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
