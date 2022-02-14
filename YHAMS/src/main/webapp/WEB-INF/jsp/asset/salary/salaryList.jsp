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
	 list(1);
 });
 
 
function list(targetPage){
	 
	 if(targetPage!=null){
		 $("#curPage").val(1);
	 }
	 
	 var param = {
		SAL_DATE       : $("#SAL_DATE").val().trim(),
		cntPerPage     : $("#cntPerPage").val(),
		curPage        : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/asset/salaryList', 
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
				    		html += '    <td scope="row"><input type="checkbox" value="' + data[i].SAL_SEQ + '"></td>';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].SAL_DATE + '</td>';
				    		html += '    <td scope="row">' + data[i].PAY_AMOUNT + '</td>';
				    		html += '    <td scope="row">' + data[i].DED_AMOUNT + '</td>';
				    		html += '    <td scope="row">' + data[i].NET_AMOUNT + '</td>';
				    		html += '    <td scope="row">';
				    		html += '       <button type="button" class="btn btn-info" onclick=\"javascript:goNew(\'' + data[i].SAL_SEQ +  '\');\">' + '상세보기/수정</button>';
				    		html += '       <button type="button" class="btn btn-danger" onclick=\"javascript:goDel(\'' + data[i].SAL_SEQ +  '\');\">' + '삭제</button>';
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
 
 function goNew(salSeq){
	 var url    = (salSeq == null || typeof salSeq == 'undefined') ? "/asset/salaryUpdate" : "/asset/salaryUpdate?SAL_SEQ=" + salSeq ;
	 var name   = (salSeq == null || typeof salSeq == 'undefined') ? '<spring:message code="com.salary.registerSalary"/>': '<spring:message code="com.salary.updateSalary"/>';
	 var option = "width = 1100, height = 700, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 function goDel(salSeq){
	 
	 if(!confirm('<spring:message code="com.salary.chkDelete"/>')) return;   // 해당 급여내역을 삭제하시겠습니까?
	 
	 var param = {
			SAL_SEQ  : salSeq
	 };
	 
	 $.ajax({
		    type : 'POST',
		    url : '/asset/deleteSalary', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	if(result.resultCode == "success"){
		    		alert('<spring:message code="com.msg.deleteSuccess"/>');  // 삭제 성공
		    		list(1);
		    	}else{
		    		alert('<spring:message code="com.msg.deleteFail"/>');   // 삭제 실패!
		    		return;
		    	}
		    },
		    error : function(request, status, error) { 
		    	alert('<spring:message code="com.msg.deleteFail"/>');   // 삭제 실패!
		    }
		});			 
 }

function enterkey(){
	if (window.event.keyCode == 13) { list(1); }
}

function goStringifyDelTarget(){
	var delTargets = '';
	$("#list").children().find("input[type='checkbox']:checked").each(function(i, val){
		if(delTargets == ''){
			delTargets += $(this).val();
		}else{
			delTargets += ',' + $(this).val();
		}
	});
	if(delTargets == ''){
		alert('<spring:message code="com.msg.unselected"/>');   // 선택된 내역이 없습니다.
		return;
	}else{
		goDel(delTargets);
	}
}


</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">급여관리</h5>
  </div>
  <div class="panel-body">
    자산관리 > 급여관리
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.salary.salDate"/></div><!-- 급여연월 -->
    </div>
    <input type="text" class="form-control" id="SAL_DATE"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <button type="button" class="btn btn-primary" onclick="javascript:list(1);"><spring:message code="com.btn.search"/></button> <!-- 검색 -->
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
	<button id="btnDel" onclick="javascript:goStringifyDelTarget();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
</div>
<div class="table table-hover">
	<table class="table">
	  <thead align="center">
	    <tr>
	      <th scope="col" width="3%"></th>
	      <th scope="col" width="10%"><spring:message code="com.txt.number"/></th><!-- No. -->
	      <th scope="col" width="15%"><spring:message code="com.salary.salDate"/></th><!-- 급여연월 -->
	      <th scope="col" width="15%"><spring:message code="com.salary.payAmount"/></th><!-- 지급총액 -->
	      <th scope="col" width="15%"><spring:message code="com.salary.dedAmount"/></th><!-- 공제총액 -->
	      <th scope="col" width="15%"><spring:message code="com.salary.realAmount"/></th><!-- 실수령액 -->
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
