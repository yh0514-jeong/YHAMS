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


function deleteMappedUser(target){
	$(target).closest('tr').remove();
}

function addMenuMapp(){
    
	var length = $('#allMenuList tr input[type="checkbox"]:checked').length;
	
	if(length == 0){
		alert('선택된 사용자가 없습니다.');
		return;
	}else{
		var alreadyAddedList = new Array();
		
		$("#addedUserList tr img").each(function(){
			alreadyAddedList.push($(this).attr("userId"));
		});
		
		var toBeAddList = '';
		var html        = '';
		
		$('#allUserList tr input[type="checkbox"]:checked').each(function(index) {
			 var userId   = $(this).closest('tr').find('input[type="checkbox"]').val();
			 var userInfo = $(this).closest('tr').find('td').eq(1).text();
			 if(alreadyAddedList.indexOf($(this).val()) == -1){
	       		 html += '<tr>';
	       		 html += '	 <td><img src="/img/x-lg.svg" userId="' + userId + '" onclick="javascript:deleteMappedUser(this);" style="cursor: pointer;"></td>';
	       		 html += '	 <td>' + userInfo + '</td>';
	       		 html += '</tr>';
	       	 }else{
	       		 alert('이미 추가되어 있는 사용자입니다.');
	       		 return false;
	       	 }
	    });
		$("#addedUserList").append(html);
	}
	$('#allUserList tr input[type="checkbox"]').prop("checked", false);
}

function searchUser(){
	var searchContent = $("#SEARCH_USER").val();
	
	if(searchContent.trim().length == 0){
		alert('검색어를 입력해주세요.');
		return;
	}else{
		var param = {
		    searchContent : searchContent	
		};
		
		$.ajax({
		    type : 'post',
		    url : '/user/getUserList', 
		    dataType : 'json', 
		    data : param,
		    success : function(result) { 
		    },
		    error : function(request, status, error) { 
		    }
		});
	}
	
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
	    url : '/role/updateRoleUserMap', 
	    dataType : 'json', 
	    data : param,
	    success : function(result) { 
	        if(result.resultCode == "success"){
	        	alert('저장성공!');
	        	opener.parent.list(); 
	        	window.close();
	        }else{
	        	alert('저장실패!');
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
    <h5 class="panel-title">권한 - 사용자 매핑관리<h6 class="panel-title">${roleMap.ROLE_NM}(${roleMap.ROLE_ID})</h6></h5>
    
  </div>
</div>

<!-- 전체 메뉴리스트 -->
<div style="float:left; width: 45%;  height: 70%;">
	<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
	  <div class="input-group">
	    <div class="input-group-prepend">
	      <div class="input-group-text" id="btnGroupAddon">사용자</div>
	    </div>
	    <input type="text" class="form-control" id="SEARCH_USER" placeholder="사용자 ID 혹은 사용자명" style="width: 240px;">
	  </div>
	  &nbsp;
	  <button type="button" class="btn btn-primary" onclick="javascript:searchUser();" type="button">검색</button>
	</div>	
	<div class="table table-hover">	
		<table class="table">
		  <thead class="thead-dark" align="center">
		    <tr>
		      <th scope="col"></th>
		       <th scope="col">사용자</th>
		    </tr>
		  </thead>
		  <tbody id="allMenuList">
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
		      <th scope="col">사용자</th>
		    </tr>
		  </thead>
		  <tbody id="addedUserList">
		  	<c:forEach items="${roleUserMapList}" var="item">
		  		<tr>
		  		  <td><img src="/img/x-lg.svg" userId="${item.USER_ID}" onclick="javascript:deleteMappedUser(this);" style="cursor: pointer;"></td>
		  		  <td>${item.USER_INFO}</td>
		  		</tr>
		  	</c:forEach>
		  </tbody>
		</table>
	</div>
</div>

</body>    
</html>
