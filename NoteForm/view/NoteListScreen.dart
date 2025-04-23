import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Note.dart';
import '../api/NoteAPIService.dart';
import 'package:app_02/NoteForm/view/NoteForm.dart';
import 'package:app_02/NoteForm/view/NoteDetailScreen.dart';
import 'package:app_02/NoteForm/view/LoginScreen.dart';

// Màn hình danh sách ghi chú
class NoteListScreen extends StatefulWidget {
  final Function? onLogout;  // Hành động khi người dùng đăng xuất (nếu có)
  const NoteListScreen({super.key, this.onLogout});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteAPIService api = NoteAPIService.instance;  // Dịch vụ API để quản lý ghi chú
  List<Note> _notes = [];  // Danh sách ghi chú
  bool _isLoading = true;  // Biến kiểm tra trạng thái tải dữ liệu
  String _searchQuery = '';  // Biến lưu trữ truy vấn tìm kiếm
  int? _filterPriority;  // Lọc theo độ ưu tiên ghi chú
  final TextEditingController _searchController = TextEditingController();  // Controller tìm kiếm

  @override
  void initState() {
    super.initState();
    _loadNotes();  // Tải ghi chú khi màn hình được khởi tạo
  }

  // Tải danh sách ghi chú từ API
  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);  // Đặt trạng thái đang tải
    try {
      List<Note> notes = await api.getAllNotes();  // Lấy tất cả ghi chú

      // Chuyển đổi màu sắc nếu màu không đúng định dạng
      notes = notes.map((note) {
        if (note.color != null && !note.color!.startsWith('0x')) {
          return note.copyWith(color: '0xFF${note.color!.replaceAll('#', '')}');
        }
        return note;
      }).toList();

      // Lọc ghi chú theo độ ưu tiên nếu có
      if (_filterPriority != null) {
        notes = notes.where((n) => n.priority == _filterPriority).toList();
      }

      // Lọc ghi chú theo truy vấn tìm kiếm nếu có
      if (_searchQuery.isNotEmpty) {
        notes = notes.where((n) =>
        n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            n.content.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      }

      setState(() {
        _notes = notes;  // Cập nhật danh sách ghi chú
        _isLoading = false;  // Đặt trạng thái tải xong
      });
    } catch (e) {
      setState(() => _isLoading = false);  // Đặt trạng thái nếu có lỗi
    }
  }

  // Định dạng ngày giờ
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Chuyển đến màn hình thêm ghi chú
  void _goToAddNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NoteForm()),  // Mở màn hình thêm ghi chú
    );
    if (result is Note) {
      await api.createNote(result);  // Tạo ghi chú mới
      _loadNotes();  // Tải lại danh sách ghi chú
    }
  }

  // Chuyển đến màn hình chỉnh sửa ghi chú
  void _goToEditNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteForm(note: note)),  // Mở màn hình chỉnh sửa ghi chú
    );
    if (result is Note) {
      await api.updateNote(result);  // Cập nhật ghi chú
      _loadNotes();  // Tải lại danh sách ghi chú
    }
  }

  // Xóa ghi chú theo id
  void _delete(int id) async {
    await api.deleteNote(id);  // Xóa ghi chú
    _loadNotes();  // Tải lại danh sách ghi chú
  }

  // Hiển thị hộp thoại xác nhận xóa
  void _showDeleteDialog(int noteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa ghi chú này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _delete(noteId);  // Xóa ghi chú
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Hiển thị hộp thoại xác nhận đăng xuất
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _logout();  // Đăng xuất
              if (widget.onLogout != null) {
                widget.onLogout!();  // Thực hiện hành động đăng xuất bên ngoài nếu có
              }
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Đăng xuất người dùng và chuyển đến màn hình đăng nhập
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Xóa dữ liệu người dùng lưu trữ
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),  // Chuyển đến màn hình đăng nhập
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Ghi chú'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadNotes),  // Tải lại danh sách ghi chú
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: _showLogoutDialog,  // Hiển thị hộp thoại đăng xuất
          ),
          PopupMenuButton<int?>(  // Lọc ghi chú theo độ ưu tiên
            icon: const Icon(Icons.filter_alt),
            onSelected: (int? val) {
              setState(() {
                _filterPriority = val;  // Cập nhật độ ưu tiên lọc
              });
              _loadNotes();  // Tải lại danh sách ghi chú
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
              controller: _searchController,
              onChanged: (val) {
                setState(() => _searchQuery = val);  // Cập nhật truy vấn tìm kiếm
                _loadNotes();  // Tải lại danh sách ghi chú
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
          ? const Center(child: CircularProgressIndicator())  // Hiển thị loading nếu đang tải
          : _notes.isEmpty
          ? const Center(child: Text('Không có ghi chú'))  // Hiển thị nếu không có ghi chú
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, i) {
          final note = _notes[i];
          final bgColor = note.color != null
              ? Color(int.tryParse(note.color!) ?? 0xFFFFFFFF)
              : Colors.white;
          return Card(
            color: bgColor,  // Màu nền của Card ghi chú
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),  // Mở màn hình chi tiết ghi chú
                );
                if (result == true) _loadNotes();  // Tải lại ghi chú nếu có thay đổi
              },
              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),  // Tiêu đề ghi chú
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(note.content.length > 100
                      ? '${note.content.substring(0, 100)}...'
                      : note.content),  // Mô tả ngắn về ghi chú
                  const SizedBox(height: 6),
                  Text('Tạo: ${_formatDate(note.createdAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),  // Ngày tạo ghi chú
                  Text('Sửa: ${_formatDate(note.modifiedAt)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),  // Ngày sửa ghi chú
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
                    )  // Hiển thị thẻ tags nếu có
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
        tooltip: 'Thêm ghi chú mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}
