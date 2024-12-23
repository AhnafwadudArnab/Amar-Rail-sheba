class User {
  int user_id ;
  String user_name;
  String user_email;
  String user_phone_number;
  String user_password;
  

  User(
   this.user_id ,
   this.user_name,
   this.user_email,
   this.user_phone_number,
   this.user_password 
   );

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toJson() => {
 
      'user_id': user_id .toString(),
      'username': user_name,
      'email ': user_email,
      'user_phone_number': user_phone_number,
      'Upassword': user_password,
  };

    // Implement toString to make it easier to see information about
    // each user when using the print statement.
    
  }
