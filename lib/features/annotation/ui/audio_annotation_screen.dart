import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/widgets/annotation_app_bar.dart';
import 'package:lexi_quest/core/widgets/xp_reward_dialog.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';

class AudioAnnotationScreen extends StatefulWidget {
  const AudioAnnotationScreen({super.key});

  @override
  State<AudioAnnotationScreen> createState() => _AudioAnnotationScreenState();
}

class _AudioAnnotationScreenState extends State<AudioAnnotationScreen> {
  List<AnnotationModel> _annotations = [];
  int _currentIndex = 0;
  final TextEditingController _transcriptionController = TextEditingController();
  final List<String> _selectedLabels = [];
  int _totalXp = 8750;
  int _currentStreak = 15;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadAnnotations();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _loadAnnotations() async {
    try {
      final String response = await rootBundle.loadString('assets/data/sample_annotations.json');
      final data = json.decode(response);
      final List<dynamic> audioAnnotations = data['audio_annotations'];

      setState(() {
        _annotations = audioAnnotations
            .map((json) => AnnotationModel.fromJson(json))
            .toList();
      });

      // Load first audio
      if (_annotations.isNotEmpty) {
        _loadAudio(_annotations[0].audioUrl);
      }
    } catch (e) {
      debugPrint('Error loading annotations: $e');
    }
  }

  Future<void> _loadAudio(String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      await _audioPlayer.setSourceUrl(url);
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  AnnotationModel? get _currentAnnotation {
    if (_annotations.isEmpty || _currentIndex >= _annotations.length) {
      return null;
    }
    return _annotations[_currentIndex];
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void _toggleLabel(String label) {
    setState(() {
      if (_selectedLabels.contains(label)) {
        _selectedLabels.remove(label);
      } else {
        _selectedLabels.add(label);
      }
    });
  }

  Future<void> _submitAnnotation() async {
    final transcription = _transcriptionController.text.trim();

    if (transcription.isEmpty && _selectedLabels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a transcription or select labels'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final xpEarned = _currentAnnotation?.xpReward ?? 10;
    setState(() {
      _totalXp += xpEarned;
      _currentStreak++;
    });

    await XpRewardDialog.show(
      context,
      xpEarned: xpEarned,
      currentStreak: _currentStreak,
    );

    _nextAnnotation();
  }

  Future<void> _nextAnnotation() async {
    await _audioPlayer.stop();

    setState(() {
      if (_currentIndex < _annotations.length - 1) {
        _currentIndex++;
        _transcriptionController.clear();
        _selectedLabels.clear();
        _position = Duration.zero;
        _duration = Duration.zero;
      } else {
        Navigator.of(context).pop();
        return;
      }
    });

    // Load next audio
    final nextAnnotation = _currentAnnotation;
    if (nextAnnotation != null) {
      await _loadAudio(nextAnnotation.audioUrl);
    }
  }

  void _skipAnnotation() {
    _nextAnnotation();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _transcriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final annotation = _currentAnnotation;

    if (annotation == null) {
      return Scaffold(
        appBar: AnnotationAppBar(
          title: 'Audio Annotation',
          currentXp: _totalXp,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AnnotationAppBar(
        title: 'Audio Annotation',
        currentXp: _totalXp,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Task ${_currentIndex + 1} of ${_annotations.length}',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '+${annotation.xpReward} XP',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.secondaryAmber500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / _annotations.length,
                    backgroundColor: AppColors.neutralSlate600_30,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryGreen500,
                    ),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo600.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryIndigo600.withValues(alpha:0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.primaryIndigo600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Instructions',
                                style: AppFonts.titleSmall.copyWith(
                                  color: AppColors.primaryIndigo600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            annotation.content,
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Audio Player
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryIndigo600, AppColors.primaryIndigo500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Waveform visualization placeholder
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.neutralWhite.withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.graphic_eq,
                                color: AppColors.neutralWhite,
                                size: 48,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Progress Slider
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                            ),
                            child: Slider(
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble().clamp(1, double.infinity),
                              activeColor: AppColors.neutralWhite,
                              inactiveColor: AppColors.neutralWhite.withValues(alpha:0.3),
                              onChanged: (value) {
                                _seekTo(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),

                          // Time Labels
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_position),
                                  style: AppFonts.bodySmall.copyWith(
                                    color: AppColors.neutralWhite,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_duration),
                                  style: AppFonts.bodySmall.copyWith(
                                    color: AppColors.neutralWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Playback Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  final newPosition = _position - const Duration(seconds: 10);
                                  _seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
                                },
                                icon: const Icon(Icons.replay_10),
                                color: AppColors.neutralWhite,
                                iconSize: 32,
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.neutralWhite,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: _togglePlayPause,
                                  icon: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                  color: AppColors.primaryIndigo600,
                                  iconSize: 40,
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                onPressed: () {
                                  final newPosition = _position + const Duration(seconds: 10);
                                  _seekTo(newPosition > _duration ? _duration : newPosition);
                                },
                                icon: const Icon(Icons.forward_10),
                                color: AppColors.neutralWhite,
                                iconSize: 32,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Classification Labels (if applicable)
                    if (annotation.labels.isNotEmpty) ...[
                      Text(
                        'Select Labels',
                        style: AppFonts.titleMedium.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: annotation.labels.map((label) {
                          final isSelected = _selectedLabels.contains(label);
                          return GestureDetector(
                            onTap: () => _toggleLabel(label),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.secondaryGreen500
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.secondaryGreen500
                                      : AppColors.neutralSlate600_30,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: AppColors.onPrimary,
                                    ),
                                  if (isSelected) const SizedBox(width: 6),
                                  Text(
                                    label,
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: isSelected
                                          ? AppColors.onPrimary
                                          : AppColors.onBackground,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Transcription Input
                    Text(
                      'Transcription',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _transcriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Type what you hear...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.neutralSlate600_30,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.neutralSlate600_30,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryIndigo600,
                            width: 2,
                          ),
                        ),
                      ),
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutralSlate900_25,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _skipAnnotation,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: AppColors.neutralSlate600_30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: AppFonts.buttonText.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitAnnotation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryIndigo600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit Annotation',
                        style: AppFonts.buttonText.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
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
