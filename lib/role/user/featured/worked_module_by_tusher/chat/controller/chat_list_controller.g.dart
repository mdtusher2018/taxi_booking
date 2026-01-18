// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserChatListController)
final userChatListControllerProvider = UserChatListControllerProvider._();

final class UserChatListControllerProvider
    extends $NotifierProvider<UserChatListController, UserChatListState> {
  UserChatListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userChatListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userChatListControllerHash();

  @$internal
  @override
  UserChatListController create() => UserChatListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserChatListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserChatListState>(value),
    );
  }
}

String _$userChatListControllerHash() =>
    r'5284ae736ba5c53bea87b3be50ca012cf66a3cb8';

abstract class _$UserChatListController extends $Notifier<UserChatListState> {
  UserChatListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserChatListState, UserChatListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserChatListState, UserChatListState>,
              UserChatListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
