import 'package:audioplayers/audioplayers.dart';

class AdhanAudioService {
  AdhanAudioService._();

  static final AdhanAudioService instance = AdhanAudioService._();

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playDefaultAdhan() async {
    await _audioPlayer.stop();

    await _audioPlayer.setReleaseMode(
      ReleaseMode.stop,
    );

    await _audioPlayer.setVolume(1.0);

    await _audioPlayer.play(
      AssetSource(
        'audio/adhan_default.mp3',
      ),
      volume: 1.0,
    );

    _isPlaying = true;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isPlaying = false;
  }
}