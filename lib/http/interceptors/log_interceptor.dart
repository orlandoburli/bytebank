import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request from log interceptor ................................');
    print('url ${data.url}');
    print('header ${data.headers}');
    print('body ${data.body}');
    print('method ${data.method}');
    print('............................................................');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response from log interceptor ..............................');
    print('statusCode: ${data.statusCode}');
    print('header ${data.headers}');
    print('body ${data.body}');
    print('............................................................');
    return data;
  }
}
