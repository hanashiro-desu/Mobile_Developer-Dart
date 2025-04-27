class Note {
  // Các thuộc tính của lớp Note (không thay đổi được sau khi đối tượng được tạo ra)
  final int? id;  // ID của ghi chú, có thể null
  final String title;  // Tiêu đề của ghi chú
  final String content;  // Nội dung của ghi chú
  final int priority;  // Mức độ ưu tiên của ghi chú (1, 2, 3, ...)
  final DateTime createdAt;  // Ngày tạo ghi chú
  final DateTime modifiedAt;  // Ngày sửa đổi ghi chú lần cuối
  final List<String>? tags;  // Danh sách các tag (thẻ) của ghi chú, có thể null
  final String? color;  // Màu sắc của ghi chú, có thể null

  // Constructor: Khởi tạo một đối tượng Note mới với các giá trị bắt buộc và không bắt buộc
  Note({
    this.id,  // ID có thể null
    required this.title,  // Tiêu đề không thể null
    required this.content,  // Nội dung không thể null
    required this.priority,  // Mức độ ưu tiên không thể null
    required this.createdAt,  // Ngày tạo không thể null
    required this.modifiedAt,  // Ngày sửa đổi không thể null
    this.tags,  // Tag có thể null
    this.color,  // Màu sắc có thể null
  });

  // Phương thức factory để tạo một đối tượng Note từ Map (thường là JSON từ API)
  factory Note.fromMap(Map<String, dynamic> json) {
    return Note(
      id: json['id'],  // Truyền ID từ Map
      title: json['title'],  // Truyền tiêu đề từ Map
      content: json['content'],  // Truyền nội dung từ Map
      priority: json['priority'],  // Truyền mức độ ưu tiên từ Map
      createdAt: DateTime.parse(json['createdAt']),  // Chuyển đổi chuỗi thành DateTime
      modifiedAt: DateTime.parse(json['modifiedAt']),  // Chuyển đổi chuỗi thành DateTime
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,  // Chuyển tags từ List trong Map thành List<String>
      color: json['color'],  // Màu sắc từ Map
    );
  }

  // Phương thức chuyển đối tượng Note thành Map để gửi lên API hoặc lưu trữ
  Map<String, dynamic> toMap() {
    return {
      'id': id,  // Chuyển ID sang Map
      'title': title,  // Chuyển tiêu đề sang Map
      'content': content,  // Chuyển nội dung sang Map
      'priority': priority,  // Chuyển mức độ ưu tiên sang Map
      'createdAt': createdAt.toIso8601String(),  // Chuyển DateTime thành chuỗi theo định dạng dd/mm/yyyy
      'modifiedAt': modifiedAt.toIso8601String(),  // Chuyển DateTime thành chuỗi theo định dạng dd/mm/yyyy
      'tags': tags,  // Chuyển tags sang Map (nếu có)
      'color': color,  // Chuyển màu sắc sang Map (nếu có)
    };
  }

  // Phương thức tạo bản sao của đối tượng Note với một số thuộc tính có thể thay đổi
  Note copyWith({
    int? id,  // ID có thể thay đổi, nếu không thì giữ nguyên giá trị cũ
    String? title,  // Tiêu đề có thể thay đổi
    String? content,  // Nội dung có thể thay đổi
    int? priority,  // Mức độ ưu tiên có thể thay đổi
    DateTime? createdAt,  // Ngày tạo có thể thay đổi
    DateTime? modifiedAt,  // Ngày sửa đổi có thể thay đổi
    List<String>? tags,  // Tags có thể thay đổi
    String? color,  // Màu sắc có thể thay đổi
  }) {
    return Note(
      id: id ?? this.id,  // Nếu không truyền ID mới thì giữ nguyên ID cũ
      title: title ?? this.title,  // Nếu không truyền tiêu đề mới thì giữ nguyên tiêu đề cũ
      content: content ?? this.content,  // Nếu không truyền nội dung mới thì giữ nguyên nội dung cũ
      priority: priority ?? this.priority,  // Nếu không truyền mức độ ưu tiên mới thì giữ nguyên mức độ ưu tiên cũ
      createdAt: createdAt ?? this.createdAt,  // Nếu không truyền ngày tạo mới thì giữ nguyên ngày tạo cũ
      modifiedAt: modifiedAt ?? this.modifiedAt,  // Nếu không truyền ngày sửa đổi mới thì giữ nguyên ngày sửa đổi cũ
      tags: tags ?? this.tags,  // Nếu không truyền tags mới thì giữ nguyên tags cũ
      color: color ?? this.color,  // Nếu không truyền màu sắc mới thì giữ nguyên màu sắc cũ
    );
  }

  // Phương thức toString() giúp in ra mô tả ngắn gọn của đối tượng Note, thuận tiện cho việc debug
  @override
  String toString() {
    return 'Note(id: $id, title: $title, priority: $priority)';
  }
}
