import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thick/Task/model/Task.dart';
import 'package:thick/Task/model/Account.dart';

class TaskService {
  final _firestore = FirebaseFirestore.instance;
  final CollectionReference _tasks = FirebaseFirestore.instance.collection('tasks');

  // Thêm task mới từ model Task lên firestore
  Future<void> addTask(Task task) async {
    await _tasks.doc(task.id).set(task.toMap());
  }

  // Lấy task theo ID của firebase
  Future<Task?> getTaskById(String taskId) async {
    final doc = await _tasks.doc(taskId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>; // chuyển đổi dữ liệu thành Map
    return Task.fromMap(data);
  }

  // Lấy danh sách tất cả task từ firebase
  Future<List<Task>> getAllTasks() async {
    final snapshot = await _tasks.get();
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)) // tạo đối tượng task từ frommap
        .toList();
  }

  // Cập nhật task theo model task
  Future<void> updateTask(Task task) async {
    await _tasks.doc(task.id).update(task.toMap());
  }

  // Xoá task theo id task
  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }
  // Lấy danh sách task dựa trên vai trò của người dùng
  Future<List<Task>> getTasksByRole(String userId, String role) async {
    if (role.toLowerCase() == 'admin') { // kiểm tra vai trò
      // Admin: Lấy tất cả các task
      final snapshot = await _tasks.get();
      return snapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)) // tạo đối tượng task từ frommap
          .toList();
    } else {
      // User: Lấy các task của họ tạo hoặc được giao
      final snapshot = await _tasks
          .where('createdById', isEqualTo: userId) //  lấy task theo id người tạo
          .get();
      final assignedSnapshot = await _tasks
          .where('assignedToId', isEqualTo: userId) // lấy task theo id người được giao ( assingnedToId)
          .get();

      final createdTasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))  // tạo đối tượng task từ frommap của id người tạo
          .toList();

      final assignedTasks = assignedSnapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)) // tạo đối tượng task từ frommap của id người được giao
          .toList();

      // Gộp danh sách và loại bỏ các task trùng lặp
      final allTasks = {...createdTasks, ...assignedTasks}.toList();
      return allTasks;
    }
  }
}
