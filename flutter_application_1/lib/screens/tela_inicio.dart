import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

/// Tela Inicial: Câmera (foto do parceiro) e GPS (minha localização)
class TelaInicio extends StatefulWidget {
  final File? fotoParceiro;
  final ValueChanged<File?> onFotoAlterada;
  final double? minhaLatitude;
  final double? minhaLongitude;
  final void Function(double latitude, double longitude) onLocalizacaoAlterada;

  const TelaInicio({
    super.key,
    required this.fotoParceiro,
    required this.onFotoAlterada,
    required this.minhaLatitude,
    required this.minhaLongitude,
    required this.onLocalizacaoAlterada,
  });

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  final ImagePicker _selecionador = ImagePicker();
  bool _carregandoGps = false;

  // Cores do protótipo
  static const Color corPrimaria = Color(0xFFEF8F95);
  static const Color corPrimariaForte = Color(0xFFE77982);
  static const Color corPrimariaSuave = Color(0xFFFDE7E9);
  static const Color corTexto = Color(0xFF442E31);
  static const Color corMuda = Color(0xFF8E7175);
  static const Color corLinha = Color(0xFFF1D6D9);

  /// Captura foto usando a Câmera nativa do aparelho
  Future<void> _tirarFoto(ImageSource origem) async {
    try {
      final XFile? foto = await _selecionador.pickImage(
        source: origem,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (foto != null) {
        widget.onFotoAlterada(File(foto.path));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto do parceiro atualizada com sucesso!'),
              backgroundColor: corPrimariaForte,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao acessar câmera: $erro'),
            backgroundColor: corPrimariaForte,
          ),
        );
      }
    }
  }

  /// Mostra as opções: tirar foto com a câmera ou escolher da galeria
  void _mostrarOpcoesFoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: corLinha,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                'Foto do Parceiro (Requisito: Câmera)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: corPrimariaSuave,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: corPrimariaForte),
                ),
                title: const Text(
                  'Tirar foto com a Câmera',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Abre a câmera do celular'),
                onTap: () {
                  Navigator.pop(context);
                  _tirarFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: corPrimariaSuave,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: corPrimariaForte),
                ),
                title: const Text(
                  'Escolher da Galeria',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Selecionar foto existente'),
                onTap: () {
                  Navigator.pop(context);
                  _tirarFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Consulta o GPS real do aparelho
  Future<void> _obterGpsReal() async {
    setState(() => _carregandoGps = true);

    try {
      bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ative o serviço de GPS nas configurações do celular.'),
              backgroundColor: corPrimariaForte,
            ),
          );
        }
        return;
      }

      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permissão de GPS negada pelo usuário.'),
                backgroundColor: corPrimariaForte,
              ),
            );
          }
          return;
        }
      }

      final Position posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      widget.onLocalizacaoAlterada(posicao.latitude, posicao.longitude);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Localização real capturada com sucesso via GPS!'),
            backgroundColor: Color(0xFF3B7650),
          ),
        );
      }
    } catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter GPS: $erro. Use o modo demo!'),
            backgroundColor: corPrimariaForte,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _carregandoGps = false);
    }
  }

  /// Aplica coordenadas de demonstração (útil em salas de aula sem sinal GPS)
  void _usarModoDemo() {
    widget.onLocalizacaoAlterada(-16.32650, -48.95340);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modo Demo ativado: coordenadas de teste carregadas!'),
        backgroundColor: corPrimariaForte,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        // Banner do protótipo
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFCEBED), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: corLinha),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Encontre seu parceiro com mais tranquilidade',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: corTexto,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Cadastre a foto, veja sua localização e monitore a distância com alertas simples.',
                style: TextStyle(fontSize: 12, color: corMuda),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Cartão 1: Meu Parceiro (Requisito Câmera)
        _construirCartao(
          titulo: '👤 Meu parceiro',
          rotuloDestaque: 'CÂMERA',
          filho: Column(
            children: [
              // Avatar com foto ou ícone
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE8EA),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFEFBCC3), width: 2),
                ),
                child: widget.fotoParceiro != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.file(
                          widget.fotoParceiro!,
                          fit: BoxFit.cover,
                          width: 96,
                          height: 96,
                        ),
                      )
                    : const Center(
                        child: Text(
                          '📷',
                          style: TextStyle(fontSize: 38),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Meu parceiro',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: corTexto,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Adicione uma foto para identificar a pessoa',
                style: TextStyle(fontSize: 11, color: corMuda),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _mostrarOpcoesFoto,
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
                    '📸 Tirar ou selecionar foto',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Cartão 2: Minha Localização (Requisito GPS)
        _construirCartao(
          titulo: '📍 Minha localização',
          rotuloDestaque: 'GPS',
          filho: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _construirEstatistica(
                      rotulo: 'Latitude',
                      valor: widget.minhaLatitude != null
                          ? widget.minhaLatitude!.toStringAsFixed(5)
                          : '—',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _construirEstatistica(
                      rotulo: 'Longitude',
                      valor: widget.minhaLongitude != null
                          ? widget.minhaLongitude!.toStringAsFixed(5)
                          : '—',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _carregandoGps ? null : _obterGpsReal,
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
                      child: _carregandoGps
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: corPrimariaForte,
                              ),
                            )
                          : const Text(
                              'Usar meu GPS',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _usarModoDemo,
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
                        'Usar demo',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'No MVP, você pode usar coordenadas reais do aparelho ou coordenadas de demonstração.',
                style: TextStyle(fontSize: 11, color: corMuda),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirEstatistica({required String rotulo, required String valor}) {
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
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: corTexto,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rotulo,
            style: const TextStyle(fontSize: 10, color: corMuda),
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
