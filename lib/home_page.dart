import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  var listTodayTasks = [
    {'title': 'tt', 'cc': 'tt'},
    {'title': '22', 'cc': 'pp'},
    {'title': '88', 'cc': '90'},
    {'title': '88', 'cc': '90'},
    {'title': 'tt', 'cc': 'tt'},
    {'title': '22', 'cc': 'pp'},
    {'title': '88', 'cc': '90'},
    {'title': '88', 'cc': '90'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        iconSize: 20,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 0),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(70),
          ),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Todo DailyTasks',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnVvDx9Kezwg0D77WzdAUzjOEHf1WEqQ3-fA&s',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.grey,
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: listTodayTasks
                    .map(
                      (value) => Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Assigned to Others",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.grey,
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: listTodayTasks
                    .map(
                      (value) => Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Completed Tasks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'more...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: listTodayTasks
                    .map(
                      (value) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(tileColor: Colors.grey,),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
