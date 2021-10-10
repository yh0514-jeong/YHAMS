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
	$("#SAL_DATE").datepicker({
		changeMonth: true,
        changeYear: true,
        changeDate : false,
        showButtonPanel: true,
        dateFormat: 'yy년 mm월',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
	});		
});


function goSave(){
	if(formCheck()){
		var list = new Array();
		$("#unearedList > tr").each(function(i, value){
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
	var len = $("#unearedList").children().find("input[type='checkbox']:checked").length;
	if(len > 0){
		$("#unearedList").children().find("input[type='checkbox']:checked").each(function(i, val){
			$(this).closest('tr').remove();
		});
	}else{
		alert('<spring:message code="com.msg.unselected"/>');   //  선택된 내역이 없습니다.
	}
	$("#chkAll").attr("checked", false);
}

function goAdd(type){
	
    let targetElement = '';	
	 
	if(type ==  'pay'){
		targetElement = 'pay_list';
	}else{
		targetElement = 'ded_list';
	}
	
	var html = "";
	    html += '<tr>';
	    html += '	<td scope="col" align="center"><input type="checkbox"></td>';
	    html += '	<td scope="col" align="center">';
	    html += '        <select id="UED_CTG_' +  trCnt + '" style="width:150px;">';
	    var codeList = getPayDeducDtlList(type);
    	for(var i=0; i<codeList.length; i++){
		html += '             <option value="' + codeList[i].CODE_CD + '">' + codeList[i].CODE_NM + '</option>';
    	}
	    html += '        </select>'; 
	    html += '   </td>'; 
	    html += '   <td scope="col" align="center"><input id="AMOUNT_' + trCnt + '" onChange="numberCheck(this.id, this.value);" type="text"></td>';    
	    html += '</tr>';
	    
	trCnt++;
	$("#" + targetElement).append(html);
	    
}

function numberCheck(id, value){
	value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
	$("#" + id ).val(value);
}


function getPayDeducDtlList(type){
	var l;
	var param = {
	   
	};
	$.ajax({
	    type : 'get',
	    url : '/asset/uedCtgList', 
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
	
	var chkUedDate   = 0;
	var chkUedIncm   = 0;
	var chkUedSource = 0;
	var chkUedCtg    = 0;
	
	if($("#unearedList tr").length == 0){
		alert('<spring:message code="com.msg.chkAddList"/>');   // 추가할 내용이 없습니다.
		return false;
	}
	
	
	$("#unearedList").children().find("input[id^=UED_DATE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedDate++;
		}
	});
	
	$("#unearedList").children().find("input[id^=UED_INCM_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedIncm++;
		}
	});
	
	$("#unearedList").children().find("input[id^=UED_SOURCE_]").each(function(i, value){
		if($(this).val().trim().length == 0 || $(this).val() == null){
			chkUedSource++;
		}
	});
	
	$("#unearedList").children().find("input[id^=UED_CTG_]").each(function(i, value){
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
    <h5 class="panel-title">급여내역 등록</h5>
  </div>
</div>

<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
  <div class="input-group">
    <div class="input-group-prepend">
      <div class="input-group-text" id="btnGroupAddon">급여연월</div><!-- 급여연월 -->
    </div>
    <input type="text" class="form-control" id="SAL_DATE">
  </div>
</div>


<!-- 급여관리  -->
<div class="panel panel-default" style="width: 100%; float:none;">
	<div class="table table-hover" style="width:48%; float: left;">	
		 <div class="panel panel-default" style="width: 100%; height: 8%;">
			<button id="btnAdd" onclick="javascript:goAdd('pay');" type="button" class="btn btn-success" style="float: right;">지급항목 추가</button><!-- 지급항목 추가 -->
		</div>
		<table id="pay_table" class="table">
		  <thead class="thead-dark" align="center">
		  	<tr>
		      <th scope="col" colspan="3">지급항목</th>
		    </tr>
		    <tr>
		      <th width="10%"><input type="checkbox"></th>
		      <th width="45%">항목</th>
		      <th width="45%">금액</th>
		    </tr>
		  </thead>
		  <tbody id="pay_list">
		    
		  </tbody>
		</table>
	</div>
	
	<div class="table table-hover" style="width:48%; float: left; padding-left: 15px;">	
		<div class="panel panel-default" style="width: 100%; height: 8%;">
			<button id="btnAdd" onclick="javascript:goAdd('ded');" type="button" class="btn btn-danger" style="float: right;">공제항목 추가</button><!-- 공제항목 추가 -->
		</div>
		<table id="ded_table" class="table">
			  <thead class="thead-dark" align="center">
			    <tr>
			      <th colspan="3">공제항목</th>
			    </tr>
			    <tr>
			      <th width="10%"><input type="checkbox"></th>
			      <th width="45%">항목</th>
			      <th width="45%">금액</th>
			    </tr>
			  </thead>
			  <tbody id="ded_list">
			    
			  </tbody>
		</table>
	</div>
</div>
</body>    
</html>
