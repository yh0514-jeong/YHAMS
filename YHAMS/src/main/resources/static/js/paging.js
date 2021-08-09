function drawPaging(param){
	$("#pagination").html('');
		let pageList = new Array();
		pageList = param.pageList;
		var html = '<nav aria-label="Page navigation example">';
		    html += '   <ul class="pagination">' ;
		if(param.isPrevExist == true){
		    html += '      <li class="page-item"><a class="page-link" href="javascript:setCurPage(' + parseInt(pageList[i])-1 + ')">Previous</a></li>';
		}
		for(var i=0; i<pageList.length; i++){
			html += '      <li class="page-item"><a class="page-link" href="javascript:setCurPage(' + parseInt(pageList[i]) + ')">'+ pageList[i]  + '</a></li>';		
		}	
		if(param.isNextExist == true){
			html += '      <li class="page-item"><a class="page-link" href="javascript:setCurPage(' + parseInt(pageList[i])+1 + ')">Next</a></li>';	
		}
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