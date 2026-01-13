// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localStorageService)
final localStorageServiceProvider = LocalStorageServiceProvider._();

final class LocalStorageServiceProvider
    extends
        $FunctionalProvider<
          ILocalStorageService,
          ILocalStorageService,
          ILocalStorageService
        >
    with $Provider<ILocalStorageService> {
  LocalStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageServiceHash();

  @$internal
  @override
  $ProviderElement<ILocalStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ILocalStorageService create(Ref ref) {
    return localStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILocalStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILocalStorageService>(value),
    );
  }
}

String _$localStorageServiceHash() =>
    r'a19e2c779d80f4b6b66be001d27428285ecaa138';

@ProviderFor(snackbarService)
final snackbarServiceProvider = SnackbarServiceProvider._();

final class SnackbarServiceProvider
    extends
        $FunctionalProvider<
          ISnackBarService,
          ISnackBarService,
          ISnackBarService
        >
    with $Provider<ISnackBarService> {
  SnackbarServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snackbarServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snackbarServiceHash();

  @$internal
  @override
  $ProviderElement<ISnackBarService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISnackBarService create(Ref ref) {
    return snackbarService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISnackBarService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISnackBarService>(value),
    );
  }
}

String _$snackbarServiceHash() => r'80ca5fd1f22f389c9251ea824c9b56172a720b20';

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'6515154c8efe718a3ee27a24cc7480b81f52efbe';

@ProviderFor(apiService)
final apiServiceProvider = ApiServiceProvider._();

final class ApiServiceProvider
    extends $FunctionalProvider<IApiService, IApiService, IApiService>
    with $Provider<IApiService> {
  ApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiServiceHash();

  @$internal
  @override
  $ProviderElement<IApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IApiService create(Ref ref) {
    return apiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IApiService>(value),
    );
  }
}

String _$apiServiceHash() => r'615727dabd9ecd6498ae7c81508e217a45787b33';

@ProviderFor(socketService)
final socketServiceProvider = SocketServiceProvider._();

final class SocketServiceProvider
    extends $FunctionalProvider<SocketService, SocketService, SocketService>
    with $Provider<SocketService> {
  SocketServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketServiceHash();

  @$internal
  @override
  $ProviderElement<SocketService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocketService create(Ref ref) {
    return socketService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketService>(value),
    );
  }
}

String _$socketServiceHash() => r'62bb102c4a074ca003f87f21aa52f7058793b5e7';
