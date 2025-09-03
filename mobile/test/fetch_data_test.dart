import 'package:flutter_test/flutter_test.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

void main() {
  final url =
      Uri.parse('https://sandbox.api.service.nhs.uk/hello-world/hello/world');
  const headers = {
    'Content-Type': 'application/json',
  };
  test(
    'Fetch data from `hello world` API and bundle'
    'it into single element list of String objects',
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
  test(
    'Fetch data from `hello world` API and bundle it into String object',
    () async {
      expect(
        await fetchSingle(
          url,
          (e) => e['message'] as String,
          headers: headers,
        ),
        'Hello World!',
      );
    },
  );
}
