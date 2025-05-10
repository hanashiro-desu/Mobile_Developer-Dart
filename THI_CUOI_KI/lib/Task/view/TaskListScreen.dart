import 'package:flutter/material.dart';
import 'package:thick/Task/model/Task.dart';
import 'package:thick/Task/db/TaskService.dart';
import 'package:thick/Task/view/TaskForm.dart';
import 'package:thick/Task/view/TaskItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thick/Task/view/LoginScreen.dart';
import 'package:thick/Task/db/AccountService.dart';

class TaskListScreen extends StatefulWidget {
  final void Function()? onLogout; // call back

  const TaskListScreen({Key? key, this.onLogout}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  List<Task> _tasks = [];
  String _searchText = '';
  String? _selectedStatus;
  String? _selectedPriority;
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final user = FirebaseAuth.instance.currentUser; // Lấy thông tin người dùng hiện tại đăng nhập qua author
    if (user != null) {
      final account = await _databaseMethods.getAccountById(user.uid); // Lấy thông tin tài khoản người dùng
      if (account != null) {
        String role = account.role;
        List<Task> tasks = await _taskService.getTasksByRole(user.uid, role); // Lấy danh sách công việc theo vai trò
        setState(() {
          _tasks = tasks;
        });
      } else {
        print("Không có tài khoản này trong FireStore");
      }
    } else {
      print("Tài khoản không được xác định bởi author");
    }
  }

  void _addOrEditTask({Task? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskForm(task: task)),
    );
    if (result != null) {
      _loadTasks();  // Gọi lại để làm mới danh sách công việc sau khi thêm hoặc chỉnh sửa
    }
  }

  void _deleteTask(Task task) async {
    await _taskService.deleteTask(task.id);
    _loadTasks();  // Tải lại danh sách công việc sau khi xoá
  }

  void _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      widget.onLogout?.call(); // Gọi callback nếu có
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _searchText = '';
      _selectedStatus = null;
      _selectedPriority = null;
    });
  }

  List<Task> _filteredTasks() {
    return _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchText.toLowerCase()); // tìm kiếm theo tiêu đề và không phân biệt chữ hoa chữ thường
      final matchesStatus = _selectedStatus == null  || task.status == _selectedStatus; // lọc trạng thái
      final matchesPriority = _selectedPriority == null ||
          (_selectedPriority == 'thấp' && task.priority == 1) ||
          (_selectedPriority == 'trung bình' && task.priority == 2) ||
          (_selectedPriority == 'cao' && task.priority == 3);
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tìm kiếm + nút xoá bộ lọc
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm theo tiêu đề',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() => _searchText = val),
                    controller: TextEditingController(text: _searchText),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearFilters,
                  tooltip: 'Xóa bộ lọc',
                )
              ],
            ),
          ),
          // Bộ lọc
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Lọc theo trạng thái
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    hint: const Text('Trạng thái'),
                    items: const [
                      DropdownMenuItem(value: 'chưa làm', child: Text('Chưa làm')),
                      DropdownMenuItem(value: 'đang làm', child: Text('Đang làm')),
                      DropdownMenuItem(value: 'hoàn thành', child: Text('Hoàn thành')),
                    ],
                    onChanged: (val) => setState(() => _selectedStatus = val),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 8),
                // Lọc theo ưu tiên
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    hint: const Text('Ưu tiên'),
                    items: const [
                      DropdownMenuItem(value: 'thấp', child: Text('Thấp')),
                      DropdownMenuItem(value: 'trung bình', child: Text('Trung bình')),
                      DropdownMenuItem(value: 'cao', child: Text('Cao')),
                    ],
                    onChanged: (val) => setState(() => _selectedPriority = val),
                    isExpanded: true, // Để mở rộng dropdown
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Danh sách công việc
          Expanded( // Dùng Expanded để giữ chiều cao của ListView
            child: filteredTasks.isEmpty
                ? const Center(child: Text('Không có công việc nào.'))
                : ListView.builder(
              itemCount: filteredTasks.length, // chiều dài or số lượng task theo fillter
              itemBuilder: (context, index) {
                final task = filteredTasks[index]; // lấy task theo index
                return TaskItem( // Hiển thị task theo index
                  task: task,
                  onEdit: () => _addOrEditTask(task: task),
                  onDelete: () => _deleteTask(task),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
