import 'package:e_learning/data/side_menu_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int selectedIndex = 0;

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'data',
            style: TextStyle(color: Color.fromARGB(255, 11, 20, 58)),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => _confirmLogout(context),
              icon: Icon(
                Icons.logout_rounded,
                color: Color.fromARGB(255, 11, 20, 58),
              ),
            ),
          ],
          backgroundColor: Color.fromARGB(255, 209, 217, 248),
        ),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(flex: 2, child: SizedBox(child: _sideMenu(context))),
              Expanded(flex: 7, child: Container(child: _home())),
              Expanded(flex: 3, child: Container(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sideMenu(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade400 : Colors.transparent,
            ),
            child: InkWell(
              onTap: () => setState(() {
                selectedIndex = index;
              }),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      data.menu[index].icon,
                      color: isSelected ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    data.menu[index].title,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _home() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          SizedBox(height: 12),
          _headerWidget(),
          SizedBox(height: 12),
          _activityDetails(),
        ],
      ),
    );
  }

  Widget _headerWidget() {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 53, 52, 52),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          hintText: 'Search',
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey, size: 21),
        ),
      ),
    );
  }

  Widget _activityDetails() {
    return Container(
      child: Row(
        children: [
        _cardWidget(),
        ]
      )
    );
  }

  Widget _cardWidget() {
    return Card(
      
    );
  }
}
