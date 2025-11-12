class ClsUserTokensDto {
  String? jwtToken;
  String? refreshToken;

  ClsUserTokensDto({this.jwtToken, this.refreshToken});

  factory ClsUserTokensDto.fromJson(Map<String, dynamic> json) {
    return ClsUserTokensDto(
      jwtToken: json['JWTToken'],
      refreshToken: json['RefreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'JWTToken': jwtToken, 'RefreshToken': refreshToken};
  }
}
