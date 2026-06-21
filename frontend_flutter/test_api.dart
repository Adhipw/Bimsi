import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8080/api',
  ));

  try {
    print('Testing Login API...');
    final response = await dio.post('/login', data: {
      'email': 'mahasiswa@bimsi.ac.id',
      'password': 'password123'
    });
    
    print('Login Response: \${response.statusCode}');
    print(response.data);

    if (response.data['status'] == 'success') {
      print('✅ API Integration is successful!');
    }
  } on DioException catch (e) {
    print('❌ Failed to connect to API');
    if (e.response != null) {
      print('Status: ' + e.response!.statusCode.toString());
      print('Data: ' + e.response!.data.toString());
    } else {
      print('Error: ' + e.message.toString());
    }
  }
}
