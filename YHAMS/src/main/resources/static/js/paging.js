function drawPaging(param){
	$("#pagination").html('');
		let pageList = new Array();
		pageList = param.pageList;
		var html = '<nav aria-label="Page navigation example">';
		    html += '   <ul class="pagination" style="justify-content: center;>' ;
		if(param.isPrevExist == true){
		    html += '      <li class="page-item"><a class="page-link" href="javascript:setCurPage(' + parseInt(pageList[i])-1 + ')">Previous</a></li>';
		}
		for(var i=0; i<pageList.length; i++){
			html += '      <li class="page-item"><a class="page-link" href="javascript:setCurPage(' + parseInt(pageList[i]) + ')">'+ pageList[i]  + '</a></li>';		
		}	
		if(param.isNextExist == true){
			html += '      <li class="page-item"><a class="page-link" href="javascript:setCurPage(' + parseInt(pageList[i])+1 + ')">Next</a></li>';	
		}
		html += "   &nbsp;&nbsp;";
		html += "   <select id='postPerPage' onchange='javascript:changePerPage(this.value);' style='float:center;'>";
		html += "        <option value='10'>10</option>";
		html += "        <option value='20'>20</option>";
		html += "        <option value='30'>30</option>";
		html += "        <option value='50'>50</option>";
		html += "        <option value='100'>100</option>";
		html += "   </select>";
		html += "  </ul>";
		html += "</nav>";
	$("#pagination").html(html);
}

function changePerPage(value){
	$("#curPage").val(1);
	$("#cntPerPage").val(value);
	list();
}

function setCurPage(page){
	$("#curPage").val(page);
	list();
}