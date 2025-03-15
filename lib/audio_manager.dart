import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  late final AudioPlayer _player;
  bool _isMuted = false;

  AudioManager._internal() {
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.loop); // Loop the music
  }

  Future<void> playMusic() async {
    if (!_isMuted) {
      await _player.play(AssetSource('audio/bgm.mp3'));
    }
  }

  Future<void> stopMusic() async {
    await _player.stop();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _player.pause();
    } else {
      await playMusic();
    }
  }

  bool get isMuted => _isMuted;
}
