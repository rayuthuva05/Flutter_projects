class ApiResponse<T> {
  T? data;
  bool error;
  String? errormessage;

  ApiResponse({
    this.data,
    this.error = false,
    this.errormessage,
  });
}
