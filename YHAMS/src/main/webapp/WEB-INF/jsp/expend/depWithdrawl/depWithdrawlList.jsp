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
	    DESCRIPT      : $("#DESCRIPT").val().trim(),
	    DW_CATE       : $("#DW_CATE").val().trim(),
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
				    		html += '    <th scope="row" colspan="11"><spring:message code="com.txt.noresult"/></th>';
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
				    		html += '    <td scope="row">' + data[i].REAL_USE_YN + '</td>';
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
 
 function goUpdate(ACT_SEQ){
	 var url    = "/expend/updateDepWithdrawal?ACT_SEQ=" + ACT_SEQ;
	 var option = "width = 700, height = 550, top = 100, left = 200, location = no";
     window.open(url, name, option);
 }
 
 
 function goDel(actSeqs){
	 
	 if(!confirm('<spring:message code="com.msg.chkSelectedDelete"/>')) return;   // ????????? ????????? ?????????????????????????
	 
	 var param = {
	    'ACT_SEQ' : actSeqs
	 };
	 
	 $.ajax({
		    type : 'POST',
		    url : '/expend/deleteDepWithdrawalList', 
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
		alert('<spring:message code="com.msg.unselected"/>');   // ????????? ????????? ????????????.
		return;
	}else{
		goDel(delTargets);
	}
}

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">?????????????????????</h5>
  </div>
  <div class="panel-body">
    ???????????? > ?????????????????????
  </div>
</div>
<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right;">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.depwithdral.period"/></div><!--?????? -->
    </div>
    <input type="text" class="form-control" id="START_DATE" style="width: 150px;">&nbsp;~&nbsp;
    <input type="text" class="form-control" id="END_DATE"   style="width: 150px;">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.depwithdral.descript"/></div><!-- ??????????????? -->
    </div>
    <input type="text" class="form-control" id="DESCRIPT"  onkeyup="javascript:enterkey();" style="width: 150px;">
  </div>
  &nbsp;
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.depwithdral.dwCate"/></div><!-- ???/????????? -->
    </div>
    <input type="text" class="form-control" id="DW_CATE"  onkeyup="javascript:enterkey();" style="width: 150px;">
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
	<button id="btnNew" onclick="javascript:goNew();" type="button" class="btn btn-primary"><spring:message code="com.btn.register"/></button><!-- ?????? -->
	<button id="btnDel" onclick="javascript:goStringifyDelTarget();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- ?????? -->
</div>
<div class="table table-hover">
	<table class="table">
	  <thead align="center">
	    <tr>
	      <th scope="col" width="3%"></th>
	      <th scope="col" width="3%"><spring:message code="com.txt.number"/></th>             <!-- No. -->
	      <th scope="col" width="9%"><spring:message code="com.depwithdral.actDate"/></th>    <!-- ?????? -->
	      <th scope="col" width="11%"><spring:message code="com.depwithdral.account"/></th>   <!-- ?????? -->
	      <th scope="col" width="9%"><spring:message code="com.depwithdral.depTotal"/></th>   <!-- ????????? -->
	      <th scope="col" width="9%"><spring:message code="com.depwithdral.withTotal"/></th>  <!-- ????????? -->
	      <th scope="col" width="11%"><spring:message code="com.depwithdral.descript"/></th>  <!-- ???/???????????? -->
	      <th scope="col" width="11%"><spring:message code="com.depwithdral.dwCate1"/></th>   <!-- ????????? -->
	      <th scope="col" width="11%"><spring:message code="com.depwithdral.dwCate2"/></th>   <!-- ????????? -->
	      <th scope="col" width="8%"><spring:message code="com.depwithdral.realUseYn"/></th>  <!-- ??????????????? -->
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
