// ignore_for_file: always_use_package_imports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'common/domain/providers/base_router_provider.dart';
import 'common/presentation/app_base_widget.dart';
import 'common/utils/custom_provider_observer.dart';
import 'common/utils/q_logger.dart';
import 'generated/l10n.dart';
import 'main/app_environment.dart';
import 'theme/theme.dart';

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvInfo.initialize(environment);
  Loggy.initLoggy(
    logPrinter: !EnvInfo.isProduction || kDebugMode
        ? StreamPrinter(const PrettyDeveloperPrinter())
        : const DisabledPrinter(),
  );
  void runAppCallback() => SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      ).then((_) => runApp(ProviderScope(
            observers: [CustomProviderObserver()],
            child: const MyApp(),
          )));
  if (environment == AppEnvironment.PROD) {
    await SentryFlutter.init(
      (options) {
        options.dsn = 'DSN';
      },
      appRunner: runAppCallback,
    );
  } else {
    runAppCallback();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseRouter = ref.watch(baseRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: EnvInfo.environment != AppEnvironment.PROD,
      title: EnvInfo.appTitle,
      theme: primaryTheme,
      darkTheme: secondaryTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        S.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      routerDelegate: baseRouter.routerDelegate,
      routeInformationParser: baseRouter.routeInformationParser,
      routeInformationProvider: baseRouter.routeInformationProvider,
      builder: (context, child) => Material(
        type: MaterialType.transparency,
        child: AppBaseWidget(child ?? const SizedBox()),
      ),
    );
  }
}
