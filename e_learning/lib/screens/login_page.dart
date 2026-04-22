import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController uNameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm(String role) async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();

    String uName = uNameController.text;
    String password = passController.text;
    String subject = subjectController.text;

    if (role == 'Teacher') {
      if (uName == 'teacher' && password == '1234') {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('role', role);
        await prefs.setString('subject', subject);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          '/teacher',
          arguments: subject,
        );
      } else {
          _showError();
      }
    } else {
      if (uName == 'student' && password == '1234') {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('role', role);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/student');
      } else {
        _showError();
      }
    }
  }
  

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invalid username or password'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    uNameController.dispose();
    passController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your role',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(221, 31, 21, 77),
              ),
            ),
            _buildCard(),
          ],
        ),
      ),
    );
  }

  Widget _login({required String role, required String img}) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              '$role Login',
              style: TextStyle(
                fontSize: 24,
                color: const Color.fromARGB(221, 31, 21, 77),
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 209, 217, 248),
            iconTheme: const IconThemeData(color: Color.fromARGB(221, 31, 21, 77)),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage(img: img),
                    role == 'Teacher'
                        ? Column(
                            children: [
                              _buildField(
                                name: 'User Name',
                                controller: uNameController,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 40),
                              _buildField(
                                name: 'Subject Name',
                                controller: subjectController,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 40),
                              _buildField(
                                name: 'Password',
                                controller: passController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildField(
                                name: 'User Name',
                                controller: uNameController,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 40),
                              _buildField(
                                name: 'Password',
                                controller: passController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                              ),
                            ],
                          ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitForm(role),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 226, 229, 244),
      ),
      child: Column(
        children: [
          _buildRole(role: 'Teacher', img: 'teacher.png', context: context),
          SizedBox(height: 5),
          Divider(thickness: 4, radius: BorderRadius.circular(5),color: const Color.fromARGB(221, 31, 21, 77)),
          SizedBox(height: 5),
          _buildRole(role: 'Student', img: 'student.jpg', context: context),
        ],
      ),
    );
  }

  Widget _buildRole({
    required String role,
    required String img,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        role == 'Student'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      _login(role: 'Student', img: 'student.jpg'),
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      _login(role: 'Teacher', img: 'teacher.png'),
                ),
              );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            elevation: 5,
            child: Image.asset(
              'assets/images/$img',
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
          ),
          Text(
            role,
            style: TextStyle(
              color: const Color.fromARGB(221, 31, 21, 77),
              fontSize: 24,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.black54,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String name,
    required TextEditingController controller,
    required TextInputAction textInputAction,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hint: Text('Enter $name', style: TextStyle(color: Colors.blueGrey),),
        labelText: name,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: TextStyle(color: const Color.fromARGB(221, 31, 21, 77))
      ),
      controller: controller,
      textInputAction: textInputAction,
      obscureText: obscureText,
      style: TextStyle(color: const Color.fromARGB(221, 31, 21, 77)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$name is required';
        }
        return null;
      },
    );
  }

  Widget _buildImage({required String img}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Center(
        child: Image.asset(
          'assets/images/$img',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
