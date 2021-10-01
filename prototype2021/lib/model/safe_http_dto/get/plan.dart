import 'package:prototype2021/data/dto/plan/plan_dto.dart';
import 'package:prototype2021/model/safe_http_dto/base.dart';
import 'package:prototype2021/model/safe_http_dto/common.dart';

/*---------------- Plan List ----------------*/
/// SafeHttpDataInput for Plan List
class PlanListInput extends SafeHttpDataInput {
  Map<String, dynamic> toJson() => {};

  Map<String, String>? getUrlParams() => null;
}

/// PaginationOutput for Plan List
class PlanListOutput extends PaginationOutput
    implements Pagination<PlanPreview> {
  final List<PlanPreview> results;
  PlanListOutput.fromJson({required Map<String, dynamic> json})
      : results = (json["results"] as List<dynamic>)
            .map((result) =>
                PlanPreview.fromJson(json: result as Map<String, dynamic>))
            .toList(),
        super.fromJson(json: json);
}

/*---------------- Plan Id input ----------------*/
/// SafeHttpDataInput for Plan Detail and Plan Delete
class PlanIdInput extends SafeHttpDataInput {
  final int id;

  PlanIdInput(this.id);

  Map<String, dynamic>? toJson() => null;

  Map<String, String>? getUrlParams() => {":id": id.toString()};
}

/*---------------- Plan Detail ----------------*/
/// SafeHttpDataOutput for PlanDetail
class PlanDetailOutput extends SafeHttpDataOutput {
  final PlanDetail result;

  PlanDetailOutput.fromJson({required Map<String, dynamic> json})
      : result = PlanDetail.fromJson(json: json);
}

/*---------------- Plan Delete ----------------*/
/// SafeHttpDataOutput for Plan Delete
class PlanDeleteOutput extends SafeHttpDataOutput {
  final int id;
  PlanDeleteOutput.fromJson({required Map<String, dynamic> json})
      : id = json["id"];
}