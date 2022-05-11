/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-10 21:41:10
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-10 22:30:36
 */
class Friend {
  int? fid;
  String? userName;
  String? userEmail;
  String? avatarPath;
  int? friendship;
  String? password;
  bool? isSelf;

  Friend(
      {this.fid,
      this.userName,
      this.userEmail,
      this.avatarPath,
      this.friendship,
      this.isSelf,
      this.password});

  Friend.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    avatarPath = json['avatarPath'];
    friendship = json['friendship'];
    isSelf = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fid'] = fid;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['avatarPath'] = avatarPath;
    data['friendship'] = friendship;
    data['isSelf'] = false;
    return data;
  }
}
