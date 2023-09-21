import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../alert_error.dart';
import 'login_function.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<String?> strings = [null, null, null, null, null, null];

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<String> titles = ['이름', '주소', '연락처', '비밀번호', '비밀번호 재입력'];
  List<FocusNode> focusList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  bool isClick = false;
  Color backColor = const Color.fromARGB(255, 201, 254, 202);

  @override
  void dispose() {
    for (int i = 0; i < 5; i++) {
      controllers[i].dispose();
      focusList[i].dispose();
    }

    super.dispose();
  }

  void signUp() async {
    isClick = false;
    if (!isClick) {
      isClick = true;
      for (int i = 0; i < 6; i++) {
        strings[i] = null;
      }

      if (controllers[0].text.isEmpty) {
        setState(() {
          strings[0] = '이름을 입력해주세요';
        });
        focusBoard(0);
      } else if (controllers[1].text.isEmpty) {
        setState(() {
          strings[1] = '주소를 입력해주세요';
        });
        focusBoard(1);
      } else if (controllers[2].text.isEmpty) {
        setState(() {
          strings[2] = '연락처를 입력해주세요';
        });
        focusBoard(2);
      } else if (controllers[3].text.isEmpty) {
        setState(() {
          strings[3] = '비밀번호를 입력해주세요';
        });
        focusBoard(3);
      } else if (controllers[4].text.isEmpty) {
        setState(() {
          strings[4] = '비밀번호 재입력을 입력해주세요';
        });
        focusBoard(3);
      } else if (!passwordValid(controllers[3].text)) {
        setState(() {
          strings[3] = '비밀번호는 숫자, 영문자, 특수문자 포함 \n7 - 20자로 입력해주세요.';
        });
        focusBoard(3);
      } else if (controllers[3].text != controllers[4].text) {
        setState(() {
          strings[4] = '비밀번호와 일치하지 않습니다';
        });
        focusBoard(4);
      } else {
        EmailLogin emailLogin = EmailLogin();
        if (context.mounted) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  ));
        }

        String token = await FirebaseMessaging.instance.getToken() as String;

        int trySingup = await emailLogin.signup(
          address: controllers[1].text,
          phoneNumber: controllers[2].text,
          email: controllers[3].text,
          password: controllers[4].text,
          name: controllers[0].text,
          fcmid: token,
        );

        Navigator.pop(context);
        if (trySingup == 200) {
          Navigator.pop(context);
          OverlaySetting setting = OverlaySetting();
          setting.showErrorAlert(context, '회원가입이 되었습니다.');
        } else if (trySingup == 401) {
          OverlaySetting setting = OverlaySetting();
          setting.showErrorAlert(context, '비밀번호가 너무 약합니다.\n다시 시도해주세요');
        } else if (trySingup == 402) {
          OverlaySetting setting = OverlaySetting();
          setting.showErrorAlert(context, '이미 존재하는 전화번호입니다.\n다시 시도해주세요');
        } else if (trySingup == 403) {
          OverlaySetting setting = OverlaySetting();
          setting.showErrorAlert(context, '회원가입에 실패하였습니다.\n다시 시도해주세요');
        } else if (trySingup == 405) {
          OverlaySetting setting = OverlaySetting();
          setting.showErrorAlert(context, '회원가입도중 문제가 발생했습니다..\n다시 시도해주세요');
        }
      }
      isClick = false;
    }
  }

  void focusBoard(int i) {
    FocusScope.of(context).requestFocus(focusList[i]);
  }

  bool emailVaild(String email) {
    String pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool passwordValid(String password) {
    String pattern = r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,20}$';
    RegExp regex = RegExp(pattern);
    print(regex.hasMatch(password));
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(),
    );
  }

  Widget body() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(children: [
      Row(
        children: [
          SizedBox(
            width: screenWidth * 0.03,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              child: const Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 30,
              )),
        ],
      ),
      SizedBox(
        width: double.maxFinite,
        height: screenWidth * 0.05,
      ),
      Expanded(
          child: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: screenWidth * 0.85,
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.00),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회원가입',
                        style: TextStyle(
                            fontSize: screenWidth * 0.09,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '회원이 되어 다양한 혜택을 경험해보세요!',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      SizedBox(
                        height: screenWidth * 0.07,
                      ),
                      for (int i = 0; i < 4; i++)
                        SizedBox(
                          height: screenWidth * 0.18,
                          child: MyTextFormField(i, screenWidth),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.7,
                            child: TextFormField(
                              controller: controllers[4],
                              cursorColor: Colors.black,
                              focusNode: focusList[4],
                              onFieldSubmitted: (value) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                signUp();
                              },
                              decoration: InputDecoration(
                                  hintText: '${titles[4]}',
                                  errorText: strings[4],
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenWidth * 0.1,
                      ),
                      TextButton(
                          onPressed: () {
                            signUp();
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); // 키보드 닫기 이벤트
                          },
                          style: const ButtonStyle(
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero)),
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(113, 53, 191, 255)),
                            child: Center(
                                child: Text(
                              '회원가입',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black),
                            )),
                          ))
                    ]),
              )
            ]),
          )
        ]),
      ))
    ]));
  }

  Row MyTextFormField(int idx, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titles[idx],
        ),
        SizedBox(
            width: screenWidth * 0.7,
            child: TextFormField(
              controller: controllers[idx],
              cursorColor: Colors.black,
              focusNode: focusList[idx],
              onFieldSubmitted: (value) {
                if (idx == 5) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  signUp();
                } else {
                  focusBoard(idx + 1);
                }
              },
              decoration: InputDecoration(
                  hintText: '${titles[idx]} 입력',
                  errorText: strings[idx],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            )),
      ],
    );
  }
}
