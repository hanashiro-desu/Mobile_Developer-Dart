import 'dart:convert';
class Task {
  final String id; // Định danh duy nhất của công việc
  final String title; // Tiêu đề công việc
  final String description; // Mô tả chi tiết
  final String status; // Trạng thái công việc (To do, In progress, Done, Cancelled)
  final int priority; // Độ ưu tiên (1: Thấp, 2: Trung bình, 3: Cao)
  final DateTime? dueDate; // Hạn hoàn thành, được chọn bằng DateTimePicker
  final DateTime createdAt; // Thời gian tạo (lưu thời gian khi tạo task)
  final DateTime updatedAt; // Thời gian cập nhật gần nhất (lưu khi mở và sửa task)
  final String? assignedToId; // ID người được giao
  final String createdById; // ID người tạo
  final String? category; // Phân loại công việc
  final List<String>? attachments; // Danh sách link tài liệu đính kèm
  final bool completed; // Trạng thái hoàn thành

  // Constructor
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.assignedToId,
    required this.createdById,
    this.category,
    this.attachments,
    required this.completed,
  });

  // Tạo Task từ Map (JSON)
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      assignedToId: json['assignedToId'],
      createdById: json['createdById'],
      category: json['category'],
      attachments: json['attachments'] != null ? List<String>.from(json['attachments']) : null,
      completed: json['completed'],
    );
  }

  // Chuyển Task thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedToId': assignedToId,
      'createdById': createdById,
      'category': category,
      'attachments': attachments,
      'completed': completed,
    };
  }

  // Phương thức copyWith
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    int? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedToId,
    String? createdById,
    String? category,
    List<String>? attachments,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedToId: assignedToId ?? this.assignedToId,
      createdById: createdById ?? this.createdById,
      category: category ?? this.category,
      attachments: attachments ?? this.attachments,
      completed: completed ?? this.completed,
    );
  }
}
