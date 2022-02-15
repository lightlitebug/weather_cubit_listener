import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'cubits/temp_settings/temp_settings_cubit.dart';
import 'cubits/theme/theme_cubit.dart';
import 'cubits/weather/weather_cubit.dart';
import 'pages/home_page.dart';
import 'repositories/weather_repository.dart';
import 'services/weather_api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiServices: WeatherApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocListener<WeatherCubit, WeatherState>(
          listener: (context, state) {
            context.read<ThemeCubit>().setTheme(state.weather.theTemp);
          },
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Weather App',
                debugShowCheckedModeBanner: false,
                theme: state.appTheme == AppTheme.light
                    ? ThemeData.light()
                    : ThemeData.dark(),
                home: HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
