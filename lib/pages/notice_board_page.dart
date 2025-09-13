// lib/pages/notice_board_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜/시간 포맷팅을 위해 필요
import '../models/notice.dart';
import '../models/comment.dart'; // Comment 모델은 Notice 모델에서 사용
import 'notice_write_page.dart';

import 'notice_detail_page.dart'; // 공지 상세 페이지

/// 공지사항 게시판 목록을 표시하는 페이지.
///
/// 관리자일 경우 화면 오른쪽 하단에 새 공지를 작성할 수 있는 버튼이 고정되어 표시됩니다.
/// 공지사항 목록을 표시하고, 각 공지 클릭 시 상세 페이지로 이동합니다.
class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({Key? key}) : super(key: key);

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  // 임시 관리자 여부 플래그. 실제 앱에서는 사용자 인증 로직과 연동되어야 합니다.
  final bool _isAdmin = true;

  // 임시 공지사항 데이터. 실제 앱에서는 서버에서 데이터를 받아와야 합니다.
  List<Notice> _notices = [
    Notice(
      id: '1',
      title: '새로운 시스템 업데이트 안내 (v1.2.0)',
      content:
          '산불 감지 시스템에 새로운 업데이트가 적용되었습니다.\n주요 변경 사항:\n- UI 개선\n- 버그 수정\n많은 이용 부탁드립니다.',
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
      comments: const [],
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
      id: '1',
      title: '새로운 시스템 업데이트 안내 (v1.2.0)',
      content:
          '산불 감지 시스템에 새로운 업데이트가 적용되었습니다.\n주요 변경 사항:\n- UI 개선\n- 버그 수정\n많은 이용 부탁드립니다.',
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
      comments: const [],
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        // 공지사항 목록을 스크롤 가능한 리스트로 표시.
        padding: const EdgeInsets.all(16.0), // 리스트 전체 패딩.
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return ListTile(
            // 각 공지 항목을 ListTile로 표시.
            title: Text(
              notice.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${notice.author} | ${DateFormat('yyyy.MM.dd HH:mm').format(notice.date)}',
            ),
            onTap: () async {
              // 공지 클릭 시 상세 페이지로 이동.
              print('공지사항 "${notice.title}" 클릭됨');
              final updatedNotice = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeDetailPage(notice: notice),
                ),
              );

              if (updatedNotice != null && updatedNotice is Notice) {
                setState(() {
                  _notices[index] = updatedNotice;
                });
              }
            },
          );
        },
        separatorBuilder: (context, index) =>
            const Divider(), // 각 공지 항목 사이에 구분선.
      ),
      // FloatingActionButton (새 공지 작성 버튼)을 Scaffold의 bottomRight에 고정.
      floatingActionButton:
          _isAdmin // 관리자일 경우에만 FAB를 표시합니다.
          ? FloatingActionButton(
              onPressed: () async {
                print('새 공지 작성 FAB 클릭됨');
                final newNotice = await Navigator.push( // <--- NoticeWritePage로 이동
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticeWritePage(),
                  ),
                );

                if (newNotice != null && newNotice is Notice) {
                  setState(() {
                    _notices.insert(0, newNotice); // 새로 작성된 공지를 리스트 맨 앞에 추가
                    _notices.sort((a, b) => b.date.compareTo(a.date)); // 날짜 기준으로 다시 정렬 (최신순)
                  });
                }
              },
              child: const Icon(Icons.edit), // 아이콘
            )
          : null, // 관리자가 아니면 FAB를 표시하지 않음.
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // <--- 기본값이지만 명시적으로 지정
    );
  }
}
