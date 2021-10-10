<%@ include file="../include/include-header.jspf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
   <meta charset="utf-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>YHAMS 자산관리시스템</title>
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
  
   #charts1{
       width: 48%;
       height: 48%;
       float: left;
   }
   #charts2{
       width: 48%;
       height: 48%;
       float: left;
   }
   #charts3{
       width: 48%;
       height: 48%;
       float: left;
   }
   #charts4{
       width: 48%;
       height: 48%;
       float: left;
   }
</style>
</head>
<script type="text/javascript">

    var menu = '${menuList}';

	$(document).ready(function(){
		$("#mainArea").show();
		$("#menuArea").hide();
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
		
		$("#menuArea").show();
		$("#mainArea").hide();
		
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
	
	function goMain(){
		$("#menuArea").hide();
		$("#mainArea").show();
	}
</script>
<body>
       <nav class="navbar navbar-expand-xl navbar-dark bg-success fixed-top" style="background-color: blueviolet;">
           <a class="navbar-brand" href="#"><img src="img/logo.png" style="width: 30%; margin-left: 15px;" onclick="goMain();"></a>
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
 
	   <div id="mainArea"  style="padding-top: 73px;"> <!-- Main Chart List -->
		    <div id="charts1">
	            <canvas id="myChart"></canvas>
	        </div>
	        <div id="charts2">
	            <canvas id="myChart2"></canvas>
	        </div>
	        <div id="charts3">
	            <canvas id="myChart3"></canvas>
	        </div>
	        <div id="charts4">
	            <canvas id="myChart4"></canvas>
	        </div>
	   </div>
	   
	   <div id="menuArea"  style="padding-top: 73px;"> <!-- Menu List -->
	   	  <div id="subMenu" class="sidebar"> <!--  style="padding-top: 71px;" -->
       	  </div>
        
	       <div id="pageload" class="content"> <!--  style="padding-top: 84px;" -->
	       </div>
	   </div>
	   
	   
	   <script>
	   var ctx = document.getElementById('myChart').getContext('2d');
	    var myChart = new Chart(ctx, {
	        type: 'bar',
	        data: {
	            labels: ['4월', '5월', '6월', '7월', '8월', '9월'],
	            datasets: [{
	                data: [12, 19, 3, 5, 2, 3],
	                backgroundColor: [
	                    'rgba(255, 99, 132, 0.2)',
	                    'rgba(54, 162, 235, 0.2)',
	                    'rgba(255, 206, 86, 0.2)',
	                    'rgba(75, 192, 192, 0.2)',
	                    'rgba(153, 102, 255, 0.2)',
	                    'rgba(255, 159, 64, 0.2)'
	                ],
	                borderColor: [
	                    'rgba(255, 99, 132, 1)',
	                    'rgba(54, 162, 235, 1)',
	                    'rgba(255, 206, 86, 1)',
	                    'rgba(75, 192, 192, 1)',
	                    'rgba(153, 102, 255, 1)',
	                    'rgba(255, 159, 64, 1)'
	                ],
	                borderWidth: 1
	            }]
	        },
	        options: {
	            scales: {
	                y: {
	                    beginAtZero: true
	                }
	            },
	            animations: {
	                tension: {
	                    duration: 1000,
	                    easing: 'linear',
	                    from: 1,
	                    to: 0,
	                    loop: true
	                }
	            },
	            plugins: {
	                title: {
	                    display: true,
	                    text: '급여 추이'
	                }
	            },
	            legend : {
	            	display : false
	            }
	        }
	    });

		var ctx1 = document.getElementById('myChart2').getContext('2d');
		var myChart = new Chart(ctx1, {
		    type: 'line',
		    data: {
		        labels: ['4월', '5월', '6월', '7월', '8월', '9월'],
		        datasets: [{
		            data: [12, 19, 3, 5, 2, 3],
		            backgroundColor: [
		                'rgba(255, 99, 132, 0.2)',
		                'rgba(54, 162, 235, 0.2)',
		                'rgba(255, 206, 86, 0.2)',
		                'rgba(75, 192, 192, 0.2)',
		                'rgba(153, 102, 255, 0.2)',
		                'rgba(255, 159, 64, 0.2)'
		            ],
		            borderColor: [
		                'rgba(255, 99, 132, 1)',
		                'rgba(54, 162, 235, 1)',
		                'rgba(255, 206, 86, 1)',
		                'rgba(75, 192, 192, 1)',
		                'rgba(153, 102, 255, 1)',
		                'rgba(255, 159, 64, 1)'
		            ],
		            borderWidth: 1
		        }]
		    },
		    options: {
		        scales: {
		            y: {
		                beginAtZero: true
		            }
		        },
			    plugins: {
	                title: {
	                    display: true,
	                    text: '자산 변화'
	                }
	            },
	            legend: {
	                display: false
	            },
	            tooltips: {
	                callbacks: {
	                   label: function(tooltipItem) {
	                          return tooltipItem.yLabel;
	                   }
	                }
	            }
		    }
		});

	    var ctx2 = document.getElementById('myChart3').getContext('2d');
	    var myChart = new Chart(ctx2, {
	        type: 'line',
	        data: {
	            labels: ['4월', '5월', '6월', '7월', '8월', '9월'],
	            datasets: [{
	                data: [12, 19, 3, 5, 2, 3],
	                backgroundColor: [
	                    'rgba(255, 99, 132, 0.2)',
	                    'rgba(54, 162, 235, 0.2)',
	                    'rgba(255, 206, 86, 0.2)',
	                    'rgba(75, 192, 192, 0.2)',
	                    'rgba(153, 102, 255, 0.2)',
	                    'rgba(255, 159, 64, 0.2)'
	                ],
	                borderColor: [
	                    'rgba(255, 99, 132, 1)',
	                    'rgba(54, 162, 235, 1)',
	                    'rgba(255, 206, 86, 1)',
	                    'rgba(75, 192, 192, 1)',
	                    'rgba(153, 102, 255, 1)',
	                    'rgba(255, 159, 64, 1)'
	                ],
	                borderWidth: 1
	            }]
	        },
	        options: {
	            scales: {
	                y: {
	                    beginAtZero: true
	                }
	            },
	            animations: {
	                tension: {
	                    duration: 1000,
	                    easing: 'linear',
	                    from: 1,
	                    to: 0,
	                    loop: true
	                }
	            },
			    plugins: {
	                title: {
	                    display: true,
	                    text: '지출 추이'
	                }
	            },
	            legend: {
	                display: false
	            },
	            tooltips: {
	                callbacks: {
	                   label: function(tooltipItem) {
	                          return tooltipItem.yLabel;
	                   }
	                }
	            }
	        }
	    });

		var ctx3 = document.getElementById('myChart4').getContext('2d');
		var myChart = new Chart(ctx3, {
		    type: 'bar',
		    data: {
		        labels: ['4월', '5월', '6월', '7월', '8월', '9월'],
		        datasets: [{
		            label: '금액',
		            data: [12, 19, 3, 5, 2, 3],
		            backgroundColor: [
		                'rgba(255, 99, 132, 0.2)',
		                'rgba(54, 162, 235, 0.2)',
		                'rgba(255, 206, 86, 0.2)',
		                'rgba(75, 192, 192, 0.2)',
		                'rgba(153, 102, 255, 0.2)',
		                'rgba(255, 159, 64, 0.2)'
		            ],
		            borderColor: [
		                'rgba(255, 99, 132, 1)',
		                'rgba(54, 162, 235, 1)',
		                'rgba(255, 206, 86, 1)',
		                'rgba(75, 192, 192, 1)',
		                'rgba(153, 102, 255, 1)',
		                'rgba(255, 159, 64, 1)'
		            ],
		            borderWidth: 1
		        }]
		    },
		    options: {
		        scales: {
		            y: {
		                beginAtZero: true
		            }
		        },
		        animations: {
		            tension: {
		                duration: 1000,
		                easing: 'linear',
		                from: 1,
		                to: 0,
		                loop: true
		            }
		        }
		    }
		});
	   </script>
	   
</body>    
</html>
