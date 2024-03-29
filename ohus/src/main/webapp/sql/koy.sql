-- 문의사항   
create table inquiry(
	inq_num number,
	inq_title varchar2(30) not null,
	inq_category number(1) not null, --1:사이트 문의 | 2:신고 문의
	inq_content clob not null,
	inq_regdate date default sysdate not null,
	inq_modifydate date,
	inq_ip varchar2(40) not null,
	inq_status number(1) default 1 not null, -- 1:처리전 | 2:처리완료
	mem_num number not null,
	constraint inquiry_pk primary key (inq_num),
	constraint inquiry_fk foreign key (mem_num) references omember (mem_num)
);
   
create sequence inquiry_seq;

-- 문의사항 답변
create table inquiry_answer(
	ans_num number,
	ans_content clob not null,
	ans_date date default sysdate not null,
	ans_mdate date, 
	inq_num number not null,
	mem_num number not null,
	constraint inquiry_ans_pk primary key (ans_num),
	constraint inquiry_ans_fk1 foreign key (inq_num) references inquiry (inq_num),
	constraint inquiry_ans_fk2 foreign key (mem_num) references omember (mem_num)
);

create sequence inquiry_ans_seq;

-- 공지사항
create table notice (
	notice_num number,
	notice_title varchar2(30) not null,
	notice_content clob not null,
	notice_regdate date default sysdate not null,
	notice_mdate date,
	notice_hit number(9) default 0 not null,
	notice_filename varchar2(50),
	mem_num number not null,
	constraint notice_pk primary key (notice_num),
	constraint notice_fk foreign key (mem_num) references omember (mem_num)
);

create sequence notice_seq;

-- 상품문의
create table item_qna(
	qna_num number,
	qna_title varchar2(50) not null,
	qna_content clob not null,
	qna_category number(1) not null, -- 1:상품|2:배송|3:반품|4:교환|5:환불|6:기타
	qna_regdate date default sysdate not null,
	qna_mdate date,
	qna_ip varchar2(40) not null,
	qna_status number(1) default 1 not null,
	mem_num number not null, -- 작성자
	item_num number not null,
	constraint qna_pk primary key (qna_num),
	constraint qna_fk foreign key (item_num) references item (item_num)
);

create sequence item_qna_seq;

-- 상품문의 답변
create table item_answer(
	a_num number,
	a_content clob not null,
	a_regdate date default sysdate not null,
	a_mdate date,
	qna_num number not null,
	mem_num number not null, -- 답변한 관리자
	constraint qna_ans_pk primary key (a_num),
	constraint qna_ans_fk1 foreign key (qna_num) references qna (qna_num),
	constraint qna_ans_fk2 foreign key (mem_num) references omember (mem_num)
);

create sequence item_ans_seq;