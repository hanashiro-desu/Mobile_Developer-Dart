void main()
{
  var s1 ='Huynh Thanh Liem';
  var s2 ='F house';

  // chèn giá trị của một biểu thức, biến vào trong chuỗi: ${...}
  double diemT = 9.5;
  double diemV = 8.5;
  var s3 = 'Xin chao $s1, diem trung binh cua ban la: ${diemT + diemV}';
  print(s3);
  // Tạo ra chuỗi nằm ở nhiều dòng
  var s4 = '''
      Dòng 1
      Dòng 2
      Dòng 3
      Dòng 4  
  ''';

  var s5 = '''
      Dòng 1
      Dòng 2
      Dòng 3
      Dòng 4  
  ''';
  var s6 = 'Đây là một đoạn \n văn bản !'; //raw
  print(s6);
  
  var s7 = r'Dây là một đoạn \n văn bản !'; //raw
  print(s7);
}