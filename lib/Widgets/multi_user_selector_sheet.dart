import 'package:flutter/material.dart';

class MultiUserSelectorSheet extends StatefulWidget {
  final List<String> users;
  final List<String> selectedUsers;
  final Function(List<String>) onDone;

  const MultiUserSelectorSheet({
    super.key,
    required this.users,
    required this.selectedUsers,
    required this.onDone,
  });

  @override
  State<MultiUserSelectorSheet> createState() =>
      _MultiUserSelectorSheetState();
}

class _MultiUserSelectorSheetState extends State<MultiUserSelectorSheet> {
  late List<String> filteredUsers;
  late List<String> tempSelected;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users;
    tempSelected = List.from(widget.selectedUsers);

    searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = widget.users
          .where((u) => u.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (tempSelected.length == widget.users.length) {
        tempSelected.clear();
      } else {
        tempSelected = List.from(widget.users);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Assign To",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _toggleSelectAll,
                  child: Text(
                    tempSelected.length == widget.users.length
                        ? "Clear All"
                        : "Select All",
                  ),
                ),
              ],
            ),

            /// Search Field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search users",
              ),
            ),

            const SizedBox(height: 10),

            /// User List
            Expanded(
              child: ListView(
                children: filteredUsers.map((user) {
                  return CheckboxListTile(
                    title: Text(user),
                    value: tempSelected.contains(user),
                    onChanged: (bool? selected) {
                      setState(() {
                        selected == true
                            ? tempSelected.add(user)
                            : tempSelected.remove(user);
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            /// Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onDone(tempSelected);
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
