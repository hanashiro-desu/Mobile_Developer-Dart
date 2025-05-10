import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/Task.dart';
import '../db/TaskService.dart';
import '../view/TaskForm.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Tiêu đề: ${task.title}'),
            Text('Mô tả: ${task.description}'),
            Text('Trạng thái: ${task.status}'),
            Text('Ưu tiên: ${task.priority == 1 ? 'Thấp' : task.priority == 2 ? 'Trung bình' : 'Cao'}'),
            Text('Hoàn thành: ${task.completed ? 'Hoàn thành' : task.status == 'In progress' ? 'Đang làm' : 'Chưa làm'}'),
            Text('Hạn: ${task.dueDate?.toLocal().toIso8601String().substring(0, 10) ?? 'Không có'}'),
            Text('Danh mục: ${task.category ?? ''}'),
            Text('Người được giao: ${task.assignedToId ?? ''}'),
            Text('Tạo lúc: ${task.createdAt.toIso8601String()}'),
            SizedBox(height: 10),
            Text('Tệp đính kèm:'),
            ...(task.attachments ?? []).map((file) => Text(file)).toList(),
          ],
        ),
      ),
    );
  }
}
