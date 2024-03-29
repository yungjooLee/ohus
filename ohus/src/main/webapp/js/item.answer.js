$(function(){
	let currentPage;
	let count;
	let rowCount;
	
	//답변 목록
	function selectList(pageNum){
		currentPage = pageNum;
		//로딩 이미지 노출
		$('#loading').show();
		
		$.ajax({
			url:'listAnswer.do',
			type:'post',
			data:{pageNum:pageNum, qna_num:$('#qna_num').val()},
			dataType:'json',
			success:function(param){
				//로딩 이미지 감추기
				$('#loading').hide();
				count = param.count;
				rowCount = param.rowCount;
				
				if(pageNum == 1){
					//처음 호출시에는 해당 ID의 div 내부 내용물을 제거
					$('#output').empty();
				}
				
				$(param.list).each(function(index, item){
					let output = '<div class="item">';
					output += '<span><b>[관리자] ' + item.id + ' </b></span>';
					
					//날짜
					if(item.a_mdate){
						output += '<span class="modify-date"><small> ' + item.a_mdate +' 작성</small></span>';
					} else{
						output += '<span class="modify-date"><small> ' + item.a_regdate +' 작성</small></span>';
					}
					
					output += '<div class="sub-item">';
					output += '<p>' + item.a_content + "</p>";
					output += '<div class="align-right re_buttons">';
					
					//수정, 삭제 버튼
					//로그인 한 회원번호와 작성자의 회원번호 일치 여부 체크
					if(param.user_num == item.mem_num){
						//일치
						output += ' <input type="button" data-anum="' + item.a_num + '" value="수정" class="modify-btn">';
						output += ' <input type="button" data-anum="' + item.a_num + '" value="삭제" class="delete-btn">';
					}
					output += '</div>';
					output += '<hr size="1" noshade width="100%">';
					output += '</div>';
					output += '</div>';
					
					//문서 객체에 추가
					$('#output').append(output);
				});//end of each
				
				//page button 처리
				if(currentPage >= Math.ceil(count/rowCount)){
					//다음 페이지가 없는 경우
					$('.paging-button').hide();
				} else{
					//다음 페이지가 있는 경우
					$('.paging-button').show();
				}
				
			},
			error:function(){
				$('#loading').hide();
				alert('네트워크 오류 발생');
			}
		});
	}
	
	//페이지 처리 이벤트 연결(다음 댓글 보기 버튼 클릭시 데이터 추가)
	$('.paging-button input').click(function(){
		selectList(currentPage + 1)
	});
	
	//답변 등록
	$('#a_form').submit(function(event){
		//기본 이벤트 제어
		//event.preventDefault();
		
		if($('#a_content').val().trim() == ''){ //답변 내용이 비어 있는 경우
			alert('답변 내용을 입력하세요.');
			$('#a_content').val('').focus();
			return false;
		}
		
		//form 이하의 태그에서 입력한 데이터를 모두 읽어옴
		let form_data = $(this).serialize();
		
		//서버와 통신
		$.ajax({
			url:'writeAnswer.do',
			type:'post',
			data:form_data,
			dataType:'json',
			success:function(param){
				if(param.result == 'logout'){
					alert('로그인해야 작성할 수 있습니다.');
				}else if(param.result == 'success'){
					//답변 입력폼 초기화
					initForm();
					//답변 작성이 성공하면 새로 삽입한 답변을 포함해서 첫번째 페이지의 댓글을 다시 호출
					selectList(1);
				}else if(param.result == 'wrongAccess'){
					alert('권한이 없습니다. 잘못된 접근!');
				}else{
					alert('답변 등록 오류 발생');
				}
			},
			error:function(){
				alert('네트워크 오류 발생');
			}
		});
	});
	
	//답변 작성 폼 초기화
	function initForm(){
		$('textarea').val('');
		$('#re_first .letter-count').text('300/300');
	}
	
	//textarea에 내용 입력 시 글자수 체크
	$(document).on('keyup','textarea', function(){
		//입력한 글자수 구하기
		let inputLength = $(this).val().length;
		
		if(inputLength > 300){
			$(this).val($(this).val().substring(0,300)); //300자까지만 표시하고 나머지 잘라냄
		}else{ //300자 이하인 경우
			let remain = 300 - inputLength;
			remain += '/300';
			if($(this).attr('id') == 'a_content'){
				//등록폼 글자수
				$('#re_first .letter-count').text(remain);
			} else{
				//수정폼 글자수
				$('#mre_first .letter-count').text(remain);
			}
		}
	});
	
	//답변 수정 버튼 클릭 시 수정 폼 노출
	$(document).on('click','.modify-btn', function(){
		//답변 번호
		let a_num = $(this).attr('data-anum');
		//답변 내용
		let tmp = $(this).parent();
		let a_content = tmp.parent().find('p').html().replace(/<br>/gi, '\n');
		
		//답변 수정폼 UI
		let modifyUI = '<form id="mre_form">';
		modifyUI += '<input type="hidden" name="a_num" id="mre_num" value="' + a_num + '">';
		modifyUI += '<textarea rows="3" cols="50" name="a_content" id="mre_content" class="rep-content">' + a_content + '</textarea>';
		modifyUI += '<div id="mre_first"><span class="letter-count">300/300</span></div>';
		modifyUI += '<div id="mre_second" class="align-right">';
		modifyUI += ' <input type="submit" value="수정">';
		modifyUI += ' <input type="button" value="취소" class="re-reset">';
		modifyUI += '</div>';
		modifyUI += '</form>';
		modifyUI += '<div id="hori_bar">'
		modifyUI += '<hr size="1" noshade width="96%">';
		modifyUI += '</div>'
		//이전에 이미 수정하는 중인 댓글이 있을 경우, 수정버튼을 클릭하면 숨겨져있는 sub-item을 환원시키고 수정폼을 초기화함
		initModifyForm();
		
		//데이터가 표시되어 있는 div 감추기
		$(this).parent().hide();
		//수정폼을 수정하고자 하는 데이터가 있는 div 노출
		$(this).parents('.item').append(modifyUI);
		
		//입력한 글자수 셋팅
		let inputLength = $('#mre_content').val().length;
		let remain = 300 - inputLength;
		remain += '/300';
		
		//문서 객체에 반영
		$('#mre_first .letter-count').text(remain);
		
	});
	
	//수정 폼에서 취소 버튼 클릭시 수정 폼 초기화
	$(document).on('click','.re-reset',function(){
		initModifyForm();
		
	});
	
	//답변 수정 폼 초기화
	function initModifyForm(){
		$('.sub-item').show();
		$('.re_buttons').show();
		$('#mre_form').remove();
		$('#hori_bar').remove();
	}
	
	//답변 수정
	$(document).on('submit', '#mre_form', function(event){
		//기본이벤트 제거
		event.preventDefault();
		
		if($('#mre_content').val().trim() == ''){
			alert('내용을 입력하세요.');
			$('#mre_content').val('').focus();
			return false;
		}
		
		//폼에 입력한 데이터 반환
		let form_data = $(this).serialize();
		
		//서버와 통신
		$.ajax({
			url:'modifyAnswer.do',
			type:'post',
			data:form_data,
			dataType:'json',
			success:function(param){
				if(param.result == 'logout'){
					alert('로그인해야 수정할 수 있습니다.');
				}else if(param.result == 'success'){
					$('#mre_form').parent().find('p').html($('#mre_content').val().replace(/</g,'&lt;').replace(/>/g, '&gt;').replace(/\n/g,'<br>'));
					//날짜
					$('#mre_form').parent().find('.modify-date').text('최근 수정일 : 5초미만');
					//수정폼 삭제 및 초기화
					initModifyForm();
				}else if(param.result == 'wrongAccess'){
					alert('타인의 댓글을 수정할 수 없습니다.');
				}else{
					alert('댓글 수정 오류');
				}
			},
			error:function(){
				alert('네트워크 오류 발생');
			}
		});
	});
	
	//답변 삭제
	$(document).on('click','.delete-btn', function(){
		//답변 번호
		let a_num = $(this).attr('data-anum');
		
		$.ajax({
			url:'deleteAnswer.do',
			type:'post',
			data:{a_num:a_num},
			dataType:'json',
			success:function(param){
				if(param.result == 'logout'){
					alert('로그인해야 삭제할 수 있습니다.');
				} else if(param.result == 'success'){
					alert('삭제 완료!');
					selectList(1);
				} else if(param.result == 'wrongAccess'){ 
					alert('타인의 댓글을 삭제할 수 없습니다.');
				} else{
					alert('댓글 삭제 오류 발생'); //오타 발생한 경우
				}
			},
			error:function(){
				alert('네트워크 오류 발생');
			}
		});
	});
	
	//초기 데이터(목록) 호출
	selectList(1);
});