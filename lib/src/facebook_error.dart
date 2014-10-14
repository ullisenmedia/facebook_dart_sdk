part of facebook;

class FacebookError {

  int code;
  int subCode;

  String message;

  FacebookError(Map error) {

    this.code = error['code'];
    this.subCode = error['error_subcode'];
    this.message = error['message'];
  }

  String toString() => "FacebookError: $message";

}
