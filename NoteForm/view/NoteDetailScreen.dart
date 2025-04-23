import 'package:flutter/material.dart';
import '../model/Note.dart';
import 'package:app_02/NoteForm/view/NoteForm.dart';
import 'package:intl/intl.dart';

// Màn hình hiển thị chi tiết một ghi chú cụ thể
class NoteDetailScreen extends StatelessWidget {
  final Note note; // Đối tượng ghi chú được truyền vào
  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  // Hàm định dạng ngày thành chuỗi dd/MM/yyyy
  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    // Xác định màu nền từ thuộc tính `color` của ghi chú
    final color = note.color != null ? Color(int.tryParse(note.color!) ?? 0xFFFFFFFF) : Colors.white;

    return Scaffold(
      backgroundColor: color, // Đặt màu nền cho trang chi tiết
      appBar: AppBar(
        title: const Text('Chi tiết Ghi chú'), // Tiêu đề AppBar
        actions: [
          // Nút chỉnh sửa ghi chú
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Chuyển sang màn hình chỉnh sửa NoteForm
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteForm(note: note)),
              );
              // Nếu ghi chú đã chỉnh sửa được trả về -> thoát khỏi màn hình và reload
              if (result is Note && context.mounted) Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Tiêu đề ghi chú
            Text(note.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Nội dung ghi chú
            Text(note.content),
            const SizedBox(height: 20),

            // Mức độ ưu tiên của ghi chú
            Text('Ưu tiên: ${note.priority}'),
            const SizedBox(height: 8),

            // Ngày tạo và ngày chỉnh sửa
            Text('Ngày tạo: ${_formatDate(note.createdAt)}'),
            Text('Ngày sửa: ${_formatDate(note.modifiedAt)}'),
            const SizedBox(height: 12),

            // Hiển thị các thẻ (tags) nếu có
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 8,
                children: note.tags!
                    .map((tag) => Chip(label: Text(tag))) // Gán mỗi tag vào một Chip
                    .toList(),
              )
          ],
        ),
      ),
    );
  }
}
