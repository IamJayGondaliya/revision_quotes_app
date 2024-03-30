import 'package:revision_quotes_app/headers.dart';
import 'package:revision_quotes_app/pages/detail_page/detail_page.dart';
import 'package:revision_quotes_app/pages/home_page/home_page.dart';
//Singleton

class AppRoutes {
  AppRoutes._();
  static final AppRoutes instance = AppRoutes._();

  String homePage = '/';
  String detailPage = 'detail_page';

  Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomePage(),
    'detail_page': (context) => const DetailPage(),
  };
}
