import 'package:dronapp/LoginPage/login_function.dart';
import 'package:dronapp/LoginPage/signup_page.dart';
import 'package:flutter/material.dart';

import '../MainPage/mainPage.dart';
import '../Model/User.dart';
import '../alert_error.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode pwFocus = FocusNode();
  bool isClick = false;
  String? emailError;
  String? pwError;
  Color backColor = Color.fromARGB(255, 255, 255, 255);

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    pwFocus.dispose();
    super.dispose();
  }

  // @login
  void login() async {
    if (!isClick) {
      isClick = true;
      emailError = null;
      pwError = null;

      if (emailController.text.isEmpty) {
        setState(() {
          emailError = '이메일을 입력해주세요';
        });
        FocusScope.of(context).requestFocus(emailFocus);
      } else {
        if (passwordController.text.isNotEmpty) {
          EmailLogin emailLogin = EmailLogin();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  ));
          int status = await emailLogin.login(
              email: emailController.text, password: passwordController.text);
          Navigator.pop(context);
          setState(() {});

          if (status == 1 && context.mounted) {
            print('빌더 호출');

            if (UserInstance.instance.type == 'user') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            } else if (UserInstance.instance.type == 'store') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            } else if (UserInstance.instance.type == 'Manager') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            }
          } else {
            if (status == -1) {
              OverlaySetting setting = OverlaySetting();
              setting.showErrorAlert(context, '비밀번호가 일치하지 않습니다.');
            } else {
              OverlaySetting setting = OverlaySetting();
              setting.showErrorAlert(context, '이메일 또는 비밀번호가 틀렸습니다.');
            }
          }
        } else {
          setState(() {
            pwError = '비밀번호를 입력해주세요';
          });
          FocusScope.of(context).requestFocus(pwFocus);
        }
      }
      isClick = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(child: body()),
    );
  }

  Widget body() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(
        width: double.maxFinite,
      ),
      Container(
        width: screenWidth * 0.85,
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(102, 158, 158, 158),
              offset: Offset(3, 4),
              spreadRadius: 4,
              blurRadius: 4)
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Text(
                '드론 배송 로그인',
                style: TextStyle(
                    fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Text(
                '로그인하여 서비스를 즐겨보세요!',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: TextFormField(
                controller: emailController,
                cursorColor: Colors.black,
                focusNode: emailFocus,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(pwFocus);
                },
                decoration: InputDecoration(
                    hintText: '이메일을 입력하세요',
                    errorText: emailError,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: TextFormField(
                controller: passwordController,
                cursorColor: Colors.black,
                focusNode: pwFocus,
                onFieldSubmitted: (v) {
                  login();
                },
                decoration: InputDecoration(
                    hintText: '비밀번호를 입력하세요',
                    errorText: pwError,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: TextButton(
                  onPressed: () {
                    login();
                  },
                  style: const ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                  child: Container(
                    width: screenWidth * 0.7,
                    height: screenWidth * 0.13,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(113, 53, 191, 255)),
                    child: Center(
                        child: Text(
                      '로그인',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, color: Colors.black),
                    )),
                  )),
            ),
          ],
        ),
      ),
      SizedBox(
        height: screenWidth * 0.03,
      ),
      Container(
        width: screenWidth * 0.85,
        height: screenWidth * 0.2,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(102, 158, 158, 158),
              offset: Offset(3, 4),
              spreadRadius: 4,
              blurRadius: 4)
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '아직 계정이 없으신가요?',
              style: TextStyle(fontSize: screenWidth * 0.038),
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));

                  print('네비게이터 호출');
                },
                style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                child: Text(
                  '가입하기',
                  style: TextStyle(
                      color: Colors.blue, fontSize: screenWidth * 0.04),
                )),
          ],
        ),
      )
    ]);
  }
}
