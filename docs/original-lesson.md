# Original classroom notes (2020)

Historical Portuguese notes preserved from the original README. Dependencies and commands below describe the old version; follow the current root README for Flutter 3.41.9.

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

