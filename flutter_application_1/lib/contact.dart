import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Contact',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildContactInfoSection(),
              const SizedBox(height: 20),
              _buildContactForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(
              'Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '267/1, Clinic Road, Gallella, Polonnaruwa',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              'Phone',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '+94 71 900 6644',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(
              'Email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'harisnm26@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              'Opening Hours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Mon to Fri 9am to 6pm',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Send us a message',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Your Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message',
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('Send'),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Or contact us directly at harisnm26@gmail.com',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
