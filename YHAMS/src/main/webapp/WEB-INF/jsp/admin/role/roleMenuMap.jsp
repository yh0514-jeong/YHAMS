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

var ROLE_ID  = "${roleMap.ROLE_ID}";
var ROLE_NM  = "${roleMap.ROLE_NM}";

$(document).ready(function() {
	
});


function deleteMappedMenu(target){
	$(target).closest('tr').remove();
}

function addMenuMapp(){
    
	var length = $('#allMenuList tr input[type="checkbox"]:checked').length;
	
	if(length == 0){
		alert('<spring:message code="com.menu.noSelected"/>');  // 선택된 메뉴가 없습니다.
		return;
	}else{
		var alreadyAddedList = new Array();
		
		$("#addedMenuList tr img").each(function(){
			alreadyAddedList.push($(this).attr("menuId"));
		});
		
		var toBeAddList = '';
		var html        = '';
		
		$('#allMenuList tr input[type="checkbox"]:checked').each(function(index) {
			 var menuId = $(this).closest('tr').find('input[type="checkbox"]').val();
			 var menuNm = $(this).closest('tr').find('td').eq(1).text();
			 if(alreadyAddedList.indexOf($(this).val()) == -1){
	       		 html += '<tr>';
	       		 html += '	 <td><img src="/img/x-lg.svg" menuId="' + menuId + '" onclick="javascript:deleteMappedMenu(this);" style="cursor: pointer;"></td>';
	       		 html += '	 <td>' + menuNm + '</td>';
	       		 html += '</tr>';
	       	 }else{
	       		 alert('<spring:message code="com.menu.alreadyAdded"/>');  // 이미 추가되어 있는 메뉴입니다.
	       		 return false;
	       	 }
	    });
		$("#addedMenuList").append(html);
	}
	$('#allMenuList tr input[type="checkbox"]').prop("checked", false);
}

function save(){
	
	var arr = '';
	
	$('#addedMenuList tr').each(function(idx) {
		if(idx == 0){
			arr += $(this).find('img').attr('menuId');
		}else{
			arr += ',' + $(this).find('img').attr('menuId');
		}
    });
	
	var param = {
	    ROLE_ID : ROLE_ID,
	    MENU_ID : arr
	};
	
	$.ajax({
	    type : 'post',
	    url : '/role/updateRoleMenuMap', 
	    dataType : 'json', 
	    data : param,
	    success : function(result) { 
	        if(result.resultCode == "success"){
	        	alert('<spring:message code="com.msg.saveSuccess"/>');  // 저장성공!
	        	opener.parent.list(1); 
	        	window.close();
	        }else{
	        	alert('<spring:message code="com.msg.saveFail"/>');  // 저장실패!
	        }
	    },
	    error : function(request, status, error) { 
	        alert('<spring:message code="com.msg.registerfail"/>');  // 등록 실패
	    }
	});
	
}

</script>
<body>

<div class="panel panel-default">
  <div class="panel-heading">
    <h5 class="panel-title">권한 - 메뉴 매핑관리<h6 class="panel-title">${roleMap.ROLE_NM}(${roleMap.ROLE_ID})</h6></h5>
    
  </div>
</div>

<!-- 전체 메뉴리스트 -->
<div style="float:left; width: 45%;  height: 70%;">
	<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
	  <div class="input-group">
	    <div class="input-group-prepend">
	      <div class="input-group-text" id="btnGroupAddon"><spring:message code="com.menu.menuNm"/></div>  <!-- 메뉴명 -->
	    </div>
	    <input type="text" class="form-control" id="ROLE_NM"  onkeyup="javascript:enterkey();">
	  </div>
	  &nbsp;
	  <button type="button" class="btn btn-primary" onclick="javascript:list(1);" type="button"><spring:message code="com.btn.search"/></button> <!-- 검색 -->
	</div>	
	<div class="table table-hover">	
		<table class="table">
		  <thead class="thead-dark" align="center">
		    <tr>
		      <th scope="col"></th>
		      <th scope="col"><spring:message code="com.menu.menuNm"/></th> <!-- 메뉴명 -->
		    </tr>
		  </thead>
		  <tbody id="allMenuList">
		  	<c:forEach items="${menuList}" var="item">
		  		<tr>
		  		  <td><input type="checkbox" value="${item.MENU_ID}"></td>
		  		  <td>${item.MENU_NM}</td>
		  		</tr>
		  	</c:forEach>
		  </tbody>
		</table>
	</div>
</div>


<div style="float:left; text-align:center; width: 10%; height: 70%; padding-top: 27%;">
    <img src="/img/arrow-right-square.svg" onclick="javascript:addMenuMapp();" style="cursor: pointer; width: 40px; vertical-align: middle; padding-bottom: 10px;">
</div>


<!-- 현재 권한에 추가되어 있는 메뉴 테이블 -->
<div style="float:right;  width: 45%; height: 70%;">
	<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups" style="float: right; padding-right: 10px;">
	  <button type="button" class="btn btn-success" onclick="javascript:save();" type="button">저장</button>
	</div>	
	<div class="table table-hover">
		<table class="table">
		  <thead class="thead-dark" align="center">
		    <tr>
		      <th scope="col"></th>
		      <th scope="col">메뉴명</th>
		    </tr>
		  </thead>
		  <tbody id="addedMenuList">
		  	<c:forEach items="${roleMenuMapList}" var="item">
		  		<tr>
		  		  <td><img src="/img/x-lg.svg" menuId="${item.MENU_ID}" onclick="javascript:deleteMappedMenu(this);" style="cursor: pointer;"></td>
		  		  <td>${item.MENU_NM}</td>
		  		</tr>
		  	</c:forEach>
		  </tbody>
		</table>
	</div>
</div>

</body>    
</html>
