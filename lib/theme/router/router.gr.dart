// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:list_app/pages/menu_app_page.dart' as _i1;
import 'package:list_app/pages/welcome_page.dart' as _i2;

/// generated route for
/// [_i1.MenuAppPage]
class MenuAppRoute extends _i3.PageRouteInfo<void> {
  const MenuAppRoute({List<_i3.PageRouteInfo>? children})
    : super(MenuAppRoute.name, initialChildren: children);

  static const String name = 'MenuAppRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.MenuAppPage();
    },
  );
}

/// generated route for
/// [_i2.WelcomePage]
class WelcomeRoute extends _i3.PageRouteInfo<void> {
  const WelcomeRoute({List<_i3.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.WelcomePage();
    },
  );
}
