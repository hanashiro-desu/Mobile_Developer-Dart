import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_02/NoteForm/api/AccountAPIService.dart';
import 'package:app_02/NoteForm/model/Account.dart';
import 'package:app_02/NoteForm/view/NoteListScreen.dart';
import 'package:app_02/NoteForm/view/ThemeProvider.dart'; // đường dẫn đến ThemeProvider

// Màn hình đăng nhập, StatefulWidget được sử dụng vì màn hình này có trạng thái thay đổi (loading, input,...)
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey cho Form để kiểm tra và validate các trường nhập liệu
  final _formKey = GlobalKey<FormState>();
  // Controller để lấy giá trị nhập vào từ các TextFormField
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Biến theo dõi trạng thái loading
  bool _isLoading = false;
  // Biến kiểm soát việc hiển thị mật khẩu
  bool _obscurePassword = true;

  // Dispose để giải phóng tài nguyên của controller khi không sử dụng
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm đăng nhập, kiểm tra hợp lệ form và gửi yêu cầu đến API
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Đang trong trạng thái loading
      });

      try {
        // Gửi thông tin đăng nhập đến API để kiểm tra tài khoản
        final account = await AccountAPIService.instance.login(
          _usernameController.text,
          _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        // Nếu đăng nhập thành công
        if (account != null) {
          // Lưu thông tin tài khoản vào SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', account.userId);
          await prefs.setInt('accountId', account.id!);
          await prefs.setString('username', account.username);
          await prefs.setBool('isLoggedIn', true);

          // Điều hướng đến màn hình danh sách ghi chú (NoteListScreen)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NoteListScreen(
                onLogout: _logout,
              ),
            ),
          );
        } else {
          // Nếu đăng nhập thất bại, hiển thị thông báo lỗi
          _showErrorDialog('Đăng nhập thất bại', 'Tên đăng nhập hoặc mật khẩu không đúng hoặc tài khoản không hoạt động.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Nếu có lỗi khi gửi yêu cầu, hiển thị thông báo lỗi
        _showErrorDialog('Lỗi đăng nhập', 'Đã xảy ra lỗi: $e');
      }
    }
  }

  // Hàm đăng xuất, xóa thông tin trong SharedPreferences
  Future<void> _logout() async {
    if (!mounted) return; // Kiểm tra nếu widget đã được xây dựng
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa thông tin người dùng trong SharedPreferences

    if (mounted) {
      // Điều hướng đến màn hình đăng nhập sau khi đăng xuất
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  // Hàm hiển thị thông báo lỗi khi đăng nhập thất bại hoặc có lỗi khác
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Đóng hộp thoại
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy đối tượng ThemeProvider từ Provider để có thể thay đổi chủ đề (Theme)
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        actions: [
          // Nút chuyển đổi giữa chế độ tối và sáng
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme(); // Thay đổi chủ đề
            },
          )
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
              // Biểu tượng tài khoản
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 40),
              // Trường nhập tên đăng nhập
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Trường nhập mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword, // Ẩn mật khẩu
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off, // Hiển thị mật khẩu
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // Thay đổi trạng thái ẩn/hiện mật khẩu
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // Nút đăng nhập
              ElevatedButton(
                onPressed: _isLoading ? null : _login, // Vô hiệu hóa nút khi đang loading
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white) // Hiển thị vòng xoay khi đang loading
                    : Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Nút quên mật khẩu
              Center(
                child: TextButton(
                  onPressed: () {},
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
