void main() {
  // Khai báo biến name và gán giá trị "Shiori-desu"
  String name = "Shiori-desu"; // Biến kiểu chuỗi (String) lưu tên người dùng

  // Khai báo biến age và gán giá trị 18
  int birthday = 13; // Biến kiểu số nguyên (int) lưu tuổi người dùng

  /*
    Kiểm tra điều kiện:
    - Nếu tuổi (birthday) lớn hơn hoặc bằng 13 thì in ra lời chào
    - Nếu không, khối lệnh bên trong if sẽ không được thực thi
  */
  if (birthday >= 13) {
    // In ra màn hình lời chào kèm theo tên người dùng
    print("Xin chào bé $name"); //  $ để chèn giá trị biến vào chuỗi
  }
}