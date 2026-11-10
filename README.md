# EncontreMeuParceiro 📱

Aplicativo mobile desenvolvido em **Flutter** fiel ao protótipo oficial [`EncontreMeuParceiro_prototipo_v2.html`](file:///home/madara/Documentos/AulaMobile/TrabalhoCadeMeuMarido/EncontreMeuParceiro_prototipo_v2.html), atendendo com rigor aos **quatro requisitos essenciais de hardware**:

1. **Câmera**: capturar fotografia do parceiro e exibir no avatar.
2. **Localização (GPS)**: obter latitude e longitude reais do celular (com modo demo para salas fechadas).
3. **Notificação Local**: simulação de distância perto (35m) e longe (175m); ao ultrapassar 100m, emite notificação real no sistema do aparelho.
4. **Sensores (Acelerômetro)**: exibir leituras contínuas dos eixos X, Y e Z em tempo real com descarte de recursos no `dispose()`.

> [!TIP]
> Um guia visual completo e interativo para a apresentação está disponível no arquivo [`guia_apresentacao.html`](file:///home/madara/Documentos/AulaMobile/TrabalhoCadeMeuMarido/guia_apresentacao.html). Basta dar dois cliques nele para abrir no navegador!

---

## 🎨 Estrutura das 4 Abas do Protótipo

| Aba | Arquivo / Classe | O que faz no protótipo | Requisito Atendido |
| :--- | :--- | :--- | :--- |
| 🏠 **Início** | [`tela_inicio.dart`](file:///home/madara/Documentos/AulaMobile/TrabalhoCadeMeuMarido/flutter_application_1/lib/screens/tela_inicio.dart)<br>`TelaInicio` | • Banner de introdução.<br>• Cartão **Meu Parceiro**: botão para abrir a câmera e preencher a foto do parceiro.<br>• Cartão **Minha Localização**: botões *Usar meu GPS* (real) e *Usar demo*. | **1. Câmera**<br>`image_picker`<br><br>**2. GPS**<br>`geolocator` |
| 📍 **Distância** | [`tela_distancia.dart`](file:///home/madara/Documentos/AulaMobile/TrabalhoCadeMeuMarido/flutter_application_1/lib/screens/tela_distancia.dart)<br>`TelaDistancia` | • Monitoramento da distância com limite seguro de 100m.<br>• Botão **Simular perto (35m)**: sinal verde seguro.<br>• Botão **Simular longe (175m)**: sinal vermelho de perigo + **disparo imediato da notificação local no Android**.<br>• Botão para testar notificação avulsa. | **3. Notificação**<br>`flutter_local_notifications` |
| 🔔 **Alertas** | [`tela_alertas.dart`](file:///home/madara/Documentos/AulaMobile/TrabalhoCadeMeuMarido/flutter_application_1/lib/screens/tela_alertas.dart)<br>`TelaAlertas` | • Preview visual idêntico da notificação recebida.<br>• Faixa de alerta ativo com botões para mostrar ou limpar o alerta. | **Visualização de Alertas** |
| 📐 **Sensores** | [`tela_sensores.dart`](file:///home/madara/Documentos/AulaMobile/TrabalhoCadeMeuMarido/flutter_application_1/lib/screens/tela_sensores.dart)<br>`TelaSensores` | • Cards dos eixos **X**, **Y** e **Z** em m/s² atualizados a cada milissegundo pelo acelerômetro físico.<br>• Botão para pausar/retomar leitura (gerenciamento de ciclo de vida). | **4. Acelerômetro**<br>`sensors_plus` |

---

## 📁 Arquitetura do Projeto (100% em Português)

```text
flutter_application_1/
├── lib/
│   ├── main.dart                          (Ponto de entrada: MeuAplicativo)
│   ├── services/
│   │   └── servico_notificacao.dart       (Gerenciamento e envio de notificações locais)
│   └── screens/
│       ├── tela_navegacao.dart            (Menu inferior e topo MVP do protótipo)
│       ├── tela_inicio.dart               (1. Câmera do parceiro & 2. GPS do usuário)
│       ├── tela_distancia.dart            (3. Monitoramento da distância & simulação)
│       ├── tela_alertas.dart              (Visualização do alerta e notificação recebida)
│       └── tela_sensores.dart             (4. Acelerômetro real X, Y e Z)
└── test/
    └── widget_test.dart                   (Teste automatizado dos 4 módulos)
```

---

## 🎤 Roteiro Passo a Passo para a Apresentação

1. **Aba Início (Câmera & GPS)**:
   - Toque em **"📸 Tirar ou selecionar foto"**: abra a câmera, tire uma foto e veja a imagem preencher o avatar do parceiro.
   - Toque em **"Usar meu GPS"**: o app solicitará permissão nativa e preencherá a Latitude e Longitude reais. *(Caso esteja em sala fechada sem sinal, use o botão "Usar demo")*.

2. **Aba Distância (Simulação Perto/Longe & Notificação)**:
   - Toque em **"Simular perto (35m)"**: o sinal fica verde (dentro do limite seguro de 100m).
   - Toque em **"Simular longe (175m)"**: o sinal muda para vermelho perigo e **uma notificação real com som, vibração e banner salta no topo do Android** avisando que o parceiro ultrapassou 100 metros.

3. **Aba Alertas (Visualização do Alerta)**:
   - Observe o ponto vermelho no ícone do menu indicando alerta pendente e veja o preview oficial da notificação.

4. **Aba Sensores (Acelerômetro em Tempo Real)**:
   - Incline e movimente o aparelho na mão: os valores dos eixos **X**, **Y** e **Z** se alteram ao vivo em m/s². Demonstre o botão de pausar e explique que a subscrição é cancelada no `dispose()` para economizar bateria.
