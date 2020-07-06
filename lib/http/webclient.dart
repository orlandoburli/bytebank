import 'package:bytebank/http/interceptors/log_interceptor.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

final client = HttpClientWithInterceptor.build(
    interceptors: [], requestTimeout: Duration(seconds: 5));

const url = 'http://192.168.18.25:8080/transactions';
