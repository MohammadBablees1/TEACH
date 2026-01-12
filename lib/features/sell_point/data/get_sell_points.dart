import 'package:teach/core/supabase_client.dart';

class GetSellPoints {


    Future<List> getSellPoints() async {
    var data = await supabase.from("sell_point").select("*");

    return data;
  }
}