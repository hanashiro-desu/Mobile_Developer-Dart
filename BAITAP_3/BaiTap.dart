/*
BÀI TẬP: Cấu trúc dữ liệu trong Dart
====================================
Bài 1: List

Có bao nhiêu cách để khai báo một List trong đoạn code? Liệt kê và giải thích từng cách.
Cho List ['A', 'B', 'C']. Viết code để:

Thêm phần tử 'D' vào cuối List
Chèn phần tử 'X' vào vị trí thứ 1
Xóa phần tử 'B'
In ra độ dài của List


Đoạn code sau sẽ cho kết quả gì?

dartCopyvar list = [1, 2, 3, 4, 5];
list.removeWhere((e) => e % 2 == 0);
print(list);

Giải thích sự khác nhau giữa các phương thức:

remove() và removeAt()
add() và insert()
addAll() và insertAll()


====================================
Bài 2: Set

Set khác List ở những điểm nào? Nêu ít nhất 3 điểm khác biệt.
Cho hai Set:

dartCopyvar set1 = {1, 2, 3};
var set2 = {3, 4, 5};
Tính kết quả của:

Union (hợp)
Intersection (giao)
Difference (hiệu) của set1 với set2


Đoạn code sau sẽ cho kết quả gì?

dartCopyvar mySet = Set.from([1, 2, 2, 3, 3, 4]);
print(mySet.length);



====================================
Bài 3: Map

Viết code để thực hiện các yêu cầu sau với Map:

dartCopyMap<String, dynamic> user = {
  'name': 'Nam',
  'age': 20,
  'isStudent': true
};

Thêm email: 'nam@gmail.com'
Cập nhật age thành 21
Xóa trường isStudent
Kiểm tra xem Map có chứa key 'phone' không


So sánh hai cách truy cập giá trị trong Map:

dartCopyuser['phone']
user['phone'] ?? 'Không có số điện thoại'

Viết một hàm nhận vào một Map và in ra tất cả các cặp key-value, mỗi cặp trên một dòng.


====================================
Phần 4: Runes

Runes được sử dụng để làm gì? Cho ví dụ cụ thể.
Viết code để:


Tạo một Runes chứa ký tự emoji cười 😀
Chuyển đổi Runes đó thành String
In ra số lượng điểm mã của Runes

*/

void main() {
  // Bài 1: List
  List<String> list = ['A', 'B', 'C'];

  // Thêm phần tử 'D' vào cuối List
  list.add('D');
  print(list); // Output: ['A', 'B', 'C', 'D']

  // Chèn phần tử 'X' vào vị trí thứ 1
  list.insert(1, 'X');
  print(list); // Output: ['A', 'X', 'B', 'C', 'D']

  // Xóa phần tử 'B'
  list.remove('B');
  print(list); // Output: ['A', 'X', 'C', 'D']

  // In ra độ dài của List
  print(list.length); // Output: 4

  // Đoạn code sau sẽ cho kết quả gì?
  var list2 = [1, 2, 3, 4, 5];
  list2.removeWhere((e) => e % 2 == 0);
  print(list2); // Output: [1, 3, 5]

  // Giải thích sự khác nhau giữa các phương thức:
  // remove() và removeAt()
  // remove() xóa phần tử đầu tiên có giá trị bằng với giá trị được cung cấp.
  // removeAt() xóa phần tử tại vị trí chỉ định.

  // add() và insert()
  // add() thêm một phần tử vào cuối danh sách.
  // insert() chèn một phần tử vào vị trí chỉ định.

  // addAll() và insertAll()
  // addAll() thêm tất cả các phần tử của một danh sách khác vào cuối danh sách hiện tại.
  // insertAll() chèn tất cả các phần tử của một danh sách khác vào vị trí chỉ định.

  // Bài 2: Set
  var set1 = {1, 2, 3};
  var set2 = {3, 4, 5};

  // Union (hợp)
  var unionSet = set1.union(set2);
  print(unionSet); // Output: {1, 2, 3, 4, 5}

  // Intersection (giao)
  var intersectionSet = set1.intersection(set2);
  print(intersectionSet); // Output: {3}

  // Difference (hiệu) của set1 với set2
  var differenceSet = set1.difference(set2);
  print(differenceSet); // Output: {1, 2}

  // Đoạn code sau sẽ cho kết quả gì?
  var mySet = Set.from([1, 2, 2, 3, 3, 4]);
  print(mySet.length); // Output: 4

  // Bài 3: Map
  Map<String, dynamic> user = {
    'name': 'Nam',
    'age': 20,
    'isStudent': true
  };

  // Thêm email: 'nam@gmail.com'
  user['email'] = 'nam@gmail.com';

  // Cập nhật age thành 21
  user['age'] = 21;

  // Xóa trường isStudent
  user.remove('isStudent');

  // Kiểm tra xem Map có chứa key 'phone' không
  bool hasPhone = user.containsKey('phone');
  print(hasPhone); // Output: false

  // So sánh hai cách truy cập giá trị trong Map:
  // user['phone']: Trả về giá trị tương ứng với key 'phone', nếu key không tồn tại sẽ trả về null.
  // user['phone'] ?? 'Không có số điện thoại': Trả về giá trị tương ứng với key 'phone', nếu key không tồn tại sẽ trả về chuỗi 'Không có số điện thoại'.

  // Viết một hàm nhận vào một Map và in ra tất cả các cặp key-value, mỗi cặp trên một dòng.
  printMap(user);

  // Phần 4: Runes
  // Tạo một Runes chứa ký tự emoji cười 😀
  var smiley = Runes('\u{1F600}');

  // Chuyển đổi Runes đó thành String
  String smileyString = String.fromCharCodes(smiley);

  // In ra số lượng điểm mã của Runes
  print(smiley.length); // Output: 1
  print(smileyString); // Output: 😀

}

void printMap(Map<String, dynamic> map) {
  map.forEach((key, value) {
    print('$key: $value');
  });
}