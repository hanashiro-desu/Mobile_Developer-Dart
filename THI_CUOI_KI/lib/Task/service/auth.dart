import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:thick/Task/db/AccountService.dart';
import 'package:thick/Task/model/Account.dart';
import 'package:thick/Task/view/LoginScreen.dart';
import 'package:thick/Task/view/TaskListScreen.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseMethods databaseMethods = DatabaseMethods();

  // Lấy thông tin người dùng hiện tại , nếu người dùng chưa đăng nhập, nó sẽ trả về null
  Future<User?> getCurrentUser() async {
    return await auth.currentUser;
  }

  // Đăng nhập bằng Google
  Future<void> signInWithGoogle(BuildContext context) async {
    final googleSignIn  = GoogleSignIn(
      clientId: 'ID của web em sài', // Dán client ID vừa sao chép ở đây
    );

    // chứa tài khoản google
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    // Nếu người dùng  dừng việc đăng nhập bằng google
    if (googleSignInAccount == null) return;

    // lấy thông tin xác thực(id or token) của google
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    //  sử dụng thông tin xác thực dùng để đăng nhập vào Firebase.
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    // đăng nhập bằng thông tin xác thực của google vào firebase
    UserCredential result = await auth.signInWithCredential(credential);
    User? userDetails = result.user;

    // Nếu người dùng đăng nhập thành công, lập tức nó thêm dữ liệu ho lên firestore
    if (userDetails != null) {
      Map<String, dynamic> userInfoMap = { // chuyển thông tin người dùng thành map
        "email": userDetails.email,
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid,
        "lastLogin": DateTime.now().toString(),
        "createdAt": DateTime.now().toString(),
      };

      // Tạo tài khoản
      Account account = Account(
        userId: userDetails.uid,
        username: userDetails.displayName ?? '',
        email: userDetails.email ?? '',
        avatar: userDetails.photoURL,
        lastLogin: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
        password: '',
        role: 'user',
      );

      // Thêm vào  Firestore
      await databaseMethods.addAccount(account);

      // Login thành công thì nhảy đến Task quản lý
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );
    }
  }

  // Đăng nhập bằng email/gmail sử dụng Firebase Author trong flutter
  Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password); // đăng nhập bằng email/gmail

      // chuyển hướng đến task quản lý
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, 'Login Failed', e.message ?? 'An error occurred'); // Nếu đăng nhập thất bại (sai tài khoản, mật khẩu...)
    }
  }

  //  báo lỗi khi có vấn đề xảy ra trong quá trình đăng nhập.
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Đăng xuất
  Future<void> signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacement( // ko back lại như push  như xếp chồng thẻ
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
