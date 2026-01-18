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
        isAutoDispose: false,
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
    r'759cc6fa47a6a11e641f9d930754b8a44cf841b4';

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
        isAutoDispose: false,
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

String _$snackbarServiceHash() => r'22fb233b5763192c88397ca544986c1845bfbc58';

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
        isAutoDispose: false,
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

String _$apiClientHash() => r'76050a8544e84573f94115cab99975bcf1a46263';

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
        isAutoDispose: false,
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

String _$apiServiceHash() => r'a2142cac08279e644b063241c13b2026b0bc491b';

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
        isAutoDispose: false,
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

String _$socketServiceHash() => r'eaa65598a36cd5e22bc520a4bb958a55c99f36db';
