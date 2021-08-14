import 'package:flutter/material.dart';
import 'package:prototype2021/settings/constants.dart';

class CardBaseProps {
  final String preview;
  final String title;
  final String place;
  final List<String> tags;
  final Function(bool)? onHeartPreessed;
  final bool isHeartSelected;

  CardBaseProps(
      {required this.preview,
      required this.title,
      required this.place,
      required this.tags,
      required this.isHeartSelected,
      this.onHeartPreessed});
}

class CardBase {
  Container buildCard(Widget itemInfo, Color backgroundColor, String preview,
      bool isHeartSelected, Function(bool)? onHeartPressed) {
    return Container(
        padding: EdgeInsets.all(20 * pt),
        height: 160 * pt,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Color(0xffe8e8e8),
            width: 1,
          ),
        ),
        child: Row(children: <Widget>[
          itemInfo,
          buildW(15 * pt),
          buildPreview(preview, isHeartSelected, onHeartPressed)
        ]));
  }

  /* 
   * Build horizontal spacing with SizedBox
  */
  SizedBox buildW(double gap) {
    return SizedBox(
      width: gap,
    );
  }

  /* 
   * Build vertical spacing with SizedBox
  */
  SizedBox buildH(double gap) {
    return SizedBox(
      height: gap,
    );
  }

  Text buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15 * pt,
        color: Color(0xff444444),
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700,
      ),
      textWidthBasis: TextWidthBasis.parent,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Text buildPlace(String place) {
    return Text(
      place,
      style: TextStyle(
        color: Color(0xff555555),
        fontSize: 10 * pt,
        fontFamily: 'Roboto',
      ),
    );
  }

  Row buildTags(List<String> tags) {
    return Row(
      children: [
        Flex(
          children: _generateTags(tags),
          direction: Axis.horizontal,
        ),
      ],
    );
  }

  List<Container> _generateTags(List<String> tags) {
    // 태그 박스 구현 코드
    return List<Container>.generate(
      tags.length,
      (index) => Container(
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black.withOpacity(0.1), width: 1)),
        child: Text(
          tags[index],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: const Color(0xff707070),
          ),
        ),
      ),
    );
  }

  ClipRRect buildPreview(
      String preview, bool isHeartSelected, Function(bool)? onHeartPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(9.0)),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            width: 100 * pt,
            height: 120 * pt,
            color: Colors.black,
            child: Image.network(
              preview,
              fit: BoxFit.cover,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (onHeartPressed != null) onHeartPressed.call(isHeartSelected);
            },
            icon: Image.asset(
              isHeartSelected
                  ? "assets/icons/ic_product_heart_fill.png"
                  : "assets/icons/ic_product_heart_default.png",
            ),
            iconSize: 30 * pt,
          ),
        ],
      ),
    );
  }
}