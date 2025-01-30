import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/surah_model.dart';

class ListenPage extends StatefulWidget {
  final SurahModel surah;

  const ListenPage({super.key, required this.surah});

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Future<void> load() async {
    String num = widget.surah.id.toString().padLeft(3, "0");
    await player.setUrl("https://server12.mp3quran.net/maher/$num.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.transliteration),
      ),
      body: Center(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (player.playing) {
                      player.pause();
                    } else {
                      player.play();
                    }
                    setState(() {});
                  },
                  icon: player.playing
                      ? Image.asset(
                          "assets/pause.png",
                          height: 150,
                          width: 150,
                          color: Color(0xff863ED5),
                        )
                      : Image.asset(
                          "assets/play.png",
                          height: 150,
                          width: 150,
                          color: Color(0xff863ED5),
                        ),
                ),
                StreamBuilder(
                  stream: player.positionStream,
                  builder: (_, snapshot) {
                    String current = _printDuration(snapshot.data);
                    String duration = _printDuration(player.duration);
                    double progress = (snapshot.data?.inMilliseconds ?? 0) /
                        (player.duration?.inMilliseconds ?? 0);
                    if (progress.isNaN) {
                      progress = 0;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(current),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          Text(duration),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _printDuration(Duration? duration) {
  duration ??= Duration.zero;
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
}
