import '../models/nhanvien.dart';
import '../models/nhanvienbanhang.dart';

void main() {
  // Test nhân viên thường
  Nhanvien nv = Nhanvien('NV001', 'Lai Trieu Minh Anh', 17500000);
  print('Thồng tin nhân viên thường: ');
  nv.hienThiThongTin();

  // Test nhân viên bán hàng
  NhanVienBanHang nv_BH = NhanVienBanHang('NV002', 'Huynh Thanh Liem', 1000000, 1500000, 0.03);
  print('\nThông tin nhân viên bán hàng:');
  nv_BH.hienThiThongTin();
}
