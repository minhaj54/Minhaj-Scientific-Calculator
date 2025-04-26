import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const AirQualityApp());
}

class AirQualityApp extends StatelessWidget {
  const AirQualityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'India Air Quality Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const AirQualityHomePage(),
    );
  }
}

class AirQualityHomePage extends StatefulWidget {
  const AirQualityHomePage({Key? key}) : super(key: key);

  @override
  State<AirQualityHomePage> createState() => _AirQualityHomePageState();
}

class _AirQualityHomePageState extends State<AirQualityHomePage> {
  bool isLoading = true;
  String selectedCity = 'Delhi';
  List<String> cities = [
    'Delhi',
    'Mumbai',
    'Bengaluru',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad'
  ];
  Map<String, dynamic> airQualityData = {};
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAirQualityData();
  }

  Future<void> fetchAirQualityData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // hmko yanah pe actual api implement krna h Using CPCB API endpoint (replace with actual endpoint when available)
      final response = await http.get(Uri.parse(
          'https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=YOUR_API_KEY&format=json&filters[city]=$selectedCity'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          airQualityData = data;
          isLoading = false;
        });
      } else {
        // For demo purposes, using mock data when API is unavailable
        setState(() {
          airQualityData = getMockData();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        airQualityData = getMockData();
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> getMockData() {
    // Mock data structure simulating API response
    return {
      "updated_at": DateTime.now().toString(),
      "records": [
        {
          "city": selectedCity,
          "station": "$selectedCity Central",
          "aqi": 158,
          "pm25": 75.8,
          "pm10": 142.3,
          "no2": 48.2,
          "so2": 12.8,
          "co": 1.2,
          "o3": 28.6,
          "last_updated":
              DateTime.now().subtract(const Duration(minutes: 30)).toString()
        },
        {
          "city": selectedCity,
          "station": "$selectedCity North",
          "aqi": 142,
          "pm25": 62.4,
          "pm10": 124.8,
          "no2": 36.5,
          "so2": 9.2,
          "co": 0.9,
          "o3": 32.1,
          "last_updated":
              DateTime.now().subtract(const Duration(minutes: 45)).toString()
        }
      ]
    };
  }

  String getAqiCategory(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Satisfactory';
    if (aqi <= 200) return 'Moderate';
    if (aqi <= 300) return 'Poor';
    if (aqi <= 400) return 'Very Poor';
    return 'Severe';
  }

  Color getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.lightGreen;
    if (aqi <= 200) return Colors.orangeAccent;
    if (aqi <= 300) return Colors.orange;
    if (aqi <= 400) return Colors.red;
    return Colors.purple;
  }

  String getHealthMessage(int aqi) {
    if (aqi <= 50)
      return 'Air quality is good, and air pollution poses little or no risk.';
    if (aqi <= 100)
      return 'Air quality is acceptable, though there may be moderate health concern for a very small number of people.';
    if (aqi <= 200)
      return 'Members of sensitive groups may experience health effects. General public is less likely to be affected.';
    if (aqi <= 300)
      return 'Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects.';
    if (aqi <= 400)
      return 'Health alert: everyone may experience more serious health effects.';
    return 'Health warning of emergency conditions. The entire population is more likely to be affected.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('India Air Quality Monitor',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.greenAccent)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade800,
              child: Column(
                children: [
                  const Text(
                    'Real-time Air Quality Index',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCity,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cities.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCity = newValue;
                            });
                            fetchAirQualityData();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                height: 400,
                alignment: Alignment.center,
                child: const SpinKitPulse(
                  color: Colors.blue,
                  size: 50.0,
                ),
              ),
            if (!isLoading && errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            if (!isLoading && errorMessage.isEmpty) _buildAirQualityContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityContent() {
    final records = airQualityData['records'] as List;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCity,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('MMM d, yyyy | HH:mm').format(
                            DateTime.parse(airQualityData['updated_at'])),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Air Quality Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...records
                      .map((record) => _buildStationCard(record))
                      .toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildHealthImpactCard(),
          const SizedBox(height: 20),
          _buildPollutantInfoCard(),
        ],
      ),
    );
  }

  Widget _buildStationCard(Map<String, dynamic> stationData) {
    final int aqi = stationData['aqi'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stationData['station'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: getAqiColor(aqi).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: getAqiColor(aqi),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        aqi.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: getAqiColor(aqi),
                        ),
                      ),
                      Text(
                        'AQI',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: getAqiColor(aqi),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getAqiCategory(aqi),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: getAqiColor(aqi),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last updated: ${DateFormat('HH:mm').format(DateTime.parse(stationData['last_updated']))}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPollutantIndicator(
                    'PM2.5', '${stationData['pm25']} μg/m³'),
                _buildPollutantIndicator(
                    'PM10', '${stationData['pm10']} μg/m³'),
                _buildPollutantIndicator('NO₂', '${stationData['no2']} μg/m³'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPollutantIndicator('SO₂', '${stationData['so2']} μg/m³'),
                _buildPollutantIndicator('CO', '${stationData['co']} mg/m³'),
                _buildPollutantIndicator('O₃', '${stationData['o3']} μg/m³'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutantIndicator(String name, String value) {
    return Column(
      children: [
        Text(name, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildHealthImpactCard() {
    final records = airQualityData['records'] as List;
    final int averageAqi =
        records.fold(0, (sum, item) => sum + item['aqi'] as int) ~/
            records.length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Impact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              getHealthMessage(averageAqi),
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Precautions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildPrecautionItem(averageAqi),
          ],
        ),
      ),
    );
  }

  Widget _buildPrecautionItem(int aqi) {
    List<Widget> precautions = [];

    if (aqi > 100) {
      precautions
          .add(_buildPrecaution(Icons.masks, 'Wear masks when going outside'));
    }
    if (aqi > 150) {
      precautions.add(_buildPrecaution(Icons.home, 'Avoid outdoor activities'));
    }
    if (aqi > 200) {
      precautions.add(_buildPrecaution(Icons.air, 'Use air purifiers indoors'));
    }
    if (aqi > 300) {
      precautions.add(_buildPrecaution(Icons.local_hospital,
          'Seek medical advice if experiencing respiratory issues'));
    }

    if (precautions.isEmpty) {
      precautions.add(_buildPrecaution(Icons.nature_people,
          'Air quality is good. Enjoy outdoor activities!'));
    }

    return Column(children: precautions);
  }

  Widget _buildPrecaution(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Air Pollutants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPollutantInfo('PM2.5',
                'Fine particulate matter with diameter less than 2.5 micrometers. These particles can penetrate deep into the lungs and even enter the bloodstream.'),
            _buildPollutantInfo('PM10',
                'Particulate matter with diameter less than 10 micrometers. These include dust, pollen, and mold that can cause respiratory issues.'),
            _buildPollutantInfo('NO₂',
                'Nitrogen Dioxide is a gaseous air pollutant produced by road traffic and other fossil fuel combustion processes.'),
            _buildPollutantInfo('SO₂',
                'Sulfur Dioxide is produced from the burning of fossil fuels (coal and oil) and the smelting of mineral ores.'),
            _buildPollutantInfo('CO',
                'Carbon Monoxide is a colorless, odorless gas formed by incomplete combustion of carbon-containing fuels.'),
            _buildPollutantInfo('O₃',
                'Ground-level Ozone is created by chemical reactions between oxides of nitrogen and volatile organic compounds in the presence of sunlight.'),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutantInfo(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          const Divider(),
        ],
      ),
    );
  }
}
