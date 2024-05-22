import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:invoice_pdf_generate/Utils/PermissionUtil.dart';
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
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            color: primaryColor,
          ),
        ),
        skipButton: SizedBox(
          // width: 100,
          height: 40,
          child: GFButton(
            onPressed: () async {
              // await storagePermission();
              Get.offAndToNamed('/company');
            },
            text: 'Skip',
            color: primaryColor,
            highlightColor: secondaryColor,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        doneButton: SizedBox(
          // width: 100,
          height: 40,
          child: GFButton(
            onPressed: () async {
              // await storagePermission();

              Get.offAndToNamed('/company');
            },
            text: 'Done',
            color: primaryColor,
            highlightColor: secondaryColor,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
