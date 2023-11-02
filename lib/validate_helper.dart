import 'package:email_validator/email_validator.dart';
class ValidatorHelper{
    

    static bool validateFields(String text,String validationType){
    bool valid = true;
    switch(validationType){
      case'TEXT_FIELD_NOT_EMPTY': valid = text.isNotEmpty;
      break;
      case'EMAIL': valid = EmailValidator.validate(text) ;
      break;

    }
    return valid;
    }
}