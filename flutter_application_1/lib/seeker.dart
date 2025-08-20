import 'package:flutter/material.dart';

class SeekerPage extends StatelessWidget {
  const SeekerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seeker'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Jobs'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/jobs');
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Seeker'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/seeker');
              },
            ),
            ListTile(
              title: const Text('Contact'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/contact');
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            ListTile(
              title: const Text('Register'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Seeker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSeekerSection(context, 'Join with Us'),
              const SizedBox(height: 20),
              _buildSeekerSection(context, 'Registered Seeker'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeekerSection(BuildContext context, String title) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to the respective seeker section
          if (title == 'Join with Us') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => JoinWithUsPage()));
          } else if (title == 'Registered Seeker') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisteredSeekerPage()));
          }
        },
      ),
    );
  }
}

class JoinWithUsPage extends StatelessWidget {
  const JoinWithUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join with Us'),
      ),
      body: const Center(
        child: Text(
          'Information about joining...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class RegisteredSeekerPage extends StatelessWidget {
  const RegisteredSeekerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Seeker'),
      ),
      body: const Center(
        child: Text(
          'Information about registered seekers...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
