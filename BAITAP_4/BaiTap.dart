/*

Câu 1: Viết một đoạn mã Dart để khai báo các kiểu dữ liệu khác nhau như số nguyên,
số thực, chuỗi ký tự và Boolean. Sau đó, in giá trị của các biến này ra console để xem
kết quả.

Câu 2: Viết một hàm trong Dart tên là calculateSum nhận vào hai tham số số nguyên
và trả về tổng của chúng. Gọi hàm này trong chương trình chính và in kết quả ra màn
hình.

*/

void main() {
  // Câu 1: Khai báo các kiểu dữ liệu khác nhau và in giá trị của chúng ra console
  int soNguyen = 10; 
  double soThuc = 3.14; 
  String chuoiKyTu = "Xin chào"; 
  bool giaTriBoolean = true; // Khai báo một biến kiểu Boolean (bool) và gán giá trị true.

  print("Giá trị của số nguyên: $soNguyen"); 
  print("Giá trị của số thực: $soThuc"); 
  print("Giá trị của chuỗi ký tự: $chuoiKyTu"); 
  print("Giá trị của Boolean: $giaTriBoolean"); // In giá trị của biến giaTriBoolean ra console.

  // Câu 2: Hàm calculateSum và gọi hàm này trong chương trình chính
  int result = calculateSum(10, 300);
  print("Tổng của 10 và 300 là: $result");
}

int calculateSum(int a, int b) {
  return a + b; // Trả về tổng của hai tham số a và b.
}