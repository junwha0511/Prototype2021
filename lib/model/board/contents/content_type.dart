enum ContentType {
  /// 메모: 플랜 생성 뷰에서 메모를 표시하기 위해 쓰입니다 [id: -2]
  memo,

  /// 알 수 없음: typeid가 null일 때를 의미합니다 [id: -1]
  unknown,

  /// 관광지 [id: 12]
  spot,

  /// 문화시설 [id: 14]
  cultureInfra,

  /// 행사/공연/축제 [id: 15]
  events,

  /// 레포츠 [id: 28]
  leisureSports,

  /// 숙박 [id: 32]
  accomodations,

  /// 쇼핑 [id: 38]
  shopping,

  /// 음식점 [id: 39]
  restaurants,
}

Map<ContentType, int> contentTypeId = {
  ContentType.memo: -2,
  ContentType.unknown: -1,
  ContentType.spot: 12,
  ContentType.cultureInfra: 14,
  ContentType.events: 15,
  ContentType.leisureSports: 28,
  ContentType.accomodations: 32,
  ContentType.shopping: 38,
  ContentType.restaurants: 39,
};

Map<int, ContentType> idContentType = {
  -2: ContentType.memo,
  -1: ContentType.unknown,
  12: ContentType.spot,
  14: ContentType.cultureInfra,
  15: ContentType.events,
  28: ContentType.leisureSports,
  32: ContentType.accomodations,
  38: ContentType.shopping,
  39: ContentType.restaurants,
};

Map<String, ContentType> titleContentType = {
  "모두 보기": ContentType.unknown,
  "관광지": ContentType.spot,
  "문화 시설": ContentType.cultureInfra,
  "행사/공연/축제": ContentType.events,
  "레포츠": ContentType.leisureSports,
  "숙박": ContentType.accomodations,
  "쇼핑": ContentType.shopping,
  "음식점": ContentType.restaurants,
};
