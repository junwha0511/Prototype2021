import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prototype2021/loader/contents_loader.dart';
import 'package:prototype2021/model/common.dart';
import 'package:prototype2021/model/user_info_model.dart';
import 'package:prototype2021/theme/board/app_bar.dart';
import 'package:prototype2021/theme/board/header_silver.dart';
import 'package:prototype2021/theme/board/helpers.dart';
import 'package:prototype2021/theme/board/search_logic.dart';
import 'package:prototype2021/theme/board/search_widget.dart';
import 'package:prototype2021/theme/board/stream_list.dart';
import 'package:prototype2021/theme/cards/contents_card.dart';
import 'package:prototype2021/theme/cards/product_card.dart';
import 'package:prototype2021/theme/center_notice.dart';
import 'package:prototype2021/ui/board/content_detail_view.dart';
import 'package:prototype2021/ui/board/plan_make_view.dart';
import 'package:prototype2021/ui/board/select_location_toggle_view.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

const double _toolbarHeight = 60;

class BoardMainView extends StatefulWidget {
  const BoardMainView({Key? key}) : super(key: key);

  @override
  _BoardMainViewState createState() => _BoardMainViewState();
}

enum BoardMainViewMode { main, search, result }

class _BoardMainViewState extends State<BoardMainView>
    with
        BoardMainSilverMixin,
        BoardMainViewAppBarMixin,
        BoardMainViewSearchWidgetMixin,
        BoardMainViewSearchLogicMixin,
        BoardMainViewHelpers,
        ContentsLoader {
  /* =================================/================================= */
  /* =========================STATES & METHODS========================= */
  /* =================================/================================= */

  BoardMainViewMode viewMode = BoardMainViewMode.main;

  Future<void> setViewMode(BoardMainViewMode _viewMode) async {
    handleModeChange(_viewMode);
    setState(() {
      viewMode = _viewMode;
    });
  }

  String searchInput = "";
  void setSearchInput(String _searchInput) => setState(() {
        searchInput = _searchInput;
      });

  int tabIndex = 0;
  void setTabIndex(int _tabIndex) => setState(() {
        tabIndex = _tabIndex;
      });

  // The types inside Lists are temporary implementation.
  // If needed, this types can be changed.
  StreamController<List<ProductCardBaseProps>> planDataController =
      new BehaviorSubject<List<ProductCardBaseProps>>();
  StreamController<List<ContentsCardBaseProps>> contentsDataController =
      new BehaviorSubject<List<ContentsCardBaseProps>>();

  late Stream<List<ProductCardBaseProps>> planDataStream;
  late Stream<List<ContentsCardBaseProps>> contentsDataStream;
  late Stream<List<dynamic>> recentSearchesStream;

  Future<void> callApi([String? keyword]) async {
    // Code below is just a simulation of api calls
    planDataController.sink.add(await getPseudoPlanData());
    try {
      UserInfoModel model = Provider.of<UserInfoModel>(context, listen: false);
      if (model.token != null) {
        contentsDataController.sink.add(await getContentsList(model.token!));
      }
    } catch (error) {
      print(error);
      // error handle
    }
  }

  Future<void> searchOnSubmitted(String? keyword) async {
    if (keyword != null && keyword.length > 0) {
      await addSearchKeyword(keyword);
      setViewMode(BoardMainViewMode.result);
      // Do something with keyword (e.g. API call)
    }
  }

  Future<void> onResetButtonPressed() async {
    await resetSearchKeyword();
    loadSearchKeywords();
  }

  Future<void> initData() async => await callApi();

  void handleModeChange(BoardMainViewMode _viewMode) {
    if (_viewMode == BoardMainViewMode.search) {
      loadSearchKeywords();
      textEditingController.text = "";
    } else {
      callApi(searchInput.length > 0 ? searchInput : null);
    }
  }

  // Need Refactor
  Map<String, String> location = {"mainLocation": "국내", "subLocation": "전체"};

  /* =================================/================================= */
  /* =================CONSTRUCTORS & Widget METHODS================= */
  /* =================================/================================= */

  _BoardMainViewState() {
    planDataStream = planDataController.stream;
    contentsDataStream = contentsDataController.stream;
    recentSearchesStream = recentSearchController.stream;
  }

  @override
  void initState() {
    super.initState();
    // Code below is a simulation of api call
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    recentSearchController.close();
    planDataController.close();
    contentsDataController.close();
  }

  /* =================================/================================= */
  /* ==============================WIDGETS============================== */
  /* =================================/================================= */

  @override
  Widget build(BuildContext context) {
    bool onSearch = viewMode == BoardMainViewMode.search;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: buildHeaderBuilder(context),
              body: onSearch ? buildSearchBody() : buildDefaultBody(context)),
        ),
        persistentFooterButtons:
            buildPersistentFooterButtons(onSearch: onSearch));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      leading:
          buildLeading(context, viewMode: viewMode, setViewMode: setViewMode),
      title: buildTextField(
        textEditingController,
        viewMode: viewMode,
        onChanged: setSearchInput,
        onSubmitted: searchOnSubmitted,
        onTap: () => setViewMode(BoardMainViewMode.search),
      ),
      toolbarHeight: _toolbarHeight,
      actions: buildActions(setViewMode: setViewMode, viewMode: viewMode),
    );
  }

  TabBarView buildDefaultBody(BuildContext context) {
    return TabBarView(children: [
      buildPlanListView(context),
      buildContentListView(context),
    ]);
  }

  Container buildSearchBody() {
    void _handleSearchKeywords() => loadSearchKeywords();
    return Container(
        padding: EdgeInsets.only(right: 20, left: 40, top: 20, bottom: 20),
        child: BoardMainViewStreamList<dynamic>(
            stream: recentSearchController.stream,
            refetch: _handleSearchKeywords,
            header: buildSearchBodyHeader(),
            emptyWidget: CenterNotice(text: '최근 검색기록이 없습니다'),
            errorWidget: CenterNotice(
              text: '예기치 못한 오류가 발생했습니다',
              actionText: "다시 시도",
              onActionPressed: _handleSearchKeywords,
            ),
            builder: (recentSearch) {
              if (recentSearch is String)
                return buildRecentSearchItem(
                    text: recentSearch,
                    onActionPressed: () => removeSearchKeyword(recentSearch),
                    onTap: () {
                      textEditingController.text = recentSearch;
                      searchOnSubmitted(recentSearch);
                    });
              else
                return SizedBox();
            }));
  }

  List<SliverAppBar> Function(BuildContext, bool) buildHeaderBuilder(
      BuildContext context) {
    // Need Refactor
    void onLeadingPressed() {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => SelectLocationToggleView(
                    mainLocation: location["mainLocation"] ?? "",
                    subLocation: location["subLocation"] ?? "",
                  ))).then((value) {
        setState(() {
          Map<String, String> _location = value as Map<String, String>;
          if (_location.containsKey("mainLocation") &&
              _location.containsKey("subLocation")) {
            location = _location;
          }
        });
      });
    }

    return buildHeaderSilverBuilder(
      location: location,
      onLeadingPressed: onLeadingPressed,
      viewMode: viewMode,
      onTabBarPressed: setTabIndex,
      tabIndex: tabIndex,
    );
  }

  List<TextButton>? buildPersistentFooterButtons({required bool onSearch}) {
    if (onSearch) {
      return [
        TextButton(
            onPressed: onResetButtonPressed,
            child: Row(
              children: [
                Icon(Icons.delete_forever, color: const Color(0xff555555)),
                SizedBox(width: 7),
                Text("전체 삭제",
                    style: const TextStyle(
                        color: const Color(0xff555555),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0),
                    textAlign: TextAlign.center)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ))
      ];
    } else {
      return null;
    }
  }

  void _handleRefetch() {
    if (viewMode == BoardMainViewMode.result && searchInput.length > 0) {
      searchOnSubmitted(searchInput);
      return;
    }
    if (viewMode == BoardMainViewMode.main) {
      callApi();
      return;
    }
  }

  BoardMainViewStreamList buildPlanListView(BuildContext context) {
    return BoardMainViewStreamList<ProductCardBaseProps>(
      stream: planDataController.stream,
      refetch: _handleRefetch,
      builder: (props) => ProductCard.fromProps(props: props),
      routeBuilder: (_, __) => PlanMakeView(),
      emptyWidget: CenterNotice(text: "불러올 수 있는 플랜이 없습니다"),
      errorWidget: CenterNotice(
        text: '예기치 못한 오류가 발생했습니다',
        actionText: "다시 시도",
        onActionPressed: _handleRefetch,
      ),
    );
  }

  BoardMainViewStreamList buildContentListView(BuildContext context) {
    return BoardMainViewStreamList<ContentsCardBaseProps>(
      stream: contentsDataController.stream,
      refetch: _handleRefetch,
      builder: (props) => ContentsCard.fromProps(props: props),
      routeBuilder: (_, id) => ContentDetailView(
        id: id!,
      ),
      emptyWidget: CenterNotice(text: "불러올 수 있는 컨텐츠가 없습니다"),
      errorWidget: CenterNotice(
        text: '예기치 못한 오류가 발생했습니다',
        actionText: "다시 시도",
        onActionPressed: _handleRefetch,
      ),
    );
  }
}
