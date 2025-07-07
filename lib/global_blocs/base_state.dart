abstract class BaseState {
  final bool isLoading;
  final Object? error;
  final bool isSuccess;

  BaseState({this.isLoading = false, this.error, this.isSuccess = false});
}
