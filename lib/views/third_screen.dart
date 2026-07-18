import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final ApiService api = ApiService();

  List<UserModel> users = [];

  int page = 1;

  bool loading = false;

  bool hasMore = true;

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    loadUsers();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        loadUsers();
      }
    });
  }

  Future loadUsers() async {
    if (loading || !hasMore) return;

    loading = true;

    final data = await api.getUsers(page);

    if (data.isEmpty) {
      hasMore = false;
    } else {
      page++;

      users.addAll(data);
    }

    loading = false;

    setState(() {});
  }

  Future refresh() async {
    page = 1;

    hasMore = true;

    users.clear();

    await loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Third Screen", style: TextStyle(fontFamily: "Poppins", fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade300),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: refresh,

        child: users.isEmpty
            ? const Center(child: Text("No Users"))
            : ListView.separated(
                controller: controller,

                itemCount: users.length,

                separatorBuilder: (_, __) => Divider(),

                itemBuilder: (_, index) {
                  final user = users[index];

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 28,

                      backgroundImage: NetworkImage(user.avatar),
                    ),

                    title: Text(
                      "${user.firstName} ${user.lastName}",

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(user.email.toUpperCase()),

                    onTap: () {
                      Navigator.pop(
                        context,

                        "${user.firstName} ${user.lastName}",
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
