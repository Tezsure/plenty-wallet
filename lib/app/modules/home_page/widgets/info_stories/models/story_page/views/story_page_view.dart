import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/info_stories/models/story_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:video_player/video_player.dart';

import '../controllers/story_page_controller.dart';

final List<InfoStory> stories = [
  const InfoStory(
    url:
        'https://nftnow.com/wp-content/uploads/2022/05/Tezos-by-Rodion-Kutsaev.jpg',
    mediaType: MediaType.image,
    duration: Duration(seconds: 5),
  ),
  const InfoStory(
    url: 'https://miro.medium.com/max/960/1*BjIiQkUDagON6SbMXEF7mg.gif',
    mediaType: MediaType.image,
    duration: Duration(seconds: 7),
  ),
];

class StoryPageView extends GetView<StoryPageController> {
  final Function()? onPressed;
  final int itemCount;
  final double? containerHeight, width;
  final List<String> profileImagePath;
  final List<String> storyTitle;
  const StoryPageView(
      {this.containerHeight,
      required this.profileImagePath,
      required this.storyTitle,
      this.width,
      this.itemCount = 4,
      this.onPressed,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 0.04.width),
        child: Column(
          children: [
            SizedBox(
              height: containerHeight ?? 0.15.height,
              width: 1.width,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: profileImagePath.length,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  cacheExtent: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          Get.to(() => NaanStoryInfoScreen(stories: stories)),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SizedBox(
                          width: width ?? 70,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SvgPicture.asset(
                                  profileImagePath[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              0.012.vspace,
                              Text(
                                storyTitle[index],
                                textAlign: TextAlign.center,
                                style: labelSmall.copyWith(
                                  color: ColorConst.Neutral.shade95,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            0.02.vspace,
            Divider(
              height: 1,
              color: ColorConst.NeutralVariant.shade20,
            ),
          ],
        ),
      );
}

class NaanStoryInfoScreen extends StatefulWidget {
  final List<InfoStory> stories;
  const NaanStoryInfoScreen({Key? key, required this.stories})
      : super(key: key);

  @override
  State<NaanStoryInfoScreen> createState() => _NaanStoryInfoScreenState();
}

class _NaanStoryInfoScreenState extends State<NaanStoryInfoScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  AnimationController? _animationController;
  VideoPlayerController? _videoPlayerController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
        vsync: this, duration: widget.stories[_currentIndex].duration)
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController
            ?..stop()
            ..reset();
          setState(() {
            if (_currentIndex + 1 < widget.stories.length) {
              _currentIndex += 1;
              _loadStory(infoStory: widget.stories[_currentIndex]);
            } else {
              _currentIndex = 0;
              _loadStory(infoStory: widget.stories[_currentIndex]);
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animationController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final InfoStory story = widget.stories[_currentIndex];
    return Scaffold(
      body: GestureDetector(
        onTapDown: ((details) => _onTapDown(details, story)),
        onVerticalDragStart: (details) {
          // TODO Implement Swipe Down Functionality
          final double dx = details.globalPosition.dy;

          if (dx > 2 * 1.height / 3) {
            setState(() {
              Get.back();
            });
          }
        },
        onVerticalDragEnd: (details) {
          // TODO Go to previous page if drag reaches a certain value
          final double dx = details.primaryVelocity ?? 0;
          setState(() {
            Get.back();
          });
        },
        child: Stack(children: <Widget>[
          PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final InfoStory infoStory = widget.stories[index];
                switch (infoStory.mediaType) {
                  case MediaType.image:
                    return CachedNetworkImage(
                      imageUrl: infoStory.url,
                      fit: BoxFit.cover,
                    );
                  case MediaType.video:
                    if (_videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController!.value.size.width,
                          height: _videoPlayerController!.value.size.height,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  case MediaType.text:
                    return Container(
                      color: Colors.white,
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }),
          if (_animationController != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                0.030.vspace,
                Row(
                    children: widget.stories
                        .asMap()
                        .map((key, value) {
                          return MapEntry(
                              key,
                              AnimatedBar(
                                animController: _animationController!,
                                position: key,
                                currentIndex: _currentIndex,
                              ));
                        })
                        .values
                        .toList()),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            )
        ]),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, InfoStory story) {
    final double dx = details.globalPosition.dx;
    if (dx < 1.width / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(infoStory: widget.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * 1.width / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex += 1;
          _loadStory(infoStory: widget.stories[_currentIndex]);
        } else {
          // Out of bounds - loop story or Get.back() to previous page
          _currentIndex = 0;
          _loadStory(infoStory: widget.stories[_currentIndex]);
        }
      });
    } else {
      if (story.mediaType == MediaType.video) {
        if (_videoPlayerController != null &&
            _videoPlayerController!.value.isPlaying) {
          _videoPlayerController?.pause();
          _animationController?.stop();
        } else {
          _videoPlayerController?.play();
          _animationController?.forward();
        }
      }
    }
  }

  void _loadStory({required InfoStory infoStory, bool animateToPage = true}) {
    _animationController
      ?..stop()
      ..reset();
    switch (infoStory.mediaType) {
      case MediaType.image:
        _animationController?.duration = infoStory.duration;
        _animationController?.forward();
        break;
      case MediaType.video:
        _videoPlayerController = null;
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.network(infoStory.url)
          ..initialize().then((_) {
            setState(() {});
            if (_videoPlayerController!.value.isInitialized) {
              _animationController!.duration =
                  _videoPlayerController!.value.duration;
              _videoPlayerController?.play();
              _animationController?.forward();
            }
          });
        break;
      default:
        break;
    }
    if (animateToPage) {
      _pageController?.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key? key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}

Container _buildContainer(double width, Color color) {
  return Container(
    height: 5.0,
    width: width,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(
        color: Colors.black26,
        width: 0.8,
      ),
      borderRadius: BorderRadius.circular(3.0),
    ),
  );
}
