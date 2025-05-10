import 'package:flutter/material.dart';
import 'package:thick/Task/db/AccountService.dart';
import 'package:thick/Task/model/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thick/Task/view/RegisterScreen.dart';
import 'package:thick/Task/view/TaskListScreen.dart';
import 'package:thick/Task/service/auth.dart'; // Thêm lớp AuthMethods để quản lý đăng nhập

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Vui lòng nhập email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) { // kiểm tra email hợp lệ hay không( ký ự + tên domain + @ + đuôi)
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off), // Hiển thị mật khẩu
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword), // Thay đổi trạng thái ẩn/hiện mật khẩu
                  ),
                ),
                validator: (val) {
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(val ?? '')) {
                    return 'Mật khẩu ≥6 ký tự, gồm chữ hoa, chữ thường, số, ký tự đặc biệt';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    await _authMethods.signInWithEmail(
                      context,
                      _emailController.text.trim(),
                      _passwordController.text,
                    );
                    setState(() => _isLoading = false);
                  }
                },
                child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('ĐĂNG NHẬP'),
              ),
              SizedBox(height: 24),
              Center(child: Text('Hoặc đăng nhập với')),
              SizedBox(height: 16),
              IconButton(
                icon: Image.asset('../images/google.png', height: 40),
                onPressed: () => _authMethods.signInWithGoogle(context),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chưa có tài khoản?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                    },
                    child: Text('Đăng ký'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
