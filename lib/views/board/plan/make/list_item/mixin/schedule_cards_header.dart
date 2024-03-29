import 'package:flutter/material.dart';
import 'package:prototype2021/model/board/place_data_props.dart';
import 'package:prototype2021/handler/board/plan/calendar.dart';
import 'package:prototype2021/handler/board/plan/plan_make_calendar_handler.dart';
import 'package:prototype2021/views/board/plan/make/list_item/plan_list_item.dart';
import 'package:prototype2021/views/board/plan/make/list_item/mixin/helper.dart';
import 'package:prototype2021/views/board/plan/make/list_item/mixin/memo_dialog.dart';
import 'package:prototype2021/views/board/plan/make/home/plan_make_home_view.dart';
import 'package:prototype2021/views/board/plan/make/home/mixin/constants.dart';
import 'package:prototype2021/views/board/plan/make/plan_make_view.dart';
import 'package:provider/provider.dart';

class ScheduleCardsHeader extends StatefulWidget {
  final int dateIndex;

  ScheduleCardsHeader({required this.dateIndex});

  @override
  _ScheduleCardsHeaderState createState() =>
      _ScheduleCardsHeaderState(dateIndex: dateIndex);
}

class _ScheduleCardsHeaderState extends State<ScheduleCardsHeader>
    with PlanListItemMemoDialogMixin, PlanListItemHelper {
  /* =================================/================================= */
  /* =========================STATES & METHODS========================= */
  /* =================================/================================= */

  final int dateIndex;

  String _memo = "";
  void _setMemo(String memo) {
    setState(() {
      _memo = memo;
    });
  }

  TextEditingController _textEditingController = TextEditingController();

  /* =================================/================================= */
  /* =================CONSTRUCTORS & LIFE CYCLE METHODS================= */
  /* =================================/================================= */

  _ScheduleCardsHeaderState({required this.dateIndex});

  /* =================================/================================= */
  /* ==============================WIDGETS============================== */
  /* =================================/================================= */

  @override
  Widget build(BuildContext context) {
    PlanMakeHandler handler = Provider.of<PlanMakeHandler>(context);
    DateTime date = handler.datePoints[0]!.add(Duration(days: dateIndex));
    return Container(
      child: Row(
        children: [
          buildLeading(context, date),
          buildActions(context),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  Container buildLeading(BuildContext context, DateTime date) {
    PlanMakeHandler handler = Provider.of<PlanMakeHandler>(context);
    List<PlaceDataInterface> data = handler.planListItems?[dateIndex] ?? [];
    bool hasItem = data.length != 0;
    PlanListItemState? parent =
        context.findAncestorStateOfType<PlanListItemState>();
    bool expanded = parent?.expanded ?? false;
    return Container(
        child: Row(
          children: [
            Container(
              child: Row(
                children: [
                  Text("${(dateIndex + 1).toString()} 일차",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                      "${date.month.toString()}.${date.day.toString()} ${Calendar().getWeekdayInKorean(date.weekday)}",
                      style: const TextStyle(
                          color: const Color(0xff505050),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                      textAlign: TextAlign.left),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ),
            IconButton(
                onPressed: hasItem ? parent?.toggleExpanded : null,
                icon: expanded
                    ? Image.asset('assets/icons/ic_calender_arrow_up_fold.png')
                    : Image.asset(
                        'assets/icons/ic_calender_arrow_down_unfold.png'))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        constraints: BoxConstraints(minWidth: 150));
  }

  Container buildActions(BuildContext context) {
    PlanMakeHandler handler = Provider.of<PlanMakeHandler>(context);
    void _createMemo() =>
        handler.addPlaceData(dateIndex, new MemoData(memo: _memo));
    PlanListItemState? parent =
        context.findAncestorStateOfType<PlanListItemState>();
    PlanMakeHomeViewState? grandParent =
        context.findAncestorStateOfType<PlanMakeHomeViewState>();
    PlanMakeMode mode = grandParent?.mode ?? PlanMakeMode.add;
    List<IconButton> children = [];
    if (mode == PlanMakeMode.add) {
      children = [
        IconButton(
            onPressed: () async {
              await displayMemoInputDialog(
                context,
                _textEditingController,
                _setMemo,
                _createMemo,
              );
              if (parent?.expanded != null && !parent!.expanded) {
                parent.setExpanded(true);
              }
            },
            icon: Image.asset('assets/icons/ic_calender_memo_gray.png')),
        IconButton(
            onPressed: () {
              handler.setCurrentIndex(dateIndex);
              if (grandParent != null) {
                grandParent.navigator(Navigate.custom, PlanMakeViewMode.select);
              }
            },
            icon: Image.asset('assets/icons/ic_calender_plus.png')),
      ];
    }
    return Container(
      child: Row(
        children: children,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
