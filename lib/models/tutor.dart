class Tutor {
  String? tutorId;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorPassword;
  String? tutorDesc;
  String? tutorDateReg;
  String? subjectName;
  
  Tutor({
    this.tutorId,
    this.tutorEmail, 
    this.tutorPhone, 
    this.tutorName, 
    this.tutorPassword, 
    this.tutorDesc, 
    this.tutorDateReg,
    this.subjectName});

  Tutor.fromJson(Map<String, dynamic> json) {
    tutorId = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
    tutorName = json['tutor_name'];
    tutorPassword = json['tutor_password'];
    tutorDesc = json['tutor_description'];
    tutorDateReg = json['tutor_datereg'];
    subjectName = json['subjectName'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutorId;
    data['tutor_email'] = tutorEmail;
    data['tutor_phone'] = tutorPhone;
    data['tutor_name'] = tutorName;
    data['tutor_password'] = tutorPassword;
    data['tutor_description'] = tutorDesc;
    data['tutor_datereg'] = tutorDateReg;
    data['subjectName'] = subjectName;
    return data;
  }
}