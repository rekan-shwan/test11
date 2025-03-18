import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<String> getToken() async {
  final preff = await SharedPreferences.getInstance();
  final token = preff.getString('token');
  return token ?? '';
}

Future<void> removeToken() async {
  final preff = await SharedPreferences.getInstance();
  preff.remove('token');
}

Future<void> setToken(String token) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString('token', token);
}

class Api {
  String baseUrl = 'http://165.232.71.180:8080';
  //String baseUrl = 'http://localhost:8080';
  String? authToken; // Stores JWT token

  // Authenticate user and store JWT token
  Future<bool> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'userName': username, 'userPassword': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = response.body;

      setToken(data.toString());

      return true;
    }

    return false;
  }

  // Helper method to get headers with authentication
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
  }

  // Get list of all patients
  Future<List<dynamic>> getAllPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/getAll'),
        headers: await _getHeaders());
    print(await getToken());
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // Get list of patients with appointments
  Future<List<dynamic>> getPatientsWithAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/getByDate'),
        headers: await _getHeaders());
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // Search patient by name
  Future<List<dynamic>> searchByName(String name) async {
    final api = "$baseUrl/patients/searchName?param=$name";
    final String token = await getToken();
    final response = await http.get(Uri.parse(api), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
    });
    print(response.body);
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // Search patient by phone
  Future<Map<String, dynamic>> searchByPhone(String phone) async {
    final response = await http.get(
        Uri.parse('$baseUrl/patients/searchPhone?param=$phone'),
        headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data; // Correct type
      } else {
        return {}; // Return empty map instead of a list
      }
    }

    return {}; // Return empty map for non-200 responses
  }

  // Save a new patient
  Future<Map<String, dynamic>> savePatient({
    String? name,
    String? secondname,
    String? age,
    String? phone,
    String? note,
    String? gender,
    String? diseas,
    String? location,
    String? skintype,
    String? allergies,
  }) async {
    final api = '$baseUrl/patients/insert';
    final uri = Uri.parse(api);
    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode({
          "page": "$age",
          "psecondName": "$secondname",
          "pphone": "$phone",
          "pnote": "$note",
          "pname": "$name",
          "pgender": "$gender",
          "pdisease": "$diseas",
          "plocation": "$location",
          "allergies": '$allergies',
          "skinType": '$skintype',
        }));

    final result = response.statusCode;
    print(response.body);
    return jsonDecode(response.body);
  }

  // Save an appointment
  Future<bool> saveAppointment(Map<String, dynamic> appointmentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: await _getHeaders(),
      body: jsonEncode(appointmentData),
    );
    return response.statusCode == 201;
  }

  // Save history appointment
  Future<bool> saveHistoryAppointment(Map<String, dynamic> historyData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments/history'),
      headers: await _getHeaders(),
      body: jsonEncode(historyData),
    );
    return response.statusCode == 201;
  }

  Future<int> addPatienttoHistiry(int id,
      {String appointmentDetail = '',
      String drug = '',
      String tratment = '',
      bool isVisisted = true,
      required DateTime date}) async {
    final api = '$baseUrl/history-appointment/insert';
    final uri = Uri.parse(api);
    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode({
          "patientID": id,
          "appointmentHistoryDate": DateFormat('yyyy-MM-dd').format(date),
          "drug": drug,
          "appointmentDetail": appointmentDetail,
          "isVisited": isVisisted,
          "tratment": tratment,
        }));

    print('addPatienttoHistiry response: ${response.body}');
    return response.statusCode;
  }

  Future<int> addPatientAppointment(int id, DateTime date) async {
    final api = '$baseUrl/appointment/insert';
    final uri = Uri.parse(api);
    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode({
          "patientID": id,
          "appointmentDate": DateFormat('yyyy-MM-dd').format(date),
        }));

    print('addPatientAppointment response: ${response.statusCode}');
    return response.statusCode;
  }

  // Update patient details
  Future<bool> updatePatient(
      int patientId, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/patients/update/$patientId'),
      headers: await _getHeaders(),
      body: jsonEncode(updatedData),
    );
    return response.statusCode == 200;
  }

  // Delete a patient
  Future<bool> deletePatient(int patientId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/patients/delete/$patientId'),
      headers: await _getHeaders(),
    );

    print('delete patient response: ${response.statusCode}');
    return response.statusCode == 200;
  }

  Future<int?> getPatientIdByPhone(String phone) async {
    final response = await http.get(
      Uri.parse('$baseUrl/patients/search/phone/$phone'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> patients = jsonDecode(response.body);
      if (patients.isNotEmpty) {
        return patients[0][
            'id']; // Assuming the response contains a list of patients and the ID is in the 'id' field
      }
    }
    return null; // Return null if no patient is found or an error occurs
  }
}
