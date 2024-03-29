import 'dart:io';

import 'package:prototype2021/model/board/plan/plan_dto.dart';
import 'package:prototype2021/utils/safe_http/base.dart';
import 'package:prototype2021/utils/safe_http/common.dart';
import 'package:prototype2021/model/board/plan/http/plan.dart';
import 'package:prototype2021/model/board/wishlist/http/heart.dart';
import 'package:prototype2021/utils/safe_http/safe_http.dart';
import 'package:prototype2021/settings/constants.dart';
import 'package:prototype2021/widgets/cards/product_card.dart';

enum PlanLoaderMode {
  board,
  wishlist,
  mylist,
}

class PlanLoader {
  final PlanLoaderMode mode;
  PaginationState pagination = PaginationState.start;

  // Custom Functions

  //// Plan에 하트를 누르는 로직, PaginationState.general과 함께 사용
  Future<void> heartPlan(String planId, String token) async {
    PlanHeartInput params = new PlanHeartInput(planId: planId);
    SafeMutationInput<PlanHeartInput> dto =
        new SafeMutationInput<PlanHeartInput>(
            data: params, url: planHeartUrl, token: token);
    SafeMutationOutput<PlanHeartOutput> result = await planHeart(dto);
    if (!result.success)
      throw HttpException(result.error?.message ?? "Unexpected error");
  }

  /// Plan List를 가져오는 로직, PaginationState.board, wishlist, mylist에서 사용가능하며,
  /// 각 인스턴스가 pagination 정보를 가지고 있어 재호출시 다음 페이지를 반환한다.
  /// pagination == PaginationState.end 일 경우 더 이상 페이지가 없음을 의미한다.
  Future<List<ProductCardBaseProps>> getPlanList(
      String token, bool reset) async {
    if (reset) {
      pagination = PaginationState.start;
      planListUrl = _urlWithMode(mode);
    }
    if (pagination == PaginationState.end) return [];

    PlanListInput params = PlanListInput();

    SafeQueryInput<PlanListInput> dto = SafeQueryInput<PlanListInput>(
        params: params, url: planListUrl, token: token);
    SafeQueryOutput<PlanListOutput> result = await planList(dto);

    if (result.success) {
      if (result.data!.next != null) {
        planListUrl = result.data!.next!
            .replaceFirst("tbserver:8000", "api.tripbuilder.co.kr");
        pagination = PaginationState.mid;
      } else {
        planListUrl = "";
        pagination = PaginationState.end;
      }
      return result.data!.results
          .map<ProductCardBaseProps>((datum) => ProductCardBaseProps(
                period: datum.period,
                costStart: datum.expense,
                costEnd: datum.expense,
                isGuide: false,
                tendencies: [],
                preview: datum.photo,
                title: datum.title,
                tags: datum.types,
                id: datum.id,
                hearted: datum.hearted ?? false,
              ))
          .toList();
    }
    throw HttpException(result.error?.message ?? "Unexpected error");
  }

  /// Plan Detail DTO를 반환한다.
  Future<PlanDetail> getPlanDetail({required int id, String? token}) async {
    PlanIdInput params = PlanIdInput(id: id);
    SafeQueryInput<PlanIdInput> dto = SafeQueryInput<PlanIdInput>(
        params: params, url: planIdUrl, token: token);
    SafeQueryOutput<PlanDetailOutput> result = await planDetail(dto);

    if (result.success) {
      return result.data!.result;
    }

    throw HttpException(result.error?.message ?? "Unexpected error");
  }

  /// Plan을 삭제하고 성공시 true를 반환한다.
  Future<bool> deletePlan({required int id, String? token}) async {
    PlanIdInput params = PlanIdInput(id: id);
    SafeQueryInput<PlanIdInput> dto = SafeQueryInput<PlanIdInput>(
        params: params, url: planIdUrl, token: token);
    SafeQueryOutput<PlanDeleteOutput> result = await planDelete(dto);
    if (result.success) return true;

    return false;
  }

  /// data로부터 json을 구성해 플랜을 생성하고, 성공 여부를 반환한다.
  Future<bool> createPlan(String token, PlanData data) async {
    PlanCreateInput planInputData = PlanCreateInput(data: data);
    SafeMutationInput<PlanCreateInput> dto = SafeMutationInput<PlanCreateInput>(
        data: planInputData, url: planGeneralUrl, token: token);
    SafeMutationOutput<PlanCreateOutput> result = await planCreate(dto);
    if (result.success) return true;

    return false;
  }

  /// data로부터 json을 구성해 플랜을 수정하고, 성공 여부를 반환한다.
  /// **컨텐츠는 수정 불가능!
  Future<bool> editPlan(String token, PlanData data) async {
    PlanCreateInput planInputData = PlanCreateInput(data: data);
    SafeMutationInput<PlanCreateInput> dto = SafeMutationInput<PlanCreateInput>(
        data: planInputData, url: planGeneralUrl, token: token);
    SafeMutationOutput<PlanCreateOutput> result = await planEdit(dto);
    if (result.success) return true;

    return false;
  }

  // Fetching Functions
  Future<SafeMutationOutput<PlanHeartOutput>> planHeart(
          SafeMutationInput<PlanHeartInput> dto) async =>
      await safePatch<PlanHeartInput, PlanHeartOutput>(
          dto, null); // null stands that any status code is okay

  Future<SafeQueryOutput<PlanListOutput>> planList(
          SafeQueryInput<PlanListInput> dto) async =>
      await safeGET<PlanListInput, PlanListOutput>(dto, 200, true);

  Future<SafeQueryOutput<PlanDetailOutput>> planDetail(
          SafeQueryInput<PlanIdInput> dto) async =>
      await safeGET<PlanIdInput, PlanDetailOutput>(dto, 200, true);
  Future<SafeQueryOutput<PlanDeleteOutput>> planDelete(
          SafeQueryInput<PlanIdInput> dto) async =>
      await safeDELETE<PlanIdInput, PlanDeleteOutput>(dto);

  Future<SafeMutationOutput<PlanCreateOutput>> planCreate(
          SafeMutationInput<PlanCreateInput> dto) async =>
      await safePOST(dto);
  Future<SafeMutationOutput<PlanCreateOutput>> planEdit(
          SafeMutationInput<PlanCreateInput> dto) async =>
      await safePatch(dto);

  // Endpoints
  final String planHeartUrl = "$apiBaseUrl/plans/:planId/like/";
  final String planGeneralUrl = "$apiBaseUrl/plans/";
  String planListUrl = "";
  final String planIdUrl = "$apiBaseUrl/plans/:id/";

  /// Pagination을 위한 인스턴스 생성 지원
  /// PlanLoaderMode.board: 게시판 목록 Pagination
  /// PlanLoaderMode.wishlist: 위시리스트 Pagination
  /// PlanLoaderMode.mylist: 내가 쓴 플랜 Pagination
  PlanLoader.withMode({required this.mode}) : planListUrl = _urlWithMode(mode);

  // **Please Review Here**
  // Please check if the codeline below could potentially cause an error
  /// Pagination 없음 (하트, 삭제 등)
  PlanLoader() : mode = PlanLoaderMode.board;
}

String _urlWithMode(PlanLoaderMode mode) {
  switch (mode) {
    case PlanLoaderMode.mylist:
      return "$apiBaseUrl/plans/mylist/";
    case PlanLoaderMode.wishlist:
      return "$apiBaseUrl/plans/wishlist/";
    default:
      return "$apiBaseUrl/plans/";
  }
}
