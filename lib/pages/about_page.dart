import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Este projeto é apoiado por:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Logos das instituições
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/logo_fapeg.png', width: 100),
                Image.asset('assets/logo_ifgoiano.png', width: 100),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            const Text(
              'Desenvolvido por:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Card Liliany Nunes
            DeveloperCard(
              name: 'Liliany Nunes',
              imagePath: 'assets/dev_liliany.jpg',
              linkedinUrl: 'https://www.linkedin.com/in/lilianynunes/',
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String linkedinUrl;

  const DeveloperCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.linkedinUrl,
  });

  // Função para abrir o LinkedIn
  Future<void> _launchLinkedIn(BuildContext context) async {
    final Uri linkedinUri = Uri.parse(linkedinUrl);
    try {
      await launchUrl(linkedinUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o LinkedIn')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // QR Code do LinkedIn
                      QrImageView(
                        data: linkedinUrl,
                        version: QrVersions.auto,
                        size: 80,
                      ),
                      const SizedBox(width: 16),
                      // Logo do LinkedIn clicável
                      GestureDetector(
                        onTap: () => _launchLinkedIn(context),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/c/ca/LinkedIn_logo_initials.png', // Logo do LinkedIn
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
