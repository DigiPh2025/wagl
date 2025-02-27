class ResponseWrapper {
  dynamic data;
  String? errorMessage;
  int statusCode;
  ResponseWrapper.success({required this.data, required this.statusCode});
  ResponseWrapper.error({required this.errorMessage, required this.statusCode});
}
