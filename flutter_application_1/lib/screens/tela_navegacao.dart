import 'dart:io';
import 'package:flutter/material.dart';
import 'tela_inicio.dart';
import 'tela_distancia.dart';
import 'tela_alertas.dart';
import 'tela_sensores.dart';
import '../services/servico_notificacao.dart';

/// Tela Principal com Navegação Inferior e Topbar idêntica ao protótipo HTML
class TelaNavegacao extends StatefulWidget {
  const TelaNavegacao({super.key});

  @override
  State<TelaNavegacao> createState() => _TelaNavegacaoState();
}

class _TelaNavegacaoState extends State<TelaNavegacao> {
  int _indiceAbaAtual = 0;

  // Estado compartilhado do protótipo
  File? _fotoParceiro;
  double? _minhaLatitude = -16.32650;
  double? _minhaLongitude = -48.95340;
  double _latitudeParceiro = -16.32618;
  double _longitudeParceiro = -48.95340;
  double _distanciaAtual = 35.0; // Perto por padrão (35m)
  bool _alertaAtivo = false;

  // Cores do protótipo
  static const Color corPrimariaForte = Color(0xFFE77982);
  static const Color corPrimariaSuave = Color(0xFFFDE7E9);
  static const Color corTexto = Color(0xFF442E31);
  static const Color corMuda = Color(0xFF8E7175);
  static const Color corLinha = Color(0xFFF1D6D9);

  /// Dispara a notificação local nativa no sistema do celular (com som e banner)
  void _dispararAlerta() {
    setState(() {
      _alertaAtivo = true;
    });

    // Emite a notificação nativa do sistema com som, vibração e banner superior
    ServicoNotificacao.exibirNotificacao(
      titulo: 'EncontreMeuParceiro',
      corpo: 'Seu parceiro está a mais de 100 metros de você.',
    );
  }

  /// Limpa o estado de alerta
  void _limparAlerta() {
    setState(() {
      _alertaAtivo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Telas correspondentes às 4 abas
    final List<Widget> telas = [
      TelaInicio(
        fotoParceiro: _fotoParceiro,
        onFotoAlterada: (novaFoto) => setState(() => _fotoParceiro = novaFoto),
        minhaLatitude: _minhaLatitude,
        minhaLongitude: _minhaLongitude,
        onLocalizacaoAlterada: (lat, lon) {
          setState(() {
            _minhaLatitude = lat;
            _minhaLongitude = lon;
          });
        },
      ),
      TelaDistancia(
        distanciaAtual: _distanciaAtual,
        minhaLatitude: _minhaLatitude,
        minhaLongitude: _minhaLongitude,
        latitudeParceiro: _latitudeParceiro,
        longitudeParceiro: _longitudeParceiro,
        onDistanciaAlterada: (novaDist, latP, lonP) {
          setState(() {
            _distanciaAtual = novaDist;
            _latitudeParceiro = latP;
            _longitudeParceiro = lonP;
            _alertaAtivo = novaDist > 100;
          });
        },
        onDispararAlerta: _dispararAlerta,
      ),
      TelaAlertas(
        alertaAtivo: _alertaAtivo,
        onDispararAlerta: _dispararAlerta,
        onLimparAlerta: _limparAlerta,
      ),
      const TelaSensores(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFFFF8F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: corPrimariaSuave,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          '⌖',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: corPrimariaForte,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'EncontreMeuParceiro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: corTexto,
                          ),
                        ),
                        Text(
                          'Seu parceiro por perto',
                          style: TextStyle(
                            fontSize: 11,
                            color: corMuda,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: corLinha),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'MVP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: corPrimariaForte,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: telas[_indiceAbaAtual],

      // Menu inferior flutuante idêntico ao protótipo HTML
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: corLinha),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD79298).withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _construirItemNavegacao(0, Icons.home_rounded, 'Início'),
            _construirItemNavegacao(1, Icons.location_on_rounded, 'Distância'),
            _construirItemNavegacao(
              2,
              Icons.notifications_rounded,
              'Alertas',
              temAlerta: _alertaAtivo,
            ),
            _construirItemNavegacao(3, Icons.straighten_rounded, 'Sensores'),
          ],
        ),
      ),
    );
  }

  Widget _construirItemNavegacao(
    int indice,
    IconData icone,
    String rotulo, {
    bool temAlerta = false,
  }) {
    final bool selecionado = _indiceAbaAtual == indice;

    return InkWell(
      onTap: () => setState(() => _indiceAbaAtual = indice),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? corPrimariaSuave : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icone,
                  size: 20,
                  color: selecionado ? corPrimariaForte : corMuda,
                ),
                const SizedBox(height: 3),
                Text(
                  rotulo,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selecionado ? corPrimariaForte : corMuda,
                  ),
                ),
              ],
            ),
            if (temAlerta)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: corPrimariaForte,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
