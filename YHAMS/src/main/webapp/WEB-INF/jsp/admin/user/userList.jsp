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
		USER_ID    : $("#USER_ID").val().trim(),
		USER_NM    : $("#USER_NM").val().trim(),
		cntPerPage : $("#cntPerPage").val(),
		curPage    : $("#curPage").val()
	 };
	 
	 
	 $.ajax({
		    type : 'get',
		    url : '/user/userListUp', 
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
				    		html += '    <th scope="row" colspan="6"><spring:message code="com.txt.noresult"/></th>';
				    		html += '</tr>';
			    	}else{
			    		for(var i=0; i<data.length; i++){
			    			html += '<tr align="left">';
				    		html += '    <td scope="row">' + data[i].RNUM + '</td>';
				    		html += '    <td scope="row">' + data[i].USER_ID + '</td>';
				    		html += '    <td scope="row">' + data[i].USER_NM + '</td>';
				    		html += '    <td scope="row">' + data[i].USER_NM_EN + '</td>';
				    		html += '    <td scope="row">' + data[i].USER_ADRS + '</td>';
				    		html += '    <td scope="row">' + data[i].USER_PHONE + '</td>';
				    		html += '    <td scope="row">' + data[i].ACT_ST + '</td>';
				    		html += '    <td scope="row">';
				    		html += '         <button type="button" class="btn btn-danger" onclick=\"javascript:goNew(\'' + data[i].USER_SEQ +  '\');\">' + '??????</button>';
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

function goNew(userSeq){
	 var url    = (userSeq == null || typeof userSeq == 'undefined') ? "/user/userUpdate" : "/user/userUpdate?USER_SEQ=" + userSeq;
	 var name   = (userSeq == null || typeof userSeq == 'undefined') ? '<spring:message code="com.user.insertUser"/>': '<spring:message code="com.user.updateUser"/>';
	 var option = "width = 700, height = 600, top = 100, left = 200, location = no";
     window.open(url, name, option);
}


function enterkey(){
	if (window.event.keyCode == 13) { list(1); }
}

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">????????? ??????</h5>
  </div>
  <div class="panel-body">
    ????????? > ????????? ??????
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.user.userId"/></div> <!-- ?????????ID -->
    </div>
    <input type="text" class="form-control" id="USER_ID"  onkeyup="javascript:enterkey();">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.user.userNm"/></div>  <!-- ???????????? -->
    </div>
    <input type="text" class="form-control" id="USER_NM"  onkeyup="javascript:enterkey();">
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
<%-- <div style="float: left;">
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-success"><spring:message code="com.btn.register"/></button>  <!-- ?????? -->
</div> --%>

<div class="table table-hover">
	<table class="table">
	  <thead class="thead-dark" align="center">
	    <tr>
	      <th scope="col"><spring:message code="com.txt.number"/></th>    <!-- No. -->
	      <th scope="col"><spring:message code="com.user.userId"/></th>   <!-- ?????????ID -->
	      <th scope="col"><spring:message code="com.user.userNm"/></th>   <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.user.userNmEn"/></th> <!-- ????????? ????????? -->
	      <th scope="col"><spring:message code="com.user.userAdrs"/></th>  <!-- ?????? -->
	      <th scope="col"><spring:message code="com.user.userPhone"/></th> <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.user.actSt"/></th>     <!-- ???????????? -->
	      <th scope="col"><spring:message code="com.txt.function"/></th>   <!-- ?????? -->
	    </tr>
	  </thead>
	  <tbody id="list" align="left">
	  </tbody>
	</table>
</div>
<!-- ????????? ?????? -->
<div id="pagination"></div>
</body>    
</html>
