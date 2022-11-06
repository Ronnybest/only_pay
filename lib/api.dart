import 'dart:typed_data';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/datastore.dart';
import 'package:mime/mime.dart';

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _clinet;
  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    if (_clinet == null) {
      _clinet =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    }
    var storage = Storage(_clinet!, 'small-talk-pdhm');
    var bucket = storage.bucket('imagestoragemongo');
    final type = lookupMimeType(name);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(contentType: type, custom: {
          'timestamp': '$timestamp',
        }));
  }
}
