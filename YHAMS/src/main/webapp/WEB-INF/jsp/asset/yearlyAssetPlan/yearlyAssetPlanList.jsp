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
	 list(1);
  });

 
 function list(targetPage){
	 
	 if(targetPage!=null){
		 $("#curPage").val(1);
	 }
	 
	 var param = {
		START_YEAR    : $("#START_YEAR").val(),
		END_YEAR      : $("#END_YEAR").val(),
		cntPerPage    : $("#cntPerPage").val(),
		curPage       : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/asset/yearlyAssetPlanList', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	console.log(JSON.stringify(result));
		    	if(result.result == "success"){
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
				    		html += '    <td scope="row"><input type="checkbox" value="' + data[i].STD_YEAR + '"></td>';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].STD_YEAR + '</td>';
				    		html += '    <td scope="row">' + data[i].DW_CAT1_01_AMOUNT + '</td>';
				    		html += '    <td scope="row">' + data[i].DW_CAT1_02_AMOUNT + '</td>';
				    		html += '    <td scope="row">' + data[i].NET_AMOUNT + '</td>';
				    		html += '    <td scope="row">';
				    		html += '       <button type="button" class="btn btn-success" onclick=\"javascript:goUpdate(\'' + data[i].STD_YEAR +  '\');\">' + '<spring:message code="com.txt.update"/></button>';
				    		html += '       <button type="button" class="btn btn-danger"  onclick=\"javascript:goDel(\'' + data[i].STD_YEAR +  '\');\">' + '<spring:message code="com.txt.delete"/></button>';
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
	 var url    = "/asset/yearlyAssetPlanUpdate";
	 window.open(url, 'newWin', 'height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');
 }
 
 function goUpdate(STD_YEAR){
	 var url    = "/asset/yearlyAssetPlanUpdate?STD_YEAR=" + STD_YEAR;
     window.open(url, 'newWin', 'height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');

 }
 
 
 function goDel(stdYears){
	 
	 if(!confirm('<spring:message code="com.msg.chkSelectedDelete"/>')) return;   // 선택된 항목을 삭제하시겠습니까?
	 
	 var param = {
	    'STD_YEAR' : stdYears
	 };
	 
	 $.ajax({
		    type : 'POST',
		    url : '/asset/deleteYearlyAssetPlanListByStdYears', 
		    dataType : 'json',
		    data : param,
		    success : function(result) { 
		    	if(result.result == "success"){
		    		alert('<spring:message code="com.msg.deleteSuccess"/>');  // 삭제 성공!
		    		list(1);
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
	if (window.event.keyCode == 13) { list(1); }
}

function initDatePicker(){
	$("#START_DATE,#END_DATE").datepicker("destroy");
	$("#START_DATE,#END_DATE").datepicker({dateFormat: 'yy-mm-dd'});
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
    <h5 class="panel-title">연자산계획</h5>
  </div>
  <div class="panel-body">
    자산관리 > 연자산계획
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.yearlyAssetPlan.planYear"/></div><!--자산계획 연도-->
    </div>
    <input type="number" class="form-control" id="START_YEAR"  onkeyup="javascript:enterkey();" style="width: 150px;">
    &nbsp; ~ &nbsp;
    <input type="number" class="form-control" id="END_YEAR"  onkeyup="javascript:enterkey();" style="width: 150px;">
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
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-primary"><spring:message code="com.btn.register"/></button><!-- 등록 -->
	<button id="btnDel" onclick="javascript:goStringifyDelTarget();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
</div>
<div class="table table-hover">
	<table class="table">
	  <thead align="center">
	    <tr>
	      <th scope="col" width="5%"></th>
	      <th scope="col" width="5%"><spring:message code="com.txt.number"/></th><!-- No. -->
	      <th scope="col" width="15%"><spring:message code="com.yearlyAssetPlan.planYear"/></th><!-- 계획연도 -->
	      <th scope="col" width="15%"><spring:message code="com.yearlyAssetPlan.incomeAmountPlan"/></th><!-- 수입계획액 -->
	      <th scope="col" width="15%"><spring:message code="com.yearlyAssetPlan.expendAmountPlan"/></th><!-- 지출계획액 -->
	      <th scope="col" width="25%"><spring:message code="com.yearlyAssetPlan.netInvestAmount"/></th><!-- 실투자액(수입계획액-지출계획액) -->
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
