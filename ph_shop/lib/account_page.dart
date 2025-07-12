import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../api/upload_avatar_api.dart';
import '../api/fetch_avatar_api.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _imageFile;
  String? _avatarUrl;
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final uid = user?.uid;
    if (uid != null) {
      fetchAvatarUrl(uid).then((url) {
        if (url != null) {
          setState(() {
            _avatarUrl = url;
          });
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final file = File(pickedImage.path);
    setState(() => _imageFile = file);

    if (user != null) {
      final uploadedUrl = await uploadAvatar(file, user!.uid);
      if (uploadedUrl != null) {
        setState(() => _avatarUrl = uploadedUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Ảnh đại diện đã được lưu")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Lỗi khi upload ảnh")),
        );
      }
    }
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _saveInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Đã lưu thông tin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.displayName ?? 'user-${user?.uid.substring(0, 6)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _imageFile != null
                ? CircleAvatar(radius: 50, backgroundImage: FileImage(_imageFile!))
                : (_avatarUrl != null
                    ? CircleAvatar(radius: 50, backgroundImage: NetworkImage(_avatarUrl!))
                    : const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.account_circle, size: 80, color: Colors.white),
                      )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Choose Avatar', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: user?.email ?? ''),
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: displayName),
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tên người dùng',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ giao hàng',
                prefixIcon: const Icon(Icons.home),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveInfo,
              icon: const Icon(Icons.save),
              label: const Text('Save Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
