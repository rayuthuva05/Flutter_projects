import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                'Find Your Right Fit',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Browse Top Categories',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildCategoryCard(context, 'Data Entry', Icons.keyboard),
                  _buildCategoryCard(context, 'Copy Paste', Icons.copy),
                  _buildCategoryCard(context, 'Auditor', Icons.assignment),
                  _buildCategoryCard(context, 'Cashier', Icons.attach_money),
                ],
              ),
              _buildHowItWorksSection(),
              _buildWhatWeAreDoingSection(),
              Container(
                color: Colors.black, // Combined black background for combined sections
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSectionTitle('ABOUT US'),
                    _buildSectionContent(
                      'Founded in 2023, we at Saha Holdings aim to streamline the job market as a job connecting agency. Our mission is to link job seekers with employers, fostering professional growth and success.',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('CONTACT INFO'),
                    _buildSectionContent(
                      'Address: 267/1, Clinic Road, Gallella, Polonnaruwa.\nPhone: +94 71 900 6644\nEmail: harisnm26@gmail.com',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('IMPORTANT LINKS'),
                    _buildImportantLinks(context),
                    const SizedBox(height: 20),
                    _buildSectionTitle('OUR VISION'),
                    _buildSectionContent(
                      'Revolutionizing global job placement through refined processes and an extensive network.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildBoldNumberText('Talented seekers', 5000), // Display for 5000
              _buildBoldNumberText('Reputed companies', 451), // Display for 451
              _buildBoldNumberText('Job opportunities', 568), // Display for 568+
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          // Handle category card tap
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'How it works',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildStepCard('1. Search a job', 'Search For a Job.', Icons.search),
          const SizedBox(height: 10),
          _buildStepCard('2. Apply for job', 'Apply For Job Through our Website', Icons.send),
          // Add more steps as needed
        ],
      ),
    );
  }

  Widget _buildStepCard(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildWhatWeAreDoingSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        children: <Widget>[
          Text(
            'WHAT WE ARE DOING',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '24k Talented people are getting Jobs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'At Saha Holdings, our mission is to bridge the gap between individuals looking for their ideal careers and employers seeking skilled and qualified candidates. We strive to create a dynamic marketplace where talent meets opportunity, fostering professional growth and organizational success.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImportantLinks(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about');
            },
            child: const Text(
              'About Us',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contact');
            },
            child: const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/jobs');
            },
            child: const Text(
              'View Jobs',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoldNumberText(String text, int number) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '$number ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: text,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
