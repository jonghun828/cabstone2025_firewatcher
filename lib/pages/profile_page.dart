import 'package:flutter/material.dart';
import '../models/user_profile.dart'; // UserProfile 모델 import

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 사용자 정보를 가져오는 로직으로 대체해야 합니다.
    // 현재는 임시 UserProfile 데이터 사용
    final UserProfile _userProfileData = UserProfile(
      name: '강동성',
      phonenumber: '010-2564-3660',
      email: 'dongsung.kang@example.com',
      photoUrl: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', // 임시 프로필 사진 URL
      position: '담당자', // 또는 '관리자'
      area: 'A', // 여러 구역일 수 있으므로 String으로
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        // 프로필 페이지는 MainPage에서 Push되어 오므로, 기본 뒤로가기 버튼이 자동으로 생깁니다.
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 컬럼 내 위젯들을 가로 중앙 정렬
          children: [
            // 프로필 사진
            CircleAvatar(
              radius: 60, // 원형 아바타의 크기
              backgroundColor: Colors.grey[200], // 사진이 없을 때 배경색
              backgroundImage: _userProfileData.photoUrl != null && _userProfileData.photoUrl!.isNotEmpty
                  ? NetworkImage(_userProfileData.photoUrl!) // URL이 있으면 네트워크 이미지 사용
                  : null, // 없으면 기본값 (CircleAvatar의 child 사용 가능)
              child: _userProfileData.photoUrl == null || _userProfileData.photoUrl!.isEmpty
                  ? Icon(Icons.person, size: 60, color: Colors.grey[600]) // 사진이 없을 때 기본 아이콘
                  : null,
            ),
            const SizedBox(height: 32),

            // 각 정보 항목 (직책, 담당구역)
            _buildProfileInfoRow(
              label: '이름',
              value: _userProfileData.name,
            ),
            const Divider(), // 구분선
            _buildProfileInfoRow(
              label: '전화번호',
              value: _userProfileData.phonenumber,
            ),
            const Divider(), // 구분선
            _buildProfileInfoRow(
              label: '이메일',
              value: _userProfileData.email,
            ),
            const Divider(), // 구분선
            _buildProfileInfoRow(
              label: '직책',
              value: _userProfileData.position,
            ),
            const Divider(), // 구분선
            _buildProfileInfoRow(
              label: '담당 구역',
              value: _userProfileData.area,
            ),
            const Divider(), // 구분선

            // TODO: 비밀번호 변경, 로그아웃 등 추가적인 프로필 관련 기능 버튼 배치 가능
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: 프로필 수정 페이지로 이동 또는 수정 기능 구현
                print('프로필 수정 버튼 클릭');
              },
              child: const Text('프로필 수정'),
            ),
          ],
        ),
      ),
    );
  }

  // 프로필 정보 항목을 깔끔하게 표시하기 위한 헬퍼 위젯/함수
  Widget _buildProfileInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}