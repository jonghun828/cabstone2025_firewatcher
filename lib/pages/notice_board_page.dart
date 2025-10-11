// lib/pages/notice_board_page.dart (VideoLogCard 디자인 참고하여 수정)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notice_detail_page.dart';
import '../models/notice.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  final List<Notice> _notices = [
    Notice(
      id: 'n001',
      title: '새로운 시스템 업데이트 안내 (v1.2.0)',
      content: '더 나은 서비스를 제공하기 위해 시스템 업데이트가 완료되었습니다. 주요 개선 사항은 다음과 같습니다:\n\n1. 새로운 구역 관리 기능 추가\n2. 센서 데이터 처리 속도 향상\n3. 사용자 인터페이스 개선\n\n자세한 내용은 공지사항을 참조해 주세요.',
      author: '관리자',
      date: DateTime(2023, 10, 26, 10, 0),
      isMajor: true,
    ),
    Notice(
      id: 'n002',
      title: '정기 점검으로 인한 서비스 일시 중단 안내',
      content: '시스템 안정화를 위한 정기 점검이 아래와 같이 진행될 예정입니다. 점검 시간 동안 일부 서비스 이용이 제한될 수 있으니 양해 부탁드립니다.\n\n- 점검 일시: 2023년 10월 28일 02:00 ~ 04:00 (2시간)\n- 점검 내용: 서버 안정화 및 보안 패치\n\n불편을 드려 죄송합니다. 항상 최선을 다하는 산불 감시 시스템이 되겠습니다.',
      author: '관리자',
      date: DateTime(2023, 10, 20, 15, 30),
      isMajor: true,
    ),
    Notice(
      id: 'n003',
      title: '화재 발생 시 대처 요령 공지',
      content: '산불 발생 시 신속하고 안전한 대처를 위해 다음 요령을 숙지해 주시기 바랍니다.\n\n1. 즉시 119에 신고\n2. 안전한 장소로 대피\n3. 시스템 알림에 주의\n\n모두의 안전을 위해 최선을 다합시다.',
      author: '안전팀',
      date: DateTime(2023, 10, 15, 9, 0),
    ),
    Notice(
      id: 'n004',
      title: '개인정보처리방침 변경 안내',
      content: '개인정보처리방침이 변경될 예정입니다. 변경 내용은 웹사이트에서 확인하실 수 있습니다.',
      author: '관리자',
      date: DateTime(2023, 10, 1, 17, 0),
    ),
    Notice(
      id: 'n005',
      title: '추석 연휴 고객센터 휴무 안내',
      content: '추석 연휴 기간 동안 고객센터 운영이 중단됩니다. 서비스 이용에 참고하시기 바랍니다.',
      author: '고객지원팀',
      date: DateTime(2023, 9, 25, 12, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          final String formattedDate = DateFormat('yyyy.MM.dd').format(notice.date);

          // 🚨 Card 대신 InkWell + Container 조합으로 VideoLogCard와 유사하게 변경
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeDetailPage(notice: notice),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0), // VideoLogCard와 유사한 마진
              padding: const EdgeInsets.all(16.0), // VideoLogCard와 유사한 패딩
              decoration: BoxDecoration(
                color: Colors.white, // 흰색 배경
                borderRadius: BorderRadius.circular(12), // 둥근 모서리
                border: Border.all(color: Colors.grey.shade300, width: 1.0), // 테두리
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 주요 공지 아이콘
                      if (notice.isMajor)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0, top: 2.0),
                          child: Icon(Icons.push_pin, color: Colors.red, size: 18),
                        ),
                      Expanded(
                        child: Text(
                          notice.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // 제목과 작성자/날짜 사이 간격
                  const Divider(height: 1), // 🚨 VideoLogCard처럼 구분선 추가
                  const SizedBox(height: 8), // 구분선 아래 간격

                  // 작성자와 날짜를 한 줄에 표시 (VideoLogCard의 _buildInfoRow 방식 참고)
                  _buildInfoRow('작성자', notice.author),
                  _buildInfoRow('게시일', formattedDate),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🚨 VideoLogCard의 _buildInfoRow를 참고하여 재사용 가능한 위젯 추가
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80, // 타이틀 너비 고정 (VideoLogCard와 유사하게)
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded( // 값 텍스트가 길어질 경우를 대비해 Expanded 추가
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}