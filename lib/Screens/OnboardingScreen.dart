import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:invoice_pdf_generate/style/ConstStyle.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  late PageController _pageController;
  late List<Widget> slideList;
  late int initialPage;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    initialPage = _pageController.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GFIntroScreen(
      color: primaryColor,
      slides: slides(),
      pageController: _pageController,
      currentIndex: 0,
      pageCount: 4,
      introScreenBottomNavigationBar: GFIntroScreenBottomNavigationBar(
        navigationBarHeight: 80,
        forwardButton: SizedBox(
          // width: 100,
          height: 40,
          child: GFButton(
            textColor: Colors.white,
            highlightColor: secondaryColor,
            onPressed: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastEaseInToSlowEaseOut);
            },
            text: 'Next',
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            color: primaryColor,
          ),
        ),
        skipButton: BlinkingButton(
          text: 'Skip',
          route: '/company',
        ),
        backButton: SizedBox(
          // width: 100,
          height: 40,
          child: GFButton(
            onPressed: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastEaseInToSlowEaseOut);
            },
            text: 'Back',
            highlightColor: secondaryColor,
            color: primaryColor,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        doneButton: BlinkingButton(
          text: 'Done',
          route: '/company',
        ),
        pageController: _pageController,
        pageCount: slideList.length,
        currentIndex: initialPage,

        onSkipTap: () {
          Get.offAndToNamed('/company');
        },
        onForwardButtonTap: () {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastEaseInToSlowEaseOut);
        },
        onBackButtonTap: () {
          _pageController.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastEaseInToSlowEaseOut);
        },
        onDoneTap: () {
          Get.offAndToNamed('/company');
        },
        navigationBarColor: primaryColor,
        showDivider: false,
        inactiveColor: secondaryColor,
        // inActiveColor: Colors.grey[200],
        activeColor: Colors.white,
      ),
    );
  }

  List<Widget> slides() {
    slideList = [
      Container(
        padding: const EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/onboarding/hello.png'),
      ),
      Container(
        padding: const EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/onboarding/company.png'),
      ),
      Container(
        padding: const EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/onboarding/add.png'),
      ),
      Container(
        padding: const EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/onboarding/your.png'),
      ),
    ];
    return slideList;
  }
}

class BlinkingButton extends StatefulWidget {
  @override
  _BlinkingButtonState createState() => _BlinkingButtonState();

  const BlinkingButton({super.key, required this.text, required this.route});
  final String text;
  final String route;
}

class _BlinkingButtonState extends State<BlinkingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 100,
      height: 40,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animationController.value,
            child: child,
          );
        },
        child: GFButton(
          onPressed: () async {
            // await storagePermission();
            Get.offAndToNamed('/company');
          },
          text: widget.text,
          color: secondaryColor,
          highlightColor: secondaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
