import 'package:flutter_test/flutter_test.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/ra_links.dart';

void main() {
  test("Correct path to RA API's posts", () {
    expect(
      Uri.https(RaApi.baseUrl, RaApi.endpoints.posts),
      Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/posts'),
    );
  });

  test("Correct path to RA's radio player", () {
    expect(
      Uri.https(RaRadio.baseUrl, RaRadio.radioStream),
      Uri.parse('https://listen.radioaktywne.pl/raogg'),
    );
  });

  test("Correct path to RA API's album; hard query params", () {
    expect(
      Uri.https(
        RaApi.baseUrl,
        RaApi.endpoints.album,
        {
          '_embed': true,
          'page': 5,
          'per_page': 15,
        }.valuesToString(),
      ),
      Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/album?_embed=true&page=5&per_page=15',
      ),
    );
  });
}
