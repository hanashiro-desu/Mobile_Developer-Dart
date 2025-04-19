void main(){
  int a = 5; // Khởi tạo biến a với giá trị 5

  print(a++); // Step 1: In giá trị hiện tại của a (5), sau đó tăng a lên 6
  // Output: 5

  print(++a); // Step 2: Tăng a lên 7 trước, sau đó in giá trị mới của a (7)
  // Output: 7

  print(a--); // Step 3: In giá trị hiện tại của a (7), sau đó giảm a xuống 6
  // Output: 7

  print(--a); // Step 4: Giảm a xuống 5 trước, sau đó in giá trị mới của a (5)
  // Output: 5

  print(a); // Step 5: In giá trị hiện tại của a (5)
  // Output: 5
}