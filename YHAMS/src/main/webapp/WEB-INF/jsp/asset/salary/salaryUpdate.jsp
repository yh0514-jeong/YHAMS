<%@ include file="../../../include/include-header.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

const SAL_SEQ  = '${result.SAL_SEQ}';
const SAL_DATE = '${result.SAL_DATE}';
var trCnt = SAL_SEQ == null || SAL_SEQ == '' ? 0 : ('${payList}').length + ('${dedList}').length; 

$(document).ready(function() {
	
	$("#SAL_DATE").datepicker({
		changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        },
        onSelect: function(dateText) {
        	dupChkSalMonth(dateText);
        }
	});
	
	if(SAL_SEQ != null && typeof SAL_SEQ != 'undefined' && SAL_SEQ.trim().length > 0){
		$("#lastMonthSal").hide();
		let set_date = new Date();
		set_date.setFullYear(Number(SAL_DATE.split('-')[0]));
		set_date.setMonth(Number(SAL_DATE.split('-')[1])-1);
		set_date.setDate(1);
		$("#SAL_DATE").datepicker('option','disabled', true);
		$("#SAL_DATE").datepicker().datepicker("setDate", set_date);
		calTotal('PAY');
		calTotal('DED');
	}
	
});


function goSave(){
	
	if(formCheck()){
		
		var list = new Array();  // 지급항목 리스트
		
		$("#pay_list tr").each(function(i, value){
			var map = {
				SAL_DATE      : $("#SAL_DATE").val().trim(),
			    AMOUNT        : $(this).find('input[id^=AMOUNT_]').val().replace(/,/g, ""),
			    PAY_DEDUC     : 'PAY',
			    PAY_DEDUC_DTL : $(this).find('select[id^=PAY]').val()
			};
			list.push(map);
		});
		
		
		$("#ded_list tr").each(function(i, value){
			var map = {
				SAL_DATE      : $("#SAL_DATE").val().trim(),
			    AMOUNT        : $(this).find('input[id^=AMOUNT_]').val().replace(/,/g, ""),
			    PAY_DEDUC     : 'DED',
			    PAY_DEDUC_DTL : $(this).find('select[id^=DED]').val()
			};
			list.push(map);
		});
		
		var param = {
		    'list' : JSON.stringify(list)
		}
		
		if(SAL_SEQ != null && typeof SAL_SEQ != 'undefined' && SAL_SEQ.trim().length != 0){
			param.SAL_SEQ =  SAL_SEQ;
		}
		
 		$.ajax({
		    type : 'post',
		    url  : '/asset/saveSalaryList', 
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



function goDel(type){
    let target = type == 'PAY' ? 'pay_list' : 'ded_list';
	var len = $("#" + target).children().find("input[type='checkbox']:checked").length;
	if(len > 0){
		$("#" + target).children().find("input[type='checkbox']:checked").each(function(i, val){
			$(this).closest('tr').remove();
		});
	}else{
		alert('<spring:message code="com.msg.unselected"/>');   //  선택된 내역이 없습니다.
	}
	calTotal(type);
}


function goAdd(type){
	
    let targetElement = '';	
	 
	if(type ==  'PAY'){
		targetElement = 'pay_list';
	}else{
		targetElement = 'ded_list';
	}
	
	var html = "";
	    html += '<tr>';
	    html += '	<td scope="col" align="center"><input type="checkbox"></td>';
	    html += '	<td scope="col" align="center">';
	    html += '        <select id="' + type + '_' +  trCnt + '" style="width:150px;">';
	    var codeList = getPayDeducDtlList(type);
	    html += '             <option value=""><spring:message code="com.txt.optionSelect"/></option>';
    	for(var i=0; i<codeList.length; i++){
		html += '             <option value="' + codeList[i].CODE_CD + '">' + codeList[i].CODE_NM + '</option>';
    	}
	    html += '        </select>'; 
	    html += '   </td>'; 
	    html += '   <td scope="col" align="center"><input id="AMOUNT_' + type + '_' + trCnt + '" onChange="numberCheck(this.id, this.value);" type="text"></td>';    
	    html += '</tr>';
	    
	trCnt++;
	$("#" + targetElement).append(html);
	    
}

function numberCheck(id, value){
	value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
	$("#" + id ).val(value);
	var type = id.split('_')[1];
	calTotal(type);
}


function getPayDeducDtlList(type){
	var l;
	var param = {
	   'type' : type
	};
	$.ajax({
	    type : 'get',
	    url : '/asset/payDeducDtlList', 
	    data : param,
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
		 $("#unearedList").children().find("input[type='checkbox']").attr("checked", true);
	}else{
		 $("#unearedList").children().find("input[type='checkbox']").attr("checked", false);
	}
}


function formCheck(){
	
	var chkPayDtl      = 0;
	var chkPayAmount   = 0;
	var chkDedDtl      = 0;
	var chkDedAmount   = 0;

	
    if($("#SAL_DATE").val().trim().length == 0 || $("#SAL_DATE").val() == null){
    	alert('<spring:message code="com.salary.chkSalDate"/>');  // 급여연월을 확인해주세요.
    	return false;
    }
	
	if($("#pay_list tr").length == 0 && $("#ded_list tr").length == 0){
		alert('<spring:message code="com.msg.chkAddList"/>');   // 추가할 내용이 없습니다.
		return false;
	}
	
	$("#pay_list tr").each(function(i, value){
		if($(this).find('select[id^=PAY]').val().trim().length == 0 || $(this).find('select[id^=PAY]').val() == null){
			chkPayDtl++;
		}
	});
	
	$("#pay_list tr").each(function(i, value){
		if($(this).find('input[id^=AMOUNT_]').val().trim().length == 0 || $(this).find('input[id^=AMOUNT_]').val() == null){
			chkPayAmount++;
		}
	});
	
	$("#ded_list tr").each(function(i, value){
		if($(this).find('select[id^=DED]').val().trim().length == 0 || $(this).find('select[id^=DED]').val() == null){
			chkDedDtl++;
		}
	});
	
	$("#ded_list tr").each(function(i, value){
		if($(this).find('input[id^=AMOUNT_]').val().trim().length == 0 || $(this).find('input[id^=AMOUNT_]').val() == null){
			chkDedAmount++;
		}
	});
	
	
	if(chkPayDtl + chkPayAmount + chkDedDtl + chkDedAmount == 0){
		return true;
	}else{
		var mesg = '';
		if(chkPayDtl > 0){
			mesg += '<spring:message code="com.salary.payCtg"/>';          // 지급항목
		}
		if(chkPayAmount > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.salary.payCtgAmount"/>';    // 지급항목 금액
		}
		if(chkDedDtl > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.salary.dedCtg"/>';          // 공제항목
		}
		if(chkDedAmount > 0){
			mesg == '' ? mesg += '' :  mesg += ',';
			mesg += '<spring:message code="com.salary.dedCtgAmount"/>';   // 공제항목 금액
		}
		alert(mesg + '<spring:message code="com.msg.pleaseChk"/>');       // ..를 확인해주세요.
		return false;
	} 
	
}

function callLastSalary(){
	$.ajax({
	    type : 'get',
	    url  : '/asset/callLastSalary', 
	    dataType : 'json', 
	    success : function(result) {
	    	if(result.result == 'success'){
				drawLastSaraly(result);	    		
	    	}else{
	    		if(result.list.length == 0){
	    			alert('<spring:message code="com.salary.alertNoLastSalary"/>');   // 가져올 수 있는 최근 급여내역이 없습니다.
	 	    		return;
	    		}else{
	    			alert('<spring:message code="com.msg.failToLoadList"/>');  // 목록을 가져오는데 실패하였습니다.
	 	    		return;
	    		}
	    	}
	    },
	    error : function(request, status, error) { 
	    }
	});
}

function calTotal(type){
	let target = type == 'PAY' ? 'pay_list' : 'ded_list';
	let total  = 0;
	$("#" + target).find("tr").each(function(i, val){
		total += Number($(this).find('input[id^=AMOUNT_]').val().replace(/,/g, ""));
	});
	total = total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','); 
	if(type == 'PAY'){
		$("#payTotalText").html('<spring:message code="com.salary.totalPayAmount"/>&nbsp;' + total);
	}else{
		$("#dedTotalText").html('<spring:message code="com.salary.totalDedAmount"/>&nbsp;' + total);
	}
}

function drawLastSaraly(result){
	
	$("#pay_list,#ded_list").empty();
	
	let pay_html  = '';
	let ded_html  = '';
	let list      = result.list;
	
	for(let i=0; i<list.length; i++){
		let text  = '';
            text += '<tr>';		
            text += '    <td scope="col" align="center"><input type="checkbox"></td>';		
            text += '    <td scope="col" align="center">';		
            text += '        <select id="' + list[i].PAY_DEDUC + '_" style="width:150px;">';		
			text += '    		<option value=""><spring:message code="com.txt.optionSelect"/></option>';
		    
			let optionList = list[i].PAY_DEDUC == 'PAY' ? result.paySelectList : result.dedSelectList;
			
			for(let j=0; j<optionList.length; j++){
		    text += '           <option value="' +  optionList[j].CODE_CD + '" ' + ( list[i].PAY_DEDUC_DTL == optionList[j].CODE_CD ? ' selected="selected">' : '>') +  optionList[j].CODE_NM + '</option>';
			}
		    text += '         </select>';
		    text += '   </td>';
		    text += '   <td scope="col" align="center"><input id="AMOUNT_' + list[i].PAY_DEDUC + '_' + ++trCnt + '" onChange="numberCheck(this.id, this.value);" type="text" value="' + list[i].AMOUNT + '"></td>';
		    text += '</tr>';
		    
		    if(list[i].PAY_DEDUC == 'PAY'){
		    	pay_html += text;
		    }else{
		    	ded_html += text;
		    }
	}
	
	$("#pay_list").append(pay_html);
	$("#ded_list").append(ded_html);
	
	calTotal('PAY');
	calTotal('DED');
}


function dupChkSalMonth(dateText){
	$.ajax({
	    type : 'get',
	    url  : '/asset/dupChkSalMonth', 
	    data : {
	    	SAL_DATE : dateText
	    },
	    dataType : 'json', 
	    success : function(result) {
	    	if(result.result == 'fail'){
	    		alert('<spring:message code="com.salary.alertAlreadyRegSalary"/>');  // 해당월에 등록된 급여내역이 이미 존재합니다.
	    		$("#SAL_DATE").val('');
	    	}
	    },
	    error : function(request, status, error) { 
	    }
	});
}

</script>
<body>

<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">${nav}</h5>
  </div>
</div>

<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.salary.salDate"/></div><!-- 급여연월 -->
    </div>
    <input type="text" class="form-control" id="SAL_DATE">
    <button id="lastMonthSal" onclick="javascript:callLastSalary();" type="button" class="btn btn-info" style="float: right; margin-left: 5px;"><spring:message code="com.salary.callLateMonthSalary"/></button><!-- 지난달 급여항목 가져오기 -->
    <button onclick="javascript:goSave();" type="button" class="btn btn-primary" style="float: right; margin-left: 5px;"><spring:message code="com.btn.save"/></button><!--저장 -->
  </div>
</div>


<!-- 급여관리  -->
<div class="panel panel-default" style="width: 100%; float:none;">
	<div class="table table-hover" style="width:48%; float: left;">	
		 <div class="panel panel-default" style="width: 100%; height: 8%;">
		 	<p id="payTotalText"><spring:message code="com.salary.totalPayAmount"/> 0</p> <!-- 총 지급액 : -->
			<button onclick="javascript:goAdd('PAY');" type="button" class="btn btn-success" style="float: right;  margin-left: 5px;"><spring:message code="com.salary.payCtgAdd"/></button><!-- 지급항목 추가 -->
			<button onclick="javascript:goDel('PAY');" type="button" class="btn btn-danger" style="float: right;"><spring:message code="com.salary.payCtgDel"/></button><!-- 지급항목 삭제 -->
		</div>
		<table id="pay_table" class="table">
		  <thead class="thead-dark" align="center">
		  	<tr>
		      <th scope="col" colspan="3"><spring:message code="com.salary.payCtg"/></th> <!-- 지급항목 -->
		    </tr>
		    <tr>
		      <th width="10%"><input type="checkbox" onclick="javascript:chkAll('PAY');"></th>
		      <th width="45%"><spring:message code="com.salary.ctg"/></th> <!-- 항목 -->
		      <th width="45%"><spring:message code="com.salary.amount"/></th> <!-- 금액 -->
		    </tr>
		  </thead>
		  <tbody id="pay_list">
		  	   <c:if test="${payList != null && payList != ''}">
		  	   		<c:forEach items="${payList}" var="item" varStatus="status">
		  	   			<tr>
		  	   				<td scope="col" align="center"><input type="checkbox"></td>
		  	   				<td scope="col" align="center">
		  	   					<select id="PAY_" style="width:150px;">
		  	   							<option value=""><spring:message code="com.txt.optionSelect"/></option>
		  	   						<c:forEach items="${paySelectList}" var="paySelectList">
		  	   							<option value="${paySelectList.CODE_CD}" <c:if test="${item.PAY_DEDUC_DTL == paySelectList.CODE_CD}">selected="selected"</c:if>>${paySelectList.CODE_NM}</option>
		  	   						</c:forEach>
		  	   					</select>
		  	   				</td>
		  	   				<td scope="col" align="center"><input id="AMOUNT_PAY_${status.count}" onChange="numberCheck(this.id, this.value);" type="text" value="<fmt:formatNumber value="${item.AMOUNT}" pattern="#,##0"/>"></td>
		  	   		    </tr>
		  	   		</c:forEach>
		  	   </c:if>
		  </tbody>
		</table>
	</div>
	
	<div class="table table-hover" style="width:48%; float: left; padding-left: 15px;">	
		<div class="panel panel-default" style="width: 100%; height: 8%;">
			<p id="dedTotalText"><spring:message code="com.salary.totalDedAmount"/> 0</p><!-- 총 공제액 : -->
			<button onclick="javascript:goAdd('DED');" type="button" class="btn btn-success" style="float: right; margin-left: 5px;"><spring:message code="com.salary.dedCtgAdd"/></button><!-- 공제항목 추가 -->
			<button onclick="javascript:goDel('DED');" type="button" class="btn btn-danger" style="float: right;"><spring:message code="com.salary.dedCtgDel"/></button><!-- 공제항목 삭제 -->
		</div>
		<table id="ded_table" class="table">
			  <thead class="thead-dark" align="center">
			    <tr>
			      <th colspan="3"><spring:message code="com.salary.dedCtg"/></th>  <!-- 공제항목 -->
			    </tr>
			    <tr>
			      <th width="10%"><input type="checkbox" onclick="javascript:chkAll('DED');"></th>
			      <th width="45%"><spring:message code="com.salary.ctg"/></th>    <!-- 항목 -->
			      <th width="45%"><spring:message code="com.salary.amount"/></th> <!-- 금액 -->
			    </tr>
			  </thead>
			  <tbody id="ded_list">
			  	<c:if test="${dedList != null && dedList != ''}">
		  	   		<c:forEach items="${dedList}" var="item" varStatus="status">
		  	   			<tr>
		  	   				<td scope="col" align="center"><input type="checkbox"></td>
		  	   				<td scope="col" align="center">
		  	   					<select id="DED_" style="width:150px;">
		  	   							<option value=""><spring:message code="com.txt.optionSelect"/></option>
		  	   						<c:forEach items="${dedSelectList}" var="dedSelectList">
		  	   							<option value="${dedSelectList.CODE_CD}" <c:if test="${item.PAY_DEDUC_DTL == dedSelectList.CODE_CD}">selected="selected"</c:if>>${dedSelectList.CODE_NM}</option>
		  	   						</c:forEach>
		  	   					</select>
		  	   				</td>
		  	   				<td scope="col" align="center"><input id="AMOUNT_DED_${status.count}" onChange="numberCheck(this.id, this.value);" type="text" value="<fmt:formatNumber value="${item.AMOUNT}" pattern="#,##0"/>"></td>
		  	   		    </tr>
		  	   		</c:forEach>
		  	  	 </c:if>
			  </tbody>
		</table>
	</div>
</div>
</body>    
</html>
