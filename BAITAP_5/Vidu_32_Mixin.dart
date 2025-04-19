/*
Tham khảo bài này: https://viblo.asia/p/dartflutter-so-sanh-abstract-class-interface-mixin-MG24BrX54z3

Mixin là một lớp có chứa các phương thức và thuộc tính dùng để gộp vào một lớp
khác. Mixin không thể được sử dụng để tạo đối tượng trực tiếp. Để sử dụng mixin, sử
dụng từ khóa with.
*/

mixin M {
  int? a; // Thuộc tính a kiểu int, có thể null
  void showSomething() {
    // Phương thức in ra một thông báo
    print("Print message .... ");
  }
}

class B {
  String name = "Class B"; // Thuộc tính name kiểu String, giá trị mặc định là "Class B"
  void displayInformation() {
    // Phương thức in ra thông tin từ lớp B
    print("Information from B");
  }
}

class C extends B with M {
  // Lớp C kế thừa từ lớp B và sử dụng mixin M
  @override
  void displayInformation() {
    // Ghi đè phương thức displayInformation từ lớp B
    showSomething(); // Gọi phương thức showSomething từ mixin M
    a = 100; // Gán giá trị 100 cho thuộc tính a (thuộc mixin M)
  }
}

void main() {
  var c = C(); // Tạo một đối tượng của lớp C
  c.displayInformation(); // Gọi phương thức displayInformation của đối tượng C
}