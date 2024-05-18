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
    color: Colors.blueGrey,
    slides: slides(),
    pageController: _pageController,
    currentIndex: 0,
    pageCount: 4,
    introScreenBottomNavigationBar: GFIntroScreenBottomNavigationBar(
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
      navigationBarColor: primaryColor  ,
      showDivider: false,
        inactiveColor:secondaryColor,
      // inActiveColor: Colors.grey[200],
      activeColor: Colors.white,
    ),
  );
}

List<Widget> slides() {
  slideList = [
   Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
            image: AssetImage('assets/onboarding/hello.png'),
            fit: BoxFit.cover,
            
          )),
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
            image: AssetImage('assets/onboarding/company.png'),
            fit: BoxFit.cover,
            
          )),
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
            image: AssetImage('assets/onboarding/add.png'),
            fit: BoxFit.cover,
            
          )),
    ), Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          image: DecorationImage(
            image: AssetImage('assets/onboarding/your.png'),
            fit: BoxFit.cover,
            
          )),
    ),
  ];
  return slideList;
}
}