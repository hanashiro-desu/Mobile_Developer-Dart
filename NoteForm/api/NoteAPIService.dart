import 'dart:convert'; // Thư viện để encode/decode JSON
import 'package:http/http.dart' as http; // Thư viện gửi HTTP request (get, post, put, delete)
import '../model/Note.dart'; // Import model Note (có các hàm fromMap(), toMap())

class NoteAPIService {
  // Singleton Pattern: chỉ tạo ra 1 instance duy nhất của NoteAPIService
  static final NoteAPIService instance = NoteAPIService._init();

  // Địa chỉ cơ bản của API server
  final String baseUrl = 'https://api-pd2d.onrender.com';

  // Constructor private để không ai có thể tạo mới NoteAPIService bên ngoài
  NoteAPIService._init();

  // Hàm lấy tất cả các notes từ server
  Future<List<Note>> getAllNotes() async {
    // Gửi request GET đến /notes
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    if (response.statusCode == 200) {
      // Nếu thành công, decode dữ liệu JSON thành List
      List<dynamic> data = jsonDecode(response.body);
      // Chuyển từng item JSON thành đối tượng Note
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      // Nếu thất bại, ném ra Exception để bắt lỗi
      throw Exception('Failed to load notes: ${response.statusCode}');
    }
  }

  // Hàm lấy 1 note cụ thể theo id
  Future<Note?> getNoteById(int id) async {
    // Gửi request GET đến /notes/{id}
    final response = await http.get(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode == 200) {
      // Nếu tìm thấy, trả về Note từ JSON
      return Note.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      // Nếu không tìm thấy (404), trả về null
      return null;
    } else {
      // Các lỗi khác, ném Exception
      throw Exception('Failed to get note: ${response.statusCode}');
    }
  }

  // Hàm tạo mới 1 note
  Future<Note> createNote(Note note) async {
    // Gửi request POST đến /notes với body là JSON của note
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'}, // Xác định kiểu dữ liệu gửi đi
      body: jsonEncode(note.toMap()), // Chuyển Note thành JSON
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // Nếu tạo thành công, trả về Note mới từ dữ liệu JSON server trả về
      return Note.fromMap(jsonDecode(response.body));
    } else {
      // Nếu thất bại, ném Exception
      throw Exception('Failed to create note: ${response.statusCode}');
    }
  }

  // Hàm cập nhật 1 note
  Future<Note> updateNote(Note note) async {
    // Gửi request PUT đến /notes/{id} với body là JSON của note cập nhật
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );
    if (response.statusCode == 200) {
      // Nếu update thành công, trả về Note mới từ JSON
      return Note.fromMap(jsonDecode(response.body));
    } else {
      // Nếu thất bại, ném Exception
      throw Exception('Failed to update note: ${response.statusCode}');
    }
  }

  // Hàm xóa 1 note theo id
  Future<bool> deleteNote(int id) async {
    // Gửi request DELETE đến /notes/{id}
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode == 200 || response.statusCode == 204) {
      // Nếu xóa thành công (200 hoặc 204 No Content), trả về true
      return true;
    } else {
      // Nếu thất bại, ném Exception
      throw Exception('Failed to delete note: ${response.statusCode}');
    }
  }

  // Hàm tìm kiếm notes theo từ khóa (trong title hoặc content)
  Future<List<Note>> searchNotes(String query) async {
    // Lấy tất cả notes trước
    final notes = await getAllNotes();
    // Lọc ra những note có chứa từ khóa trong title hoặc content (không phân biệt hoa thường)
    return notes.where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Hàm lấy các notes theo mức độ ưu tiên (priority)
  Future<List<Note>> getNotesByPriority(int priority) async {
    // Lấy tất cả notes trước
    final notes = await getAllNotes();
    // Lọc ra những note có priority bằng giá trị yêu cầu
    return notes.where((note) => note.priority == priority).toList();
  }
}
