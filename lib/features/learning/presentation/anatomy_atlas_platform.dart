export 'anatomy_atlas_platform_stub.dart'
    if (dart.library.io) 'anatomy_atlas_platform_native.dart'
    if (dart.library.js_interop) 'anatomy_atlas_platform_web.dart';
