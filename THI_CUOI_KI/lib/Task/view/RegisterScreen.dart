import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/Account.dart';
import '../db/AccountService.dart';
import '../service/auth.dart';
import '../view/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  String _role = 'user'; // Mặc định là 'user'
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return; // Kiểm tra xem các ô nhập liệu có hợp lệ không

    setState(() => _isLoading = true);

    try {
      // 1. Tạo tài khoản Firebase
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword( // userCredential chứa thông tin tk mới tạo
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      User? user = userCredential.user; // lấy user từ userCredential
      if (user != null) {
        // 2. Tạo đối tượng Account và lưu vào Firestore
        final newAccount = Account(
          userId: user.uid,
          username: _usernameController.text.trim(),
          email: user.email ?? '',
          password: _passwordController.text, // Thêm dòng này
          avatar: null,
          createdAt: DateTime.now().toIso8601String(),
          lastLogin: DateTime.now().toIso8601String(),
          role: _role, // Gán role được chọn
        );

        await _databaseMethods.addAccount(newAccount); // gọi API để lưu
      }

      Navigator.pop(context); // quay lại login
    } on FirebaseAuthException catch (e) { // nếu lỗi (email đã tồn tại, mật khẩu yếu...)
      _showErrorDialog('Lỗi đăng ký', e.message ?? 'Đã xảy ra lỗi');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // báo lỗi
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Tên người dùng'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Vui lòng nhập tên người dùng' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                validator: (val) {
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(val ?? '')) {
                    return 'Mật khẩu ≥6 ký tự, gồm chữ hoa, chữ thường, số, ký tự đặc biệt';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: InputDecoration(labelText: 'Chọn vai trò'),
                onChanged: (newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
                items: ['user', 'admin']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role), // chuyển items thành bằng map để hiển thị
                ))
                    .toList(),
                validator: (val) =>
                val == null ? 'Vui lòng chọn vai trò' : null, // khi chưa chọn vai trò
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,  // Khi đang đăng ký → ko cho nhấn , ngược lại
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white) // ko cho nhấn
                    : Text('ĐĂNG KÝ'), // Khi đăng ký xong hoặc chưa đăng ký → hiện chữ đăng ký.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
