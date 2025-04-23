import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_02/NoteForm/api/AccountAPIService.dart';
import 'package:app_02/NoteForm/model/Account.dart';
import 'package:app_02/NoteForm/view/NoteListScreen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(bool)? onToggleTheme;
  final bool isDarkMode;

  const LoginScreen({Key? key, this.onToggleTheme, this.isDarkMode = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final account = await AccountAPIService.instance.login(
          _usernameController.text,
          _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (account != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', account.userId);
          await prefs.setInt('accountId', account.id!);
          await prefs.setString('username', account.username);
          await prefs.setBool('isLoggedIn', true);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NoteListScreen(onLogout: _logout),
            ),
          );
        } else {
          _showErrorDialog('Đăng nhập thất bại', 'Tên đăng nhập hoặc mật khẩu không đúng hoặc tài khoản không hoạt động.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Lỗi đăng nhập', 'Đã xảy ra lỗi: $e');
      }
    }
  }

  Future<void> _logout() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen(onToggleTheme: widget.onToggleTheme, isDarkMode: widget.isDarkMode)),
            (Route<dynamic> route) => false,
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: (value) {
              if (widget.onToggleTheme != null) {
                widget.onToggleTheme!(value);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Xử lý quên mật khẩu nếu cần
                  },
                  child: Text('Quên mật khẩu?'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
