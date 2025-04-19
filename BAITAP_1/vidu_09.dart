void main(){
  Object obj = 'Xin chao cac ban'; // Khởi tạo một biến obj kiểu Object, gán giá trị chuỗi

  // Kiểm tra obj có phải là String
  if (obj is String) {
    print('obj la mot String'); // Nếu obj là String, in ra thông báo
  }

  // Kiểm tra obj không phải kiểu int
  if (obj is! int) {
    print("obj khong phai la so nguyen int"); // Nếu obj không phải int, in ra thông báo
  }

  // Ép kiểu
  String str = obj as String; // Ép obj từ kiểu Object sang String
  print(str.toUpperCase()); // Chuyển chuỗi thành chữ in hoa và in ra
}