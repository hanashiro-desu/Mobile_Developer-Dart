import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/Note.dart';
import 'package:app_02/NoteForm/view/NoteForm.dart';
import 'package:app_02/NoteForm/view/ThemeProvider.dart'; // import ThemeProvider

// Màn hình hiển thị chi tiết một ghi chú cụ thể
class NoteDetailScreen extends StatelessWidget {
  final Note note; // Đối tượng ghi chú được truyền vào
  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  // Hàm định dạng ngày thành chuỗi dd/MM/yyyy
  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Xác định màu nền từ thuộc tính `color` của ghi chú
    final color = note.color != null
        ? Color(int.tryParse(note.color!) ?? 0xFFFFFFFF)
        : Colors.white;

    return Scaffold(
      backgroundColor: color, // Đặt màu nền cho trang chi tiết
      appBar: AppBar(
        title: const Text('Chi tiết Ghi chú'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteForm(note: note)),
              );
              if (result is Note && context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(note.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(note.content),
            const SizedBox(height: 20),
            Text('Ưu tiên: ${note.priority}'),
            const SizedBox(height: 8),
            Text('Ngày tạo: ${_formatDate(note.createdAt)}'),
            Text('Ngày sửa: ${_formatDate(note.modifiedAt)}'),
            const SizedBox(height: 12),
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 8,
                children: note.tags!
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              )
          ],
        ),
      ),
    );
  }
}
