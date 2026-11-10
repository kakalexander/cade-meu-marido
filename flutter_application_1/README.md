# EncontreMeuParceiro 📱

Aplicativo mobile desenvolvido em **Flutter** para apresentação acadêmica na faculdade.

O projeto consiste em um **MVP (Minimum Viable Product)** funcional, intuitivo e com visual moderno baseado em tons pasteis (branco, vermelho pastel e cinza claro), atendendo rigorosamente aos quatro requisitos de hardware e sensores do dispositivo móvel.

---

## 🎯 Funcionalidades e Requisitos Atendidos

| Requisito | Aba | Descrição | Biblioteca Utilizada |
| :--- | :--- | :--- | :--- |
| **1. Câmera** | **Início** | Captura fotografia real do parceiro através da câmera do celular e exibe a imagem capturada no cartão do parceiro. | `image_picker` |
| **2. Localização GPS** | **Início** | Solicita permissão de geolocalização e captura em tempo real a latitude e longitude reais do dispositivo. Possui também modo demo para salas sem sinal. | `geolocator` |
| **3. Notificação Local** | **Distância & Alertas** | Simula aproximação (35m) e afastamento (175m) do parceiro em relação ao limite seguro (100m). Ao simular o afastamento, dispara uma notificação real local do Android com título e mensagem. | `flutter_local_notifications` |
| **4. Acelerômetro** | **Sensores** | Captura e exibe em tempo real os valores reais dos eixos X, Y e Z do sensor do celular com duas casas decimais. Cancela a subscrição ao sair da tela. | `sensors_plus` |

---

## 🎨 Design e Interface

- Paleta de cores inspirada no protótipo HTML oficial:
  - Fundo: `#FFF8F8`
  - Destaque/Primária: `#EF8F95` / `#E77982`
  - Suave (Badges/Pills): `#FDE7E9`
  - Cartões: Branco com bordas arredondadas e sombras suaves
  - Status Seguro: Verde claro (`#EAF8EF`, texto `#3B7650`)
  - Status Alerta: Vermelho pastel (`#FFF0F1`, texto `#BB4F5D`)
- Menu inferior flutuante com quatro abas:
  - 🏠 **Início**: Foto do parceiro (Câmera) e Coordenadas atuais (GPS).
  - 📍 **Distância**: Monitoramento da distância e botões de simulação perto/longe.
  - 🔔 **Alertas**: Visualização do alerta ativo e preview da notificação recebida.
  - 📐 **Sensores**: Leituras X, Y e Z do acelerômetro em tempo real.

---

## 📁 Estrutura de Arquivos

```text
lib/
  ├── main.dart                         (Inicialização, tema e chamada da tela principal)
  ├── services/
  │   └── notification_service.dart     (Configuração e disparo das notificações locais)
  └── screens/
      ├── main_navigation_screen.dart   (Gerenciamento da navegação inferior e estado do app)
      ├── home_screen.dart              (Câmera e GPS)
      ├── distance_screen.dart          (Cálculo e simulação de distância)
      ├── alerts_screen.dart            (Visualização de alertas e teste de notificação)
      └── sensors_screen.dart           (Leitura do acelerômetro real X, Y, Z)
```

---

## 🚀 Como Executar o Projeto

```bash
flutter pub get
flutter analyze
flutter run
```

Para gerar o APK debug:
```bash
flutter build apk --debug
```
