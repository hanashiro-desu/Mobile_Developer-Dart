import 'package:flutter/material.dart';
import '../model/Note.dart';

// Widget hiển thị thông tin ghi chú
class NoteItem extends StatelessWidget {
  final Note note;  // Tham số ghi chú (note) cần hiển thị
  final VoidCallback onTap;  // Hành động khi nhấn vào ghi chú
  final VoidCallback onDelete;  // Hành động khi nhấn nút xóa

  // Constructor nhận vào 3 tham số: ghi chú, hành động nhấn, hành động xóa
  const NoteItem({super.key, required this.note, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    // Lấy màu nền của ghi chú, nếu không có màu, sẽ mặc định là màu trắng
    final bgColor = note.color != null ? Color(int.tryParse(note.color!) ?? 0xFFFFFFFF) : Colors.white;

    return Card(
      color: bgColor,  // Đặt màu nền của Card theo màu ghi chú
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),  // Lề của Card
      child: ListTile(
        onTap: onTap,  // Hành động khi nhấn vào ghi chú
        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),  // Tiêu đề ghi chú
        subtitle: Text(note.content.length > 60 ? '${note.content.substring(0, 60)}...' : note.content),  // Mô tả ghi chú, nếu dài hơn 60 ký tự thì chỉ hiển thị 60 ký tự đầu
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),  // Biểu tượng nút xóa (màu đỏ)
          onPressed: onDelete,  // Hành động khi nhấn nút xóa
        ),
      ),
    );
  }
}
