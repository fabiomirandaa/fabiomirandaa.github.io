---
layout: post
title: "Extensões que todo desenvolvedor Javascript/Typescript tem que ter!"
---

Hoje falarei sobre alguns plugins que são ótimos para aumentar a produtividade de um desenvolvedor Javascript/Typescript, são alguns que eu já uso há muito tempo e alguns eu descobri recentemente e estou gostando do resultado.

## - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)

Eu já vou começar com um que eu descobri recentemente. Quem nunca usou o POSTMAN pra fazer um request né? Faciita muito e é uma excelente ferramenta, mas eu descobri essa extensão que permite que façamos o request direto do VSCode! E o legal é que tem suporte para o REST, GraphQL, Curl e etc. Vale a pena dar um conferida nessa extensão.

## - [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)

O ESLint é quase uma obrigação se você quer ser um bom desenvolvedor. Esse é um linter já consagrado de Javascript.Com ele será mais fácil manter o padrão do seu código, pois ele vai alertar erros e avisar caso o seu código esteja descumprindo alguma das regras.

Se você nunca viu, vale a pena conferir o site do [ESLint](https://eslint.org/).

### Pra não precisar criar outra seção só pra indicar o lint do Typescript, use o [TSLint](https://marketplace.visualstudio.com/items?itemName=eg2.tslint)

Para os Devs que usam o Typescript, o TSLint segue a mesma linha do ESLint, e você consegue manter seu código limpo e padronizado. 

## - [Git Lens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)

O VS Code já possui integração nativa com o Git, porém o Git Lens é uma extensão muito poderosa que estende os recursos do versionador que não estão disponíveis nativamente.

Ele ajuda você a visualizar a autoria de código rapidamente através de anotações, a navegar e explorar os repositórios Git, a obter informações valiosas por meio de poderosos comandos de comparação e muito mais.

## - [Bracket Pair Colorizer](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer)

Muito mais do que adicionar uma corzinha ao seu código, essa extensão vai te ajudar a não se perder em partes que possuem muitas chaves, ou parênteses. Quem nunca se perder sem saber o que fechava o que, né? Essa extensão é justamente para resolver esse problema e ajuda mais do que parece.

## - [npm Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense)

Essa extensão facilita a importação dos módulos NPM no seu código, ajuda muito na hora de colocar novos módulos a um código.

## - [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

Para que o código não fique totalmente zoneado em termos de padrões de espaçamento e estilo de indentação, é essa a extensão necessária para qualquer trabalho em equipe. Quando não se usa essa extensão, é muito comum haver conflitos no git simplesmente porque uma linha está com a indentação, por exemplo, de tab na sua máquina e algum colega commitou esse mesmo arquivo com a indentação com espaço.

Para funcionar, é necessário criar um arquivo chamado `.editorconfig` com as configurações que devem ser usadas, caso não haja no projeto, converse com a equipe e adicione. Com todos da equipe usando a extensão, as configurações serão aplicadas pra todo mundo quando forem mexer no projeto.

## - [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)

Eu descobri essa extensão tem pouco tempo. Eu ficava fazendo aquele trabalho de corno de sempre instalar tudo manualemnte quando por algum motivo precisava instalar o VSCode numa máquina nova, ou após uma formatação. Eu sei que poderia salvar o arquivo de settings num Github da vida manualmente e usar ele pra sempre ter as mesmas configurações, mas sempre esquecia.

Aí, essa extensão chegou pra resolver. Ela usa o GitHub Gist pra sincronizar as configurações, extensões e temas para você não precisar ficar como eu ficava fazendo trabalhinho de corno de instalar tudo de novo.

## - [TODO Highlight](https://marketplace.visualstudio.com/items?itemName=wayou.vscode-todo-highlight)

Essa extensão é boa para deixar bem evidente que há um TODO a ser feito no seu código sempre que você abrir um arquivo que tenha um TODO.

## - [TODO Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)

Ainda no assunto TODO, essa extensão é boa para acessar com facilidade uma linha de código que tenha um TODO. Ela cria um menu lateral no VSCode, que mostra cada arquivo que tem um TODO. 

## - [Import Cost](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost)

Essa é uma extensão para uso temporário. Você com essa extensão vai conseguir saber quanto está pesando cada importação no seu código. Depois de um tempo fica meio que desnecessário porque você já vai saber, mas é bom usar por um tempo pra ter a noção se você está fazendo corretamente os imports, pegando só as partes necessárias de uma lib ou importantando tudo.

## - [Sort JSON objects](https://marketplace.visualstudio.com/items?itemName=richie5um2.vscode-sort-json)

Essa aqui é bem o que o nome já diz, mas para os consagrados meio caídos no inglês que nem eu, ela é para ordenar os itens dentro de um Json em ordem alfabética. 

## - [Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag)

Essa aqui é também é bem o que o nome já diz. Quem nunca deu aquela sofrida ao precisar mudar a tag e aí sempre rola o esquecimento de mudar a tag de fechamento e tal... Essa aqui resolve esse problema =) 


## - [Paste JSON as Code](https://marketplace.visualstudio.com/items?itemName=quicktype.quicktype)

Essa é uma extensão maravilhosa! Ela pega qualquer JSON que você copiar e transforma em uma interface, e se der criar até Enun. Precisando criar uma interface para aquele novo endpoint? Só fazer o request usando a primeira dica de extensão e copiar e colar usando essa extensão aqui =) 

## - [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

Para fechar, estou deixando aqui como fica simplesmente o mais famoso formatador de código do VSCode. Esse carinha aqui vai ajudar você a formatar aquele arquivo que tá todo zoado porque o projeto começou sem editor.config, ou mesmo aquela função que tu copiou lá do stackoverflow e ainda não indentou =P 


Bom, esss foram as dicas de extensões que eu uso e que são muito úteis para o desenvolvimento. Tem algumas extensões que são muito legais, mas não tem necessáriamente uma atuação no código como essas e se quiserem eu posso criar um artigo listando elas =D 