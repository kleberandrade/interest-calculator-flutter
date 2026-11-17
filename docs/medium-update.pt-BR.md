# Atualização do tutorial no Medium

Artigo próprio identificado pelo link direto no README e lido em 17/11/2026:
https://medium.com/flutter-comunidade-br/desenvolvimento-de-uma-calculadora-de-juros-para-boletos-vencidos-44ab70fcf0cd

O editor desse mesmo artigo foi aberto na sessão autenticada de Kleber Andrade. A atualização mantém URL, título, idioma, autoria e material histórico; a orientação atual antecede a aula de 2020 e seus embeds, identificados como históricos. Não houve alteração de artigos de terceiros nem de gists externos. Publicação confirmada na página do próprio artigo após Save and publish, em 17/11/2026, com o mesmo identificador 44ab70fcf0cd, título e subtítulo original. A revisão não abriu fluxo de newsletter nem enviou mensagens a seguidores. A captura real está em screenshots/medium-published.jpg.

## Texto da orientação atual

### Atualização da aula — Flutter 3.41.9 e Dart 3.11.5

A calculadora foi modernizada em novembro de 2026. Para acompanhar a versão atual, use as instruções desta seção; o material de 2020 permanece abaixo como registro didático. Não copie a configuração Gradle 5.6 nem instale os plugins antigos no projeto atualizado.

### Preparando e executando o projeto

Instale Flutter 3.41.9 stable, que inclui Dart 3.11.5, e o Chrome. Clone o repositório https://github.com/kleberandrade/interest-calculator-flutter e entre na pasta interest-calculator-flutter. Execute, em ordem:

```sh
flutter --version
flutter pub get --enforce-lockfile
flutter run -d chrome
```

O pubspec.yaml atual usa flutter e flutter_localizations do SDK, além de cupertino_icons 1.0.9 para os ícones das interfaces nativas. flutter_lints 6 é uma dependência de desenvolvimento; flutter_test vem do SDK. Não usamos mais flutter_masked_text, datetime_picker_formfield nem custom_radio_grouped_button. intl é uma dependência transitiva da localização e não faz a leitura de dinheiro. TextFormField, showDatePicker, ChoiceChip e DropdownButtonFormField são os componentes nativos empregados. Não é necessário Firebase, banco de dados, conta ou chave de API.

O host Android agora usa o plugin declarativo do Flutter, Kotlin 2.2.20, AGP 8.11.1 e Gradle 8.14, com Java 17 como alvo. Não force Gradle 5.6. O host iOS usa cenas e tem mínimo iOS 15. Para distribuição, configure suas próprias assinaturas; a chave de depuração Android serve apenas para experimentos locais.

### Separando entrada, domínio e apresentação

lib/domain/input.dart converte texto brasileiro em centavos inteiros e valida datas reais. Por exemplo, parseDecimal('1.234,56') retorna 123456; números negativos, notação exponencial e mais de duas casas decimais são rejeitados. Datas usam dd/mm/aaaa, incluindo validação de ano bissexto.

lib/domain/calculation.dart contém Slip imutável, enums ChargeUnit e Period e a função pura calculate. A tela em lib/pages/calculator_page.dart gerencia apenas os campos, mensagens e apresentação. Os antigos PaymentSlip, ResultPaymentSlip, Controller e Constantes não são a API da versão atual. lib/main.dart configura localização e os temas claro/escuro.

Exemplo de cálculo independente da interface:

```dart
final result = calculate(Slip(
  principal: 100000, // R$ 1.000,00 em centavos
  fee: 200, // 2,00% em centésimos de porcentagem
  interest: 100, // 1,00% por período
  feeUnit: ChargeUnit.percent,
  interestUnit: ChargeUnit.percent,
  period: Period.day,
  due: DateTime.utc(2024, 2, 28),
  paid: DateTime.utc(2024, 3, 1),
));
// result.fee == 2000; result.interest == 2010;
// result.total == 104010 (R$ 1.040,10).
```

Importe package:interest_calculator/domain/calculation.dart para usar esse exemplo. Os valores financeiros não passam por double: usamos inteiros e frações exatas com BigInt, inclusive na potência dos juros compostos.

### O que a fórmula realmente significa

Preservamos os juros compostos da aula: juros = P × ((1 + r)^n − 1). P é o valor original, sem incluir a multa. A multa é cobrada uma única vez, apenas se houver atraso. Percentuais são informados de 0 a 100,00% por período; internamente, 1,00% corresponde a 100 centésimos de porcentagem e à razão 100/10000.

Os dias são corridos, excluindo o vencimento. As datas são normalizadas por seus componentes de calendário em UTC para não perder dias por horário ou horário de verão. No modo mensal, n é a divisão inteira dos dias por 30: 29 dias não geram juros mensais; 60 dias geram dois períodos. A multa continua devida a partir do primeiro dia de atraso. Pagamento no vencimento ou antecipado não tem encargos.

No modo R$, o valor de juros é convertido na taxa valor/P e depois capitalizado: não se trata de somar um valor fixo a cada dia. Juros positivos em reais exigem P maior que zero. Cada encargo é arredondado apenas uma vez, ao centavo mais próximo, com meio centavo para cima; o total soma principal e encargos já arredondados.

A simulação aceita datas de 1900 a 2100, até 3.660 dias de atraso, entradas monetárias de até R$ 10 bilhões e total de até R$ 10 trilhões. Esses limites são computacionais, não limites legais. O aplicativo é educativo: não consulta bancos nem assegura que as condições correspondam às do seu boleto.

### Experimentando e verificando

Na tela, selecione Usar exemplo e depois Calcular total. De 28/02/2024 a 01/03/2024 há dois dias: 1000 multiplicado por 1,01 duas vezes, mais 20, resulta em R$ 1.040,10. A tela mostra R$ 20,00 de multa e R$ 20,10 de juros. Ao editar entradas, o resumo antigo desaparece. Limpar reinicia os campos; os botões da barra alternam o tema e exibem informações/licenças. O resumo se empilha abaixo do formulário em telas estreitas e usa semântica acessível.

Execute flutter analyze, flutter test --coverage e flutter build web --release para conferir o projeto. Os testes incluem exemplos independentes, valores zero/negativos, limites, ano bissexto, datas invertidas, arredondamento e interação em tela de 360px com texto ampliado. O README registra separadamente builds e verificações reais de cada plataforma; teste Web não equivale a teste em telefone.

Como exercício, acrescente juros simples como opção explícita e compare-os com os compostos usando exemplos calculados à mão. Não troque silenciosamente a convenção nem anuncie conformidade bancária sem verificação. O código, os testes e o guia de apresentação estão no repositório vinculado acima.

### Material histórico da aula de 2020

A seção original abaixo, seus links, imagens e embeds ficam preservados para estudo da evolução do Flutter. Classes, dependências e comandos antigos pertencem à versão de 2020; siga a atualização acima e o README atual para executar o aplicativo modernizado.
