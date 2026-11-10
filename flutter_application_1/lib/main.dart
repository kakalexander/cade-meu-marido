import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/tela_navegacao.dart';
import 'services/servico_notificacao.dart';

void main() async {
  // Garante a inicialização das integrações com o sistema operacional
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o serviço de notificações locais
  await ServicoNotificacao.inicializar();

  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EncontreMeuParceiro',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF8F95),
          primary: const Color(0xFFE77982),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const TelaNavegacao(),
    );
  }
}
