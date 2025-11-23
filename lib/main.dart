import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WeatherDashboard(),
    );
  }
}

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({Key? key}) : super(key: key);

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  final TextEditingController _indexController = TextEditingController();

  double? latitude;
  double? longitude;
  String? requestUrl;

  bool isLoading = false;
  bool isCached = false;
  String? errorMessage;

  double? temperature;
  double? windSpeed;
  int? weatherCode;
  String? lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  void _calculateCoordinates() {
    final index = _indexController.text.trim();
    if (index.length < 4) {
      setState(() {
        errorMessage = 'Index must be at least 4 digits';
      });
      return;
    }

    final firstTwo = int.parse(index.substring(0, 2));
    final nextTwo = int.parse(index.substring(2, 4));

    setState(() {
      latitude = 5 + (firstTwo / 10.0);
      longitude = 79 + (nextTwo / 10.0);
      requestUrl = 'https://api.open-meteo.com/v1/forecast?'
          'latitude=${latitude!.toStringAsFixed(2)}&'
          'longitude=${longitude!.toStringAsFixed(2)}&'
          'current_weather=true';
      errorMessage = null;
    });
  }

  Future<void> _fetchWeather() async {
    if (latitude == null || longitude == null) {
      _calculateCoordinates();
      if (latitude == null || longitude == null) return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      isCached = false;
    });

    try {
      final response = await http.get(Uri.parse(requestUrl!)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final currentWeather = data['current_weather'];

        setState(() {
          temperature = currentWeather['temperature'].toDouble();
          windSpeed = currentWeather['windspeed'].toDouble();
          weatherCode = currentWeather['weathercode'];
          lastUpdate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
          isLoading = false;
          isCached = false;
        });

        await _cacheData();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      await _loadCachedData(); // Load cached data if available

      setState(() {
        isLoading = false;
        if (temperature != null) {
          errorMessage = 'You appear to be offline. Showing cached data.';
          isCached = true;
        } else {
          errorMessage = 'You are offline and no cached data is available.';
        }
      });
    }
  }

  Future<void> _cacheData() async {
    final prefs = await SharedPreferences.getInstance();
    if (temperature != null) await prefs.setDouble('temperature', temperature!);
    if (windSpeed != null) await prefs.setDouble('windSpeed', windSpeed!);
    if (weatherCode != null) await prefs.setInt('weatherCode', weatherCode!);
    if (lastUpdate != null) await prefs.setString('lastUpdate', lastUpdate!);
    if (requestUrl != null) await prefs.setString('requestUrl', requestUrl!);
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedTemp = prefs.getDouble('temperature');

    if (cachedTemp != null) {
      setState(() {
        temperature = cachedTemp;
        windSpeed = prefs.getDouble('windSpeed');
        weatherCode = prefs.getInt('weatherCode');
        lastUpdate = prefs.getString('lastUpdate');
        requestUrl = prefs.getString('requestUrl');
        isCached = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Index Input Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Index',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _indexController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Index',
                        hintText: 'e.g., 123456A',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateCoordinates(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Coordinates Card
            if (latitude != null && longitude != null)
              Card(
                elevation: 4,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Computed Coordinates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Latitude', style: TextStyle(color: Colors.grey)),
                                Text(
                                  '${latitude!.toStringAsFixed(2)}°',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Longitude', style: TextStyle(color: Colors.grey)),
                                Text(
                                  '${longitude!.toStringAsFixed(2)}°',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Fetch Button
            ElevatedButton.icon(
              onPressed: isLoading ? null : _fetchWeather,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(isLoading ? 'Fetching...' : 'Fetch Weather'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Error Message
            if (errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Weather Data Card
            if (temperature != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Weather Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isCached)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '(cached)',
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildWeatherRow(
                        'Temperature',
                        '${temperature!.toStringAsFixed(1)}°C',
                        Icons.thermostat,
                        Colors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherRow(
                        'Wind Speed',
                        '${windSpeed!.toStringAsFixed(1)} km/h',
                        Icons.air,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherRow(
                        'Weather Code',
                        weatherCode.toString(),
                        Icons.wb_sunny,
                        Colors.amber,
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherRow(
                        'Last Updated',
                        lastUpdate ?? 'N/A',
                        Icons.access_time,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),

            // Request URL Card
            if (requestUrl != null)
              Card(
                elevation: 2,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Request URL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        requestUrl!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }
}