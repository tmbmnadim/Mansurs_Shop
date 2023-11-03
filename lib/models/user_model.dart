class UserModel {
  String? id;
  String? image;
  String? fullName;
  String? email;
  String? address;
  String? mobileNumber;
  String? landMark;
  String? province;
  String? city;
  String? area;
  String? homeOrOffice;

  UserModel({
    this.id,
    this.image,
    this.fullName,
    this.email,
    this.address,
    this.mobileNumber,
    this.landMark,
    this.province,
    this.city,
    this.area,
    this.homeOrOffice,
  });

  UserModel.fromJson({required Map<String, dynamic> json}) {
    image = json['image'];
    fullName = json['fullName'];
    email = json['email'];
    address = json['address'];
    mobileNumber = json['mobileNumber'];
    landMark = json['landMark'];
    province = json['province'];
    city = json['city'];
    area = json['area'];
    homeOrOffice = json['homeOrOffice'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'image': image,
    'fullName': fullName,
    'email': email,
    'address': address,
    'mobileNumber': mobileNumber,
    'landMark': landMark,
    'province': province,
    'city': city,
    'area': area,
    'homeOrOffice': homeOrOffice,
  };
}
