import 'package:teach/main.dart';

class DataFromSupaForSignIn {

  getMAinManager() async {
  return  await supabase
                                .from('main_manager')
                                .select()
                                .eq("id", 1)
                                .maybeSingle();
  }

  getUSerByUniversityNumber(universityNumber, user)async{
    return await supabase
                                  .from('current_user')
                                  .select()
                                  .eq('id', user.user!.id)
                                  .eq(
                                      "university_number",
                                      universityNumber)
                                  .maybeSingle();
  }


}