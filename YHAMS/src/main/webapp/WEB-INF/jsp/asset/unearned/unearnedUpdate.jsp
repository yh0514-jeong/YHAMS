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

    var UED_SEQ = '${result.UED_SEQ}';

	$(document).ready(function(){
		$("#UED_DATE").datepicker({dateFormat: 'yy-mm-dd'}).datepicker('setDate', '${result.UED_DATE}');
	});


	function updateUneared(){
		
		let pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

		if(!pattern.test($("#UED_DATE").val().trim())){
			alert('<spring:message code="com.unearned.chkUenDateForm"/>');   // 수입일의 날짜 형식을 확인해주세요.
			return;
		}
		
		if($("#UED_DATE").val().trim().length == 0){
			alert('<spring:message code="com.unearned.chkUenDate"/>');    // 수입일을 확인해주세요.
			return;
		}
		
		if($("#UED_INCM").val().trim().length == 0){
			alert('<spring:message code="com.unearned.chkUenDate"/>');     // 금액을 확인해주세요.
			return;
		}
		
		if($("#UED_SOURCE").val().trim().length == 0){
			alert('<spring:message code="com.unearned.chkUenSource"/>');    // 수입처를 확인해주세요.
			return;
		}
		
		if($("#UED_CTG").val().trim().length == 0){
			alert('<spring:message code="com.unearned.chkUenCtg"/>');    // 수입분류를 확인해주세요.
			return;
		}
		
		var param = {
				UED_SEQ    : UED_SEQ,
				UED_DATE   : $("#UED_DATE").val().trim(),
				UED_INCM   : $("#UED_INCM").val().trim().replace(/,/g, ""),
				UED_SOURCE : $("#UED_SOURCE").val().trim(),
				UED_CTG    : $("#UED_CTG").val().trim()
		}

		$.ajax({
		    type : 'post',
		    url : '/asset/updateUnearned', 
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
	

</script>
<body>
<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">${nav}</h5>
  </div>
</div>
	<div class="row mb-3">
	    <label for="inputEmail3" class="col-sm-2 col-form-label"><spring:message code="com.unearned.uenDate"/></label><!-- 수입일 -->
	    <div class="col-sm-10">
	      <input type="text" class="form-control" id="UED_DATE" value=""> 
	    </div>
    </div>
    <div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.unearned.uenIncm"/></label><!-- 금액 -->
	    <div class="col-sm-10">
	       <input type="text" class="form-control" id="UED_INCM" value="${result.UED_INCM}" onChange="numberCheck(this.id, this.value);"> 
	    </div>
    </div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.unearned.uenSource"/></label><!-- 수입처 -->
	    <div class="col-sm-10">
	       <input type="text" class="form-control" id="UED_SOURCE" value="${result.UED_SOURCE}">
    	</div>
	</div>
	<div class="row mb-3">
	    <label for="inputPassword3" class="col-sm-2 col-form-label"><spring:message code="com.unearned.uenCtg"/></label><!-- 수입분류 -->
	    <div class="col-sm-10">
	      <select id="UED_CTG" class="form-select" aria-label="Default select example">
	          		<option value=""><spring:message code="com.txt.optionSelect"/></option>
	          <c:forEach items="${uedCtgList}" var="item">
	          		<option value="${item.CODE_CD}" <c:if test ="${result.UED_CTG eq item.CODE_CD}"> selected="selected"</c:if>>${item.CODE_NM}</option>
	          </c:forEach>
			</select>
    	</div>
	</div>
<div align="center" style="padding-top: 5%;">
	<button id="btnUpdate" onclick="javascript:updateUneared();" type="button" class="btn btn-primary"><spring:message code="com.txt.update"/></button> 
	<button id="btnDel" onclick="javascript:window.close();" type="button" class="btn btn-primary"><spring:message code="com.btn.close"/></button> <!-- 닫기 -->
</div>
</body>    
</html>
