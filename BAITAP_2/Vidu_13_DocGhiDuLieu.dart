import 'dart:io';

void main(){
  // Nhập tên người dùng
  stdout.write('Nhập tên của bạn: ');
  String name = stdin.readLineSync()!;

  // Nhập tuổi người dùng
  stdout.write('Nhập tuổi của bạn: ');
  int age = int.parse(stdin.readLineSync()!);

  print("Xin chào: $name, tuổi của bạn là: $age");
}