/*
 Toán tử điều kiện (?:)
 - Cú pháp: expr1 ? expr2 : expr3;
 - Nếu expr1 đúng (true), trả về expr2; ngược lại, trả về expr3.

 Toán tử gán giá trị mặc định (??)
 - Cú pháp: expr1 ?? expr2;
 - Nếu expr1 không null, trả về giá trị của nó; 
   ngược lại trả về expr2.
*/

void main() {
  // Sử dụng toán tử điều kiện (?:)
  // Kiểm tra xem 100 có phải là số chẵn hay không
  var kiemTra = (100 % 2 == 0) ? "100 là số chẵn" : "100 là số lẻ";
  print(kiemTra); // Kết quả: 100 là số chẵn

  // Sử dụng toán tử gán giá trị mặc định (??)
  var x = 100; // x có giá trị là 100
  var y = x ?? 50; // Vì x không null, nên y = 100
  print(y); // Kết quả: 100

  int? z; // z là biến kiểu int? (có thể null), hiện tại chưa được gán giá trị
  y = z ?? 30; // Vì z là null, nên y = 30
  print(y); // Kết quả: 30
}