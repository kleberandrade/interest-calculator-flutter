# Interest Calculator

[![Language: Dart](https://img.shields.io/badge/Language-Dart-0175C2)](https://github.com/kleberandrade/interest-calculator-flutter/blob/master/pubspec.yaml)
[![Framework: Flutter](https://img.shields.io/badge/Framework-Flutter-02569B)](https://github.com/kleberandrade/interest-calculator-flutter/blob/master/pubspec.yaml)

Flutter classroom app for calculating interest on overdue payment slips.

## Getting started

- Select a Flutter release whose bundled Dart SDK satisfies the manifest constraint, then run the commands below from the repository root.

```sh
flutter pub get
flutter run
```

- If the app depends on Firebase or another external service, configure your own service project using the dependencies and original notes; credentials are not supplied by this guide.

## Recorded requirements

- Dart SDK constraint from [`pubspec.yaml`](https://github.com/kleberandrade/interest-calculator-flutter/blob/master/pubspec.yaml): `>=2.1.0 <3.0.0`.

## Repository map

- [lib](https://github.com/kleberandrade/interest-calculator-flutter/tree/master/lib)
- [test](https://github.com/kleberandrade/interest-calculator-flutter/tree/master/test)
- [android](https://github.com/kleberandrade/interest-calculator-flutter/tree/master/android)
- [ios](https://github.com/kleberandrade/interest-calculator-flutter/tree/master/ios)

## Validation status

This update documents the tracked source and project metadata. It does not certify a successful build, device test or compatibility with a current toolchain. Follow any project-specific validation instructions in the original material.

## License and attribution

No standalone repository-wide license file was identified in this review. Preserve the original credits and any component-specific licenses; this documentation update grants no additional rights.

---

## Original project material

# Calculadora de Juros

Aplicativo de uma calculadora de juros para boletos vencidos para disciplina de Programação Mobile, criado por Kleber de Oliveira Andrade

Tutorial de criação deste app: [clique aqui](https://medium.com/flutter-comunidade-br/desenvolvimento-de-uma-calculadora-de-juros-para-boletos-vencidos-44ab70fcf0cd)

<p align="center">
    <img src="https://cdn-images-1.medium.com/max/1200/1*WdbItC4zKosSqygbVG4oMw.png" width="250"/>
    <img src="https://cdn-images-1.medium.com/max/1200/1*XnHNyKaV6INFue5l7Sj6EQ.png" width="250"/>
    <img src="https://cdn-images-1.medium.com/max/1200/1*rKoCLkb9VN14KkOQYekgww.png" width="250"/>
</p>

## Como clonar e importar

*   Faça um fork do projeto (precisa ter uma conta no github)
*   Abra o terminal do Visual Studio Code
*   Acesse a pasta onde deseja salvar o aplicativo e digite: git clone *link_do_projeto_no_seu_github* **interest_calculator**
*   Clique em File --> Open e abra o projeto
*   Não se esqueça de abrir o arquivo *pubspec.yaml* e salvar (CTRL + S) o arquivo para que os plugins sejam baixados 

## Desafio para aula

*   [ ] Não permitir adicionar valores negativos (multas e juros). Você pode adicionar essa validação entendendo mais sobre [TextFormField](https://flutter.dev/docs/cookbook/forms/validation);
*   [ ] Adicionar um background gradiente ([tutorial](https://alligator.io/flutter/flutter-gradient/) e [uiGradients](https://uigradients.com/));
*   [ ] Adicionar um botão na IconButton na AppBar para exibir informações do aplicativo utilizando a função [showAboutDialog](https://api.flutter.dev/flutter/material/showAboutDialog.html);
*   [ ] Criar um IconButton na AppBar para alternar entre os temas Light/dark (use o [plugin dynamic_theme](https://pub.dev/packages/dynamic_theme) e para entender mais sobre os parâmetros do tema use o [panache](https://rxlabz.github.io/panache/#/));
*   [ ] Implementar a função que limpa (clear) a tela na classe Controller.

## Licença

    Copyright 2020 Kleber de Oliveira Andrade
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
