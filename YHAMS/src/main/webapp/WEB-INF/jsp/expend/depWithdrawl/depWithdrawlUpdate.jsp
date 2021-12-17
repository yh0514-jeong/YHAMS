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
<script type="text/javascript">

    var ACT_SEQ = '${result.ACT_SEQ}';

	$(document).ready(function(){
		$("#ACT_DATE").datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', '${result.ACT_DATE}');
	});


	function updateDepWithdrawl(){
		
		let datePattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

		if(!datePattern.test($("#ACT_DATE").val().trim())){
			alert('<spring:message code="com.depwithdral.chkActDate"/>');   // 날짜 형식을 다시 한 번 확인해주세요.
			return;
		}
		
		if($("#ACCOUNT_CD").val().trim().length == 0){
			alert('<spring:message code="com.depwithdral.chkAccount"/>');    // 계좌를 확인해주세요.
			return;
		}
		
		if(isNaN($("#DEPOSIT_TOTAL").val().trim().replace(/,/g, ""))){
			alert('<spring:message code="com.depwithdral.chkDepTotal"/>');     // 입금액을 확인해주세요.
			return;
		}
		
		if(isNaN($("#WITHDRL_TOTAL").val().trim().replace(/,/g, ""))){
			alert('<spring:message code="com.depwithdral.chkWithTotal"/>');     // 지출액을 확인해주세요.
			return;
		}
		
		if($("#DESCRIPT").val().trim().length == 0){
			alert('<spring:message code="com.depwithdral.chkDescript"/>');    // 입출금사유를 확인해주세요.
			return;
		}
		
		if($("#DW_CATE1").val().trim().length == 0){
			alert('<spring:message code="com.depwithdral.chkDwCate1"/>');    // 대분류 항목을 확인해주세요.
			return;
		}
		
		if($("#DW_CATE2").val().trim().length == 0){
			alert('<spring:message code="com.depwithdral.chkDwCate2"/>');    // 소분류 항목을 확인해주세요.
			return;
		}
		
		var param = {
				ACT_SEQ       : ACT_SEQ,
				ACT_DATE      : $("#ACT_DATE").val().trim(),
				ACCOUNT_CD    : $("#ACCOUNT_CD").val().trim(),
				DEPOSIT_TOTAL : $("#DEPOSIT_TOTAL").val().trim().replace(/,/g, ""),
				WITHDRL_TOTAL : $("#WITHDRL_TOTAL").val().trim().replace(/,/g, ""),
				DESCRIPT      : $("#DESCRIPT").val().trim(),
				DW_CATE1      : $("#DW_CATE1").val().trim(),
				DW_CATE2      : $("#DW_CATE2").val().trim()
		}

		$.ajax({
		    type : 'post',
		    url : '/expend/updateDepWithdrawl', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		        if(result.result == "success"){
			        alert('<spring:message code="com.msg.updateSuccess"/>');    // 수정 성공!
			        opener.parent.list(1); 
			        window.close();
		        }else{
		        	alert('<spring:message code="com.msg.updatefail"/>');  // 수정 실패!
		        }
		    },
		    error : function(request, status, error) { 
		        alert('<spring:message code="com.msg.updatefail"/>');  // 수정 실패!
		    }
		});		
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
		    html += '<option value=""><spring:message code="com.txt.optionSelect"/></option>';
		for(var i=0; i<list.length; i++){
			html += '<option value="' + list[i].CODE_CD + '">' + list[i].CODE_NM + '</option>';
	   	}
		$("#" + targetId).empty();
		$("#" + targetId).append(html);
	}
	

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">${nav}</h5>
  </div>
</div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.actDate"/></label><!-- 날짜 -->
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="ACT_DATE" value=""> 
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.account"/></label><!-- 계좌 -->
	    <div class="col-sm-10">
	      <select id="ACCOUNT_CD" class="form-select" aria-label="Default select example">
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${accounCdList}" var="item">
	          		<option value="${item.ACCOUNT_CD}" <c:if test ="${result.ACCOUNT_CD eq item.ACCOUNT_CD}"> selected="selected"</c:if>>${item.ACCOUNT_NM}</option>
	          </c:forEach>
			</select>
    	</div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.depTotal"/></label><!-- 입금액 -->
	    <div class="col-sm-10">
	       <input type="text" class="form-control" id="DEPOSIT_TOTAL" value="${result.DEPOSIT_TOTAL}" onchange="javascript:numberCheck(this.id, this.value);"> 
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.withTotal"/></label><!-- 지출액 -->
	    <div class="col-sm-10">
	       <input type="text" class="form-control" id="WITHDRL_TOTAL" value="${result.WITHDRL_TOTAL}" onchange="javascript:numberCheck(this.id, this.value);"> 
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.descript"/></label><!-- 입출금사유 -->
	    <div class="col-sm-10">
	       <input type="text" class="form-control" id="DESCRIPT" value="${result.DESCRIPT}">
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.dwCate1"/></label><!-- 대분류 -->
	    <div class="col-sm-10">
	      <select id="DW_CATE1" class="form-select" aria-label="Default select example" onchange="javascript:setDwCate2('DW_CATE2', this.value);">
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${dwCate1List}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.DW_CATE1 eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.depwithdral.dwCate2"/></label><!-- 수입분류 -->
	    <div class="col-sm-10">
	      <select id="DW_CATE2" class="form-select" aria-label="Default select example">
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${dwCate2List}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.DW_CATE2 eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
    	</div>
	</div>
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateDepWithdrawl();" type="button" class="btn btn-primary"><spring:message code="com.txt.update"/></button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary"><spring:message code="com.btn.close"/></button> <!-- 닫기 -->
</div>
</body>    
</html>
