<%@ include file="../../../include/include-header.jspf"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

	let STD_YEAR = '${STD_YEAR}';
	let trCnt = 0;

	$(document).ready(function() {
		if(STD_YEAR != null && STD_YEAR != ''){
			goAdd('${result}');
			$("#STD_YEAR").val(STD_YEAR).attr('disabled', true);
		}
	});

	function goSave() {

		var list = new Array();

		$("#yearlyAssetPlanList > tr").each(function(i, value) {
			$(this).find("input").each(function(j, value_j) {
				if ($(value_j).val().trim().length > 0) {
					let idsp = $(value_j).attr('id').split('__');
					let map = {
						STD_YEAR : $("#STD_YEAR").val(),
						STD_MONTH : idsp[2],
						MAIN_CTG : idsp[0],
						SUB_CTG : idsp[1],
						AMOUNT : $(value_j).val().replace(/,/g, "")
					};
					list.push(map);
				}
			});
		});

		var param = {
			'list' : JSON.stringify(list)
		}

		$.ajax({
			type : 'post',
			url : '/asset/saveYearlyAssetPlanList',
			dataType : 'json',
			data : param,
			success : function(result) {
				if (result.result == 'success') {
					alert('<spring:message code="com.msg.registerSuccess"/>'); // 등록 성공!!
					opener.parent.list(1);
					window.close();
				} else {
					alert('<spring:message code="com.msg.registerFail"/>'); // 등록 실패!
					return;
				}
			},
			error : function(request, status, error) {
				alert('<spring:message code="com.msg.registerfail"/>'); // 등록 실패
			}
		});
	}

	function goDel(btnId) {
		if(btnId == 'btnDelDb'){
			if(confirm('<spring:message code="com.yearlyAssetPlan.chkDeleteWhenDbExist"/>')){  // 데이터베이스에 저장된 하기 연자산계획이 삭제됩니다. 그래도 삭제하시겠습니까?
				let param = {};
				param.STD_YEAR = $("#STD_YEAR").val()
				$.ajax({
					type : 'post',
					url : '/asset/deleteYearlyAssetPlanList',
					dataType : 'json',
					data : param,
					async : false,
					success : function(result) {
						if(result.result == "success"){
							alert('<spring:message code="com.msg.deleteSuccess"/>');  // 삭제 성공
							 var url = '/asset/yearlyAssetPlanUpdate';
							 window.location.href= url;
						}else{
							alert('<spring:message code="com.msg.deleteFail"/>');  // 삭제 실패
						}
					}
				});
				
			}
		}else if(btnId == 'btnDel'){
			if(confirm('<spring:message code="com.yearlyAssetPlan.chkDeletePlanBelow"/>')){  // 하기 연자산계획 내역을 삭제하시겠습니까? 
				$("#yearlyAssetPlanList").empty();
			}
			
		}
	}

	function goAddChk() {
		if ($("#STD_YEAR").val().trim().length == 0) {
			alert('<spring:message code="com.yearlyAssetPlan.chkYearlyAssetPlanYear"/>');  // 계획연도를 입력해주세요.
			return;
		} else {
			var param = {};
			param.STD_YEAR = $("#STD_YEAR").val();
			$.ajax({
				type : 'get',
				url : '/asset/chkYearlyAssetPlanExist',
				dataType : 'json',
				data : param,
				async : false,
				success : function(result) {
					if (result.isExist == "FALSE") {
						$("#yearlyAssetPlanList").empty();
						goAdd(result);
					} else {
						if (confirm('<spring:message code="com.yearlyAssetPlan.chkCallYearlyAssetPlanYear"/>')) {  // 해당연도의 지출계획이 이미 존재합니다. 불러오시겠습니까?
							 var url = '/asset/yearlyAssetPlanUpdate?STD_YEAR=' + param.STD_YEAR;
							 window.location.href= url;
						}
					}
				}
			});
		}
	}

	function goAdd(result) {
		
		result = typeof result == 'string' ? JSON.parse(result) : result;
		let list = result.userYearlyPlanTemplate;
		let dwCat101Cnt = result.dwCat101Cnt;
		let dwCat102Cnt = result.dwCat102Cnt;
		let finalHtml = '';

		for (let i = 0; i < list.length; i++) {
			html = '<tr>';
			if (list[i].IS_HEAD == "HEAD") {
				html += '   <th id="' + list[i].MAIN_CTG + '__HEAD" scope="col" width="5%" head="head" rowSpan="'
						+ (list[i].MAIN_CTG == 'DW_CAT1_01' ? dwCat101Cnt
								: dwCat102Cnt) + '">' + list[i].MAIN_CTG_NM
						+ '</th>';
			}
			html += '   <th scope="col" width="5%" '
					+ (list[i].IS_TOTAL == 'TOTAL' ? 'total="total"' : '')
					+ '>' + list[i].SUB_CTG_NM;
					
			if(list[i].IS_TOTAL != 'TOTAL'){
				let trId = list[i].MAIN_CTG + '__' +  list[i].USER_DEF_SEQ;
				html +=	'<img id="' + trId + '" src="/img/check-box.png" height="13px;" width="13px;" style="font-size: 13px;float: right;cursor:pointer;" onclick="javascript:adaptSameValue(this.id);">&nbsp;&nbsp;&nbsp;';
				html += '<img id="' + trId + '" src="/img/delete-button.png" height="13px;" width="13px;" style="font-size: 13px;float: right;cursor:pointer;" onclick="javascript:deleteRow(this);">';
			}		
			
			html += '</th>';

			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_1, 'MONTH_1');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_2, 'MONTH_2');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_3, 'MONTH_3');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_4, 'MONTH_4');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_5, 'MONTH_5');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_6, 'MONTH_6');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_7, 'MONTH_7');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_8, 'MONTH_8');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_9, 'MONTH_9');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_10, 'MONTH_10');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_11, 'MONTH_11');
			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].MONTH_12, 'MONTH_12');

			html += generateHtml(list[i].MAIN_CTG, list[i].USER_DEF_SEQ,
					list[i].IS_TOTAL, list[i].TOTAL); // row별 total

			html += '</tr>';
			finalHtml += html;
		}

		$("#yearlyAssetPlanList").append(finalHtml);
	}

	function generateHtml(mainCtg, userDefSeq, isTotal, value, month) {

		let html = '';
		let id = mainCtg;
		value = value == null || '' ? '' : value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				
		if (isTotal == 'TOTAL') {
			id += '__' + isTotal + '__' + month;
		} else {
			id += '__' + userDefSeq;
			if (month == null) {
				id += '__' + 'TOTAL';
			} else {
				id += '__' + month;
			}
		}

		if (isTotal == "TOTAL" || month == null) {
			html = '   <th scope="col" width="5%"><p id="' + id + '">' + value
					+ '</p></th>';
		} else {
			html = '   <th scope="col" width="5%"><input id="'
					+ id
					+ '" type="text" value="'
					+ value
					+ '" style="width:90px;" onchange="javascript:numberCheck(this.id, this.value);"></th>';
		}
		return html;
	}

	function numberCheck(id, value) {

		value = value.replace(/[^0-9]/g, "").replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
		$("#" + id).val(value);

		let idSplit = id.split('__');
		let hSumTotalId = idSplit[0] + '__' + idSplit[1] + '__TOTAL';
		let vSumTotalId = idSplit[0] + '__TOTAL__' + idSplit[2];

		// 가로 합계 계산
		let hSumEleIdRule = idSplit[0] + '__' + idSplit[1];
		let hSum = 0;
		$("input[id^='" + hSumEleIdRule + "']").each(function(i, item) {
			if ($(item).val().trim().length == 0) {
				return "boolean";
			} else {
				hSum += parseInt($(item).val().replace(/,/g, ""));
			}
		});
		$("p[id='" + idSplit[0] + '__' + idSplit[1] + "__TOTAL']")
				.text(hSum.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));

		// 세로 합계 계산
		let vSum = 0;
		$("input[id^='" + idSplit[0] + "'][id$='" + idSplit[2] + "']").each(function(i, item) {
					if ($(item).val().trim().length == 0) {
						return "boolean";
					} else {
						vSum += parseInt($(item).val().replace(/,/g, ""));
					}
				});
		$("p[id='" + idSplit[0] + '__TOTAL__' + idSplit[2] + "']")
				.text(vSum.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
	}

	function getUedCtgList() {
		var l;
		$.ajax({
			type : 'get',
			url : '/asset/uedCtgList',
			dataType : 'json',
			async : false,
			success : function(result) {
				l = result;
			}
		});
		return l;
	}

	
	function chkboxFlag(chkboxId){
		$("#criteria_chkbox").find('input[id^="MONTH_"]').each(function(i, item){
			if($(item).attr("id") != chkboxId){
				$(item).prop("checked", false);
			}
		});
	}
	
	function adaptSameValue(id){
	    
		// 기준월 컬럼 가져오기
		let stdMonth = $("#criteria_chkbox").find('input[id^="MONTH_"]:checked').attr('id');
		
		if(typeof stdMonth == 'undefined' || stdMonth == null){
			alert('<spring:message code="com.yearlyAssetPlan.chkStdYear"/>');  // 선택된 기준 월이 없습니다.
		   return;
		}else{
			let splId = id + '__' + stdMonth;
			let selectedMonthItemVal = parseInt($("#" + splId).val().replace(/,/g, ""));
			$("#" + id).closest('tr').find('input').each(function(i, item){
				$(item).val(selectedMonthItemVal.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
				numberCheck($(item).attr('id'), $(item).val());
			});
		}
	}
	
	function deleteRow(target){
		let category = $(target).attr('id').split('__')[0];
		$.headTh     =  $("#yearlyAssetPlanList").find('th[id="'+  category + '__HEAD"]');
		let rowspan = $.headTh.attr('rowspan');
		$(target).closest('tr').remove();
		$.headTh.attr('rowspan', rowspan-1);
	}
	

</script>
<body>

	<div class="panel panel-default">
		<div class="panel-heading">
			<h5 class="panel-title">${nav}</h5>
		</div>
	</div>

	<div class="panel panel-default" style="float: right;">
		
		<!-- 추가 -->
		<c:if test="${STD_YEAR == null}">
			<button id="btnAdd" onclick="javascript:goAddChk();" type="button"	class="btn btn-success">
				<spring:message code="com.btn.add" />
			</button>
		</c:if>
		
		<!-- 삭제 -->
		<c:choose>
			<c:when test="${STD_YEAR == null}">
				<button id="btnDel" onclick="javascript:goDel(this.id);" type="button"	class="btn btn-danger">
					<spring:message code="com.btn.delete" /> <!-- 삭제 -->
				</button>
			</c:when>
			<c:when test="${STD_YEAR != null}">
				<button id="btnDelDb" onclick="javascript:goDel(this.id);" type="button" class="btn btn-danger">
					<spring:message code="com.btn.delete" /> <!-- 삭제 -->
				</button>
			</c:when>
		</c:choose>	
		
		
		<!-- 등록 -->
		<button id="btnSave" onclick="javascript:goSave();" type="button" class="btn btn-primary">
			<c:choose>
				<c:when test="${STD_YEAR == null}">
					<spring:message code="com.btn.register" /> <!-- 등록 -->
				</c:when>
				<c:otherwise>
					<spring:message code="com.btn.update" /> <!-- 수정 -->
				</c:otherwise>
			</c:choose>
		</button>
		<!-- 저장 -->
	</div>

	<div class="btn-toolbar mb-3" role="toolbar"
		aria-label="Toolbar with button groups">
		<div class="input-group">
			<div class="input-group-prepend">
				<div class="input-group-text" id="btnGroupAddon"><spring:message code="com.yearlyAssetPlan.planYear" /></div> <!-- 계획연도 --> 
			</div>
			<input type="number" class="form-control" id="STD_YEAR">
		</div>
	</div>


	<!-- 전체 메뉴리스트 -->
	<div class="table table-hover">
	    <div>
			<img src="/img/check-box.png" height="13px;" width="13px;" style="font-size: 13px;float: left;">&nbsp;&nbsp;<p style="font-size: 13px; float: left;">금액 일괄적용</p>
			&nbsp;&nbsp;<img src="/img/delete-button.png" height="13px;" width="13px;" style="font-size: 13px;float: left;">&nbsp;&nbsp;<p style="font-size: 13px; float: left;">삭제</p>
		</div>
		<table class="table">
			<thead class="thead-dark" align="center">
				<tr id="criteria_chkbox">
					<th scope="col" width="5%"></th>
					<th scope="col" width="10%"></th>
					<c:forEach begin="1" end="12" var="month">
						<th scope="col" width="7%"><input type="checkbox" id="MONTH_${month}" onchange="javascript:chkboxFlag(this.id);"></th>
					</c:forEach>
					<th scope="col" width="7%"></th>
				</tr>
				<tr id="monthHeader">
					<th scope="col" width="5%"></th>
					<th scope="col" width="10%"></th>
					<c:forEach begin="1" end="12" var="month">
						<th scope="col" width="7%">${month}월</th>
					</c:forEach>
					<th scope="col" width="7%">계</th>
				</tr>
			</thead>
			<tbody id="yearlyAssetPlanList">

			</tbody>
		</table>
	</div>
</body>
</html>
