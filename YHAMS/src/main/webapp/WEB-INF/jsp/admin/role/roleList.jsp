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

$(document).ready(function() {
	list(1);
});


function list(targetPage){
	
	 if(targetPage!=null){
		 $("#curPage").val(1);
	 }
	
	 var param = {
		ROLE_ID    : $("#ROLE_ID").val().trim(),
		ROLE_NM    : $("#ROLE_NM").val().trim(),
		cntPerPage : $("#cntPerPage").val(),
		curPage    : $("#curPage").val()
	 };
	 
	 
	 $.ajax({
		    type : 'get',
		    url : '/role/roleListUp', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    	if(result.resultCode == "success"){
		    		$("#list").empty();
		    		drawPaging(result.block);
		    		var data = result.list;
			    	var html = "";
			    	if(data.length == 0){
				    		html += '<tr align="center">';
				    		html += '    <th scope="row" colspan="7"><spring:message code="com.txt.noresult"/></th>';
				    		html += '</tr>';
			    	}else{
			    		for(var i=0; i<data.length; i++){
			    			html += '<tr align="center">';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].ROLE_ID + '</td>';
				    		html += '    <td scope="row">' + data[i].PAR_ROLE_ID + '</td>';
				    		html += '    <td scope="row">' + data[i].ROLE_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].ROLE_DC + '</td>';
				    		html += '    <td scope="row">' + data[i].DEFAULT_YN + '</td>';
				    		html += '    <td scope="row">';
				    		html += '         <button type="button" class="btn btn-danger" onclick=\"javascript:goNew(\'' + data[i].ROLE_ID +  '\');\">' + '<spring:message code="com.txt.update"/></button>';
				    		html += '         <button type="button" class="btn btn-success" onclick=\"javascript:goMenuMap(\'' + data[i].ROLE_ID +  '\');\">' + '<spring:message code="com.menu.menuManage"/></button>';
				    		html += '         <button type="button" class="btn btn-info" onclick=\"javascript:goUserMap(\'' + data[i].ROLE_ID +  '\');\">' + '<spring:message code="com.user.userManage"/></button>';
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

function goNew(roleId){
	 var url    = (roleId == null || typeof roleId == 'undefined') ? "/role/roleUpdate" : "/role/roleUpdate?ROLE_ID=" + roleId ;
	 var name   = (roleId == null || typeof roleId == 'undefined') ? '<spring:message code="com.role.insertRole"/>': '<spring:message code="com.role.updateRole"/>';
	 var option = "width = 500, height = 600, top = 100, left = 200, location = no";
     window.open(url, name, option);
}

function goMenuMap(roleId){
	var url    = "/role/roleMenuMap?ROLE_ID=" + roleId ;
	var name   = '<spring:message code="com.menu.menuManage"/>';
	var option = "width = 850, height = 500, top = 100, left = 200, location = no";
    window.open(url, name, option);
}

function goUserMap(roleId){
	var url    = "/role/roleUserMap?ROLE_ID=" + roleId ;
	var name   = '<spring:message code="com.user.userManage"/>';
	var option = "width = 850, height = 500, top = 100, left = 200, location = no";
    window.open(url, name, option);
}


function enterkey(){
	if (window.event.keyCode == 13) { list(1); }
}

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">?????? ??????</h5>
  </div>
  <div class="panel-body">
    ????????? > ????????????
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.role.roleId"/></div> <!-- ???????????? -->
    </div>
    <input type="text" class="form-control" id="ROLE_ID"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.role.roleNm"/></div> <!-- ????????? -->
    </div>
    <input type="text" class="form-control" id="ROLE_NM"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <button type="button" class="btn btn-primary" onclick="javascript:list(1);" type="button"><spring:message code="com.btn.search"/></button> <!-- ?????? -->
  &nbsp;
</div>
<!-- Paging Util Parameter Start -->
<input id="cntPerPage"     name="cntPerPage"     type="hidden"   value="10">
<input id="curPage"        name="curPage"        type="hidden"   value="1">
<!-- Paging Util Parameter End -->
<br>
<br>
<div style="float: left;">
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-success"><spring:message code="com.btn.register"/></button> <!-- ?????? -->
</div>

<div class="table table-hover">
	<table class="table">
	  <thead class="thead-dark" align="center">
	    <tr>
	      <th scope="col"><spring:message code="com.txt.number"/></th>      <!-- No. -->
	      <th scope="col"><spring:message code="com.role.roleId"/></th>     <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.role.uppserRole"/></th> <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.role.roleNm"/></th>     <!-- ????????? -->
	      <th scope="col"><spring:message code="com.role.roleDc"/></th>     <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.role.defaultYn"/></th>  <!-- ?????????????????? -->
	      <th scope="col"><spring:message code="com.txt.function"/></th>    <!-- ?????? -->
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
