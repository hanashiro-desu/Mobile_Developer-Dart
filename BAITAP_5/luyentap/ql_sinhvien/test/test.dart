import '../models/sinhvien.dart';
import '../models/lophoc.dart';

void main() {
  var sv = SinhVien("Huynh Thanh Liem", 22, "SV001", 9);
  print(sv.hoTen);

  sv.hoTen = 'Lai Trieu Minh Anh';
  print(sv.hoTen);

  sv.hoTen = "";
  print(sv.hoTen);

  print(sv.xepLoai());

  sv.hienThiThongTin();

  // ----------------------
  var lopHoc = LopHoc("21DTHF1");
  lopHoc.themSinhVien(SinhVien("Huynh Thanh Liem", 22, 'SV001', 9));
  lopHoc.themSinhVien(SinhVien('Lai Trieu Minh Anh', 22, 'SV002', 9));
  lopHoc.themSinhVien(SinhVien('Nguyen Thien Nhan', 23, 'SV003', 8));
  lopHoc.themSinhVien(SinhVien('Nguyen Ngoc Na', 22, 'SV004', 8.5));
  lopHoc.hienThiDanhSach();
}
