import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // File 클래스를 사용하기 위해 필요
import '../models/profile.dart';
import 'profile_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Profile _ProfileData;
  File? _pickedImageFile; // <--- 선택된 이미지 파일을 저장할 변수

  @override
  void initState() {
    super.initState();
    _ProfileData = Profile(
      name: '강동성',
      phonenumber: '010-2564-3660',
      email: 'dongsung.kang@example.com',
      photoUrl: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
      position: '담당자',
      area: 'A',
    );
  }

  // 이미지 선택 로직
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path); // 선택된 파일로 업데이트
        // TODO: 서버에 프로필 사진 업로드 및 photoUrl 업데이트 로직 필요
        // _userProfileData = _userProfileData.copyWith(photoUrl: _pickedImageFile!.path);
      });
    }
  }

  Widget _buildProfileInfoRow({
    required String label,
    required String value,
    required String fieldKey,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return InkWell(
      onTap: () async {
        final newValue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileEditPage(
              title: label,
              currentValue: value,
              fieldKey: fieldKey,
            ),
          ),
        );

        if (newValue != null && newValue is String) {
          setState(() {
            switch (fieldKey) {
              case 'name':
                _ProfileData = _ProfileData.copyWith(name: newValue);
                break;
              case 'phonenumber':
                _ProfileData = _ProfileData.copyWith(phonenumber: newValue);
                break;
              case 'email':
                _ProfileData = _ProfileData.copyWith(email: newValue);
                break;
              case 'position':
                _ProfileData = _ProfileData.copyWith(position: newValue);
                break;
              case 'area':
                _ProfileData = _ProfileData.copyWith(area: newValue);
                break;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label이(가) ${newValue}로 변경되었습니다.')),
            );
          });
        }
      },
      child: Padding(
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
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 프로필 사진 표시를 위한 조건부 로직
    ImageProvider<Object>? profileImage;
    if (_pickedImageFile != null) {
      profileImage = FileImage(_pickedImageFile!); // 선택된 파일이 있으면 FileImage 사용
    } else if (_ProfileData.photoUrl != null && _ProfileData.photoUrl!.isNotEmpty) {
      profileImage = NetworkImage(_ProfileData.photoUrl!); // 없으면 기존 URL 사용
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profileImage, // <--- 조건부 로직으로 결정된 이미지 사용
                  child: profileImage == null // 이미지가 없는 경우 기본 아이콘 표시
                      ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('카메라'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('갤러리'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildProfileInfoRow(
              label: '이름',
              value: _ProfileData.name,
              fieldKey: 'name',
            ),
            const Divider(),
            _buildProfileInfoRow(
              label: '전화번호',
              value: _ProfileData.phonenumber,
              fieldKey: 'phonenumber',
              keyboardType: TextInputType.phone,
            ),
            const Divider(),
            _buildProfileInfoRow(
              label: '이메일',
              value: _ProfileData.email,
              fieldKey: 'email',
              keyboardType: TextInputType.emailAddress,
            ),
            const Divider(),
            _buildProfileInfoRow(
              label: '직책',
              value: _ProfileData.position,
              fieldKey: 'position',
            ),
            const Divider(),
            _buildProfileInfoRow(
              label: '담당 구역',
              value: _ProfileData.area,
              fieldKey: 'area',
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}