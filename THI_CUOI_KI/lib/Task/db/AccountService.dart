import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thick/Task/model/Account.dart';

class DatabaseMethods {
  final CollectionReference accountCollection =
  FirebaseFirestore.instance.collection("User"); // tạo collection

  // Thêm user từ model Account
  Future<void> addAccount(Account account) async {
    await accountCollection.doc(account.userId).set(account.toMap());
  }

  // Lấy thông tin user theo userId
  Future<Account?> getAccountById(String userId) async {
    DocumentSnapshot snapshot = await accountCollection.doc(userId).get();
    if (snapshot.exists) {
      return Account.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Cập nhật user theo userId của firebase
  Future<void> updateAccount(String userId, Map<String, dynamic> data) async {
    await accountCollection.doc(userId).update(data);
  }

  // Cập nhật từ model Account
  Future<void> updateAccountFromModel(Account account) async {
    await accountCollection.doc(account.userId).update(account.toMap());
  }

  // Xóa user
  Future<void> deleteAccount(String userId) async {
    await accountCollection.doc(userId).delete();
  }

  // Lấy toàn bộ user
  Future<List<Account>> getAllAccounts() async {
    QuerySnapshot snapshot = await accountCollection.get();
    return snapshot.docs
        .map((doc) => Account.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

}
