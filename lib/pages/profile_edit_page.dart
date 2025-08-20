import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  final String title;        // AppBar 제목 및 TextField의 Label
  final String currentValue; // 현재 값
  final String fieldKey;     // 어떤 필드인지 구분하기 위한 키

  const ProfileEditPage({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.fieldKey,
  }) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: widget.title,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${widget.title}을(를) 입력해주세요.';
                  }
                  // 이메일 필드에 대한 간단한 유효성 검사
                  if (widget.fieldKey == 'email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return '유효한 이메일 주소를 입력해주세요.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}