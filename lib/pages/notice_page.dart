import 'package:flutter/material.dart';

class Notice {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime date;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
  });
}

class NoticePage extends StatefulWidget { // 공지 목록의 상태 관리를 위해 StatefulWidget 사용
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  // 임시 공지사항 데이터 (나중에는 API 호출을 통해 실제 데이터를 받아옴)
  final List<Notice> _notices = [
    Notice(
        id: '1',
        title: '새로운 시스템 업데이트 안내',
        content: '산불 감지 시스템에 새로운 업데이트가 적용되었습니다...',
        author: '관리자',
        date: DateTime(2025, 8, 15)),
    Notice(
        id: '2',
        title: '정기 점검으로 인한 서비스 일시 중단 안내',
        content: '더 나은 서비스 제공을 위해 정기 점검이 있을 예정입니다.',
        author: '관리자',
        date: DateTime(2025, 8, 10)),
    Notice(
        id: '3',
        title: '화재 발생 시 대처 요령',
        content: '만약 화재가 발생했을 경우, 침착하게 다음 요령을 따르세요...',
        author: '관리자',
        date: DateTime(2025, 8, 5)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar는 MainPage에 이미 존재하므로 여기서는 생략하거나,
      // 공지사항 페이지 자체의 고유한 AppBar를 가질 수도 있습니다.
      // BottomNavigationBar 탭의 하위 페이지이므로 일반적으로는 Scaffold를 생략하거나
      // AppBar title만 설정하는 정도를 사용합니다.
      // 여기서는 Scaffold를 유지하고 AppBar title만 줍니다.
      appBar: AppBar(
        title: const Text('공지사항'),
        automaticallyImplyLeading: false, // BottomNavigationBar 탭의 페이지이므로 뒤로가기 버튼 없음
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
            subtitle: Text('${notice.author} | ${notice.date.toLocal().toString().split(' ')[0]}'), // 날짜 포맷팅
            onTap: () {
              print('공지사항 "${notice.title}" 클릭됨');
              // TODO: 공지 상세 페이지로 이동
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => NoticeDetailPage(notice: notice),
              //   ),
              // );
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(), // 각 공지 사이에 구분선
      ),
    );
  }
}