import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/bloc/day_forecast_bloc/bloc.dart';
import 'package:lab1/models/day_forecast.dart';
import 'package:lab1/ui/resources/colors.dart';
import 'package:lab1/ui/screens/city_search_screen/city_search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<DayForecastBloc>().add(
          GetWeekForecast(
            49.842957,
            24.031111,
            "Lviv"
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _colors(),
            _body(),
          ],
        ),
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _body() {
    return BlocBuilder<DayForecastBloc, DayForecastState>(
      builder: (context, state) {
        if (state is WeekForecastLoaded) {
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: _todayForecast(state.weekForecast[0]),
              ),
              Expanded(
                flex: 3,
                child: _weekForecast(context, state.weekForecast),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _colors() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: AppColor.primaryBlue,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: AppColor.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _todayForecast(DayForecast dayForecast) {
    return Padding(
      padding: const EdgeInsets.all(55),
      child: FittedBox(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${dayForecast.city}, ${dayForecast.dayName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 46,
                    color: Colors.white,
                  ),
                ),
                Text(
                  dayForecast.date,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 38,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "${dayForecast.temperature}°С",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 85,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 70),
            Icon(
              Icons.wb_sunny,
              color: Colors.amber,
              size: 140,
            ),
          ],
        ),
      ),
    );
  }

  Widget _weekForecast(BuildContext context, List<DayForecast> weekForecast) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        childAspectRatio: 0.35,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                weekForecast[index].dayName.substring(0, 3),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                ),
              ),
              SizedBox(height: 50),
              _cardWeather(weekForecast[index]),
              SizedBox(height: 20),
              Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _cardWeather(DayForecast dayForecast) {
    return Column(
      children: [
        Icon(
          Icons.wb_sunny,
          color: Colors.amber,
          size: 40,
        ),
        SizedBox(height: 20),
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  color: AppColor.lightGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "${dayForecast.temperature}°С",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CitySearchScreen(),
          ),
        );
      },
      backgroundColor: AppColor.primaryBlue,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.wb_cloudy_rounded,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Icon(
              Icons.add,
              color: AppColor.lightBlue,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
