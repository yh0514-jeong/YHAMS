<%@ include file="../include/include-header.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
   <meta charset="utf-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>YHAMS Main</title>
<style>
  body {
    margin: 0;
    font-family: "Lato", sans-serif;
  }
  
  .sidebar {
    margin: 0;
    padding: 0;
    width: 200px;
    background-color: #f1f1f1;
    position: fixed;
    height: 100%;
    overflow: auto;
  }
  
  .sidebar a {
    display: block;
    color: black;
    padding: 16px;
    text-decoration: none;
  }
   
  .sidebar a.active {
    background-color: #04AA6D;
    color: white;
  }
  
  .sidebar a:hover:not(.active) {
    background-color: #555;
    color: white;
  }
  
  div.content {
    margin-left: 200px;
    padding: 1px 16px;
    height: 1000px;
  }
  
  @media screen and (max-width: 700px) {
    .sidebar {
      width: 100%;
      height: auto;
      position: relative;
    }
    .sidebar a {float: left;}
    div.content {margin-left: 0;}
  }
  
  @media screen and (max-width: 400px) {
    .sidebar a {
      text-align: center;
      float: none;
    }
  }
  </style>
</head>
<script type="text/javascript">

    var menu = '${menuList}';

	$(document).ready(function(){
		
		$("#subMenu").hide();
		
	});
	
	function drawTopMenu(){
		$("#menu").empty();
		if(menu != null && typeof menu != 'undefined'){
			var html = "";
			for(var i=0; i<menu.length; i++){
				html += '<li class="nav-item">';
				html += '    <a class="nav-link active" style="cursor:pointer;" aria-current="page" name="' + menu[i].MENU_ID + '">' + menu[i].MENU_NM + '</a>';
				html += '</li>';
			}
			$("#menu").append(html);
		}
	}
	
	function drawLeftMenu(parMenuId){
		
		$("#pageload").empty();
		if(parMenuId != null && typeof parMenuId != 'undefined'){
			var param = {
				'PAR_MENU_ID' : parMenuId
			};
			$.ajax({
			    type : 'get',
			    url  : '/getSubMenuList', 
			    dataType : 'json', 
			    data : param,
			    success : function(result) { 
			    	$("#subMenu").show();
			    	$("#subMenu").empty();
			    	var html = "";
			    	for(var i=0; i<result.length; i++){
			    		html += "<a onclick='javascript:pageLoad(this);' style='cursor:pointer;' url='" + result[i].MENU_URL + "'>" + result[i].MENU_NM + "</a>";
			    	}
			    	$("#subMenu").append(html);
			    	$("#subMenu").children().eq(0).click();
			    },
			    error : function(request, status, error) { 
			    }
			});
			
		}
	}
	
	function pageLoad(selectedMenu){
		var url = $(selectedMenu).attr("url");
		 $("#pageload").load(url);
	}

</script>
<body>
       <nav class="navbar navbar-expand-xl navbar-dark bg-success fixed-top" style="background-color: blueviolet;">
           <a class="navbar-brand" href="#"><img src="img/logo.png" style="width: 30%; margin-left: 15px;"></a>
           <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menues" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
               <span class="navbar-toggler-icon"></span>
           </button>
             <div class="collapse navbar-collapse">
               <ul class="navbar-nav" id="menu">	
               		<c:forEach items="${menuList}" var="item">
               			<li class="nav-item">                                                                                     
               			    <a onclick="javascript:drawLeftMenu(this.id);" class="nav-link active" aria-current="page" id="${item.MENU_ID}" style="cursor: pointer;">${item.MENU_NM}</a>
               			</li>                                                                                                      
               		</c:forEach>
               </ul>
             </div>
       </nav>

       <div id="subMenu" class="sidebar" style="padding-top: 71px;">
       </div>
        
       <div id="pageload" class="content" style="padding-top: 84px;">
       </div>
</body>    
</html>
