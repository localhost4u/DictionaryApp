import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:dictionaryx/dictentry.dart';
import 'package:dictionaryx/dictionary_msa_json_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
} // phone connect che ? naa kariyo che wai

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = 'DictionaryX Flutter Demo';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cText = TextEditingController();
  var dMSAJson = DictionaryMSAFlutter();
  int timeMillis = 0;

  DictEntry _entry = DictEntry('', [], [], []);

  // Gets a DictEntry for a given word.
  void lookupWord() async {
    DictEntry? tmp;
    final txt = cText.text.trim();
    if (await dMSAJson.hasEntry(txt)) {
      var s = Stopwatch()..start();
      tmp = await dMSAJson.getEntry(txt);
      s.stop();
      timeMillis = s.elapsedMilliseconds;
    }

    setState(() {
      if (tmp != null) {
        _entry = tmp;
      } else {
        _entry = DictEntry('', [], [], []);
      }
    });
  }

  void openPackage() async {
    await launchUrl(Uri.parse('https://pub.dev/packages/dictionaryx'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 246, 255),
      appBar: AppBar(
        title: Text(
          "Dictionary App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            Color.fromRGBO(151, 220, 244, 1), // Customize the background color
        elevation: 0, // Remove app bar shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    // color: Colors.blue,
                    color: Color.fromRGBO(151, 220, 244, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.095,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: cText,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
    //                 onSubmitted: (value) {
    // lookupWord();
    // setState(() {});
    // },
                    onChanged: (value) {
                      if (value != "") {
                        lookupWord();
                        setState(() {});
                      } else {
                        _entry.word = "";
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                      hintText: "Search word",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: () {
                          lookupWord();
                          setState(() {});
                        },
                        icon: const Icon(Icons.search),
                        splashRadius: 25,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_entry.word.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Milliseconds(timeMillis),
              ),
            if (_entry.word.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: WordEntry(_entry),
              ),
          ],
        ),
      ),
    );
  }
}

class Milliseconds extends StatelessWidget {
  final int timeMillis;
  const Milliseconds(this.timeMillis, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Text(
          '$timeMillis ms',
          style: GoogleFonts.nunitoSans(
            color: Colors.blue, // Text color
            fontSize: 18.0, // Font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Displays the content of a DictEntry.
///

class WordEntry extends StatelessWidget {
  final DictEntry _entry;
  const WordEntry(this._entry, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Word Entry',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '${_entry.word}',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 28.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 1,
                ),
                if (_entry.synonyms.join(', ') != "")
                  _buildRow('Synonyms', _entry.synonyms.join(', ')),
                Divider(
                  color: Colors.grey[300],
                  height: 1,
                ),
                if (_entry.antonyms.join(', ') != "")
                  _buildRow('Antonyms', _entry.antonyms.join(', ')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Variations',
                style: GoogleFonts.nunitoSans(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Column(
            children: _entry.meanings.map((e) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 0.5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    _buildRow('POS', e.pos.name),
                    Divider(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    _buildRow('Description', e.description),
                    Divider(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    if (e.meanings.isNotEmpty)
                      _buildRow('Meanings', e.meanings.join('\n')),
                    Divider(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    if (e.examples.join(' / ').isNotEmpty)
                      _buildRow('Examples', e.examples.join('\n')),
                    Divider(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunitoSans(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            content,
            style: GoogleFonts.nunitoSans(
              fontSize: 17.0,
              // color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
