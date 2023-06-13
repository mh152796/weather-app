import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/helper.dart';

import '../provider/weather_provider.dart';
import '../utils/constants.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  void didChangeDependencies() {
    determinePosition().then((position) {
      Provider.of<WeatherProvider>(context, listen: false)
          .setNewPosition(position);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return Center(
            child: provider.hasDataLoaded
                ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentSection(provider),
                      _forecastSection(provider),
                    ],
                  )
                : const CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _currentSection(WeatherProvider provider) {
    return Column(
      children: [
        Text(
          '${provider.currentWeather!.name}-${provider.currentWeather!.sys!.country}',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          getFormattedDateTime(provider.currentWeather!.dt!,
              pattern: 'EEE MMM dd, yyyy'),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          '${provider.currentWeather!.main!.temp!.round()}$degree$celsius',
          style: TextStyle(
            fontSize: 80,
          ),
        ),
        Text(
          'Feels like ${provider.currentWeather!.main!.feelsLike!.round()}$degree$celsius',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Image.network(
            '$prefixWeatherIconUrl${provider.currentWeather!.weather![0].icon}$suffixWeatherIconUrl'),
        Text(
          provider.currentWeather!.weather![0].description!,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _forecastSection(WeatherProvider provider) {
    final itemList = provider.forecastWeather!.list!;
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final item = itemList[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getFormattedDateTime(item.dt!, pattern: 'EEE HH:mm')),
                    Image.network(
                        '$prefixWeatherIconUrl${item.weather![0].icon}$suffixWeatherIconUrl', width: 50, height: 50,),
                    Text(item.weather![0].description!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
