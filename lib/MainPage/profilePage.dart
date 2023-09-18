import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/LoginPage/loginPage.dart';
import 'package:dronapp/LoginPage/login_function.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/alert_error.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController textEditingController = TextEditingController();
  final Color mainColor = Colors.blue;
  String? error;
  bool isChanging = false;
  bool isClickChangeName = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  Future<bool> checkIsCanUseName(String name) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeUserNickName(String name, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'name': name});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('회원정보'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          UserInstance.instance.name!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 196, 195, 195)),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isClickChangeName = !isClickChangeName;
                              });
                            },
                            style: const ButtonStyle(
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                overlayColor: MaterialStatePropertyAll(
                                    Color.fromARGB(0, 0, 0, 0))),
                            child: Text(
                              isClickChangeName ? '변경 취소' : '변경',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isClickChangeName
                                      ? Colors.black38
                                      : Colors.blue,
                                  fontSize: screenWidth * 0.043),
                            ))
                      ],
                    ),
                    Container(
                      color: const Color.fromARGB(255, 224, 224, 224),
                      width: screenWidth,
                      height: 1,
                    )
                  ],
                ),
              ),
              if (isClickChangeName)
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, top: screenWidth * 0.05),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.subdirectory_arrow_right,
                          color: Colors.black12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '변경할 닉네임',
                              style: TextStyle(fontSize: screenWidth * 0.038),
                            ),
                            SizedBox(
                              width: screenWidth * 0.83,
                              height: screenWidth * 0.18,
                              child: TextFormField(
                                controller: textEditingController,
                                cursorColor: mainColor,
                                decoration: InputDecoration(
                                    errorText: error,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: mainColor)),
                                    suffixIcon: TextButton(
                                      onPressed: () async {
                                        if (!isChanging) {
                                          var pattern = RegExp(
                                              r'[?!@#%$^&*(),.?":{}|<>]');
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          if (pattern.hasMatch(
                                              textEditingController.text)) {
                                            setState(() {
                                              error =
                                                  '특수문자를 포함하지 않고 닉네임을 지어주세요';
                                            });
                                          } else {
                                            if (textEditingController
                                                    .text.length >
                                                8) {
                                              setState(() {
                                                error = '8자리 이하로 닉네임을 입력해주세요';
                                              });
                                            } else {
                                              isChanging = true;
                                              var isCan =
                                                  await checkIsCanUseName(
                                                      textEditingController
                                                          .text);
                                              if (isCan) {
                                                var changing =
                                                    await changeUserNickName(
                                                        textEditingController
                                                            .text,
                                                        UserInstance
                                                            .instance.name!);
                                                if (changing) {
                                                  UserInstance.instance.name =
                                                      textEditingController
                                                          .text;

                                                  setState(() {
                                                    error = null;
                                                    textEditingController.text =
                                                        '';
                                                    isClickChangeName = false;
                                                  });
                                                  OverlaySetting
                                                      overlaySetting =
                                                      OverlaySetting();
                                                  overlaySetting.showErrorAlert(
                                                      context, '닉네임을 변경했습니다');
                                                } else {
                                                  setState(() {
                                                    error =
                                                        '닉네임 변경에 실패했습니다. 다시 시도해주세요';
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  error = '이미 존재하는 닉네임입니다.';
                                                });
                                              }
                                              isChanging = false;
                                            }
                                          }
                                        }
                                      },
                                      child: Text(
                                        '변경 완료',
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: screenWidth * 0.043,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.black26,
                                        fontSize: screenWidth * 0.04),
                                    hintText: '변경할 닉네임을 입력해주세요'),
                              ),
                            )
                          ],
                        )
                      ]),
                ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: TextButton(
                  onPressed: () async {
                    EmailLogin logout = EmailLogin();
                    await logout.signout();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: const ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '로그아웃',
                          style: TextStyle(fontSize: screenWidth * 0.043),
                        ),
                        Icon(Icons.logout)
                      ]),
                ),
              )
            ],
          ),
        ));
  }
}
