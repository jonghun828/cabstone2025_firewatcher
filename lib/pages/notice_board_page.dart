import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/notice.dart';
import 'notice_detail_page.dart';
import 'notice_write_page.dart';

final GlobalKey<_NoticeBoardPageState> noticeBoardKey = GlobalKey();

class NoticeBoardPage extends StatefulWidget {
  // key 중복 오류가 수정된 생성자
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
    loadNotices();
  }

  Future<void> loadNotices() async {
    // 이미 로딩 중이거나 위젯이 마운트되지 않은 경우 중복 호출 방지
    if (!mounted || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.fetchNotices();

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final List<Notice> fetchedNotices = jsonList
            .map((json) => Notice.fromJson(json))
            .toList();

        setState(() {
          // 최신순 정렬
          fetchedNotices.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
          _notices = fetchedNotices;
        });
      } else {
        setState(() {
          _errorMessage = '공지 목록 로드 실패 (코드: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '데이터 로드 중 오류 발생';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 공지 작성 페이지 이동 및 결과 (게시글 등록 성공 여부) 받기
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoticeWritePage()),
          );
          if (result == true) {
            // 새로운 게시글 등록 시 목록 새로고침
            loadNotices();
          }
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) {
      return Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(_errorMessage!, textAlign: TextAlign.center), const SizedBox(height: 20),
            ElevatedButton(onPressed: loadNotices, child: const Text('다시 시도'))]));
    }
    if (_notices.isEmpty) return const Center(child: Text('등록된 공지사항이 없습니다.'));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _notices.length,
      itemBuilder: (context, index) {
        final notice = _notices[index];
        final String formattedDate = DateFormat('yyyy.MM.dd').format(notice.modifiedAt);

        return InkWell(
          onTap: () async {
            // 상세 페이지 이동 및 결과 (댓글 등록/수정 여부) 받기
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoticeDetailPage(notice: notice)),
            );
            if (result == true) {
              // 댓글 변경이 있을 경우 목록 새로고침 (댓글 수 업데이트 위함)
              loadNotices();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1.0)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // 중요 공지 아이콘 표시
                if (notice.isMajor) const Padding(padding: EdgeInsets.only(right: 8.0, top: 2.0), child: Icon(Icons.push_pin, color: Colors.red, size: 18)),
                Expanded(child: Text(notice.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis)),
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

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }
}
