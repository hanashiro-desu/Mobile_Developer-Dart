import 'package:flutter/material.dart';
import '../model/Task.dart';
import '../view/TaskDetailScreen.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function()? onEdit;
  final Function()? onDelete;

  const TaskItem({
    required this.task,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // hộp giới hạn cao 4 rộng 8 => khoảng cách nút
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trạng thái: ${task.status}'),
            Text('Ưu tiên: ${task.priority == 1 ? 'Thấp' : task.priority == 2 ? 'Trung bình' : 'Cao'}'),
            Text('Hoàn thành: ${task.completed ? 'Hoàn thành' : 'Chưa làm'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: Text('Xem'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute( //route
                    builder: (context) => TaskDetailScreen(task: task), 
                  ),
                );
              },
            ),
            TextButton(child: Text('Sửa'), onPressed: onEdit),
            TextButton(child: Text('Xóa'), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
