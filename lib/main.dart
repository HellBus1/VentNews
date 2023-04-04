import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vent_news/data/NewsRepository.dart';
import 'package:vent_news/feature/MainPage.dart';
import 'package:vent_news/feature/home/HomePage.dart';
import 'package:vent_news/feature/home/cubits/ArticlesCubit.dart';
import 'package:vent_news/locator.dart';

import 'common/theme.dart';

Future<void> main() async {
  await initializeDependencies();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticlesCubit(
            locator<NewsRepository>(),
          )..getBreakingNewsArticles(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        primaryColor: kWhiteColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: kColorScheme.copyWith(secondary: kPrimaryColor),
        bottomNavigationBarTheme: bottomNavigationBarTheme,
      ),
      initialRoute: '/',
      routes: {'/': (context) => const MainPage()},
    );
  }
}
