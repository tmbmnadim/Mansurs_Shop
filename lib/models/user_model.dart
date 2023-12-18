class UserModel {
  String? id;
  String? image;
  String? userStat;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? address;
  String? landMark;
  String? province;
  String? city;
  String? area;
  String? homeOrOffice;
  List? favouritesList;

  UserModel({
    this.id,
    this.image,
    this.userStat,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.address,
    this.landMark,
    this.province,
    this.city,
    this.area,
    this.homeOrOffice,
    this.favouritesList,
  });

  UserModel.fromJson({required Map<String, dynamic> json}) {
    image = json['image'];
    userStat = json['userStat'];
    fullName = json['fullName'];
    email = json['email'];
    address = json['address'];
    mobileNumber = json['mobileNumber'];
    landMark = json['landMark'];
    province = json['province'];
    city = json['city'];
    area = json['area'];
    homeOrOffice = json['homeOrOffice'];
    favouritesList = json['favouritesList'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'image': image,
        'userStat': userStat,
        'fullName': fullName,
        'email': email,
        'address': address,
        'mobileNumber': mobileNumber,
        'landMark': landMark,
        'province': province,
        'city': city,
        'area': area,
        'homeOrOffice': homeOrOffice,
        'favouritesList': favouritesList,
      };
}
