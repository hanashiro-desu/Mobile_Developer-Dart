import 'package:flutter/material.dart';  // Thư viện Flutter để xây dựng giao diện
import 'package:intl/intl.dart';  // Thư viện để xử lý định dạng ngày tháng
import 'package:shared_preferences/shared_preferences.dart';  // Thư viện lưu trữ cài đặt người dùng
import 'package:provider/provider.dart';  // Thư viện để quản lý trạng thái (provider)
import '../model/Note.dart';  // Import lớp mô hình ghi chú
import '../api/NoteAPIService.dart';  // Import dịch vụ API để lấy và thao tác với dữ liệu ghi chú
import 'package:app_02/NoteForm/view/NoteForm.dart';  // Import màn hình tạo mới ghi chú
import 'package:app_02/NoteForm/view/NoteDetailScreen.dart';  // Import màn hình chi tiết ghi chú
import 'package:app_02/NoteForm/view/LoginScreen.dart';  // Import màn hình đăng nhập
import 'package:app_02/NoteForm/view/ThemeProvider.dart';  // Import màn hình quản lý theme tối sáng

// Lớp NoteListScreen: Màn hình hiển thị danh sách ghi chú
class NoteListScreen extends StatefulWidget {
  final Function? onLogout;  // Tham số truyền vào để gọi khi người dùng đăng xuất
  const NoteListScreen({super.key, this.onLogout});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

// Lớp _NoteListScreenState: Trạng thái của màn hình danh sách ghi chú
class _NoteListScreenState extends State<NoteListScreen> {
  final NoteAPIService api = NoteAPIService.instance;  // Khởi tạo dịch vụ API để lấy dữ liệu ghi chú
  List<Note> _notes = [];  // Danh sách ghi chú
  bool _isLoading = true;  // Trạng thái loading khi dữ liệu đang được tải
  String _searchQuery = '';  // Truy vấn tìm kiếm
  int? _filterPriority;  // Bộ lọc ưu tiên ghi chú
  final TextEditingController _searchController = TextEditingController();  // Controller cho ô tìm kiếm

  @override
  void initState() {
    super.initState();
    _loadNotes();  // Tải danh sách ghi chú khi màn hình được khởi tạo
  }

  // Hàm tải ghi chú từ API
  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);  // Bắt đầu trạng thái loading
    try {
      List<Note> notes = await api.getAllNotes();  // Lấy tất cả ghi chú từ API
      // Chuyển đổi màu sắc ghi chú nếu cần
      notes = notes.map((note) {
        if (note.color != null && !note.color!.startsWith('0x')) {
          return note.copyWith(color: '0xFF${note.color!.replaceAll('#', '')}');
        }
        return note;
      }).toList();

      // Lọc ghi chú theo mức độ ưu tiên nếu có
      if (_filterPriority != null) {
        notes = notes.where((n) => n.priority == _filterPriority).toList();
      }

      // Tìm kiếm trong ghi chú nếu có truy vấn tìm kiếm
      if (_searchQuery.isNotEmpty) {
        notes = notes.where((n) =>
        n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            n.content.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      }

      setState(() {
        _notes = notes;  // Cập nhật danh sách ghi chú
        _isLoading = false;  // Dừng trạng thái loading
      });
    } catch (e) {
      setState(() => _isLoading = false);  // Dừng trạng thái loading nếu có lỗi
    }
  }

  // Hàm format ngày tháng
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Hàm điều hướng đến màn hình thêm ghi chú
  void _goToAddNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NoteForm()),  // Điều hướng đến màn hình NoteForm
    );
    if (result is Note) {
      await api.createNote(result);  // Tạo ghi chú mới qua API
      _loadNotes();  // Tải lại danh sách ghi chú
    }
  }

  // Hàm điều hướng đến màn hình chỉnh sửa ghi chú
  void _goToEditNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteForm(note: note)),  // Điều hướng đến màn hình chỉnh sửa
    );
    if (result is Note) {
      await api.updateNote(result);  // Cập nhật ghi chú qua API
      _loadNotes();  // Tải lại danh sách ghi chú
    }
  }

  // Hàm xóa ghi chú
  void _delete(int id) async {
    await api.deleteNote(id);  // Xóa ghi chú qua API
    _loadNotes();  // Tải lại danh sách ghi chú
  }

  // Hàm hiển thị hộp thoại xác nhận xóa ghi chú
  void _showDeleteDialog(int noteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa ghi chú này?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _delete(noteId);  // Xóa ghi chú nếu người dùng đồng ý
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị hộp thoại xác nhận đăng xuất
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Hủy')),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _logout();  // Thực hiện đăng xuất
              if (widget.onLogout != null) {
                widget.onLogout!();  // Gọi hàm onLogout nếu có
              }
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Hàm thực hiện đăng xuất
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();  // Lấy SharedPreferences
    await prefs.clear();  // Xóa tất cả dữ liệu đã lưu
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),  // Điều hướng đến màn hình đăng nhập
            (route) => false,  // Xóa tất cả các màn hình hiện tại
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);  // Lấy trạng thái của theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Ghi chú'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadNotes),  // Nút làm mới
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            tooltip: 'Chuyển giao diện sáng/tối',  // Nút chuyển giao diện sáng/tối
            onPressed: themeProvider.toggleTheme,  // Thay đổi theme
          ),
          IconButton(
            icon: const Icon(Icons.logout),  // Nút đăng xuất
            tooltip: 'Đăng xuất',
            onPressed: _showLogoutDialog,
          ),
          PopupMenuButton<int?>(  // Menu lọc theo mức độ ưu tiên
            icon: const Icon(Icons.filter_alt),
            onSelected: (int? val) {
              setState(() => _filterPriority = val);  // Lọc ghi chú theo mức độ ưu tiên
              _loadNotes();
            },
            itemBuilder: (_) => const [
              PopupMenuItem<int?>(value: 3, child: Text('Ưu tiên: Cao')),
              PopupMenuItem<int?>(value: 2, child: Text('Ưu tiên: Trung bình')),
              PopupMenuItem<int?>(value: 1, child: Text('Ưu tiên: Thấp')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,  // Controller tìm kiếm
              onChanged: (val) {
                setState(() => _searchQuery = val);  // Cập nhật truy vấn tìm kiếm
                _loadNotes();  // Tải lại ghi chú khi tìm kiếm
              },
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm ghi chú...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())  // Hiển thị loading khi đang tải
          : _notes.isEmpty
          ? const Center(child: Text('Không có ghi chú'))  // Hiển thị thông báo nếu không có ghi chú
          : ListView.builder(  // Hiển thị danh sách ghi chú
        itemCount: _notes.length,
        itemBuilder: (context, i) {
          final note = _notes[i];
          final bgColor = note.color != null
              ? Color(int.tryParse(note.color!) ?? 0xFFFFFFFF)  // Chuyển màu sắc của ghi chú
              : Colors.white;
          return Card(
            color: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),  // Điều hướng đến màn hình chi tiết ghi chú
                );
                if (result == true) _loadNotes();  // Tải lại ghi chú nếu người dùng quay lại
              },
              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(note.content.length > 100
                      ? '${note.content.substring(0, 100)}...'
                      : note.content),  // Hiển thị nội dung ghi chú (cắt ngắn nếu dài)
                  const SizedBox(height: 6),
                  Text('Tạo: ${_formatDate(note.createdAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  Text('Sửa: ${_formatDate(note.modifiedAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  if (note.tags != null && note.tags!.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: note.tags!
                          .map((tag) => Chip(
                        label: Text(tag),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ))
                          .toList(),
                    )
                ],
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _goToEditNote(note),  // Chỉnh sửa ghi chú
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteDialog(note.id!),  // Xóa ghi chú
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddNote,  // Thêm ghi chú mới
        tooltip: 'Thêm ghi chú mới', // giải thích tên nút này là gì
        child: const Icon(Icons.add),
      ),
    );
  }
}
