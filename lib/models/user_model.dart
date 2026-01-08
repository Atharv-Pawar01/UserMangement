class UserModel {
  final String? id;
  final String name;
  final String email;
  final int age;

  UserModel({
    this.id, 
    required this.name, 
    required this.email, 
    required this.age
  });

  //Reading from Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
    );
  }

  //Writing to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'created_at': DateTime.now(),
    };
  }
}
