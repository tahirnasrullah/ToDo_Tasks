import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';

class FilterUsers extends StatelessWidget {
  final String statusText;
  final String? selectedUser;
  final ValueChanged<String?> onUserSelected;

  const FilterUsers({
    super.key,
    required this.statusText,
    required this.selectedUser,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    final UserDetailDatabase userDb = UserDetailDatabase();
    final currentUser = FirebaseAuth.instance.currentUser?.displayName;

    return Row(
      children: [
        Text(
          statusText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        SizedBox(width: 10),
        Expanded(
          child: StreamBuilder<List<String>>(
            stream: userDb.getDropdownValues('username'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              final users = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // All Users button
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () => onUserSelected(null),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedUser == null
                              ? Colors.deepPurpleAccent.shade700
                              : Colors.grey.shade200,
                          foregroundColor: selectedUser == null
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text("All Users",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800),),
                      ),
                    ),
                    // Me button
                    if (currentUser != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterElevatedButton(
                          updateUsers: currentUser,
                          selectedUser: selectedUser,
                          onUserSelected: onUserSelected,
                        ),
                      ),
                    // Other users
                    ...users.map(
                      (user) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterElevatedButton(
                          updateUsers: user,
                          selectedUser: selectedUser,
                          onUserSelected: onUserSelected,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FilterElevatedButton extends StatefulWidget {
  final String? selectedUser;
  final ValueChanged<String?> onUserSelected;
  final String updateUsers;

  const FilterElevatedButton({
    super.key,
    this.selectedUser,
    required this.onUserSelected,
    required this.updateUsers,
  });

  @override
  State<FilterElevatedButton> createState() => _FilterElevatedButtonState();
}

class _FilterElevatedButtonState extends State<FilterElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.onUserSelected(widget.updateUsers),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.selectedUser == widget.updateUsers
            ? Colors.deepPurpleAccent.shade700
            : Colors.grey.shade200,
        foregroundColor: widget.selectedUser == widget.updateUsers
            ? Colors.white
            : Colors.black,
      ),
      child: Text(
        widget.updateUsers == FirebaseAuth.instance.currentUser!.displayName
            ? "Me"
            : widget.updateUsers.isNotEmpty
            ? widget.updateUsers
            : "All Users",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800),
      ),
    );
  }
}
