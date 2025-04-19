void main(){
  var a = 2; // Khởi tạo biến a với giá trị 2
  print(a); // In giá trị của a
  // Output: 2

  // ??= : sẽ gán giá trị nếu biến hiện tại đang null

  int? b; // Khai báo biến b kiểu int có thể null (nullable), giá trị ban đầu là null
  b ??= 5; // Nếu b đang null, gán giá trị 5 cho b
  print('b = $b'); // In giá trị của b
  // Output: b = 5

  b ??= 10; // Nếu b đang null, gán giá trị 10 cho b (nhưng b hiện tại không null, nên không gán)
  print('b = $b'); // In giá trị của b
  // Output: b = 5
}