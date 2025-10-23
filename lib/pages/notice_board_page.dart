// lib/pages/notice_board_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/notice.dart';
import 'notice_detail_page.dart';
import 'notice_write_page.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  final ApiService _apiService = ApiService();

  List<Notice> _notices = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  // API를 통해 공지사항을 불러오는 메서드
  Future<void> _loadNotices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // API 호출 및 파싱
      final response = await _apiService.fetchNotices();

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;

        // JSON 처리
        final List<Notice> fetchedNotices = jsonList
            .map((json) => Notice.fromJson(json))
            .toList();

        setState(() {
          // 최종 수정일 기준으로 내림차순 정렬
          fetchedNotices.sort((a, b) {
            return b.modifiedAt.compareTo(a.modifiedAt);
          });
          _notices = fetchedNotices;
        });
      } else {
        setState(() {
          _errorMessage = '공지 목록 로드 실패 (코드: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        // 데이터 로드 오류
        final String error = e.toString().contains('Exception:')
            ? e.toString().replaceFirst('Exception: ', '')
            : '네트워크 연결 오류 또는 알 수 없는 오류';
        _errorMessage = '데이터 로드 중 오류 발생: $error';
      });
      print('Notice Load Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 게시판'),
      ),
      body: _buildBody(),

      // 공지 작성 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 공지 작성 페이지로 이동
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoticeWritePage(),
            ),
          );

          // 공지 작성이 완료되면 목록을 다시 불러옴
          if (result == true) {
            _loadNotices();
          }
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }

  // 로딩/오류/데이터 상태에 따른 본문 위젯 분리
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadNotices,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_notices.isEmpty) {
      return const Center(
        child: Text('등록된 공지사항이 없습니다.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _notices.length,
      itemBuilder: (context, index) {
        final notice = _notices[index];

        // modifiedAt을 사용하여 날짜 표시
        final String formattedDate = DateFormat('yyyy.MM.dd').format(notice.modifiedAt);

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
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
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
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),

                _buildInfoRow('작성자', notice.author),
                _buildInfoRow('게시일', formattedDate),
              ],
            ),
          ),
        );
      },
    );
  }

  // 정보를 표시하는 보조 위젯
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
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