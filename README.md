# How to fetch api with flutter 

Let's create a Flutter app that fetches user data from the provided API using the GetX package. I'll guide you through the steps, including setting up the project structure and writing the necessary code.

Project structure
Your project structure in the lib directory will look like this:
```
lib
│-- main.dart
│-- controllers
│   └-- user_controller.dart
│-- models
│   └-- user.dart
│-- services
│   └-- api_service.dart
│-- views
    └-- user_view.dart

```

# Step 1: Setup the project 
1. Add dependencies to 'pubspec.yaml'
```
dependencies:
  flutter:
    sdk: flutter
  get:

```
2. Run flutter pub get to install the dependencies.

# Step 2: Create model
Create a model class for the user data in `lib/models/user.dart`:

```
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  User({required this.id, required this.firstName, required this.lastName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
    );
  }
}

```

# Step 3: Create the API Service
Create a service to fetch the data from the API in `lib/services/api_service.dart`:

```
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/users';

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['users'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}

```
# Step 4: Create the Controller
Create a controller to manage the state in `lib/controllers/user_controller.dart`:
```
import 'package:get/get.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      var fetchedUsers = await ApiService.fetchUsers();
      if (fetchedUsers.isNotEmpty) {
        users.value = fetchedUsers;
      }
    } finally {
      isLoading(false);
    }
  }
}

```

# Step 5: Create the View
Create a view to display the data in `lib/views/user_view.dart`:
```
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: userController.users.length,
            itemBuilder: (context, index) {
              final user = userController.users[index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
              );
            },
          );
        }
      }),
    );
  }
}

```

# Step 6: Set Up the Main File
Finally, set up the main entry point of your application in `lib/main.dart`:
```
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/user_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserView(),
    );
  }
}

```

# Run the Application
Run your application using flutter run. You should see a list of users fetched from the API displayed on the screen.

This setup provides a clean and maintainable structure, leveraging the power of GetX for state management and API interaction.