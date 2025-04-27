import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_02/NoteForm/model/Note.dart';

// Lớp singleton giúp quản lý kết nối đến cơ sở dữ liệu SQLite
class NoteDatabaseHelper {
  // Khởi tạo singleton cho NoteDatabaseHelper
  static final NoteDatabaseHelper _instance = NoteDatabaseHelper._internal();
  factory NoteDatabaseHelper() => _instance; // Hàm factory để tạo và trả về instance duy nhất của lớp
  NoteDatabaseHelper._internal(); // Constructor private, chỉ có thể tạo qua _instance

  // Biến để lưu trữ đối tượng Database
  Database? _db;

  // Truy cập cơ sở dữ liệu, nếu đã tạo trước đó thì trả về đối tượng database đã tồn tại
  Future<Database> get database async {
    if (_db != null) return _db!; // Nếu đã có database thì trả về
    _db = await _initDB(); // Nếu chưa có, gọi hàm khởi tạo database
    return _db!; // Trả về đối tượng database
  }

  // Hàm khởi tạo cơ sở dữ liệu và tạo bảng nếu chưa có
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // Lấy đường dẫn của cơ sở dữ liệu
    final path = join(dbPath, 'notes.db'); // Kết hợp đường dẫn với tên file cơ sở dữ liệu

    // Mở cơ sở dữ liệu, tạo bảng nếu là lần đầu tiên mở
    return await openDatabase(
      path,
      version: 1, // Phiên bản của cơ sở dữ liệu
      onCreate: (db, version) async {
        // Tạo bảng 'notes' nếu chưa tồn tại
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            priority INTEGER,
            createdAt TEXT,
            modifiedAt TEXT,
            tags TEXT,
            color TEXT
          )
        ''');
      },
    );
  }

  // Hàm thêm một ghi chú mới vào cơ sở dữ liệu
  Future<int> insertNote(Note note) async {
    final db = await database; // Truy cập database
    return await db.insert('notes', note.toMap()); // Chèn ghi chú vào bảng 'notes'
  }

  // Hàm lấy tất cả các ghi chú từ cơ sở dữ liệu
  Future<List<Note>> getAllNotes() async {
    final db = await database; // Truy cập database
    final maps = await db.query('notes'); // Lấy tất cả các bản ghi trong bảng 'notes'
    // Chuyển đổi các bản ghi từ Map thành các đối tượng Note và trả về danh sách
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Hàm cập nhật thông tin của một ghi chú trong cơ sở dữ liệu
  Future<int> updateNote(Note note) async {
    final db = await database; // Truy cập database
    return await db.update(
      'notes',
      note.toMap(), // Cập nhật ghi chú với dữ liệu từ đối tượng Note
      where: 'id = ?', // Điều kiện tìm kiếm theo id
      whereArgs: [note.id], // Truyền id của ghi chú cần cập nhật
    );
  }

  // Hàm xóa một ghi chú khỏi cơ sở dữ liệu theo id
  Future<int> deleteNote(int id) async {
    final db = await database; // Truy cập database
    return await db.delete(
      'notes',
      where: 'id = ?', // Điều kiện tìm kiếm theo id
      whereArgs: [id], // Truyền id của ghi chú cần xóa
    );
  }

  // Hàm tìm kiếm các ghi chú theo tiêu đề hoặc nội dung
  Future<List<Note>> searchNotes(String query) async {
    final db = await database; // Truy cập database
    final maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?', // Tìm kiếm theo title hoặc content
      whereArgs: ['%$query%', '%$query%'], // Thực hiện tìm kiếm với từ khóa
    );
    // Chuyển đổi các bản ghi từ Map thành các đối tượng Note và trả về danh sách
    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
