// lib/pages/notice_board_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notice.dart'; // 수정된 Notice 모델 import
import '../models/comment.dart'; // Comment 모델 import
import 'notice_detail_page.dart'; // 새로 생성한 NoticeDetailPage import

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  // TODO: 실제 사용자 인증 로직과 연동하여 관리자 여부 판단
  bool _isAdmin = true; // 임시로 true로 설정하여 관리자 기능을 테스트합니다.

  // 임시 공지사항 데이터 (댓글 포함하여 정의)
  List<Notice> _notices = [
    Notice(
      id: '1',
      title: '새로운 시스템 업데이트 안내 (v1.2.0)',
      content:
          '산불 감지 시스템에 새로운 업데이트가 적용되었습니다.\n주요 변경 사항:\n- UI 개선\n- 버그 수정\n많은 이용 부탁드립니다.\n1\n2\n3\n4\n5\n6\n7\n1\n2\n3\n4\n5\n6\n7',
      author: '관리자',
      date: DateTime(2025, 8, 15, 10, 30),
      comments: [
        Comment(
          id: 'c1',
          author: '사용자A',
          content: '기대됩니다!',
          date: DateTime(2025, 8, 15, 11, 0),
        ),
        Comment(
          id: 'c2',
          author: '사용자B',
          content: '수고하셨습니다.',
          date: DateTime(2025, 8, 15, 11, 10),
        ),
      ],
    ),
    Notice(
      id: '2',
      title: '정기 점검으로 인한 서비스 일시 중단 안내',
      content:
          '더 나은 서비스 제공을 위해 정기 점검이 있을 예정입니다.\n일시: 2025년 8월 20일 03:00 ~ 05:00\n이용에 불편을 드려 죄송합니다.',
      author: '관리자',
      date: DateTime(2025, 8, 10, 14, 0),
      comments: [],
    ),
    Notice(
      id: '3',
      title: '화재 발생 시 대처 요령 공지',
      content:
          '만약 화재가 발생했을 경우, 침착하게 다음 요령을 따르세요...\n1. 119 신고\n2. 초기 소화\n3. 대피',
      author: '관리자',
      date: DateTime(2025, 8, 5, 9, 0),
      comments: [
        Comment(
          id: 'c3',
          author: '사용자C',
          content: '유용한 정보 감사합니다.',
          date: DateTime(2025, 8, 6, 9, 30),
        ),
      ],
    ),
    Notice(
      id: '4',
      title: '화재 발생 시 대처 요령 공지',
      content:
          '만약 화재가 발생했을 경우, 침착하게 다음 요령을 따르세요...\n1. 119 신고\n2. 초기 소화\n3. 대피',
      author: '관리자',
      date: DateTime(2025, 8, 5, 9, 0),
      comments: [
        Comment(
          id: 'c3',
          author: '사용자C',
          content: '유용한 정보 감사합니다.',
          date: DateTime(2025, 8, 6, 9, 30),
        ),
      ],
    ),
    Notice(
      id: '5',
      title: '화재 발생 시 대처 요령 공지',
      content:
          '만약 화재가 발생했을 경우, 침착하게 다음 요령을 따르세요...\n1. 119 신고\n2. 초기 소화\n3. 대피',
      author: '관리자',
      date: DateTime(2025, 8, 5, 9, 0),
      comments: [
        Comment(
          id: 'c3',
          author: '사용자C',
          content: '유용한 정보 감사합니다.',
          date: DateTime(2025, 8, 6, 9, 30),
        ),
      ],
    ),
    Notice(
      id: '6',
      title: '화재 발생 시 대처 요령 공지',
      content:
          '만약 화재가 발생했을 경우, 침착하게 다음 요령을 따르세요...\n1. 119 신고\n2. 초기 소화\n3. 대피',
      author: '관리자',
      date: DateTime(2025, 8, 5, 9, 0),
      comments: [
        Comment(
          id: 'c3',
          author: '사용자C',
          content: '유용한 정보 감사합니다.',
          date: DateTime(2025, 8, 6, 9, 30),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 게시판'),
        automaticallyImplyLeading:
            false, // BottomNavigationBar 탭 페이지이므로 뒤로가기 버튼 없음
        actions: [
          // Collection If 문을 사용하여 _isAdmin이 true일 때만 IconButton을 리스트에 포함
          if (_isAdmin) // <--- 이 조건문이 _isAdmin이 true일 때만 아래 위젯을 렌더링합니다.
            IconButton(
              icon: const Icon(Icons.edit, size: 20.0), // 수정 아이콘
              onPressed: () {
                print('새 공지 작성 버튼 클릭됨');
                // TODO: 새 공지 작성 페이지로 이동
                // Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeWritePage()));
              },
            ),
          // 필요하다면 여기에 다른 아이콘 버튼들도 추가할 수 있습니다.
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return ListTile(
            title: Text(
              notice.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${notice.author} | ${DateFormat('yyyy.MM.dd HH:mm').format(notice.date)}',
            ),
            onTap: () async {
              print('공지사항 "${notice.title}" 클릭됨');
              // 상세 페이지로 이동하며 선택된 공지 데이터를 전달
              final updatedNotice = await Navigator.push(
                // await로 상세 페이지에서 업데이트된 Notice를 받을 수 있음
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeDetailPage(notice: notice),
                ),
              );

              // 상세 페이지에서 Notice 객체가 업데이트되었다면 (예: 댓글 추가), 현재 목록 업데이트
              if (updatedNotice != null && updatedNotice is Notice) {
                setState(() {
                  _notices[index] = updatedNotice;
                });
              }
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(), // 각 공지 사이에 구분선
      ),
    );
  }
}
