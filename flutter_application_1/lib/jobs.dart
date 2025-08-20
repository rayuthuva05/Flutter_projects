import 'package:flutter/material.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
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
                'Jobs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildJobSection(context, 'Find Jobs'),
              const SizedBox(height: 20),
              _buildJobSection(context, 'Applied Jobs'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobSection(BuildContext context, String title) {
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
          // Navigate to the respective job section
          if (title == 'Find Jobs') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FindJobsPage()));
          } else if (title == 'Applied Jobs') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedJobsPage()));
          }
        },
      ),
    );
  }
}

class FindJobsPage extends StatelessWidget {
  const FindJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Jobs'),
      ),
      body: const Center(
        child: Text(
          'List of jobs to find...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class AppliedJobsPage extends StatelessWidget {
  const AppliedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applied Jobs'),
      ),
      body: const Center(
        child: Text(
          'List of applied jobs...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
