import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/footer.dart';
import '../lang.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const Color beigeBg = Color(0xFFF5F0E6);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/hero_animation.mp4')
      ..initialize().then((_) {
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle get baseText => const TextStyle(fontFamily: 'PlayfairDisplay');

  Widget _animatedWords({required String text, required Alignment alignment}) {
    final words = text.split(" ");
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(words.length, (index) {
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 1400 + (index * 700)),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset((1 - value) * -50, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        words[index],
                        style: baseText.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _animatedSlide(String image, String text, int index) {
    Alignment position;
    switch (index) {
      case 0:
        position = Alignment.centerLeft;
        break;
      case 1:
        position = Alignment.centerRight;
        break;
      case 2:
        position = Alignment.centerLeft;
        break;
      default:
        position = Alignment.center;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(image, fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.25)),
        _animatedWords(text: text, alignment: position),
      ],
    );
  }

  static final List<_Benefit> _benefits = [
    _Benefit(
      image: 'assets/benefit1.png',
      titleKey: 'benefit1_title',
      descriptionKey: 'benefit1_desc',
    ),
    _Benefit(
      image: 'assets/benefit2.png',
      titleKey: 'benefit2_title',
      descriptionKey: 'benefit2_desc',
    ),
    _Benefit(
      image: 'assets/benefit3.png',
      titleKey: 'benefit3_title',
      descriptionKey: 'benefit3_desc',
    ),
    _Benefit(
      image: 'assets/benefit4.png',
      titleKey: 'benefit4_title',
      descriptionKey: 'benefit4_desc',
    ),
  ];

  Widget _buildBenefits(Lang lang) {
    return Container(
      width: double.infinity,
      color: HomePage.beigeBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Text(
            lang.t("why_use"),
            style: baseText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _benefits.length,
            itemBuilder: (context, index) {
              final b = _benefits[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      b.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lang.t(b.titleKey),
                    style: baseText.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    lang.t(b.descriptionKey),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    return Directionality(
      textDirection: lang.current == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/backgroundgaspi.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.15)),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  // Hero
                  Stack(
                    children: [
                      SizedBox(
                        height: 900,
                        width: double.infinity,
                        child: _controller.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _controller.value.size.width,
                                  height: _controller.value.size.height,
                                  child: VideoPlayer(_controller),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      Container(
                        height: 900,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      SizedBox(
                        height: 900,
                        child: Center(
                          child: Text(
                            lang.t("save_planet"),
                            textAlign: TextAlign.center,
                            style: baseText.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Our Goal
                  Container(
                    width: double.infinity,
                    color: HomePage.beigeBg,
                    padding: const EdgeInsets.symmetric(
                      vertical: 60,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "OUR GOAL",
                          style: baseText.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFB6C1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          lang.t("about_small"),
                          textAlign: TextAlign.center,
                          style: baseText.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  // Benefits
                  _buildBenefits(lang),
                  // How it works slider
                  Container(
                    width: double.infinity,
                    color: HomePage.beigeBg,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t("how_it_works"),
                          style: baseText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0A3B2A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 550,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 6),
                            autoPlayAnimationDuration: const Duration(
                              seconds: 2,
                            ),
                            viewportFraction: 1.0,
                          ),
                          items: [
                            _animatedSlide(
                              "assets/how1.png",
                              lang.t("download"),
                              0,
                            ),
                            _animatedSlide(
                              "assets/how2.png",
                              lang.t("find"),
                              1,
                            ),
                            _animatedSlide(
                              "assets/how3.png",
                              lang.t("reserve"),
                              2,
                            ),
                            _animatedSlide(
                              "assets/how4.png",
                              lang.t("pickup"),
                              3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 500),
                  const AppFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Benefit {
  final String image;
  final String titleKey;
  final String descriptionKey;
  const _Benefit({
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
  });
}
