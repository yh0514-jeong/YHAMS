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
		$("#expendPlanList > tr").each(function(i, value){
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
		    url  : '/expend/saveExpendPlanList', 
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
	$("#yearlyAssetPlanList").empty();
}

function goAddChk(){
	
	if($("#STD_YEAR").val().trim().length == 0){
		alert("계획연도를 입력해주세요.");
		return;
	}else{
		var param = {};
		param.STD_YEAR = $("#STD_YEAR").val();
		$.ajax({
		    type : 'get',
		    url : '/asset/chkYearlyAssetPlanExist', 
		    dataType : 'json', 
		    data : param,
		    async: false,
		    success : function(result) { 
		    	if(result.isExist == "FALSE"){
				    goAdd(result);    		
		    	}else{
		    		alert("해당연도의 지출계획이 이미 존재합니다. 불러오시겠습니까?");
		    	}
		    }
		});
	}
}

function goAdd(result){
	
	let list = result.userYearlyPlanTemplate;
	
	let dwCat101Cnt = result.dwCat101Cnt;
	let dwCat102Cnt = result.dwCat102Cnt;
	
	let finalHtml = '';
	
	for(let i=0; i<list.length; i++){
		html  = '<tr>';
		if(list[i].IS_HEAD == "HEAD"){
			html += '   <th scope="col" width="5%" head="head" rowSpan="' + (list[i].MAIN_CTG == 'DW_CAT1_01' ? dwCat101Cnt : dwCat102Cnt) + '">' + list[i].MAIN_CTG_NM + '</th>';
		}
			html += '   <th scope="col" width="5%" ' + (list[i].IS_TOTAL == 'total' ? 'total="total"' : '') + '>' + list[i].SUB_CTG_NM + '</th>';
			
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_1, 'MONTH_1');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_2, 'MONTH_2');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_3, 'MONTH_3');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_4, 'MONTH_4');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_5, 'MONTH_5');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_6, 'MONTH_6');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_7, 'MONTH_7');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_8, 'MONTH_8');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_9, 'MONTH_9');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_10, 'MONTH_10');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_11, 'MONTH_11');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].MONTH_12, 'MONTH_12');
			
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ, list[i].IS_TOTAL, list[i].TOTAL);   // row별 total
			
			html += '</tr>';
		finalHtml += html;
	}
	
	$("#yearlyAssetPlanList").append(finalHtml);
}

function generateHtml(mainCtg, userDefSeq, isTotal, value, month){
	
	let html = '';
	let id = mainCtg;
	value = value == null?  '' : value;
	
	if(isTotal == 'TOTAL'){
		id += '__' + isTotal + '__' + month;
	}else {
		id += '__' + userDefSeq;
		if(month == null){
			id += '__' + 'TOTAL';
		}else{
			id += '__' + month;
		}
	}
	
	if(isTotal == "TOTAL" || month == null){
		html = '   <th scope="col" width="5%"><p id="' + id + '">' + value + '</p></th>';
	}else{
		html = '   <th scope="col" width="5%"><input id="' + id + '" type="text" value="' + value + '" style="width:60px;" onchange="javascript:numberCheck(this.id, this.value);"></th>';
	}
	return html;
}

function numberCheck(id, value){
	value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
	$("#" + id ).val(value);
	
	let idSplit = id.split('__');
	
	let hSumTotalId = idSplit[0] + '__' + idSplit[1] + '__TOTAL';
	let vSumTotalId = idSplit[0] + '__TOTAL__' + idSplit[2];
	
	// 가로 합계 계산
	let hSum = 0;
	$("#input[id^=" + idSplit[0] + '__' + idSplit[1] + "]").each(function(i, item){
		hSum += item[i].val();
	});
	
	// 세로 합계 계산
	let vSum = 0;
	
}


function getUedCtgList(){
	var l;
	$.ajax({
	    type : 'get',
	    url : '/asset/uedCtgList', 
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
		 $("#expendPlanList").children().find("input[type='checkbox']").attr("checked", true);
	}else{
		 $("#expendPlanList").children().find("input[type='checkbox']").attr("checked", false);
	}
}


function formCheck(){
	
	var chkUedDate   = 0;
	var chkUedIncm   = 0;
	var chkUedSource = 0;
	var chkUedCtg    = 0;
	
	if($("#expendPlanList tr").length == 0){
		alert('<spring:message code="com.msg.chkAddList"/>');   // 추가할 내용이 없습니다.
		return false;
	}
	
	
	$("#expendPlanList").children().find("input[id^=UED_DATE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedDate++;
		}
	});
	
	$("#expendPlanList").children().find("input[id^=UED_INCM_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedIncm++;
		}
	});
	
	$("#expendPlanList").children().find("input[id^=UED_SOURCE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedSource++;
		}
	});
	
	$("#expendPlanList").children().find("input[id^=UED_CTG_]").each(function(i, value){
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

function chkDupYearMonth(value){
	
	var l;
	let param = {};
	param.STD_YEAR_MONTH = value;
	
	$.ajax({
	    type : 'get',
	    url : '/expend/chkDupYearMonth', 
	    data : param,
	    dataType : 'json', 
	    async: false,
	    success : function(result) { 
	    	if(result.isExist == "TRUE"){
	    		alert("이미 해당 연월에 등록된 지출계획 내역이 있습니다.\n 불러오시겠습니까?");
	    	}
	    }
	});
	return l;
}

function setFeildToggle(){
	if($("#expendPlanList").children().length == 0){
		$("#setField").hide();
	}else{
		$("#setField").show();
	}
}

function setSequentialDate(){
	
	
}

function setEqualNumber(){
	
	
	
}
	
</script>
<body>

<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">연자산계획 등록</h5>
  </div>
</div>

<div class="panel panel-default" style="float: right;">
	<button id="btnAdd" onclick="javascript:goAddChk();" type="button" class="btn btn-success"><spring:message code="com.btn.add"/></button><!-- 추가 -->
	<button id="btnDel" onclick="javascript:goDel();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
	<button id="btnSave" onclick="javascript:goSave();" type="button" class="btn btn-primary"><spring:message code="com.btn.save"/></button><!-- 저장 -->
</div>

<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">계획연도</div><!-- 계획연도 -->
    </div>
    <input type="number" class="form-control" id="STD_YEAR">
  </div>
</div>


<!-- 전체 메뉴리스트 -->
<div class="table table-hover">	
	<table class="table">
	  <thead class="thead-dark" align="center">
	  	<!-- <tr id="setField">
	      <th scope="col" width="*"></th>
	      <th scope="col" width="20%"><button onclick="javascript:setSequentialDate();">순차적날짜 적용</button></th>  
	      <th scope="col" width="18%"><button onclick="javascript:setEqualNumber();">동일금액 적용</button></th> 
	      <th scope="col" width="18%"></th>  
	      <th scope="col" width="18%"></th>  
	      <th scope="col" width="18%"></th>  
	      <th scope="col" width="18%"></th>  
	    </tr> -->
	    <tr id="monthHeader">
	      <th scope="col" width="5%"></th>
	      <th scope="col" width="10%"></th>
	      <c:forEach begin="1" end="12" var="month">
     		 <th scope="col" width="7%">${month}월</th>    
	      </c:forEach>
	      <th scope="col" width="7%">계</th>	
	    </tr>
	  </thead>
	  <tbody id="yearlyAssetPlanList">
	    
	  </tbody>
	</table>
</div>
</body>    
</html>
