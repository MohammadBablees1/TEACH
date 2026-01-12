import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/core/init_after_start.dart';
import 'package:teach/core/supabase_client.dart';
import 'package:teach/core/supabase_gate.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/features/welcom_screen/presentation/page_veiw.dart';
import 'package:teach/screens/waiting_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Session? _session;
  bool _initDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initDone) {
      _initDone = true;

      /// 🔥 هنا المكان الصحيح
      AppInitializer.initAfterLaunch().then((_) async {
        await SupabaseGate.ensureReady(); // 🔥 مهم جدًا
       
        if(mounted){
          context.read<TeachCubit>().checkConnection();
        }
       
       if(mounted){
         context.read<ThemModeCubit>().loadInfo();
       }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _session = supabase.auth.currentSession;

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _session = data.session;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_session == null) {
      return const PageVeiwScreen();
    }

    return const WaitingScreen();
  }
}
