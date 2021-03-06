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
	    ACCOUNT_NM     : $("#ACCOUNT_NM").val().trim(),
	    ACCOUNT_CTG_NM : $("#ACCOUNT_CTG_NM").val().trim(),
	    ISUE_AGY_NM    : $("#ISUE_AGY_NM").val().trim(),
		cntPerPage     : $("#cntPerPage").val(),
		curPage        : $("#curPage").val()
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
 
 function goNew(accountCd){
	 var url    = (accountCd == null || typeof accountCd == 'undefined') ? "/asset/accountUpdate" : "/asset/accountUpdate?ACCOUNT_CD=" + accountCd ;
	 var name   = (accountCd == null || typeof accountCd == 'undefined') ? '?????? ??????': '?????? ??????';
	 var option = "width = 500, height = 500, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 function goDel(accountCd){
	 
	 if(!confirm('<spring:message code="com.acccount.cfrmAccountDelete"/>')) return;   // ?????? ????????? ?????????????????????????
	 
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
		    		alert('<spring:message code="com.msg.deleteSuccess"/>');  // ?????? ??????!
		    		list(1);
		    	}else{
		    		alert('<spring:message code="com.msg.deleteFail"/>');   // ?????? ??????!
		    	}
		    },
		    error : function(request, status, error) { 
		    	alert('<spring:message code="com.msg.deleteFail"/>');   // ?????? ??????!
		    }
		});			 
 }

function enterkey(){
	if (window.event.keyCode == 13) { list(1); }
}


</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">????????????</h5>
  </div>
  <div class="panel-body">
    ???????????? > ????????????
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.acccount.accountNm"/></div><!-- ????????? -->
    </div>
    <input type="text" class="form-control" id="ACCOUNT_NM"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.acccount.acccountCtg"/></div><!-- ???????????? -->
    </div>
    <input type="text" class="form-control" id="ACCOUNT_CTG_NM"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.acccount.isueAgy"/></div><!-- ???????????? -->
    </div>
    <input type="text" class="form-control" id="ISUE_AGY_NM"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <button type="button" class="btn btn-primary" onclick="javascript:list(1);"><spring:message code="com.btn.search"/></button> <!-- ?????? -->
  &nbsp;
</div>
<!-- Paging Util Parameter Start -->
<input id="cntPerPage"     name="cntPerPage"     type="hidden"   value="10">
<input id="curPage"        name="curPage"        type="hidden"   value="1">
<!-- Paging Util Parameter End -->
<br>
<br>
<div style="float: left;">
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-success"><spring:message code="com.btn.register"/></button><!-- ?????? -->
</div>
<div class="table table-hover">
	<table class="table">
	  <thead align="center">
	    <tr>
	      <th scope="col" width="5%"></th>
	      <th scope="col" width="10%"><spring:message code="com.txt.number"/></th><!-- No. -->
	      <th scope="col" width="15%"><spring:message code="com.acccount.accountNm"/></th><!-- ????????? -->
	      <th scope="col" width="15%"><spring:message code="com.acccount.acccountCtg"/></th><!-- ???????????? -->
	      <th scope="col" width="15%"><spring:message code="com.acccount.isueAgy"/></th><!-- ???????????? -->
	      <th scope="col" width="15%"><spring:message code="com.acccount.acccountHrdr"/></th><!-- ????????? -->
	      <th scope="col" width="*"></th>
	    </tr>
	  </thead>
	  <tbody id="list">
	   </tbody>
	</table>
</div>
<!-- ????????? ?????? -->
<div id="pagination"></div>
</body>    
</html>
