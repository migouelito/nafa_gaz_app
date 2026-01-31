import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // Langue par défaut : Français
  String _selectedLanguage = 'fr';

  final List<Map<String, String>> _languages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'mo', 'name': 'Mooré', 'flag': '🇧🇫'},
    {'code': 'di', 'name': 'Dioula', 'flag': '🇧🇫'},
    {'code': 'fu', 'name': 'Fulfudé', 'flag': '🇧🇫'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Changer de langue"),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _languages.length,
        separatorBuilder: (c, i) => const Divider(),
        itemBuilder: (context, index) {
          final lang = _languages[index];
          final isSelected = lang['code'] == _selectedLanguage;

          return ListTile(
            leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
            title: Text(lang['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: isSelected 
              ? const Icon(Icons.check_circle, color: Color(0xFF00A86B)) 
              : null,
            onTap: () {
              setState(() => _selectedLanguage = lang['code']!);
              
              // Feedback utilisateur
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Langue changée en ${lang['name']}"))
              );
              
              // Ici, on pourrait recharger l'app avec la nouvelle locale
            },
          );
        },
      ),
    );
  }
}
