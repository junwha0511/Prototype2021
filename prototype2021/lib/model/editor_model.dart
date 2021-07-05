import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype2021/model/article_loader.dart';
import 'package:prototype2021/model/map/location.dart';
import 'package:prototype2021/model/map/map_place.dart';
import 'package:prototype2021/model/safe_http.dart';

import 'package:prototype2021/settings/constants.dart';

class EditorModel with ChangeNotifier {
  /* General Arguments */
  String title = "";
  String content = "";
  bool hasAge = true;
  bool hasGender = true;
  int recruitNumber = 0;
  int maleRecruitNumber = 0;
  int femaleRecruitNumber = 0;
  int startAge = 0;
  int endAge = 0;
  int uid = 0;
  DateTime? startDate;
  DateTime? endDate;

  WriteType writeType = WriteType.POST;
  ArticleType articleType = ArticleType.EVENT;

  /* For COMPANION */
  int? pid = 1; // TODO: Change to real pid

  /* For EVENT */
  int? cid;
  Location? location;

  /* For PATCH, PUT and TEMP */
  int? articleId;

  EditorModel();
  EditorModel.location(this.location);

  EditorModel.edit(ArticleDetailData data) {
    this.articleId = data.id;
    this.writeType = WriteType.PUT;

    this.title = data.title;
    this.content = data.body;
    if (data.male == -1 || data.female == -1) {
      this.hasAge = false;
    }
    this.startAge = data.minAge;
    this.endAge = data.maxAge;
    if (data.female == -1 || data.male == -1) {
      this.hasGender = false;
    }
    this.recruitNumber = data.recruit;
    this.maleRecruitNumber = data.male;
    this.femaleRecruitNumber = data.female;
    this.uid = data.userData.uid;
    this.startDate = data.period.start;
    this.endDate = data.period.end;

    if (data is EventDetailData)
      initEvent(data);
    else if (data is CompanionDetailData) initCompanion(data);
  }

  void initEvent(EventDetailData data) {
    this.articleType = ArticleType.EVENT;
    this.writeType = WriteType.PUT;
    this.cid = data.cid;
    this.location =
        Location(data.coord, PlaceType.DEFAULT, ""); // TODO: modify this part
  }

  void initCompanion(CompanionDetailData data) {
    this.articleType = ArticleType.COMPANION;
    this.pid = data.pid;
  }

  void setStartDate(DateTime? startDate) {
    this.startDate = startDate;
    notifyListeners();
  }

  void setEndDate(DateTime? endDate) {
    this.endDate = endDate;
    notifyListeners();
  }

  Future<bool> writeArticle() async {
    Map<String, dynamic> originData = {
      "uid": 1,
      "title": this.title,
      "body": this.content,
      "recruits": {
        "no": this.recruitNumber,
        "male": this.maleRecruitNumber,
        "female": this.femaleRecruitNumber
      },
      "ages": {"min": this.startAge, "max": this.endAge},
      "period": {
        "start":
            this.startDate == null ? null : this.startDate!.toIso8601String(),
        "end": this.endDate == null ? null : this.endDate!.toIso8601String()
      },
    };
    if (this.articleType == ArticleType.COMPANION) {
      return await writeCompanionArticle(originData);
    } else if (this.articleType == ArticleType.EVENT) {
      return await writeEventArticle(originData);
    }

    return false;
  }

  Future<bool> writeCompanionArticle(Map<String, dynamic> originData) async {
    originData["pid"] = this.pid;
    var url;

    if (this.writeType == WriteType.POST) {
      url = POST_RECRUITMENTS_COMPANION_API;
      return await safePOST(url, originData);
    } else if (this.writeType == WriteType.PUT) {
      if (articleId == null) return false;
      url =
          "http://api.tripbuilder.co.kr/recruitments/companions/${articleId!}/";
      return await safePUT(url, originData);
    }
    return false;
  }

  Future<bool> writeEventArticle(Map<String, dynamic> originData) async {
    if (location == null) return false;
    originData["coord"] = {
      "lat": this.location!.latLng.latitude.toString().substring(0, 9),
      "long": this.location!.latLng.longitude.toString().substring(0, 9)
    };

    originData["cid"] = this.cid;

    var url;

    if (this.writeType == WriteType.POST) {
      url = POST_RECRUITMENTS_EVENT_API;
      return await safePOST(url, originData);
    } else if (this.writeType == WriteType.PUT) {
      if (articleId == null) return false;
      url = "http://api.tripbuilder.co.kr/recruitments/events/${articleId!}/";
      return await safePUT(url, originData);
    }
    return false;
  }
}

enum WriteType {
  POST,
  PUT,
  PATCH,
  TEMP,
}
