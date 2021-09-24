import 'package:prototype2021/model/safe_http_dto/common.dart';

class ContentPreviewBase {
  final int id;
  final String title;
  final String overview;

  /// URL of the photo
  final String? thumbnail;
  final String address;

  /// catCode가 int가 아닌 것으로 보입니다.
  /// 예를들어 이런 식입니다: B0201
  final String catCode;
  final int heartNo;
  final bool hearted;

  ContentPreviewBase.fromJson({required Map<String, dynamic> json})
      : id = int.parse(json["id"] as String), // dart recieves it as String
        title = json["title"] as String,
        overview = json["overview"] as String,
        thumbnail = nullable<String>(json["thumbnail"]),
        address = json["address"] as String,
        catCode = json["cat_code"] as String,
        heartNo = json["heart_no"] as int,
        hearted = json["hearted"] as bool;
}

// 이 DTO가 맞지 않는 것 같습니다
// class ContentPreview extends ContentPreviewBase {
//   final double rating;
//   final int reviewNo;

//   ContentPreview.fromJson({required Map<String, dynamic> json})
//       : rating = json["rating"] as double,
//         reviewNo = json["review_no"] as int,
//         super.fromJson(json: json);
// }

class WishlistContentPreview extends ContentPreviewBase {
  final double ratingNo;

  WishlistContentPreview.fromJson({required Map<String, dynamic> json})
      : ratingNo = json["rating_no"] as double,
        super.fromJson(json: json);
}