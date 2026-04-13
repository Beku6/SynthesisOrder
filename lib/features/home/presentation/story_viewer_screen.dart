import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class StoryViewerScreen extends ConsumerStatefulWidget {
  const StoryViewerScreen({
    super.key,
    required this.bundles,
    required this.initialBundleIndex,
  });

  final List<StoryItem> bundles;
  final int initialBundleIndex;

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen> {
  late PageController _bundleController;
  late int _currentBundleIndex;
  late int _currentStoryIndex;
  late AnimationController _progressController;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _currentBundleIndex = widget.initialBundleIndex;
    _currentStoryIndex = 0;
    _bundleController = PageController(initialPage: _currentBundleIndex);
    
    // No animation controller initialization here because it depends on story duration
  }

  void _onStoryFinish() {
    final currentBundle = widget.bundles[_currentBundleIndex];
    if (_currentStoryIndex < currentBundle.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
    } else if (_currentBundleIndex < widget.bundles.length - 1) {
      _bundleController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _onStoryPrev() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
    } else if (_currentBundleIndex > 0) {
      _bundleController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _bundleController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _bundleController,
        itemCount: widget.bundles.length,
        onPageChanged: (index) {
          setState(() {
            _currentBundleIndex = index;
            _currentStoryIndex = 0;
          });
        },
        itemBuilder: (context, index) {
          return _StoryBundleView(
            bundle: widget.bundles[index],
            isCurrent: _currentBundleIndex == index,
            storyIndex: _currentStoryIndex,
            onFinish: _onStoryFinish,
            onPrev: _onStoryPrev,
            onClose: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}

class _StoryBundleView extends StatefulWidget {
  const _StoryBundleView({
    required this.bundle,
    required this.isCurrent,
    required this.storyIndex,
    required this.onFinish,
    required this.onPrev,
    required this.onClose,
  });

  final StoryItem bundle;
  final bool isCurrent;
  final int storyIndex;
  final VoidCallback onFinish;
  final VoidCallback onPrev;
  final VoidCallback onClose;

  @override
  State<_StoryBundleView> createState() => _StoryBundleViewState();
}

class _StoryBundleViewState extends State<_StoryBundleView> with TickerProviderStateMixin {
  late AnimationController _animController;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    _loadStory();
  }

  @override
  void didUpdateWidget(_StoryBundleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && (oldWidget.storyIndex != widget.storyIndex || !oldWidget.isCurrent)) {
      _loadStory();
    } else if (!widget.isCurrent) {
      _animController.stop();
      _videoController?.pause();
    }
  }

  void _loadStory() {
    _animController.stop();
    _animController.reset();
    _videoController?.dispose();
    _videoController = null;

    if (!widget.isCurrent) return;

    final story = widget.bundle.stories[widget.storyIndex];
    if (story.type == StoryMediaType.video) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(story.url))
        ..initialize().then((_) {
          setState(() {});
          if (widget.isCurrent) {
            _videoController!.play();
            _animController.duration = _videoController!.value.duration;
            _animController.forward().whenComplete(widget.onFinish);
          }
        });
    } else {
      _animController.duration = const Duration(seconds: 5);
      _animController.forward().whenComplete(widget.onFinish);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.bundle.stories[widget.storyIndex];

    return Stack(
      children: [
        // Background blur for portrait fit
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Opacity(
              opacity: 0.5,
              child: story.type == StoryMediaType.image
                  ? CachedNetworkImage(
                      imageUrl: story.url,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(), // Video blur is complex, keeping simple
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black26),
          ),
        ),

        // Content
        Center(
          child: story.type == StoryMediaType.image
              ? CachedNetworkImage(
                  imageUrl: story.url,
                  fit: BoxFit.contain,
                )
              : (_videoController != null && _videoController!.value.isInitialized)
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : const Center(child: CircularProgressIndicator()),
        ),

        // Gestures
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.onPrev,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (_) {
                    _animController.stop();
                    _videoController?.pause();
                  },
                  onLongPressEnd: (_) {
                    _animController.forward();
                    _videoController?.play();
                  },
                  behavior: HitTestBehavior.translucent,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: widget.onFinish,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
            ],
          ),
        ),

        // Overlays
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress bars
                Row(
                  children: List.generate(
                    widget.bundle.stories.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _ProgressBar(
                          progress: index < widget.storyIndex
                              ? 1.0
                              : index == widget.storyIndex
                                  ? _animController
                                  : 0.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User info
                Row(
                  children: [
                    SynorGlassPanel(
                      padding: const EdgeInsets.all(4),
                      radius: 99,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: widget.bundle.avatarAsset != null
                                ? AssetImage(widget.bundle.avatarAsset!)
                                : null,
                            child: widget.bundle.avatarAsset == null
                                ? const Icon(LucideIcons.user, size: 16)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.bundle.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.white),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bottom actions
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SynorGlassPanel(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      radius: 99,
                      backgroundColor: Colors.white10,
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Send message...',
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _EmojiReaction(emoji: '🔥'),
                  const SizedBox(width: 8),
                  _EmojiReaction(emoji: '❤️'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final dynamic progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (progress is double) {
            return Container(
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          } else {
            return AnimatedBuilder(
              animation: progress as Animation<double>,
              builder: (context, child) {
                return Container(
                  width: constraints.maxWidth * progress.value,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _EmojiReaction extends StatelessWidget {
  const _EmojiReaction({required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () {},
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
