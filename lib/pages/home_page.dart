import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generation_projects/pages/surah_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/surah_model.dart';

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({super.key});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  SurahModel? lastRead;
  List<SurahModel> allSurah = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    allSurah = await getAllSurah();
    lastRead = await getLastRead();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return SurahPage(surah: lastRead ?? alFatiha);
                      },
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Image.asset("assets/background.png"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/book.png",
                                height: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Last Read",
                                style: GoogleFonts.poppins(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            lastRead?.transliteration ?? "Al-Fatiha",
                            style: GoogleFonts.poppins(
                              color: Color(0xffFFFFFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: allSurah.length,
                  itemBuilder: (_, int index) {
                    SurahModel surah = allSurah[index];
                    return Column(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) {
                                return SurahPage(surah: surah);
                              }),
                            );
                            await saveLastRead(surah);
                            lastRead = surah;
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/square.png",
                                      height: 45,
                                    ),
                                    Text(
                                      surah.id.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Color(0xff240F4F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.transliteration,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xff240F4F),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          surah.type.toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            color: Color(0xff8789A3),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Image.asset(
                                          "assets/dot.png",
                                          height: 6,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${surah.totalVerses} VERSES",
                                          style: GoogleFonts.poppins(
                                            color: Color(0xff8789A3),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  surah.name,
                                  style: GoogleFonts.amiri(
                                    color: Color(0xff240F4F),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
