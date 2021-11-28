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

var trCnt = 0; 

$(document).ready(function() {
	
});


function goSave(){
	if(formCheck()){
		var list = new Array();
		$("#depWithDrawlList > tr").each(function(i, value){
			var map = {
				UED_DATE   : $(this).children().find("input[id^=UED_DATE_]").val(),
			    UED_INCM   : $(this).children().find("input[id^=UED_INCM_]").val().replace(/,/g, ""),
			    UED_SOURCE : $(this).children().find("input[id^=UED_SOURCE_]").val(),
			    UED_CTG	   : $(this).children().find("select[id^=UED_CTG_]").val()
			};
			list.push(map);
		});
		
		var param = {
		    'list' : JSON.stringify(list)		
		}
		
		$.ajax({
		    type : 'post',
		    url  : '/asset/saveUnearnedList', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) {
		    	if(result.result == 'success'){
		    		alert('<spring:message code="com.msg.registerSuccess"/>');  // 등록 성공!!
		    		opener.parent.list(1); 
		    		window.close();
		    	}else{
		    	    alert('<spring:message code="com.msg.registerFail"/>'); // 등록 실패!
		    	    return;
		    	}
		    },
		    error : function(request, status, error) { 
		        alert('<spring:message code="com.msg.registerfail"/>');  // 등록 실패
		    }
		});
	}
}


function goDel(){
	var len = $("#depWithDrawlList").children().find("input[type='checkbox']:checked").length;
	if(len > 0){
		$("#depWithDrawlList").children().find("input[type='checkbox']:checked").each(function(i, val){
			$(this).closest('tr').remove();
		});
	}else{
		alert('<spring:message code="com.msg.unselected"/>');   //  선택된 내역이 없습니다.
	}
	$("#chkAll").attr("checked", false);
}

function goAdd(){
	
	var html = "";
	    html += '<tr id="UED_SEQ_' + trCnt + '">';
	    html += '	<td scope="col"><input id="CHKUEDSEQ_' +  trCnt + '" type="checkbox"></td>';
	    html += '	<td scope="col"><input id="ACT_DATE_' +  trCnt + '"  type="text"></td>';   
	    html += '	<td scope="col"><input id="DEPOSIT_TOTAL_' +  trCnt + '"   onChange="numberCheck(this.id, this.value);" type="text"></td>';    
	    html += '	<td scope="col"><input id="WITHDRL_TOTAL_' +  trCnt + '"  onChange="numberCheck(this.id, this.value);"  type="text"></td>';   
	    html += '	<td scope="col"><input id="DESCRIPTION_' +  trCnt + '"  type="text"></td>';  
	    html += '	<td scope="col">'
	    html += '        <select id="DW_CATE_1_' +  trCnt +  '" onChange="setDwCate2("DW_CATE_2_' + trCnt + '", this.value);">';
	    
	    
	    var codeList = getDwCateList(null);
    	for(var i=0; i<codeList.length; i++){
		html += '             <option value="' + codeList[i].CODE_CD + '">' + codeList[i].CODE_NM + '</option>';
    	}
	    html += '        </select>';
	    html += '   </td>'; 
	    html += '	<td scope="col">'
	    html += '        <select id="DW_CATE_2_' +  trCnt + '">';
	    html += '        </select>'; 
	    html += '   </td>'; 
	    html += '</tr>';
	    
    $("#depWithDrawlList").append(html);
	$("#ACT_DATE_" + trCnt).datepicker({dateFormat: 'yy-mm-dd'});
	trCnt = trCnt+1;
	$("#chkAll").attr("checked", false);
}

function numberCheck(id, value){
	value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
	$("#" + id ).val(value);
}


function getDwCateList(parCode){
	var param = {parCode : parCode};
	var l;
	$.ajax({
	    type : 'get',
	    url : '/expend/getDwCateList',
	    param : param,
	    dataType : 'json', 
	    async: false,
	    success : function(result) { 
	    	l = result;
	    }
	});
	return l;
}

function setDwCate2(targetId, value){
	console.log('setDwCate2 called... targetId : {}, value : {}', targetId, value);
	var list = getDwCateList(value);
	var html = '';
	for(var i=0; i<list.length; i++){
		html += '<option value="' + list[i].CODE_CD + '">' + list[i].CODE_NM + '</option>';
   	}
	$("#" + targetId).empty().append(html);
}


function checkFlag(t){
	var flag = $(t).prop('checked');
	if(flag){
		 $("#depWithDrawlList").children().find("input[type='checkbox']").attr("checked", true);
	}else{
		 $("#depWithDrawlList").children().find("input[type='checkbox']").attr("checked", false);
	}
}


function formCheck(){
	
	var chkUedDate   = 0;
	var chkUedIncm   = 0;
	var chkUedSource = 0;
	var chkUedCtg    = 0;
	
	if($("#unearedList tr").length == 0){
		alert('<spring:message code="com.msg.chkAddList"/>');   // 추가할 내용이 없습니다.
		return false;
	}
	
	
	$("#depWithDrawlList").children().find("input[id^=UED_DATE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedDate++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=UED_INCM_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedIncm++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=UED_SOURCE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedSource++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=UED_CTG_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedCtg++;
		}
	});
	
	
	if(chkUedDate + chkUedIncm + chkUedSource + chkUedCtg == 0){
		return true;
	}else{
		var mesg = '';
		if(chkUedDate > 0){
			mesg += '<spring:message code="com.unearned.uenDate"/>';   // 수입일
		}
		if(chkUedIncm > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.unearned.uenIncm"/>';   // 금액
		}
		if(chkUedSource > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.unearned.uenSource"/>';  // 수입처
		}
		if(chkUedCtg > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.unearned.uenCtg"/>';  // 수입분류
		}
		alert(mesg + '<spring:message code="com.msg.pleaseChk"/>');  // ..를 확인해주세요.
		return false;
	}
	
}
	
</script>
<body>

<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">입출금내역 등록</h5>
  </div>
</div>

<div class="panel panel-default" style="float: right;">
	<button id="btnAdd" onclick="javascript:goAdd();" type="button" class="btn btn-success"><spring:message code="com.btn.add"/></button><!-- 추가 -->
	<button id="btnDel" onclick="javascript:goDel();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
	<button id="btnSave" onclick="javascript:goSave();" type="button" class="btn btn-primary"><spring:message code="com.btn.save"/></button><!-- 저장 -->
</div>

<!-- 전체 메뉴리스트 -->
<div class="table table-hover">	
	<table class="table">
	  <thead class="thead-dark" align="center">
	    <tr>
	      <th scope="col"><input id="chkAll" type="checkbox" onchange="javascript:checkFlag(this);"></th>
	      <th scope="col">일자</th>      <!--  일자 -->
	      <th scope="col">입금액</th>     <!--  입금액 -->
	      <th scope="col">지출액</th>     <!--  지출액 -->
	      <th scope="col">입출금사유</th>  <!--  입출금사유 -->
	      <th scope="col">대분류</th>      <!--  대분류 -->
	      <th scope="col">소분류</th>      <!--  소분류 -->
	    </tr>
	  </thead>
	  <tbody id="depWithDrawlList">
	    
	  </tbody>
	</table>
</div>
</body>    
</html>
