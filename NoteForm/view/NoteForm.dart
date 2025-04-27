import 'package:flutter/material.dart';
import '../model/Note.dart';
import 'package:intl/intl.dart';

// Lớp NoteForm kế thừa StatefulWidget vì form có thể thay đổi trạng thái
class NoteForm extends StatefulWidget {
  final Note? note; // Ghi chú cũ (nếu có) để sửa, nếu không sẽ là null
  const NoteForm({super.key, this.note}); // Constructor để truyền ghi chú nếu có

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  // Khai báo GlobalKey cho Form để quản lý trạng thái của form
  final _formKey = GlobalKey<FormState>();
  // Các controller cho từng trường thông tin trong form
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _colorController = TextEditingController();

  // Biến lưu trữ thông tin mức độ ưu tiên, màu sắc, và ngày tạo của ghi chú
  int _priority = 1;
  String? _color;
  DateTime _createdAt = DateTime.now();

  // Hàm khởi tạo (initState) sẽ chạy khi widget được tạo ra
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Nếu có ghi chú cũ (sửa ghi chú), điền vào các trường
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _tagsController.text = widget.note!.tags?.join(', ') ?? '';
      _priority = widget.note!.priority;
      _color = widget.note!.color;
      _colorController.text = widget.note!.color ?? '';
      _createdAt = widget.note!.createdAt;
    }
  }

  // Hàm dispose() sẽ chạy khi widget bị hủy, giúp giải phóng bộ nhớ
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  // Hàm chọn ngày sử dụng showDatePicker để người dùng chọn ngày
  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _createdAt = picked); // Cập nhật ngày đã chọn
    }
  }

  // Hàm lưu ghi chú khi người dùng nhấn nút Lưu
  void _save() {
    if (_formKey.currentState!.validate()) { // Kiểm tra tính hợp lệ của form
      final newNote = Note(
        id: widget.note?.id, // Giữ lại id cũ nếu là sửa ghi chú
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        priority: _priority,
        createdAt: _createdAt,
        modifiedAt: DateTime.now(),
        tags: _tagsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(), // Chuyển tags thành danh sách từ chuỗi
        color: _colorController.text.trim().isNotEmpty
            ? _colorController.text.trim() // Nếu có màu sắc, lấy giá trị
            : null,
      );
      Navigator.pop(context, newNote); // Trả về ghi chú mới khi lưu
    }
  }

  // Hàm định dạng ngày tháng theo định dạng 'dd/MM/yyyy'
  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Thêm Ghi chú' : 'Sửa Ghi chú'), // Tiêu đề AppBar tùy theo chế độ thêm hay sửa
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // Padding cho toàn bộ nội dung
        child: Form(
          key: _formKey, // Gắn formKey vào form để quản lý trạng thái form
          child: ListView(
            children: [
              // Trường tiêu đề
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Nhập tiêu đề' : null, // Kiểm tra tính hợp lệ
              ),
              const SizedBox(height: 12),
              // Trường nội dung
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Nội dung'),
                maxLines: 5,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Nhập nội dung'
                    : null,
              ),
              const SizedBox(height: 12),
              // Dropdown cho mức độ ưu tiên
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Mức độ ưu tiên'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (val) => setState(() => _priority = val ?? 1),
              ),
              const SizedBox(height: 12),
              // Trường nhãn
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                    labelText: 'Nhãn (cách nhau bởi dấu phẩy)'),
              ),
              const SizedBox(height: 12),
              // Trường màu sắc
              TextFormField(
                controller: _colorController,
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
              // Hiển thị màu sắc nếu mã hợp lệ
              if (_colorController.text.trim().isNotEmpty &&
                  RegExp(r'^[0-9A-Fa-f]{6}$')
                      .hasMatch(_colorController.text.replaceAll('#', '')))
                Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                        '0xff${_colorController.text.replaceAll('#', '')}')),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              const SizedBox(height: 12),
              // Hiển thị ngày tạo
              Text('Ngày tạo:', style: Theme.of(context).textTheme.labelMedium),
              GestureDetector(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_formatDate(_createdAt)),
                ),
              ),
              const SizedBox(height: 12),
              // Hiển thị ngày cập nhật nếu có
              if (widget.note != null)
                Text(
                  'Ngày cập nhật gần nhất: ${_formatDate(widget.note!.modifiedAt)}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              const SizedBox(height: 20),
              // Nút Lưu
              ElevatedButton(onPressed: _save, child: const Text('Lưu'))
            ],
          ),
        ),
      ),
    );
  }
}
