import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/network/http.dart';

class RaImage extends StatelessWidget {
  const RaImage({
    super.key,
    required this.imageUrl,
  });

  /// network link, `file://` or even `assets/`
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl.startsWith('assets/')
        ? Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          )
        : Image(
            image: RaNetworkImageProvider(url: imageUrl),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? FittedBox(
                        fit: BoxFit.fitWidth,
                        clipBehavior: Clip.hardEdge,
                        child: child,
                      )
                    : Container(
                        color: context.colors.backgroundDarkSecondary,
                        child: const RaProgressIndicator(),
                      ),
            errorBuilder: (context, child, loadingProgress) => Center(
              child: Image.asset('assets/defaultMedia.png'),
            ),
          );
  }
}

class RaNetworkImageProvider extends ImageProvider<RaNetworkImageProvider> {
  const RaNetworkImageProvider({
    required this.url,
  });

  final String url;

  @override
  Future<RaNetworkImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture<RaNetworkImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    RaNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1,
    );
  }

  Future<Codec> _loadAsync(
    RaNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    final response = await raHttpClient.get<List<int>>(
      key.url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    if (response.data == null) {
      throw Exception('Failed to load image: ${key.url}');
    }

    final bytes = Uint8List.fromList(response.data!);

    return decode(await ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) =>
      other is RaNetworkImageProvider && other.url == url;

  @override
  int get hashCode => url.hashCode;
}
