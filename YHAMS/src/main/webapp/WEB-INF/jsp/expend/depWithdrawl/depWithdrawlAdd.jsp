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
				ACT_DATE      : $(this).children().find("input[id^=ACT_DATE_]").val(),
				ACCOUNT_CD    : $(this).children().find("select[id^=ACCOUNT_]").val(),
				DEPOSIT_TOTAL : $(this).children().find("input[id^=DEPOSIT_TOTAL_]").val().replace(/,/g, ""),
			    WITHDRL_TOTAL : $(this).children().find("input[id^=WITHDRL_TOTAL_]").val().replace(/,/g, ""),
			    DESCRIPT      : $(this).children().find("input[id^=DESCRIPT_]").val(),
			    DW_CATE1	  : $(this).children().find("select[id^=DW_CATE1_]").val(),
			    DW_CATE2	  : $(this).children().find("select[id^=DW_CATE2_]").val()
			};
			list.push(map);
		});
		
		var param = {
		    'list' : JSON.stringify(list)		
		}
		
		$.ajax({
		    type : 'post',
		    url  : '/expend/saveDepWithdralList', 
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
	    html += '	<td scope="col"><input id="ACT_DATE_' +  trCnt + '"  type="text" style="width:110px;"></td>';
	    html += '	<td scope="col">';
	    html += '        <select id="ACCOUNT_CD_' + trCnt + '"  style="width:110px;">';
	    var accountList = getAccountList();
	    for(var i=0; i<accountList.length; i++){
			html += '             <option value="' + accountList[i].ACCOUNT_CD + '">' + accountList[i].ACCOUNT_NM + '</option>';
    	}
	    html += '        </select>'; 
	    html += '   </td>'; 
	    html += '	<td scope="col"><input id="DEPOSIT_TOTAL_' +  trCnt + '"   onChange="numberCheck(this.id, this.value);" type="text"  style="width:110px;"></td>';    
	    html += '	<td scope="col"><input id="WITHDRL_TOTAL_' +  trCnt + '"  onChange="numberCheck(this.id, this.value);"  type="text"  style="width:110px;"></td>';   
	    html += '	<td scope="col"><input id="DESCRIPT_' +  trCnt + '"  type="text"  style="width:110px;"></td>';  
	    html += '	<td scope="col">';
	    let tmpId = 'DW_CATE2_' + trCnt;
	    html += "        <select id='DW_CATE1_" +  trCnt +  "' onChange='setDwCate2(\"" + tmpId + "\", this.value);'  style='width:110px;'>";
	    var codeList = getDwCateList();
	    html += '             <option value=""><spring:message code="com.txt.optionSelect"/></option>';
    	for(var i=0; i<codeList.length; i++){
		html += '             <option value="' + codeList[i].CODE_CD + '">' + codeList[i].CODE_NM + '</option>';
    	}
	    html += '        </select>';
	    html += '   </td>'; 
	    html += '	<td scope="col">'
	    html += '        <select id="'+ tmpId + '"  style="width:110px;">';
	    html += '             <option value=""><spring:message code="com.txt.optionSelect"/></option>';
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
	var param = {};
	param.parCode = parCode;
	var l;
	$.ajax({
	    type : 'get',
	    url : '/expend/getDwCateList',
	    data : param,
	    dataType : 'json', 
	    async: false,
	    success : function(result) { 
	    	l = result;
	    }
	});
	return l;
}

function setDwCate2(targetId, parCode){
	var list = getDwCateList(parCode);
	var html = '';
	for(var i=0; i<list.length; i++){
		html += '<option value="' + list[i].CODE_CD + '">' + list[i].CODE_NM + '</option>';
   	}
	
	$("#" + targetId).empty();
	$("#" + targetId).append(html);
}

function getAccountList(){
	var l;
	$.ajax({
	    type : 'get',
	    url : '/expend/getAccountList',
	    dataType : 'json', 
	    async: false,
	    success : function(result) { 
	    	l = result;
	    }
	});
	return l;
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
	
	let chkActDate     = 0;
	let chkAccount     = 0;
	let chkDepTotal    = 0;
	let chkWithTotal   = 0;
	let chkDescription = 0;
	let chkDwCate1     = 0;
	let chkDwCate2     = 0;
	
	if($("#depWithDrawlList tr").length == 0){
		alert('<spring:message code="com.msg.chkAddList"/>');   // 추가할 내용이 없습니다.
		return false;
	}
	
	
	$("#depWithDrawlList").children().find("input[id^=ACT_DATE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkActDate++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=ACCOUNT_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkAccount++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=DEPOSIT_TOTAL_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkDepTotal++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=WITHDRL_TOTAL_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkWithTotal++;
		}
	});
	
	$("#depWithDrawlList").children().find("input[id^=DESCRIPT_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkDescription++;
		}
	});
	
	$("#depWithDrawlList").children().find("select[id^=DW_CATE1_]").each(function(i, value){
		if($(this).val() == '' || $(this).val() == null){
			chkDwCate1++;
		}
	});
	
	$("#depWithDrawlList").children().find("select[id^=DW_CATE2_]").each(function(i, value){
		if($(this).val() == '' || $(this).val() == null){
			chkDwCate2++;
		}
	});
	
	
	if(chkActDate + chkAccount + chkDepTotal + chkWithTotal + chkDescription + chkDwCate1 + chkDwCate2 == 0){
		return true;
	}else{
		var mesg = '';
		if(chkActDate > 0){
			mesg += '<spring:message code="com.depwithdral.actDate"/>';   // 날짜
		}
		if(chkAccount > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.depwithdral.account"/>';   // 계좌
		}
		if(chkDepTotal > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.depwithdral.depTotal"/>';   // 입금액
		}
		if(chkWithTotal > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.depwithdral.withTotal"/>';  // 지출액
		}
		if(chkDescription > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.depwithdral.description"/>';  // 입출금사유
		}
		if(chkDwCate1 > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.depwithdral.dwCate1"/>';  // 대분류
		}
		if(chkDwCate2 > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.depwithdral.dwCate2"/>';  // 소분류
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
	      <th scope="col"><spring:message code="com.depwithdral.actDate"/></th>      <!--  날짜 -->
	      <th scope="col"><spring:message code="com.depwithdral.account"/></th>      <!--  계좌 -->
	      <th scope="col"><spring:message code="com.depwithdral.depTotal"/></th>     <!--  입금액 -->
	      <th scope="col"><spring:message code="com.depwithdral.withTotal"/></th>    <!--  지출액 -->
	      <th scope="col"><spring:message code="com.depwithdral.description"/></th>  <!--  입출금사유 -->
	      <th scope="col"><spring:message code="com.depwithdral.dwCate1"/></th>      <!--  대분류 -->
	      <th scope="col"><spring:message code="com.depwithdral.dwCate2"/></th>      <!--  소분류 -->
	    </tr>
	  </thead>
	  <tbody id="depWithDrawlList">
	    
	  </tbody>
	</table>
</div>
</body>    
</html>
