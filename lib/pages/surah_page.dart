import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class SurahPage extends StatefulWidget {
  final SurahModel surah;

  const SurahPage({super.key, required this.surah});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<AyahModel> ayahs = [];
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadAyahs();
  }

  Future<void> loadAyahs() async {
    String data = await rootBundle.loadString("assets/saheeh.json");
    List listJson = List.from(json.decode(data))[widget.surah.id - 1]["verses"];
    ayahs = listJson.map((json) => AyahModel.fromJson(json)).toList();
    setState(() {});
  }

  Future<void> playAudio(AyahModel ayah) async {
    String surahNumber = "${widget.surah.id}".padLeft(3, "0");
    String ayahNumber = "${ayah.id}".padLeft(3, "0");
    await player.setUrl(
        "https://everyayah.com/data/Alafasy_128kbps/$surahNumber$ayahNumber.mp3");
    await player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        surfaceTintColor: Color(0xffFFFFFF),
        title: Text(
          widget.surah.transliteration,
          style: GoogleFonts.poppins(
            color: Color(0xff672CBC),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/background-2.png"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      Text(
                        widget.surah.transliteration,
                        style: GoogleFonts.poppins(
                          color: Color(0xffFFFFFF),
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.surah.translation,
                        style: GoogleFonts.poppins(
                          color: Color(0xffFFFFFF),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.surah.type.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 5),
                          Image.asset(
                            "assets/dot.png",
                            height: 6,
                            color: Color(0xffFFFFFF),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${widget.surah.totalVerses} VERSES",
                            style: GoogleFonts.poppins(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      widget.surah.id != 9
                          ? Image.asset("assets/basmala.png")
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...ayahs.map((ayah) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xfff3f3f5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xff863ED5),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              ayah.id.toString(),
                              style: GoogleFonts.poppins(
                                color: Color(0xffFFFFFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              playAudio(ayah);
                            },
                            child: Image.asset(
                              "assets/play.png",
                              color: Color(0xff863ED5),
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ayah.text,
                        style: GoogleFonts.amiri(
                          color: Color(0xff240F4F),
                          fontSize: 20,
                          height: 2.5,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      ayah.translation,
                      style: GoogleFonts.poppins(
                        color: Color(0xff240F4F),
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
