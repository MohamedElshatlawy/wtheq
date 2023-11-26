import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/src/main_screen/view/main_screen.dart';

import 'core/base/depindancy_injection.dart' as di;
import 'core/base/depindancy_injection.dart';
import 'core/base/route_genrator.dart';
import 'core/common/app_colors/app_colors.dart';
import 'core/util/localization/app_localizations.dart';
import 'core/util/localization/cubit/localization_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocalizationCubit>()..getSavedLanguage(),
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          if (state is ChangeLanguageState) {
            return ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Wteq Demo',
                    theme: ThemeData(
                      scaffoldBackgroundColor: AppColors.backGround,
                      appBarTheme: const AppBarTheme(
                        color: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                    locale: state.locale,
                    supportedLocales: const [
                      Locale('en', 'US'),
                      Locale('ar', 'SA'),
                    ],
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      DefaultMaterialLocalizations.delegate,
                      DefaultWidgetsLocalizations.delegate,
                    ],
                    localeResolutionCallback: (locale, supportedLocales) {
                      for (var supportedLocale in supportedLocales) {
                        if (supportedLocale.languageCode ==
                            locale?.languageCode) {
                          return supportedLocale;
                        }
                      }
                      return supportedLocales.first;
                    },
                    onGenerateRoute: RouteGenrator.genratedRoute,
                    initialRoute: MainScreen.routeName,
                  );
                });
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
