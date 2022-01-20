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
	
	$("#STD_YEAR_MONTH").datepicker({
		changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        },
        onSelect: function(dateText){
        	$("#expendPlanList").empty();
        }
	});
	
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
	var len = $("#expendPlanList").children().find("input[type='checkbox']:checked").length;
	if(len > 0){
		$("#expendPlanList").children().find("input[type='checkbox']:checked").each(function(i, val){
			$(this).closest('tr').remove();
		});
	}else{
		alert('<spring:message code="com.msg.unselected"/>');   //  선택된 내역이 없습니다.
	}
	$("#chkAll").attr("checked", false);
	
	setFeildToggle();
}

function goAdd(){
	
	if($("#STD_YEAR_MONTH").val() == '' || $("#STD_YEAR_MONTH").val() == null){
		alert('계획연월을 입력해주세요');
		return;
	}
	
	let selectedDate = $("#STD_YEAR_MONTH").val().split('-');
	let lastDay = new Date(parseInt(selectedDate[0]), parseInt(selectedDate[1]), 0).getDate();
	
	for(let i=1; i<=lastDay; i++){
		
		var html = "";
	    html += '<tr id="UED_SEQ_' + trCnt + '">';
	    html += '	<td scope="col"><input id="CHKUEDSEQ_' +  trCnt + '"  type="checkbox"></td>';
	    html += '	<td scope="col"><input id="UED_DATE_' +  trCnt + '"   type="text"  style="width: 110px;"></td>';   
	    html += '	<td scope="col"><input id="UED_INCM_' +  trCnt + '"   onChange="numberCheck(this.id, this.value);" type="text" style="width: 110px;"></td>';    
	    html += '	<td scope="col"><p></p></td>';   
	    html += '	<td scope="col"><p></p></td>';   
	    html += '	<td scope="col"><p></p></td>';   
	    html += '	<td scope="col"><p></p></td>';   
	    html += '</tr>';
	    
	    $("#expendPlanList").append(html);
		$("#UED_DATE_" + trCnt).datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', $("#STD_YEAR_MONTH").val() + '-' + i);
		trCnt = trCnt+1;
	}
	
}

function numberCheck(id, value){
	value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
	$("#" + id ).val(value);
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
	
</script>
<body>

<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">일단위지출계획 등록</h5>
  </div>
</div>

<div class="panel panel-default" style="float: right;">
	<button id="btnAdd" onclick="javascript:goAdd();" type="button" class="btn btn-success"><spring:message code="com.btn.add"/></button><!-- 추가 -->
	<button id="btnDel" onclick="javascript:goDel();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
	<button id="btnSave" onclick="javascript:goSave();" type="button" class="btn btn-primary"><spring:message code="com.btn.save"/></button><!-- 저장 -->
</div>

<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">계획연월</div><!-- 계획연월 -->
    </div>
    <input type="text" class="form-control" id="STD_YEAR_MONTH" onchange="javascript:chkDupYearMonth(this.value);">
  </div>
</div>


<!-- 전체 메뉴리스트 -->
<div class="table table-hover">	
	<table class="table">
	  <thead class="thead-dark" align="center">
	    <tr>
	      <th scope="col" width="*"><input id="chkAll" type="checkbox" onchange="javascript:checkFlag(this);"></th>
	      <th scope="col" width="18%">날짜</th>          <!--  날짜 -->
	      <th scope="col" width="18%">할당금액</th>       <!--  할당금액 -->
	      <th scope="col" width="18%">당월누적사용액</th>   <!--  당월누적사용액 -->
	      <th scope="col" width="18%">실사용액</th>       <!--  실사용액 -->
	      <th scope="col" width="18%">누적실사용액</th>     <!-- 누적실사용액 -->
	      <th scope="col" width="18%">오차</th>          <!--  오차-->
	    </tr>
	  </thead>
	  <tbody id="expendPlanList">
	    
	  </tbody>
	</table>
</div>
</body>    
</html>
