import 'package:prototype2021/settings/constants.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';
import 'dart:io';

class S3Uploader {
  /// This method upload image to S3 Server, and get the url of the image
  /// Call this method carefully! it consumes S3 Server resources.
  static Future<String> uploadToS3AndGetUrl(File file) async {
    SimpleS3 simpleS3 = SimpleS3();
    String result = await simpleS3.uploadFile(
      file,
      S3_BUCKET_NAME,
      S3_POOL_ID,
      AWSRegions.apNorthEast2,
    );

    return result;
  }

  /// Get File Instance from Assets
  static Future<File> _getFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
