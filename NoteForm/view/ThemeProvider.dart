import 'package:flutter/material.dart';

// Tạo lớp ThemeProvider, kế thừa từ ChangeNotifier để có thể thông báo cho các widget khác khi dữ liệu thay đổi
class ThemeProvider with ChangeNotifier {
  // Biến _themeMode lưu trạng thái của chế độ giao diện, mặc định là hệ thống (ThemeMode.system)
  ThemeMode _themeMode = ThemeMode.system;

  // Getter để truy cập giá trị của _themeMode
  ThemeMode get themeMode => _themeMode;

  // Hàm toggleTheme sẽ thay đổi chế độ giao diện từ sáng sang tối và ngược lại
  void toggleTheme() {
    // Nếu chế độ hiện tại là sáng, chuyển sang tối
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      // Ngược lại, chuyển sang chế độ sáng
      _themeMode = ThemeMode.light;
    }
    // Gọi notifyListeners để thông báo rằng dữ liệu đã thay đổi, các widget sử dụng provider này sẽ được cập nhật
    notifyListeners();
  }
}
