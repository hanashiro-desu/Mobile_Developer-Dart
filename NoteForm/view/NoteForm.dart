import 'package:flutter/material.dart';
import '../model/Note.dart';
import 'package:intl/intl.dart';

class NoteForm extends StatefulWidget {
  final Note? note; // Ghi chú cũ (nếu có) để sửa
  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  // Khởi tạo key cho form và các controller để quản lý dữ liệu nhập
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  int _priority = 1; // Mức độ ưu tiên mặc định
  String? _color; // Mã màu hex
  DateTime _createdAt = DateTime.now(); // Ngày tạo ghi chú

  @override
  void initState() {
    super.initState();
    // Nếu đang sửa ghi chú, gán dữ liệu cũ vào form
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _tagsController.text = widget.note!.tags?.join(', ') ?? '';
      _priority = widget.note!.priority;
      _color = widget.note!.color;
      _createdAt = widget.note!.createdAt;
    }
  }

  // Mở hộp thoại chọn ngày
  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _createdAt = picked);
    }
  }

  // Hàm lưu dữ liệu nếu form hợp lệ
  void _save() {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(
        id: widget.note?.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        priority: _priority,
        createdAt: _createdAt,
        modifiedAt: DateTime.now(),
        tags: _tagsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        color: _color?.isNotEmpty == true ? _color : null,
      );
      Navigator.pop(context, newNote); // Trả dữ liệu về màn hình trước
    }
  }

  // Định dạng ngày hiển thị
  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.note == null ? 'Thêm Ghi chú' : 'Sửa Ghi chú')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nhập tiêu đề ghi chú
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Nhập tiêu đề' : null,
              ),
              const SizedBox(height: 12),

              // Nhập nội dung ghi chú
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Nội dung'),
                maxLines: 5,
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Nhập nội dung' : null,
              ),
              const SizedBox(height: 12),

              // Chọn mức độ ưu tiên
              DropdownButtonFormField<int>(
                value: _priority,
                decoration:
                const InputDecoration(labelText: 'Mức độ ưu tiên'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (val) => setState(() => _priority = val ?? 1),
              ),
              const SizedBox(height: 12),

              // Nhập nhãn (tags)
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                    labelText: 'Nhãn (cách nhau bởi dấu phẩy)'),
              ),
              const SizedBox(height: 12),

              // Nhập mã màu dạng hex (có kiểm tra hợp lệ)
              TextFormField(
                initialValue: _color,
                decoration: const InputDecoration(labelText: 'Mã màu (hex)'),
                onChanged: (val) => _color = val.trim(),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty) {
                    final cleaned = val.replaceAll('#', '');
                    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(cleaned)) {
                      return 'Mã màu không hợp lệ (VD: #FFAA00 hoặc FFAA00)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Chọn ngày tạo
              Text('Ngày tạo:',
                  style: Theme.of(context).textTheme.labelMedium),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    controller:
                    TextEditingController(text: _formatDate(_createdAt)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Hiển thị ngày cập nhật (nếu có)
              if (widget.note != null)
                Text(
                  'Ngày cập nhật gần nhất: ${_formatDate(widget.note!.modifiedAt)}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

              const SizedBox(height: 20),
              // Nút lưu ghi chú
              ElevatedButton(onPressed: _save, child: const Text('Lưu'))
            ],
          ),
        ),
      ),
    );
  }
}
