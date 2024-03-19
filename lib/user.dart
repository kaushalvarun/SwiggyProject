// // ignore_for_file: prefer_initializing_formals
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:json_annotation/json_annotation.dart';
// part 'user.g.dart';

// @JsonSerializable()
// class SwUser {
//   String username;
//   String email;

//   SwUser({
//     required String username,
//     required String email,
//   })  : username = username,
//         email = email;

//   Map<String, dynamic> toMap() {
//     return {
//       'username': username,
//       'email': email,
//     };
//   }

//   // Fetch data from db format
//   factory SwUser.fromJson(Map<String, dynamic> json) => _$SwUserFromJson(json);

//   // Write data to db format
//   Map<String, dynamic> toJson() => _$SwUserToJson(this);

//   String getUsername() {
//     return username;
//   }

//   void setUsername(String username) {
//     username = username;
//   }

//   String getEmail() {
//     return email;
//   }

//   void setEmail(String email) {
//     email = email;
//   }

//   @override
//   String toString() {
//     return 'SwUser{username: $username, email: $email}';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is SwUser &&
//         other.username == username &&
//         other.email == email;
//   }

//   @override
//   int get hashCode => username.hashCode ^ email.hashCode;
// }

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Future<SwUser?> userfromEmail(String email) async {
//   try {
//     var userDocs = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();

//     if (userDocs.docs.isNotEmpty) {
//       Map<String, dynamic> userMap = userDocs.docs[0].data();
//       return SwUser.fromJson(userMap);
//     }
//   } catch (e) {
//     // ignore: avoid_print
//     print('Error getting user from email \n=>Error: $e');
//   }
//   return null; // user is not found or an error occurs
// }
