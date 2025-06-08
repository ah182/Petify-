
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PetifyApp());
}

class PetifyApp extends StatefulWidget {
  const PetifyApp({super.key});
  @override
  State<PetifyApp> createState() => _PetifyAppState();
}

class _PetifyAppState extends State<PetifyApp> {
  Locale? _locale;

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('langCode');
    if (langCode != null) {
      setState(() => _locale = Locale(langCode));
    } else {
      final defaultLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      setState(() => _locale = Locale(defaultLocale));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      theme: ThemeData(primarySwatch: Colors.pink),
      locale: _locale,
      home: HomeScreen(onLocaleChange: (locale) {
        setState(() => _locale = locale);
      }),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const HomeScreen({required this.onLocaleChange, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageUrl = "https://cataas.com/cat";
  String fact = "Loading...";
  String selectedLang = 'en';
  final languages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
    'tr': 'Türkçe',
  };

  @override
  void initState() {
    super.initState();
    loadFact();
  }

  Future<void> loadFact() async {
    final res = await http.get(Uri.parse("https://catfact.ninja/fact"));
    final original = json.decode(res.body)['fact'];
    if (selectedLang == 'en') {
      setState(() => fact = original);
    } else {
      final trans = await http.post(
        Uri.parse("https://cute-moment-proxy.onrender.app/translate"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"text": original, "lang": selectedLang}),
      );
      final translated = json.decode(trans.body)['translatedText'];
      setState(() => fact = translated ?? original);
    }
  }

  Future<void> loadImage() async {
    setState(() {
      imageUrl = "https://cataas.com/cat?${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  void changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', langCode);
    widget.onLocaleChange(Locale(langCode));
    setState(() => selectedLang = langCode);
    loadFact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(title: const Text('Petify 🐶🐱')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Settings")),
            ListTile(
              title: const Text("Change Language"),
              trailing: DropdownButton<String>(
                value: selectedLang,
                onChanged: (val) {
                  if (val != null) changeLanguage(val);
                },
                items: languages.entries
                    .map((entry) => DropdownMenuItem(
                          child: Text(entry.value),
                          value: entry.key,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(imageUrl, width: 300),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(fact, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
          ),
          ElevatedButton(onPressed: loadFact, child: const Text('🐾 معلومة جديدة')),
          ElevatedButton(onPressed: loadImage, child: const Text('📸 صورة جديدة')),
        ],
      ),
    );
  }
}
