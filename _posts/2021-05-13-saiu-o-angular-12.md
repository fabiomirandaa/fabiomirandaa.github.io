---
layout: post
title: "Saiu o Angular 12"
date: 2021-05-13 01:08:20
seo-image: '/assets/img/post-13-mai-2021/postagem-angular-12.jpg'
description: "Saiu mais uma versão do Angular, a versão 12. Confira a tradução do post oficial de lançamento dessa nova versão e fique por dentro das novidades" 
---

É aquela vez novamente, amigos - estamos de volta com um novo lançamento e mal podemos esperar para compartilhar todas as grandes atualizações e features que esperam por vocês no Angular 12.

Antes de mergulharmos nessas atualizações, vamos dar uma olhada na trajetória do Angular. Uma chave vital para o futuro do Angular é o Ivy e o que ele desbloqueia para a plataforma. Temos trabalhado nos últimos lançamentos com o objetivo de convergir o ecossistema Angular em Ivy. Gostamos de chamar esta abordagem de "Ivy Everywhere" (Ivy em Todos os Lugares).

Aqui estão as mudanças que estamos fazendo para possibilitar esta transição.

## Se aproximando mais de Ivy em todos os lugares

O momento chave na próxima evolução do Angular finalmente chegou - estamos finalmente depreciando o View Engine. Isto é o que significa para a comunidade.

-   Agora que o View Engine foi depreciado, ele será removido em uma **futura major release**.
-   As bibliotecas atuais que usam o View Engine ainda funcionarão com aplicações Ivy (nenhum trabalho é exigido pelos desenvolvedores), mas os autores das bibliotecas devem começar a planejar a transição para o Ivy.

Escrevemos um [post no blog](https://blog.angular.io/upcoming-improvements-to-angular-library-distribution-76c02f782aa4) com detalhes sobre esta mudança e o que ela significa para os autores das bibliotecas e muito mais.

## Transição do Legado IDs de mensagens do i18n

Atualmente, existem vários formatos de identificação de mensagens legadas que estão sendo usados em nosso sistema i18n. Estes ids de mensagens legadas são frágeis, pois podem surgir problemas com base nos espaços em branco e nos templates de formatação e expressões ICU. Para resolver este problema, estamos migrando para longe deles. O novo formato de id de mensagem canônica é muito mais resiliente e intuitivo. Este formato reduzirá a invalidação desnecessária da tradução e o custo de retradução associado em aplicações onde as traduções não correspondem devido a mudanças no espaço em branco, por exemplo.

Desde o 11, novos projetos são automaticamente configurados para usar os novos IDs de mensagens e agora temos ferramentas para migrar os projetos existentes com as traduções existentes. Saiba mais [aqui](https://v12.angular.io/guide/migration-legacy-message-id).

## O futuro do Protractor

A equipe Angular tem trabalhado com a comunidade para determinar o futuro do Protractor. Estamos atualmente analisando o feedback compartilhado na [RFC](https://github.com/angular/protractor/issues/5502). Ainda estamos descobrindo o melhor futuro para o Protractor. Optamos por não incluí-lo em novos projetos e, em vez disso, fornecemos opções com soluções populares de terceiros na CLI Angular. Atualmente estamos trabalhando com Cypress, WebdriverIO, e TestCafe para ajudar os usuários a adotarem as soluções alternativas. Mais informações virão à medida que isso se desenvolver.

##  Nullish Coalescing

O operador de coalescência nula (`??`) tem ajudado os desenvolvedores a escrever código mais limpo nas classes TypeScript há algum tempo. Estamos entusiasmados em anunciar que você pode trazer o poder da coalescência nula para os templates do Angular na versão 12!

Agora, nos templates, os desenvolvedores podem utilizar a nova sintaxe para simplificar os condicionamentos complexos. Por exemplo:
{% raw %}
```typescript
{{age !== null && age !== undefined ? age : calculateAge() }}
```
{% endraw %}
Vira:
{% raw %}
```typescript
{{ age ?? calculateAge() }}
```
{% endraw %}
Experimente hoje mesmo e nos diga o que você acha!

## Aprendendo Angular

Estamos sempre trabalhando para melhorar a experiência de aprendizagem do Angular para os desenvolvedores. Como parte deste esforço, fizemos algumas mudanças significativas em nossa documentação. Escrevemos um [guia de projeção de conteúdo](https://v12.angular.io/guide/content-projection), com mais conteúdo novo a disposição.

Mas há mais nesta história. Recebemos muitos comentários e perguntas sobre como você pode nos ajudar a melhorar a documentação. Ótimas notícias, atualizamos o angular.io com um [guia de contribuição](https://angular.io/guide/contributors-guide-overview) que ajudará as pessoas que procuram melhorar os documentos. Confira e nos ajude a melhorar os documentos.

Mais uma coisa aqui - desde nossa última Major Release, incluímos [guias e vídeos](https://blog.angular.io/angular-debugging-guides-dfe0ef915036) para mensagens de erro. A comunidade achou isto incrivelmente útil, portanto, se você não os viu, então definitivamente [veja](https://angular.io/errors)!

## Stylish Improvements

Começando na versão 12, os componentes do Angular agora suportarão Sass inline no campo de style do `@Component` decorator. Anteriormente, Sass só estava disponível em fontes externas devido ao compilador do Angular. Para habilitar este recurso em suas aplicações existentes, adicione `"inlineStyleLanguage": "scss”`  no  `angular.json`. Caso contrário, ele estará disponível para novos projetos utilizando o SCSS.

Na versão v11.2, adicionamos suporte para o Tailwind CSS. Para começar a usá-lo em projetos: instale o pacote `tailwindcss` do [npm](https://www.npmjs.com/package/tailwindcss) e depois inicialize Tailwind para criar o `tailwind.config.js` em seu projeto. Agora, as equipes estão prontas para começar a usar o Tailwind em Angular.

Angular CDK e Angular Material adotaram internamente o [novo sistema de módulos do Sass](https://sass-lang.com/blog/the-module-system-is-launched). Se sua aplicação usa Angular CDK ou Angular Material, você precisará ter certeza de ter trocado o pacote `node-sass` para o [pacote npm](https://www.npmjs.com/package/sass) `sass` . O `node-sass` não é mais mantido e não acompanha mais os novos recursos adicionados à linguagem Sass.

Além disso, tanto o Angular CDK como o Angular Material expõem uma nova interface da API do Sass, projetada para consumo com a nova sintaxe `@use`. Essa nova interface da API oferece as mesmas características, mas com nomes mais significativos e pontos de acesso mais ergonômicos. Todas os [guias sobre Angular Material](https://material.angular.io/guides) foram totalmente reescritos para mostrar esta nova interface da API, bem como fornecer explicações mais detalhadas sobre seus conceitos e APIs.

Ao atualizar para a versão 12 com `ng update` sua aplicação mudará automaticamente para a nova API do Sass. Este comando irá refatorar qualquer declaração `@import` do Sass e Angular CDK e Angular Material para a nova API `@use`.  Aqui está um exemplo do [antes e do depois](https://gist.github.com/MarkTechson/6283b6a3b353f9e38964af0740e29280).

## Mais ótimas Features

Vamos dar uma olhada em algumas das outras grandes atualizações que fizeram com que este lançamento se tornasse realidade:

-   Rodando  `ng build`  como padrão no modo de produção, o que economiza algumas etapas extras para as equipes e previne que algum código de desenvolvimento acidentalmente builde em produção!
-   O Strict mode("modo estrito") é ativado por padrão no CLI. O Strict mode ajuda a detectar erros no início do ciclo de desenvolvimento. Saiba mais sobre o Strict mode na [documentação](https://angular.io/guide/strict-mode) e encontre o anúncio original em nosso [blog](https://blog.angular.io/with-best-practices-from-the-start-d64881a16de8).
-   O Ivy-based Language Service está passando de opt-in para ligado por padrão. O Language Service ajuda a aumentar sua produtividade ao construir aplicativos, fornecendo grandes recursos como completes de código, erros, dicas e navegação dentro de templates angulares. Verifique [nesta apresentação de vídeo](https://www.youtube.com/watch?v=doVYC32hjIw) para saber mais.
-   Na atualização da versão 11, adicionamos suporte experimental para o Webpack 5. Hoje, temos o prazer de anunciar que estamos lançando uma versão pronta para **_produção_** do suporte do Webpack 5 em Angular. 
-   Também estamos atualizando a versão do TypeScript para a 4.2 — vejo sobre isso no [post](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/)  para mais detalhes sobre o que está incluído.

##  Suporte depreciado para o IE11

Angular é uma plataforma "evergreen", o que significa que ela se mantém atualizada com o ecossistema em evolução da web. A remoção do suporte a navegadores legados nos permite concentrar nossos esforços em fornecer soluções modernas e melhor suporte aos desenvolvedores e usuários.

Vamos começar a incluir uma nova mensagem de aviso de depreciação na Angular versão 12 - e remover o suporte ao IE11 na Angular versão 13.

Você pode ver nossa lógica de decisão indo a este [RFC](https://github.com/angular/angular/issues/41840).

## Apoio da comunidade

A comunidade Angular tem trabalhado arduamente para melhorar a experiência Angular para todos, contribuindo para o framework - obrigado! Aqui estão alguns dos PRs que foram entregues graças a seu incrível trabalho:

-   Evitar que o  `ngZone`  lance um aviso relacionado a navegação desnecessariamente  [(#25839)](https://github.com/angular/angular/pull/25839)
-   `HttpClient`  supports specifying request metadata ([#25751](https://github.com/angular/angular/pull/25751))
-   `min`  e  `max`  Forms validators adicionados ([#39063](https://github.com/angular/angular/pull/39063))
-   Suporte para o  `APP_INITIALIZER`  funcionar/trabalhar com observables ([#33222](https://github.com/angular/angular/pull/33222))

## Conclusão

A equipe do Angular tem trabalhado duro para servir a comunidade em muitas áreas. Não deixe de nos [seguir no Twitter](https://twitter.com/angular)  para atualizações e em nosso [canal remodelado no YouTube](https://www.youtube.com/channel/UCbn1OgGei-DV7aSRo_HaAiw)  para novos conteúdos.

Qual funcionalidade deixou você mais entusiasmado com a versão 12? Comente sobre este post e nos informe.

Muito obrigado por fazer parte da incrível comunidade do Angular. Até a próxima vez, vá construindo grandes Apps!
## Tradução
Este texto foi uma tradução do [post original](https://blog.angular.io/angular-v12-is-now-available-32ed51fbfd49) de lançamento da versão 12 do Angular.  

