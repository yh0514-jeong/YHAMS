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

let EXP_PLAN_SEQ = '${EXP_PLAN_SEQ}';

$(document).ready(function() {
	
	$("#STD_YEAR_MONTH").datepicker({
		changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
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
	
	var html = "";
	    html += '<tr id="UED_SEQ_' + trCnt + '">';
	    html += '	<td scope="col"><input id="CHKUEDSEQ_' +  trCnt + '"  type="checkbox"></td>';
	    html += '	<td scope="col"><input id="UED_DATE_' +  trCnt + '"   type="text"  style="width: 110px;"></td>';   
	    html += '	<td scope="col"><input id="UED_INCM_' +  trCnt + '"   onChange="numberCheck(this.id, this.value);" type="text" style="width: 110px;"></td>';    
	    html += '	<td scope="col"><input id="UED_SOURCE_' +  trCnt + '" type="text" style="width: 110px;"></td>';   
	    html += '	<td scope="col"><input id="UED_SOURCE_' +  trCnt + '" type="text" style="width: 110px;"></td>';   
	    html += '	<td scope="col"><input id="UED_SOURCE_' +  trCnt + '" type="text" style="width: 110px;"></td>';   
	    html += '	<td scope="col"><input id="UED_SOURCE_' +  trCnt + '" type="text" style="width: 110px;"></td>';   
	    html += '</tr>';
	    
    $("#expendPlanList").append(html);
	$("#UED_DATE_" + trCnt).datepicker({dateFormat: 'yy-mm-dd'});
	trCnt = trCnt+1;
	$("#chkAll").attr("checked", false);
	
	setFeildToggle();
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
	<button id="btnAdd" onclick="javascript:goAdd();" type="button" class="btn btn-success"><spring:message code="com.btn.add"/></button><!-- 추가 -->
	<button id="btnDel" onclick="javascript:goDel();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
	<button id="btnSave" onclick="javascript:goSave();" type="button" class="btn btn-primary"><spring:message code="com.btn.save"/></button><!-- 저장 -->
</div>

<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">계획연도</div><!-- 계획연도 -->
    </div>
    <input type="text" class="form-control" id="STD_YEAR_MONTH" onchange="javascript:chkDupYearMonth(this.value);">
  </div>
</div>


<!-- 전체 메뉴리스트 -->
<div class="table table-hover">	
	<table class="table">
	  <thead class="thead-dark" align="center">
	  	<!-- <tr id="setField">
	      <th scope="col" width="*"></th>
	      <th scope="col" width="20%"><button onclick="javascript:setSequentialDate();">순차적날짜 적용</button></th>  순차적날짜 적용 버튼
	      <th scope="col" width="18%"><button onclick="javascript:setEqualNumber();">동일금액 적용</button></th>    동일금액 적용 버튼
	      <th scope="col" width="18%"></th>  
	      <th scope="col" width="18%"></th>  
	      <th scope="col" width="18%"></th>  
	      <th scope="col" width="18%"></th>  
	    </tr> -->
	    <tr>
	      <th scope="col" width="5%"></th>
	      <th scope="col" width="10%"></th>
	      <th scope="col" width="7%">1월</th>         
	      <th scope="col" width="7%">2월</th>         
	      <th scope="col" width="7%">3월</th>         
	      <th scope="col" width="7%">4월</th>         
	      <th scope="col" width="7%">5월</th>         
	      <th scope="col" width="7%">6월</th>         
	      <th scope="col" width="7%">7월</th>         
	      <th scope="col" width="7%">8월</th>         
	      <th scope="col" width="7%">8월</th>         
	      <th scope="col" width="7%">9월</th>         
	      <th scope="col" width="7%">10월</th>         
	      <th scope="col" width="7%">11월</th>         
	      <th scope="col" width="7%">12월</th>         
	    </tr>
	    <tr>
	      <th scope="col" width="5%">수입</th>
	      <th scope="col" width="10%">월급</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>      
	    </tr>
	    <tr>
	      <th scope="col" width="5%" rowspan="7">지출</th>
	      <th scope="col" width="10%">어머니 용돈</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	    <tr>
	      <th scope="col" width="10%">통신비용</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	    <tr>
	      <th scope="col" width="10%">보험료</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	    <tr>
	      <th scope="col" width="10%">여자친구</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	    <tr>
	      <th scope="col" width="10%">경기도장학관</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	    <tr>
	      <th scope="col" width="10%">교통비</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	    <tr>
	      <th scope="col" width="10%">카드</th>
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>         
	      <th scope="col" width="7%"><input type="text" style="width: 50px;"></th>          
	    </tr>
	  </thead>
	  <tbody id="expendPlanList">
	    
	  </tbody>
	</table>
</div>
</body>    
</html>
