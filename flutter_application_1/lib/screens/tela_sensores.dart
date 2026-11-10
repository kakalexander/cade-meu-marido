import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tela do Acelerômetro: Leituras reais dos eixos X, Y e Z em tempo real
class TelaSensores extends StatefulWidget {
  const TelaSensores({super.key});

  @override
  State<TelaSensores> createState() => _TelaSensoresState();
}

class _TelaSensoresState extends State<TelaSensores> {
  double _eixoX = 0.0;
  double _eixoY = 0.0;
  double _eixoZ = 9.81;

  StreamSubscription<AccelerometerEvent>? _inscricaoSensor;
  bool _estaOuvindo = true;

  // Cores do protótipo
  static const Color corPrimariaForte = Color(0xFFE77982);
  static const Color corPrimariaSuave = Color(0xFFFDE7E9);
  static const Color corTexto = Color(0xFF442E31);
  static const Color corMuda = Color(0xFF8E7175);
  static const Color corLinha = Color(0xFFF1D6D9);

  @override
  void initState() {
    super.initState();
    _iniciarEscutaSensor();
  }

  void _iniciarEscutaSensor() {
    _inscricaoSensor?.cancel();
    _inscricaoSensor =
        accelerometerEventStream().listen((AccelerometerEvent evento) {
      if (mounted) {
        setState(() {
          _eixoX = evento.x;
          _eixoY = evento.y;
          _eixoZ = evento.z;
          _estaOuvindo = true;
        });
      }
    });
  }

  void _alternarSensor() {
    if (_estaOuvindo) {
      _inscricaoSensor?.cancel();
      _inscricaoSensor = null;
      setState(() => _estaOuvindo = false);
    } else {
      _iniciarEscutaSensor();
      setState(() => _estaOuvindo = true);
    }
  }

  @override
  void dispose() {
    _inscricaoSensor?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        _construirCartao(
          titulo: '📐 Acelerômetro',
          rotuloDestaque: _estaOuvindo ? 'REAL' : 'PAUSADO',
          filho: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grid de 3 colunas para X, Y e Z
              Row(
                children: [
                  Expanded(
                    child: _construirEstatisticaEixo(
                      rotulo: 'Eixo X',
                      valor: _eixoX.toStringAsFixed(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _construirEstatisticaEixo(
                      rotulo: 'Eixo Y',
                      valor: _eixoY.toStringAsFixed(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _construirEstatisticaEixo(
                      rotulo: 'Eixo Z',
                      valor: _eixoZ.toStringAsFixed(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Botão para pausar ou ativar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _alternarSensor,
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
                  child: Text(
                    _estaOuvindo
                        ? 'Pausar leitura do acelerômetro'
                        : 'Ativar sensor do aparelho',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Os valores X, Y e Z são capturados diretamente do sensor de aceleração e gravidade do dispositivo através do pacote sensors_plus.',
                style: TextStyle(fontSize: 11, color: corMuda),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'EncontreMeuParceiro • Protótipo acadêmico',
            style: TextStyle(
              fontSize: 11,
              color: corMuda,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirEstatisticaEixo({
    required String rotulo,
    required String valor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: corLinha),
      ),
      child: Column(
        children: [
          Text(
            rotulo,
            style: const TextStyle(fontSize: 10, color: corMuda),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: corPrimariaForte,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'm/s²',
            style: TextStyle(fontSize: 9, color: corMuda),
          ),
        ],
      ),
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
