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
		CODE_ID    : $("#CODE_ID").val().trim(),
		CODE_CD    : $("#CODE_CD").val().trim(),
		CODE_NM    : $("#CODE_NM").val().trim(),
		cntPerPage : $("#cntPerPage").val(),
		curPage    : $("#curPage").val()
	 };
	 
	 $.ajax({
		    type : 'get',
		    url : '/dtlCode/dtlCodeListUp', 
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
				    		html += '    <th scope="row" colspan="10"><spring:message code="com.txt.noresult"/></th>';
				    		html += '</tr>';
			    	}else{
			    		for(var i=0; i<data.length; i++){
			    			html += '<tr align="center">';
				    		html += '    <td scope="row"><input type="checkbox"></td>';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_CD + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_ID + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].CODE_ORDR + '</td>';
				    		html += '    <td scope="row">' + data[i].USE_YN + '</td>';
				    		html += '    <td scope="row">' + data[i].CREATE_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].CREATE_DATE + '</td>';
				    		html += '    <td scope="row"><button type="button" class="btn btn-danger" onclick=\"javascript:goUpdate(\'' + data[i].CODE_ID + '\',\'' + data[i].CODE_CD + '\' );\">' + '<spring:message code="com.txt.update"/></button></td>';
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
 
 function goUpdate(codeId, codeCd){
	 var flag = (codeId != null && typeof codeId != 'undefined') && (codeCd != null && typeof codeCd != 'undefined');
	 var url    = flag ?  "/dtlCode/dtlCodeUpdate?CODE_ID=" + codeId + "&CODE_CD="+ codeCd : "/dtlCode/dtlCodeUpdate"; 
	 var name   = flag ? '<spring:message code="com.dtlCode.updateDtlCode"/>' : '<spring:message code="com.dtlCode.insertDtlCode"/>';
	 var option = "width = 500, height = 600, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
function enterkey(){
	if (window.event.keyCode == 13) { list(1); }
}



</script>
<body onkeyup="javascript:enterkey();">
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">???????????? ??????</h5>
  </div>
  <div class="panel-body">
    ????????? > ???????????? ??????
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.dtlCode.dtlCode"/></div> <!-- ???????????? -->
    </div>
    <input type="text" class="form-control" id="CODE_CD"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.comCode.comCode"/></div> <!-- ???????????? -->
    </div>
    <input type="text" class="form-control" id="CODE_ID"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.comCode.codeNm"/></div> <!-- ????????? -->
    </div>
    <input type="text" class="form-control" id="CODE_NM"  onkeyup="javascript:enterkey();">
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
	<button id="btnNew" onclick="javascript:goUpdate();" type="button" class="btn btn-success">??????</button> 
</div>
<div class="table table-hover">
	<table class="table">
	  <thead align="center">
	    <tr>
	      <th scope="col"></th>
	      <th scope="col"><spring:message code="com.txt.number"/></th> <!-- No. -->
	      <th scope="col"><spring:message code="com.dtlCode.dtlCode"/></th> <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.comCode.comCode"/></th><!-- ???????????? -->
	      <th scope="col"><spring:message code="com.comCode.codeNm"/></th><!-- ????????? -->
	      <th scope="col"><spring:message code="com.dtlCode.codeOrdr"/></th> <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.comCode.useYn"/></th> <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.txt.createId"/></th> <!-- ????????? -->
	      <th scope="col"><spring:message code="com.txt.createDtm"/></th> <!-- ????????? -->
	      <th scope="col"></th>
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
