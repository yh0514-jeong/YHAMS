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

let trCnt = 0; 
let STD_YEAR_MONTH = '${STD_YEAR_MONTH}'

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
        	resetComponents();
        }
	});
	
	if(STD_YEAR_MONTH != null && STD_YEAR_MONTH != ''){
		$("#STD_YEAR_MONTH").val(STD_YEAR_MONTH).attr('disabled', true);
		$("#btnAdd").hide();
		$("#amountOfExpendPlanValue").text(numberToText('${existYearlyPlanAmount}'));
		goDraw(JSON.parse('${result}'));
	}
	
});


function goSave(){
	
	if(formCheck()){
		var list = new Array();
		$("#expendPlanList > tr").each(function(i, value){
			var map = {
				STD_DATE   : $(this).children().find("input[id^=STD_DATE_]").val(),
				AMOUNT     : $(this).children().find("input[id^=AMOUNT_]").val().replace(/,/g, ""),
			};
			list.push(map);
		});
		
		var param = {
			'STD_YEAR_MONTH' : $("#STD_YEAR_MONTH").val(),
		    'list'           : JSON.stringify(list)		
		}
		
	$.ajax({
		    type : 'post',
		    url  : '/expend/saveDailyExpendPlanList', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) {
		    	if(result.resultCode == 'success'){
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
	if(STD_YEAR_MONTH != null && STD_YEAR_MONTH != ''){
		if(confirm('<spring:message code="com.dailyExpendPlan.chkSavedDailyPlan"/>')){ // 등록된 일단위지출계획을 삭제하시겠습니까?
			let param = {};
			param.STD_YEAR_MONTH = STD_YEAR_MONTH;
			$.ajax({
			    type : 'post',
			    url  : '/expend/deleteDailyPlanList', 
			    dataType : 'json', 
			    data : param,
			    success : function(result) {
			    	if(result.resultCode == 'success'){
			    		alert('<spring:message code="com.msg.deleteSuccess"/>');  // 삭제 성공!
			    		opener.parent.list(1); 
			    		window.close();
			    	}else{
			    		alert('<spring:message code="com.msg.deleteFail"/>');   // 삭제 실패!
			    	}
			    },
			    error : function(request, status, error) { 
			    	alert('<spring:message code="com.msg.askToManager"/>');   // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
			    }
			});
		}
	}else{
		resetComponents();
	}
}

function goAddCheckFirst(){
	
	if($("#STD_YEAR_MONTH").val() == '' || $("#STD_YEAR_MONTH").val() == null){
		alert('<spring:message code="com.dailyExpendPlan.chkPlannedYearMonth"/>');  // 계획연월을 입력해주세요.
		return;
	}else{
		let param = {
			STD_YEAR_MONTH : $("#STD_YEAR_MONTH").val()
		};
		
		// 해당 월의 일 지출 계획이 등록되어 있는지 체크
		$.ajax({
		    type : 'get',
		    url  : '/expend/chkExistOfDailyExpendPlan', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) {
		    	if(result.resultCode == "success"){
		    		if(result.isExist){
		    			if(confirm('<spring:message code="com.dailyExpendPlan.redirectToDailyExpendUpdate"/>')){  // 이미 해당 연월로 등록된 일 지출계획이 있습니다. 수정 화면으로 이동하시겠습니까?
		    				 let url = '/expend/dailyExpendPlanUpdate?STD_YEAR_MONTH=' + param.STD_YEAR_MONTH;
							 window.location.href= url;		    			
		    			}else{
			    			return;
		    			}
		    		}else{
		    			goAddCheckSecond(param);
		    		}
		    	}else{
		    		alert('<spring:message code="com.msg.askToManager"/>');   // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
		    	}
		    },
		    error : function(request, status, error) { 
		    	alert('<spring:message code="com.msg.askToManager"/>');   // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
		    }
		});
		
	}
}

function goAddCheckSecond(param){

	// 등록을 해야 한다면, 연 지출 계획이 먼저 등록되어 있는지 확인
	$.ajax({
	    type : 'get',
	    url  : '/expend/chkExistOfYearlyExpendPlan', 
	    dataType : 'json', 
	    data : param,
	    success : function(result) {
			if(result.resultCode == "success"){
				if(result.existYearlyPlanCount > 0){
					param.existYearlyPlanAmount = result.existYearlyPlanAmount;
					goAdd(param);
				}else{
					alert('<spring:message code="com.dailyExpendPlan.redirectToYealyAssetPlanAdd"/>');   // 해당 연도에 등록된 연자산계획이 없습니다. 연 자산 계획을 먼저 등록해주세요.
					return;
				}
	    	}else{
	    		alert('<spring:message code="com.msg.askToManager"/>');   // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
	    	}
	    	
	    },
	    error : function(request, status, error) { 
	    	alert('<spring:message code="com.msg.askToManager"/>');   // 오류가 발생하였습니다. 관리자에게 문의 바랍니다.
	    }
	    
	});
	
}

function goAdd(param){
	
	$("#expendPlanList").empty();
	$("#amountOfExpendPlanValue").text(param.existYearlyPlanAmount.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
	let selectedDate = param.STD_YEAR_MONTH.split('-');
	let lastDay = new Date(parseInt(selectedDate[0]), parseInt(selectedDate[1]), 0).getDate();
	
	for(let i=1; i<=lastDay; i++){
		let html = "";
	    html += '<tr id="UED_SEQ_' + trCnt + '">';
	    html += '	<td scope="col"><input id="STD_DATE_' +  trCnt + '"  type="text"  style="width: 110px;" disabled="disabled"></td>';   
	    html += '	<td scope="col"><input id="AMOUNT_' +  trCnt + '"   onChange="numberCheck(this.id, this.value);" type="text" style="width: 110px;"></td>';    
	    html += '	<td scope="col"><p id="CUM_AMOUNT_' + trCnt + '" style="text-align : right;"></p></td>';                 
	    html += '	<td scope="col"><p id="WITHDRL_TOTAL_' + trCnt + '" style="text-align : right;"></p></td>';              
	    html += '	<td scope="col"><p id="CUM_WITHDRL_TOTAL_' + trCnt + '" style="text-align : right;"></p></td>';      
	    html += '	<td scope="col"><p id="DIF_' + trCnt + '" style="text-align : right;"></p></td>';                           
	    html += '</tr>';
	    
	    $("#expendPlanList").append(html);
		$("#STD_DATE_" + trCnt).datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', $("#STD_YEAR_MONTH").val() + '-' + i);
		trCnt = trCnt+1;
	}
	
}

function goDraw(list){
	for(let i=0; i<list.length; i++){
		let html = "";
	    html += '<tr id="UED_SEQ_' + trCnt + '">';
	    html += '	<td scope="col"><input id="STD_DATE_' +  trCnt + '" value="'+ list[i].STD_DATE + '" type="text"  style="width: 110px;" disabled="disabled"></td>';   
	    html += '	<td scope="col"><input id="AMOUNT_' +  trCnt + '"  value="' + list[i].AMOUNT + '" onChange="numberCheck(this.id, this.value);" type="text" style="width: 110px;"></td>';    
	    html += '	<td scope="col"><p id="CUM_AMOUNT_' + trCnt + '" style="text-align : right;">' + numberToText(list[i].CUM_AMOUNT) + '</p></td>';   
	    html += '	<td scope="col"><p id="WITHDRL_TOTAL_' + trCnt + '" style="text-align : right;">' + numberToText(list[i].WITHDRL_TOTAL) + '</p></td>';   
	    html += '	<td scope="col"><p id="CUM_WITHDRL_TOTAL_' + trCnt + '" style="text-align : right;">' + numberToText(list[i].CUM_WITHDRL_TOTAL) + '</p></td>';   
	    html += '	<td scope="col"><p id="DIF_' + trCnt + '" style="text-align : right;">' + numberToText(list[i].DIF) + '</p></td>';   
	    html += '</tr>';
	    $("#expendPlanList").append(html);
	    difCss("DIF_" + trCnt, list[i].DIF);
	    trCnt = trCnt+1;
	}
}

function numberCheck(id, value){
	value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
	$("#" + id ).val(value);
	reCalCums();
}

function reCalCums(){
	let cumAmountSum = 0;
	$("input[id^='AMOUNT_']").each(function(i, item){
		cumAmountSum += parseInt($(item).val().trim().length == 0 ? 0 : $(item).val().replace(/,/g, ""));
		$("#CUM_AMOUNT_" + i).text(numberToText(cumAmountSum));
		let dif = cumAmountSum - parseInt($("#CUM_WITHDRL_TOTAL_" + i).text().trim().length == 0 ? 0 : $("#CUM_WITHDRL_TOTAL_" + i).text().replace(/,/g, ""));
		$("#DIF_" + i).text(numberToText(dif));
		difCss("DIF_" + i, dif);
	});		
}

function formCheck(){

	if($("#expendPlanList").children().length == 0){
		alert('<spring:message code="com.dailyExpendPlan.chkSaveExpendPlanList"/>');  // 저장할 지출계획이 없습니다.
		return false;
	}else{
		let invalidCnt = 0;
		$("#expendPlanList input[id^='AMOUNT_']").each(function(i, item){
			if($(item).val() == null || $(item).val().trim().length == 0){
				invalidCnt++;
			}
		});
		if(invalidCnt > 0){
			alert('<spring:message code="com.dailyExpendPlan.chkAssignedAmountField"/>'); // 할당금액 필드를 확인해주세요.
			return false;
		}else{
			return true;
		}
	}
}


function setEqualAmount(){
	if($("#expendPlanList").children().length > 0){
		let amount = parseInt($("#amountOfExpendPlanValue").text().replace(/,/g, ""));
		let dividedAmount = Math.ceil(amount / $("#expendPlanList").children().length);
		$("#expendPlanList input[id^='AMOUNT_']").val(numberToText(dividedAmount));
		reCalCums();
	}else{
		alert('<spring:message code="com.dailyExpendPlan.chkNoAdaptableDailyPlanList"/>');	 // 적용할 일단위지출계획 리스트가 없습니다.
	}
}


function resetComponents(){
	$("#expendPlanList").empty();
	$("#amountOfExpendPlanValue").text('');
}

function numberToText(number){
	return number.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
}

function textToNumber(text){
	return text.toString().replace(/,/g, "");
}

function difCss(id, dif){
	if(dif > 0){
		$("#" + id).css('color', 'red').css('font-weight', 'bold');
	}else if(dif < 0){
		$("#" + id).css('color', 'blue').css('font-weight', 'bold');
	}else{
		$("#" + id).css('color', 'black').css('font-weight', 'bold');
	}
}
	
</script>
<body>

<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">${nav}</h5>
  </div>
</div>
<div class="panel panel-default" style="float: right;">
	<button id="btnAdd" onclick="javascript:goAddCheckFirst();" type="button" class="btn btn-success"><spring:message code="com.btn.add"/></button><!-- 추가 -->
	<button id="btnDel" onclick="javascript:goDel();" type="button" class="btn btn-danger"><spring:message code="com.btn.delete"/></button><!-- 삭제 -->
	<button id="btnSave" onclick="javascript:goSave();" type="button" class="btn btn-primary"><spring:message code="com.btn.save"/></button><!-- 저장 -->
</div>

<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.dailyExpendPlan.plannedYearMonth"/></div>    <!-- 계획연월 -->
    </div>
    <input type="text" class="form-control" id="STD_YEAR_MONTH" onchange="javascript:resetComponents();">
  </div>
</div>


<!-- 전체 메뉴리스트 -->
<div class="table table-hover">	
	<table class="table">
	  <thead class="thead-dark" align="center">
	  	 <tr>
	      <th scope="col" width="11%" colspan="2"><button id="setEqualAmountBtn" type="button" class="btn btn-primary" onclick="javascript:setEqualAmount();"><spring:message code="com.dailyExpendPlan.setEqualAmount"/></button> <!-- 동일금액 적용 --> 
	      <th scope="col" width="17%" colspan="2">
      		<p id="amountOfExpendPlanText" style="float: left;"><spring:message code="com.dailyExpendPlan.usableExpendAmount"/></p><!-- 가용 지출액 : -->
 			<p id="amountOfExpendPlanValue"></p>
	 	  </th>
	      <th scope="col" width="17%"> 
	      <th scope="col" width="33%"> 	
	    </tr>
	    <tr>
	      <th scope="col" width="11%"><spring:message code="com.dailyExpendPlan.date"/></th>                      <!--  날짜 -->
	      <th scope="col" width="11%"><spring:message code="com.dailyExpendPlan.assignedAmount"/></th>            <!--  할당금액 -->
	      <th scope="col" width="17%"><spring:message code="com.dailyExpendPlan.monthlyAccumulatedAmount"/></th>  <!--  당월누적사용액 -->
	      <th scope="col" width="11%"><spring:message code="com.dailyExpendPlan.realUseAmount"/></th>             <!--  실사용액 -->
	      <th scope="col" width="17%"><spring:message code="com.dailyExpendPlan.accumulatedRealUseAmount"/></th>  <!--  누적실사용액 -->
	      <th scope="col" width="33%"><spring:message code="com.dailyExpendPlan.errorPlanUpdate"/></th>           <!--  오차(당월누적사용액-누적실사용액)-->
	    </tr>
	  </thead>
	  <tbody id="expendPlanList">
	    
	  </tbody>
	</table>
</div>
</body>    
</html>
