import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  bool visual = true;
  bool vibracao = false;
  bool sonoro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha o tipo de retorno:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Visual'),
              value: visual,
              onChanged: (val) {
                setState(() => visual = val);
              },
            ),
            SwitchListTile(
              title: const Text('Vibração'),
              value: vibracao,
              onChanged: (val) {
                setState(() => vibracao = val);
              },
            ),
            SwitchListTile(
              title: const Text('Sinal Sonoro'),
              value: sonoro,
              onChanged: (val) {
                setState(() => sonoro = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}