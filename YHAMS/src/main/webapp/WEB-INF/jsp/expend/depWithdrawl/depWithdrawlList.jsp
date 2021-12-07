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
	    START_DATE    : $("#START_DATE").val().trim(),
	    END_DATE      : $("#END_DATE").val().trim(),
	    UED_SOURCE    : $("#UEN_SOURCE").val().trim(),
	    UED_CTG_NM    : $("#UED_CTG_NM").val().trim(),
		cntPerPage    : $("#cntPerPage").val(),
		curPage       : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/expend/depWithdralList', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	console.log(JSON.stringify(result));
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
				    		html += '    <td scope="row"><input type="checkbox" value="' + data[i].ACT_SEQ + '"></td>';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].ACT_DATE + '</td>';
				    		html += '    <td scope="row">' + data[i].ACCOUNT_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].DEPOSIT_TOTAL + '</td>';
				    		html += '    <td scope="row">' + data[i].WITHDRL_TOTAL + '</td>';
				    		html += '    <td scope="row">' + data[i].DESCRIPT + '</td>';
				    		html += '    <td scope="row">' + data[i].DW_CATE1_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].DW_CATE2_NM + '</td>';
				    		html += '    <td scope="row">';
				    		html += '       <button type="button" class="btn btn-success" onclick=\"javascript:goUpdate(\'' + data[i].ACT_SEQ +  '\');\">' + '<spring:message code="com.txt.update"/></button>';
				    		html += '       <button type="button" class="btn btn-danger"  onclick=\"javascript:goDel(\'' + data[i].ACT_SEQ +  '\');\">' + '<spring:message code="com.txt.delete"/></button>';
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
	 var url    = "/expend/depWithdrAdd";
	 var option = "width = 1100, height = 500, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 function goUpdate(UED_SEQ){
	 var url    = "/asset/unearnedUpdate?UED_SEQ=" + UED_SEQ;
	 var option = "width = 500, height = 500, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 
 function goDel(uedSeqs){
	 
	 if(!confirm('<spring:message code="com.msg.chkSelectedDelete"/>')) return;   // 선택된 항목을 삭제하시겠습니까?
	 
	 var param = {
	    'UED_SEQS' : uedSeqs
	 };
	 
	 $.ajax({
		    type : 'POST',
		    url : '/asset/deleteUnearedList', 
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
    <h5 class="panel-title">입출금내역관리</h5>
  </div>
  <div class="panel-body">
    지출관리 > 입출금내역관리
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.depwithdral.period"/></div><!--기간 -->
    </div>
    <input type="text" class="form-control" id="START_DATE" style="width: 150px;">&nbsp;~&nbsp;
    <input type="text" class="form-control" id="END_DATE"   style="width: 150px;">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.depwithdral.descript"/></div><!-- 입출금사유 -->
    </div>
    <input type="text" class="form-control" id="UEN_SOURCE"  onkeyup="javascript:enterkey();" style="width: 150px;">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.depwithdral.dwCate"/></div><!-- 대/소분류 -->
    </div>
    <input type="text" class="form-control" id="UED_CTG_NM"  onkeyup="javascript:enterkey();" style="width: 150px;">
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
	      <th scope="col" width="2%"></th>
	      <th scope="col" width="5%"><spring:message code="com.txt.number"/></th>             <!-- No. -->
	      <th scope="col" width="10%"><spring:message code="com.depwithdral.actDate"/></th>   <!-- 일자 -->
	      <th scope="col" width="15%"><spring:message code="com.depwithdral.account"/></th>   <!-- 계좌 -->
	      <th scope="col" width="10%"><spring:message code="com.depwithdral.depTotal"/></th>  <!-- 입금액 -->
	      <th scope="col" width="10%"><spring:message code="com.depwithdral.withTotal"/></th> <!-- 지출액 -->
	      <th scope="col" width="15%"><spring:message code="com.depwithdral.descript"/></th>  <!-- 입/출금사유 -->
	      <th scope="col" width="10%"><spring:message code="com.depwithdral.dwCate1"/></th>   <!-- 대분류 -->
	      <th scope="col" width="10%"><spring:message code="com.depwithdral.dwCate2"/></th>   <!-- 소분류 -->
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
