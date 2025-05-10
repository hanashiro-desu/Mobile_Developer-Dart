import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thick/Task/model/Task.dart';
import 'package:thick/Task/db/TaskService.dart';
import 'package:thick/Task/db/AccountService.dart';
import 'package:thick/Task/model/Account.dart';
import 'package:file_picker/file_picker.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _completed = false;
  int _priority = 1;
  DateTime _dueDate = DateTime.now();
  String _status = 'chưa làm';
  final TaskService _taskService = TaskService();

  List<Account> _userList = [];
  Account? _selectedUser;
  List<String> _attachments = []; // Danh sách file đính kèm

  @override
  void initState() {
    super.initState();
    _loadUsers();
    // Nếu đang sửa task, gán các giá trị ban đầu
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _categoryController.text = widget.task!.category ?? '';
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate ?? DateTime.now();
      _status = widget.task!.status ?? 'chưa làm';
      _completed = widget.task!.completed;
    }
  }
  // đính kèm file
  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // chon nhiều file cùng lúc
      type: FileType.any, // chọn loại file nào
    );

    if (result != null) { // nếu chọn file
      setState(() {
        _attachments.addAll(result.paths.whereType<String>()); // thêm vào danh sách đường dẫn file đính kèm
      });
    }
  }
  // xóa đính kèm
  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }
  // lấy danh sách người dùng
  Future<void> _loadUsers() async {
    final users = await DatabaseMethods().getAllAccounts(); // Lấy danh sách người dùng từ Firestore
    setState(() {
      _userList = users; // lưu các user đã lấy vô biến
      // Nếu đang sửa task, gán selectedUser
      if (widget.task != null && widget.task!.assignedToId != null) { // kiểm tra task có đang sửa hay thuộc id người đc giao
        _selectedUser = users.firstWhere( // tìm user đó trong danh sách users
              (u) => u.userId == widget.task!.assignedToId,
          orElse: () => users.isNotEmpty
              ? users[0] // nếu ds rỗng thì user đầu tiên nó đc chọn
              : Account(
            userId: 'defaultUserId',
            username: 'Default User',
            password: '',
            email: 'default@example.com',
            lastLogin: DateTime.now().toString(),
            createdAt: DateTime.now().toString(),
            role: 'user',
          ),
        );
      }
    });
  }

// Dispose để giải phóng tài nguyên của controller khi không sử dụng
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
  // chọn khoảng năm
  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) { // kiểm tra các trường nhập liệu có hợp lệ không
      final newTask = Task( // tạo task mới
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        completed: _status == 'hoàn thành',
        dueDate: _dueDate,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        category: _categoryController.text.trim(),
        assignedToId: _selectedUser?.userId,
        createdById: 'currentUserId',
        attachments: widget.task?.attachments ?? [],
        status: _status,
      );
      // lưu task vào Firestore
      if (widget.task == null) {
        await _taskService.addTask(newTask);
      } else {
        await _taskService.updateTask(newTask);
      }
      // Trả về task đã lưu
      if (mounted) Navigator.pop(context, newTask); // mounted là boolean kiểm tra widget đã được build hay chưa
    }
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Thêm Công việc' : 'Sửa Công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Nhập tiêu đề' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLines: 5,
                validator: (val) => val == null || val.trim().isEmpty ? 'Nhập mô tả' : null,
              ),
              const SizedBox(height: 12),
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
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Thể loại'),
              ),
              const SizedBox(height: 12),

              // Gửi cho (Dropdown chọn người dùng)
              DropdownButtonFormField<Account>(
                value: _selectedUser,
                decoration: const InputDecoration(labelText: 'Gửi cho'),
                items: _userList.map((user) {
                  return DropdownMenuItem(
                    value: user,
                    child: Text('${user.username} (${user.email})'),
                  );
                }).toList(),
                onChanged: (user) {
                  setState(() {
                    _selectedUser = user;
                  });
                },
                validator: (val) => val == null ? 'Chọn người nhận' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                items: const [
                  DropdownMenuItem(value: 'chưa làm', child: Text('Chưa làm')),
                  DropdownMenuItem(value: 'đang làm', child: Text('Đang làm')),
                  DropdownMenuItem(value: 'hoàn thành', child: Text('Hoàn thành')),
                ],
                onChanged: (val) => setState(() => _status = val ?? 'chưa làm'),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text('Hoàn thành:'),
                  const SizedBox(width: 10),
                  Switch(
                    value: _completed,
                    onChanged: (value) {
                      setState(() {
                        _completed = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Ngày hết hạn:', style: Theme.of(context).textTheme.labelMedium),
              GestureDetector(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_formatDate(_dueDate)),
                ),
              ),
              const SizedBox(height: 12),

              // File đính kèm
              Text('File đính kèm:', style: Theme.of(context).textTheme.labelMedium),
              ElevatedButton.icon(
                onPressed: _pickAttachments,
                icon: const Icon(Icons.attach_file),
                label: const Text('Chọn file'),
              ),
              const SizedBox(height: 8),
              ..._attachments.map((path) => ListTile(
                title: Text(path.split('/').last),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeAttachment(_attachments.indexOf(path)),
                ),
              )),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Lưu')),
            ],
          ),
        ),
      ),
    );
  }
}
