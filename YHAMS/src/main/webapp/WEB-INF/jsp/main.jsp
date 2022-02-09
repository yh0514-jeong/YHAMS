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
       width: 43%;
       height: 43%;
       float: left;
   }
   #charts2{
       width: 50%;
       height: 43%;
       float: right;
       padding-bottom: 10%;
   }
   #charts3{
       width: 50%;
       height: 43%;
       float: right;
       padding-top: 4%;
   }
</style>
</head>
<script type="text/javascript">

	let sc, ac, asc;
	let salChart, acChart, ascChart;

    let menu = '${menuList}';

	$(document).ready(function(){
		$("#mainArea").show();
		$("#menuArea").hide();
		$("#subMenu").hide();
		loadChartData();
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
		loadChartData();
	}
	
	
	function loadChartData(){
		
		$.ajax({
		    type : 'get',
		    url  : '/dashboard/getStatistics', 
		    dataType : 'json', 
		    success : function(result) {
		    	drawChart(result);
		    },
		    error : function(request, status, error) { 
		    }
		});
		
	}
	
	
	function drawChart(data){
		
		  asc = document.getElementById('asseetConsistChart').getContext('2d');
		  ascChart = new Chart(asc, {
			    //type: 'pie',
			    type: 'doughnut',
			    plugins:[ ChartDataLabels,
				    	{
				    	    id: 'text',
				    	    beforeDraw: function(chart, a, b) {
					    	      var width  = chart.width,
					    	          height = chart.height,
					    	          ctx    = chart.ctx;
					    	      ctx.restore();
					    	      var fontSize = (height / 400).toFixed(2);
					    	      ctx.font = fontSize + "em sans-serif";
					    	      ctx.textBaseline = "middle";
					    	      
					    	      let sum = 0;
					    	      for(let i=0; i<data.assetConsistList.value.length; i++){
					    	    	  sum += data.assetConsistList.value[i];
					    	      }
					    	      var text = "총액\n";
					    	    	  text += sum.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
					    	    	  text += "원";
					    	          textX = Math.round((width - ctx.measureText(text).width) / 2),
					    	          textY = height / 1.8;
					    	      ctx.fillText(text, textX, textY);
					    	      ctx.save();
				    	    }
			    	   }
			    ],
		        data: {
		            labels: data.assetConsistList.label,
		            datasets: [{
		            	data: data.assetConsistList.value,
		            	datalabels : {
		            		 labels: {
		            	          name: {
			            	            align: 'top',
			            	            font: {
			            	            	color : 'black',
			            	            	weight : 'bold',
			            	            	size: 13
			            	            },
			            	            formatter: function(value, ctx) {
			            	               return ctx.chart.data.labels[ctx.dataIndex];
			            	            }
		            	          },
		            	          value: {
			            	            align: 'bottom',
			            	            backgroundColor: 'black',
			            	            borderColor: 'white',
			            	            borderWidth: 2,
			            	            borderRadius: 5,
			            	            color: 'white',
			            	            formatter: function(value, ctx) {
			            	              return value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");	
			            	            },
			            	            padding: 4
		            	         }
	            	        }
		            	},
		            	aspectRatio: 4 / 3,
		            	cutoutPercentage: 32,
		            	layout: {
		            	      padding: 32
		            	},
		            	elements: {
	            	       line: {
	            	         fill: false
	            	       },
	            	       point: {
	            	         hoverRadius: 7,
	            	         radius: 5
	            	       }
		            	},
		                borderWidth: 1,
		                backgroundColor: [
		                    'rgb(201, 203, 207)',
		                    'rgb(75, 192, 192)',
		                    'rgb(255, 205, 86)',
		                	'rgb(255, 99, 132)',
		                    'rgb(54, 162, 235)',
		                    'rgb(197, 54, 236)',
		                    'rgb(131, 210, 239)'
			           ]
		            }]		           
		        },
		        options: {
			 	    plugins: {
			 	    	title: {
		                     display: true,
		                     text: '나의자산구성',
		                     font : {
		                     	size : 20
		                     }
		                 },
		                 legend : {
		                 	display : true,
			             	position : 'top'
			             }
		             }
			     }
		    });
		  
		// 자산추이 
		sc = document.getElementById('assetChart').getContext('2d');
	    salChart = new Chart(sc, {
	        data: {
	            labels: data.labels,
	            datasets: [
		            	{
		            	  data: data.salaryStatList,
		            	  type: 'bar',
			              backgroundColor: 'rgba(181, 236, 255, 0.8)',
			              label : '급여액',
			              borderWidth: 1
		               },
		               {
		            	  data: data.unearnedStatList,
		            	  type: 'bar',
			              backgroundColor: 'rgba(125, 219, 253, 0.8)',
			              label : '불로소득액',
			              borderWidth: 1
		               },
           			   {
			              data:  data.assetStatList,
			              type: 'bar',
	 		              backgroundColor: 'rgb(32, 193, 252, 0.8)',
	     		          label : '자산총액',
	     		          borderWidth: 1
 		         	   }
	            ]
	        },
	        options: {
	            scales: {
	                y: {
	                    beginAtZero: false
	                }
	            },
	            plugins: {
	                title: {
	                    display: true,
	                    text: '자산추이',
	                    font : {
	                    	size : 20
	                    }
	                },
	                legend : {
	                	display : true,
		            	position : 'top'
		            }
	        	}
	    	}
		  }); 
		
		 
		 // 지출추이
	     ac = document.getElementById('expendChart').getContext('2d');
		 acChart = new Chart(ac, {
		 	type: 'bar',
		     data: {
		         labels: data.labels,
		         datasets: [{
		             data: data.assetStatList,
		             backgroundColor: 'rgba(255, 99, 132, 0.2)',
		             label : '지출총액',
		             borderWidth: 1
		         }]
		     },
		     options: {
		 	    plugins: {
		 	    	title: {
	                     display: true,
	                     text: '지출추이',
	                     font : {
	                     	size : 20
	                     }
	                 },
	                 legend : {
	                 	display : true,
		             	position : 'top'
		             }
	             }
		     }
		 });
	}
	
function logout(){
	if(confirm('로그아웃 하시겠습니까?')){
		window.location.href = "/logout";
	}else{
		return;
	}
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
             <img src="/img/logout.svg" style="padding-right: 3%; cursor: pointer; height: 50px; width: 70px;" onclick="javascript : logout();" alt="로그아웃">                                                                            
       </nav>
 
	   <div id="mainArea"  style="padding-top: 73px;"> <!-- Main Chart List -->
	        <div id="charts1">
	            <canvas id="asseetConsistChart"></canvas>
	        </div>
	        <div id="charts2">
	            <canvas id="assetChart"></canvas>
	        </div>
		    <div id="charts3">
	            <canvas id="expendChart"></canvas>
	        </div>
	   </div>
	   
	   <div id="menuArea"  style="padding-top: 73px;"> <!-- Menu List -->
	   	  <div id="subMenu" class="sidebar"> <!--  style="padding-top: 71px;" -->
       	  </div>
        
	       <div id="pageload" class="content"> <!--  style="padding-top: 84px;" -->
	       </div>
	   </div>
	   
</body>    
</html>
