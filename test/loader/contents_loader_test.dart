import 'package:flutter_test/flutter_test.dart';
import 'package:prototype2021/model/board/contents/content_preview.dart';
import 'package:prototype2021/utils/safe_http/base.dart';
import 'package:prototype2021/model/board/contents/http/contents.dart';
import 'package:prototype2021/loader/board/contents_loader.dart';

import 'login_loader_test.dart';

void main() {
  setUpAll(() async {
    token = await login();
  });

  // group('[Class] ContentsLoader', testContentsLoader);
}

String token = "";
List<ContentPreview>? sampleData;
ContentsLoader? contentsLoader;

void testContentsLoader() {
  contentsLoader = new ContentsLoader();
  group('[Fetching Method] contentsList', testContentsList);
  group('[Fetching Method] contentsHeart', testContentsHeart);
  group('[Fetching Method] contentsWishlist', testContentsWishlist);
  group('[Fetching Method] contentsDetail', testContentsDetail);
}

void testContentsList() {
  test('should get the response', () async {
    ContentsListInput params = new ContentsListInput();
    SafeQueryInput<ContentsListInput> dto = new SafeQueryInput(
        url: contentsLoader!.contentsListUrl, params: params, token: token);
    SafeQueryOutput<ContentsListOutput> result =
        await contentsLoader!.contentsList(dto);
    print(result.error?.message);
    print(result.data?.results);
    expect(result.data?.results != null, true);
    expect(result.data!.count > 0, true);
    expect(result.data!.previous, null);
    sampleData = result.data!.results;
  });

  test('should get a list of contents with keywords related', () async {
    String keyword = "대구";
    ContentsListInput params = new ContentsListInput(keyword: keyword);
    SafeQueryInput<ContentsListInput> dto = new SafeQueryInput(
        url: contentsLoader!.contentsListUrl, params: params, token: token);
    SafeQueryOutput<ContentsListOutput> result =
        await contentsLoader!.contentsList(dto);
    print(result.error?.message);
    print(result.data?.results);
    expect(result.data?.results != null, true);
    expect(result.data!.count > 0, true);
    expect(result.data!.previous, null);
  });
}

void testContentsHeart() {
  test('should heart the content', () async {
    bool success = true;
    try {
      await contentsLoader!.heartContents(sampleData![0].id.toString(), token);
    } catch (error) {
      success = false;
    }
    expect(success, true);
  });
}

void testContentsWishlist() {
  test('should get wishlist', () async {
    ContentsWishlistInput params = new ContentsWishlistInput();
    SafeQueryInput<ContentsWishlistInput> dto = new SafeQueryInput(
        url: contentsLoader!.contentsWishlistUrl, params: params, token: token);
    SafeQueryOutput<ContentsWishlistOutput> result =
        await contentsLoader!.contentsWishlist(dto);
    expect(result.data?.results != null, true);
  });
}

void testContentsDetail() {
  test('should get detail', () async {
    await Future.forEach<ContentPreview>(sampleData!, (datum) async {
      ContentsDetailInput params = new ContentsDetailInput(id: datum.id);
      SafeQueryInput<ContentsDetailInput> dto = new SafeQueryInput(
          url: contentsLoader!.contentsDetailUrl, params: params, token: token);
      SafeQueryOutput<ContentsDetailOutput> result =
          await contentsLoader!.contentsDetail(dto);
      print(result.error?.message);
      expect(result.data?.result != null, true);
    });
  });
}
