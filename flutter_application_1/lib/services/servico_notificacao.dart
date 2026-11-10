import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serviço responsável por gerenciar e disparar notificações locais nativas do Android com som e alta prioridade
class ServicoNotificacao {
  static final FlutterLocalNotificationsPlugin _pluginNotificacoes =
      FlutterLocalNotificationsPlugin();

  static bool _inicializado = false;

  // Identificador do canal de notificação com som e banner flutuante (Heads-up)
  static const String _idCanal = 'canal_alertas_prioridade_maxima';
  static const String _nomeCanal = 'Alertas de Distância';
  static const String _descricaoCanal =
      'Notificações de alta prioridade com som quando o parceiro se afasta';

  /// Inicializa as configurações de notificação do sistema
  static Future<void> inicializar() async {
    if (_inicializado) return;

    // Configuração para Android utilizando o ícone padrão do aplicativo
    const AndroidInitializationSettings configuracoesAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings configuracoesGerais = InitializationSettings(
      android: configuracoesAndroid,
    );

    await _pluginNotificacoes.initialize(settings: configuracoesGerais);

    final implementacaoAndroid = _pluginNotificacoes
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (implementacaoAndroid != null) {
      // Cria explicitamente o canal no Android com som, vibração e importância máxima (Heads-up)
      final canal = AndroidNotificationChannel(
        _idCanal,
        _nomeCanal,
        description: _descricaoCanal,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
      );
      await implementacaoAndroid.createNotificationChannel(canal);

      // Solicita permissão para Android 13 ou superior (POST_NOTIFICATIONS)
      await implementacaoAndroid.requestNotificationsPermission();
    }

    _inicializado = true;
  }

  /// Dispara a notificação local nativa com som, vibração e banner flutuante no celular
  static Future<void> exibirNotificacao({
    String titulo = 'EncontreMeuParceiro',
    String corpo = 'Seu parceiro está a mais de 100 metros de você.',
  }) async {
    if (!_inicializado) {
      await inicializar();
    }

    // Configura os detalhes para a notificação saltar na tela (Heads-up) com som e estilo expandido
    final AndroidNotificationDetails detalhesAndroid =
        AndroidNotificationDetails(
      _idCanal,
      _nomeCanal,
      channelDescription: _descricaoCanal,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Alerta de Distância',
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFFE77982), // Cor temática do aplicativo
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
      styleInformation: BigTextStyleInformation(
        corpo,
        contentTitle: '🚨 $titulo',
        summaryText: 'Alerta de Proximidade',
      ),
    );

    final NotificationDetails detalhesGerais = NotificationDetails(
      android: detalhesAndroid,
    );

    await _pluginNotificacoes.show(
      id: 1,
      title: '🚨 $titulo',
      body: corpo,
      notificationDetails: detalhesGerais,
    );
  }
}
