import 'package:flutter/material.dart';
import '../services/servico_notificacao.dart';

/// Tela de Monitoramento de Distância e Simulação Perto/Longe
class TelaDistancia extends StatefulWidget {
  final double distanciaAtual;
  final double? minhaLatitude;
  final double? minhaLongitude;
  final double latitudeParceiro;
  final double longitudeParceiro;
  final void Function(double novaDistancia, double latParceiro, double lonParceiro)
      onDistanciaAlterada;
  final VoidCallback onDispararAlerta;

  const TelaDistancia({
    super.key,
    required this.distanciaAtual,
    required this.minhaLatitude,
    required this.minhaLongitude,
    required this.latitudeParceiro,
    required this.longitudeParceiro,
    required this.onDistanciaAlterada,
    required this.onDispararAlerta,
  });

  @override
  State<TelaDistancia> createState() => _TelaDistanciaState();
}

class _TelaDistanciaState extends State<TelaDistancia> {
  late TextEditingController _controladorLat;
  late TextEditingController _controladorLon;

  // Cores do protótipo
  static const Color corPrimaria = Color(0xFFEF8F95);
  static const Color corPrimariaForte = Color(0xFFE77982);
  static const Color corPrimariaSuave = Color(0xFFFDE7E9);
  static const Color corTexto = Color(0xFF442E31);
  static const Color corMuda = Color(0xFF8E7175);
  static const Color corLinha = Color(0xFFF1D6D9);
  static const Color corSucesso = Color(0xFFEAF8EF);
  static const Color corSucessoTexto = Color(0xFF3B7650);
  static const Color corPerigo = Color(0xFFFFF0F1);
  static const Color corPerigoTexto = Color(0xFFBB4F5D);

  @override
  void initState() {
    super.initState();
    _controladorLat =
        TextEditingController(text: widget.latitudeParceiro.toStringAsFixed(5));
    _controladorLon =
        TextEditingController(text: widget.longitudeParceiro.toStringAsFixed(5));
  }

  @override
  void didUpdateWidget(covariant TelaDistancia oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitudeParceiro != widget.latitudeParceiro ||
        oldWidget.longitudeParceiro != widget.longitudeParceiro) {
      _controladorLat.text = widget.latitudeParceiro.toStringAsFixed(5);
      _controladorLon.text = widget.longitudeParceiro.toStringAsFixed(5);
    }
  }

  @override
  void dispose() {
    _controladorLat.dispose();
    _controladorLon.dispose();
    super.dispose();
  }

  /// Simula aproximação ou afastamento do parceiro (em metros)
  void _moverParceiro(double metros) {
    final double minhaLat = widget.minhaLatitude ?? -16.32650;
    final double minhaLon = widget.minhaLongitude ?? -48.95340;

    // 1 grau de latitude equivale a aprox. 111.195 metros
    final double novaLat = minhaLat + (metros / 111195.0);
    final double novaLon = minhaLon;

    widget.onDistanciaAlterada(metros, novaLat, novaLon);

    // Se estiver a mais de 100 metros, aciona o alerta e a notificação
    if (metros > 100) {
      widget.onDispararAlerta();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool estaLonge = widget.distanciaAtual > 100;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        // Cartão: Distância do parceiro
        _construirCartao(
          titulo: '📏 Distância do parceiro',
          rotuloDestaque: 'MONITORAMENTO',
          filho: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Limite de segurança',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: corTexto,
                    ),
                  ),
                  Text(
                    '100 metros',
                    style: TextStyle(fontSize: 11, color: corMuda),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Indicador grande de distância
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.distanciaAtual.round().toString(),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: corPrimariaForte,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'metros',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: corMuda,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Faixa de sinal (seguro vs perigo)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: estaLonge ? corPerigo : corSucesso,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  estaLonge
                      ? '⚠️ Parceiro fora do limite de segurança!'
                      : '✓ Parceiro dentro do limite de 100 metros.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: estaLonge ? corPerigoTexto : corSucessoTexto,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campos das coordenadas do parceiro
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latitude do parceiro',
                          style: TextStyle(fontSize: 10, color: corMuda),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _controladorLat,
                          readOnly: true,
                          style: const TextStyle(fontSize: 12, color: corTexto),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: corLinha),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Longitude do parceiro',
                          style: TextStyle(fontSize: 10, color: corMuda),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _controladorLon,
                          readOnly: true,
                          style: const TextStyle(fontSize: 12, color: corTexto),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: corLinha),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'No MVP, as coordenadas do parceiro são informadas para demonstrar a simulação.',
                style: TextStyle(fontSize: 11, color: corMuda),
              ),
              const SizedBox(height: 14),

              // Botões de Simulação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _moverParceiro(35),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: corTexto,
                        elevation: 0,
                        side: const BorderSide(color: corLinha),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Simular perto (35m)',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _moverParceiro(175),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corPrimaria,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Simular longe (175m)',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Cartão: Notificação local (Requisito Notificação)
        _construirCartao(
          titulo: '🔔 Notificação local',
          rotuloDestaque: 'ALERTA',
          filho: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'A notificação é disparada quando o parceiro ultrapassa o limite de 100 metros.',
                style: TextStyle(fontSize: 12, color: corMuda),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await ServicoNotificacao.exibirNotificacao();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notificação de teste enviada!'),
                          backgroundColor: corPrimariaForte,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: corTexto,
                    elevation: 0,
                    side: const BorderSide(color: corLinha),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text(
                    'Testar notificação',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirCartao({
    required String titulo,
    required String rotuloDestaque,
    required Widget filho,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: corLinha),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD59198).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: corTexto,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: corPrimariaSuave,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  rotuloDestaque,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: corPrimariaForte,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          filho,
        ],
      ),
    );
  }
}
