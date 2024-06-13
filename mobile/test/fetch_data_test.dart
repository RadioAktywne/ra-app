import 'package:flutter_test/flutter_test.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

void main() async {
  final url = Uri.parse(
    'https://sandbox.api.service.nhs.uk/hello-world/hello/world',
  );
  const headers = {
    'Content-Type': 'application/json',
  };
  test(
    'Test 1: fetch data from sample `hello world` API',
    () async {
      expect(
        await fetchData(
          url,
          (e) => e['message'] as String,
          headers: headers,
        ),
        ['Hello World!'],
      );
    },
  );
}
