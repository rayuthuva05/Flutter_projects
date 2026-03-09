import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
                // Add navigation to contact page if needed
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
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Founded with a mission to streamline the job market, Saha Holdings is a pioneering job connecting agency that serves as a vital link between talented job seekers and discerning employers. Our agency was established in 2023 by a team of industry veterans who recognized the need for a more efficient and effective approach to job placement.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission',
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
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Our Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Talent Acquisition: We source and identify skilled professionals from various fields, ensuring that they meet the specific needs and standards of our client companies.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Career Placement: We assist job seekers in finding positions that align with their skills, experience, and career aspirations, helping them to achieve their professional goals.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Consultation and Coaching: Our expert career consultants provide personalized advice and coaching to job seekers, enhancing their job search strategies and interview skills.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Employer Partnerships: We work closely with businesses of all sizes to understand their workforce needs and provide them with top-tier candidates who can drive their success.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Why Choose Saha Holdings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Comprehensive Network: Our extensive network of professionals and employers spans various industries, giving us a broad reach and deep insight into market trends.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Personalized Approach: We tailor our services to meet the unique needs of both job seekers and employers, ensuring a customized and effective matching process.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Commitment to Excellence: Our dedication to quality and excellence is evident in every aspect of our service, from initial consultations to final placements.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Our Vision',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We envision a world where every job seeker finds their perfect role and every employer discovers the ideal candidate. By continually refining our processes and expanding our network, we aim to set the standard for job placement agencies globally.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Join us at Saha Holdings - where talent meets opportunity.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
