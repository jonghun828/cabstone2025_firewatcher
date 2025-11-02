// lib/pages/profile_edit_page.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ProfileEditPage extends StatefulWidget {
  final Uint8List? initialProfileImageBytes;
  final String initialName;
  final String initialPosition;
  final String initialArea;

  const ProfileEditPage({
    super.key,
    this.initialProfileImageBytes,
    required this.initialName,
    required this.initialPosition,
    required this.initialArea,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Uint8List? _profileImageBytes;
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _areaController;

  @override
  void initState() {
    super.initState();
    _profileImageBytes = widget.initialProfileImageBytes;
    _nameController = TextEditingController(text: widget.initialName);
    _positionController = TextEditingController(text: widget.initialPosition);
    _areaController = TextEditingController(text: widget.initialArea);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      setState(() {
        _profileImageBytes = bytes;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${source == ImageSource.gallery ? '갤러리' : '카메라'}에서 사진을 선택했습니다.')),
        );
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('앨범에서 선택'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라로 촬영'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('기본 이미지로 변경', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _profileImageBytes = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('프로필 이미지가 기본 이미지로 변경되었습니다.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 저장 로직을 분리하여 재사용성을 높임
  void _saveProfile() {
    // TODO: 변경된 프로필 정보 (이름, 직책, 지역, 이미지)를 서버에 저장하는 로직 구현

    // 이전 페이지로 업데이트된 데이터 반환
    Navigator.pop(context, {
      'profileImageBytes': _profileImageBytes,
      'name': _nameController.text,
      'position': _positionController.text,
      'area': _areaController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 50;
    const Color defaultColor = Color(0xFFC3E0F1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        // 💡 actions (아이콘 버튼) 삭제
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: InkWell(
              onTap: _showImageSourceActionSheet,
              borderRadius: BorderRadius.circular(radius),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: defaultColor,
                child: _profileImageBytes != null
                    ? ClipOval(
                        child: Image.memory(
                          _profileImageBytes!,
                          fit: BoxFit.cover,
                          width: radius * 2,
                          height: radius * 2,
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '이름',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _positionController,
            decoration: const InputDecoration(
              labelText: '직책',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _areaController,
            decoration: const InputDecoration(
              labelText: '담당 구역',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          // 💡 저장하기 버튼에 카드 디자인 적용
          Card(
            margin: EdgeInsets.zero, // ListView padding을 사용하므로 margin 제거
            elevation: 0,
            color: Theme.of(context).primaryColor, // 앱의 기본 색상 사용
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 모서리 둥글게
            ),
            child: InkWell(
              onTap: _saveProfile,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    '저장하기',
                    style: TextStyle(
                      color: Colors.white, // 흰색 텍스트
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}