import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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
  
  String baseUrl = 'http://localhost:8080';
  //String baseUrl = '';
  String? authToken;

  Future<int> updateFutureAppointmentDate(
      int appointmentID, DateTime date) async {
    final response = await http.put(
      Uri.parse('$baseUrl/appointment/update/$appointmentID'),
      headers: await _getHeaders(),
      body: jsonEncode({
        "appointmentDate": DateFormat('yyyy-MM-dd').format(date),
      }),
    );

    return response.statusCode;
  }


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

  Future<bool> deleteAllhistory(int patientID) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/history-appointment/delete/$patientID'),
      headers: await _getHeaders(),
    );

    return response.statusCode == 200;
  }

 
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
  }


  Future<List<dynamic>> getAllPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/getAll'),
        headers: await _getHeaders());

    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  
  Future<List<dynamic>> getPatientsWithAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/getByDate'),
        headers: await _getHeaders());
    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  
  Future<List<dynamic>> searchByName(String name) async {
    final api = "$baseUrl/patients/searchName?param=$name";
    final String token = await getToken();
    final response = await http.get(Uri.parse(api), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // Search patient by phone
  Future<Map<String, dynamic>> searchByPhone(String phone) async {
    final response = await http
        .get(Uri.parse('$baseUrl/patients/searchPhone?param=$phone'), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await getToken()}",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {}; 
      }
    }

    return {}; 
  }

 
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
      Uri.parse('$baseUrl/history-appointment/insert'),
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

    return response.statusCode;
  }

  Future<Map<String, dynamic>> getPatientByID(int id) async {
    final api = '$baseUrl/patients/getById/$id';
    final uri = Uri.parse(api);
    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await getToken()}",
    });

    return jsonDecode(response.body);
  }

  Future<bool> deleteFutureAppointment(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/appointment/delete/$id'),
      headers: await _getHeaders(),
    );

    return response.statusCode == 200;
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
    try {
      await deleteAllhistory(patientId);

      await deleteFutureAppointment(patientId);
    } catch (e) {
      log('Error deleting patient: $e');
      return false;
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/patients/delete/$patientId'),
      headers: await _getHeaders(),
    );

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
            'id']; 
      }
    }
    return null; 
  }

  Future<bool> isTokenValied() async {
    final token = await getToken();
    if (token == '') return false;
    return !JwtDecoder.isExpired(token);
  }
}
