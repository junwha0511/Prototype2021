import 'dart:io';

import 'package:prototype2021/data/dto/plan/plan_dto.dart';
import 'package:prototype2021/loader/safe_http.dart';
import 'package:prototype2021/model/safe_http_dto/base.dart';
import 'package:prototype2021/model/safe_http_dto/get/plan.dart';
import 'package:prototype2021/model/safe_http_dto/output_dto_factory.dart';
import 'package:prototype2021/model/safe_http_dto/patch/heart.dart';
import 'package:prototype2021/settings/constants.dart';

enum PaginationState {
  start,
  mid,
  end,
}

enum PlanLoaderMode {
  board,
  wishlist,
  mylist,
}

class PlanLoader {
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
  Future<List<PlanPreview>> getPlanList(String token) async {
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
      return result.data!.results;
    }
    throw HttpException(result.error?.message ?? "Unexpected error");
  }

  /// Plan Detail DTO를 반환한다.
  Future<PlanDetail> getPlanDetail({required int id, String? token}) async {
    PlanIdInput params = PlanIdInput(id);
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
    PlanIdInput params = PlanIdInput(id);
    SafeQueryInput<PlanIdInput> dto = SafeQueryInput<PlanIdInput>(
        params: params, url: planIdUrl, token: token);
    SafeQueryOutput<PlanDeleteOutput> result = await planDelete(dto);
    if (result.success) return true;

    return false;
  }

  // Fetching Functions
  Future<SafeMutationOutput<PlanHeartOutput>> planHeart(
          SafeMutationInput<PlanHeartInput> dto) async =>
      await safePatch<PlanHeartInput, PlanHeartOutput>(dto);

  Future<SafeQueryOutput<PlanListOutput>> planList(
          SafeQueryInput<PlanListInput> dto) async =>
      await safeGET<PlanListInput, PlanListOutput>(dto);

  Future<SafeQueryOutput<PlanDetailOutput>> planDetail(
          SafeQueryInput<PlanIdInput> dto) async =>
      await safeGET<PlanIdInput, PlanDetailOutput>(dto);
  Future<SafeQueryOutput<PlanDeleteOutput>> planDelete(
          SafeQueryInput<PlanIdInput> dto) async =>
      await safeDELETE<PlanIdInput, PlanDeleteOutput>(dto);

  // Endpoints
  String planHeartUrl = "$apiBaseUrl/plan/:planId/like";
  String planListUrl = "$apiBaseUrl/plans";
  String planIdUrl = "$apiBaseUrl/plans/:id";

  /// Pagination을 위한 인스턴스 생성 지원
  /// PlanLoaderMode.board: 게시판 목록 Pagination
  /// PlanLoaderMode.wishlist: 위시리스트 Pagination
  /// PlanLoaderMode.mylist: 내가 쓴 플랜 Pagination
  PlanLoader.withMode(PlanLoaderMode mode) {
    if (mode == PlanLoaderMode.board) {
      planListUrl = "$apiBaseUrl/plans";
    } else if (mode == PlanLoaderMode.mylist) {
      planListUrl = "$apiBaseUrl/plans/mylist/";
    } else if (mode == PlanLoaderMode.wishlist) {
      planListUrl = "$apiBaseUrl/plans/wishlists/";
    }
  }

  /// Pagination 없음 (하트, 삭제 등)
  PlanLoader();
}
