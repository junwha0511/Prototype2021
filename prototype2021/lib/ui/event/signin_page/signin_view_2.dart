import 'package:flutter/material.dart';
import 'package:prototype2021/settings/constants.dart';
import 'package:prototype2021/theme/editor/custom_text_field.dart';
import 'package:prototype2021/theme/selectable_text_button.dart';

class SigninView2 extends StatefulWidget {
  const SigninView2({Key? key}) : super(key: key);

  @override
  _SigninView2State createState() => _SigninView2State();
}

class _SigninView2State extends State<SigninView2> {
  List<bool> isChecked = [false, true];
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  void _changeisChecked1(bool value) => setState(() => isChecked1 = value);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.white,
      appBar: buildAppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              '트립빌더에 오신 것을 환영합니다!',
              style: TextStyle(
                color: Color(0xff444444),
                fontSize: 21,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text('수천명의 여행 메이트와 함께하는\n나만의 간편한 여행 만들기\n지금 바로 시작하세요',
                style: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center),
            SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  margin: EdgeInsets.only(
                    left: 128,
                    right: 128,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffdbdbdb),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                ),
                Positioned(
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/icons/ic_image_gray.png",
                    ),
                  ),
                  right: 110,
                  bottom: 0,
                )
              ],
            ),
            TextField(
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 140, bottom: 11, top: 30, right: 50),
                hintText: "닉네임을 입력해주세요",
              ),
              onChanged: (String text) {},
              maxLines: 1,
              enableInteractiveSelection: false,
            ),
            Container(
              height: 0,
              margin: EdgeInsets.only(
                left: 87.5,
                right: 87.5,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff707070),
                  width: 1,
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            TextButton(
                onPressed: () {},
                child: Container(
                    child: Center(
                      child: Text(
                        "다음",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                      ),
                    ),
                    width: 370,
                    height: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xff4080ff),
                    ))),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: Image.asset("assets/icons/ic_arrow_left_back.png"),
          onPressed: () {},
        ),
        title: Text("회원설정",
            style: const TextStyle(
                color: const Color(0xff000000),
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 16.0 * pt),
            textAlign: TextAlign.left));
  }
}