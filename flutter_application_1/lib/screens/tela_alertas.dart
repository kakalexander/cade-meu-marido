import 'package:flutter/material.dart';

/// Tela de Alertas: Visualização do estado de perigo e simulação de alerta
class TelaAlertas extends StatelessWidget {
  final bool alertaAtivo;
  final VoidCallback onDispararAlerta;
  final VoidCallback onLimparAlerta;

  const TelaAlertas({
    super.key,
    required this.alertaAtivo,
    required this.onDispararAlerta,
    required this.onLimparAlerta,
  });

  // Cores do protótipo
  static const Color corPrimaria = Color(0xFFEF8F95);
  static const Color corPrimariaForte = Color(0xFFE77982);
  static const Color corPrimariaSuave = Color(0xFFFDE7E9);
  static const Color corTexto = Color(0xFF442E31);
  static const Color corMuda = Color(0xFF8E7175);
  static const Color corLinha = Color(0xFFF1D6D9);
  static const Color corPerigo = Color(0xFFFFF0F1);
  static const Color corPerigoTexto = Color(0xFFBB4F5D);
  static const Color corSucesso = Color(0xFFEAF8EF);
  static const Color corSucessoTexto = Color(0xFF3B7650);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        _construirCartao(
          titulo: '🚨 Parceiro distante',
          rotuloDestaque: 'VISUALIZAÇÃO',
          filho: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview estilizado da notificação
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: corLinha),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: corPrimariaSuave,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notifications_active_rounded,
                          color: corPrimariaForte,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EncontreMeuParceiro',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Seu parceiro está a mais de 100 metros de você.',
                            style: TextStyle(fontSize: 11, color: corMuda),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Faixa indicativa de alerta ativo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: alertaAtivo ? corPerigo : corSucesso,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  alertaAtivo
                      ? '⚠️ Alerta ativo: parceiro fora do limite de segurança.'
                      : '✓ Limite seguro: nenhum alerta pendente no momento.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: alertaAtivo ? corPerigoTexto : corSucessoTexto,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Esta tela foi adicionada para mostrar claramente, na apresentação, como o app exibe o estado de alerta quando o parceiro estiver longe.',
                style: TextStyle(fontSize: 11, color: corMuda),
              ),
              const SizedBox(height: 16),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDispararAlerta,
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
                        'Mostrar alerta',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onLimparAlerta,
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
                        'Limpar alerta',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
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
