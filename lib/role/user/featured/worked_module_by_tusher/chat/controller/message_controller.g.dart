// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserMessageController)
final userMessageControllerProvider = UserMessageControllerProvider._();

final class UserMessageControllerProvider
    extends $NotifierProvider<UserMessageController, UserMessageState> {
  UserMessageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userMessageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userMessageControllerHash();

  @$internal
  @override
  UserMessageController create() => UserMessageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserMessageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserMessageState>(value),
    );
  }
}

String _$userMessageControllerHash() =>
    r'89761ad0ffebcdc67057bbfd53621f4f91c2819d';

abstract class _$UserMessageController extends $Notifier<UserMessageState> {
  UserMessageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserMessageState, UserMessageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserMessageState, UserMessageState>,
              UserMessageState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
