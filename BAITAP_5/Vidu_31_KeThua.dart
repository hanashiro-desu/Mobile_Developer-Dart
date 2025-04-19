abstract class Product {
  double price;
  int quantity;
  String name;

  Product(this.price, this.quantity, this.name);

// Phương thức trừu tượng (không có phần thân)
  void showDetails();

  // Phương thức thông thường
  void showTotal() {
    print("Total price is: ${price * quantity}");
  }
}

class Tablet extends Product {
  double width;
  double height;

  Tablet(this.width, this.height, double price, int quantity, String name)
    : super(price, quantity, name);

// Ghi đè phương thức trừu tượng
  @override
  void showDetails() {
    print("Tablet: $name, Width: $width, Height: $height");
  }

  @override
  void showTotal() {
    print("Name of Tablet: $name");
    super.showTotal();
  }
}

void main() {
  // Product p = Product(6000000, 1, "San Pham"); // Lỗi: Không thể khởi tạo lớp trừu tượng

  Tablet t = Tablet(7, 6, 15000000, 10, "Day chuyen kim cuong mau hong");
t.showDetails(); // Gọi phương thức ghi đè
  t.showTotal();   // Gọi phương thức ghi đè
}

// Nghien cuu ve lop truu tuong (abstract class)
// Lớp trừu tượng (abstract class) là một lớp không thể khởi tạo trực tiếp.
// Nó có thể chứa các phương thức trừu tượng (không có phần thân) và các phương thức thông thường.
// Các lớp con kế thừa từ lớp trừu tượng phải ghi đè các phương thức trừu tượng.
