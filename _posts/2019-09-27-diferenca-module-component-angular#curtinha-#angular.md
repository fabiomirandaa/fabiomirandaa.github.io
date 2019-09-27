---
layout: post
title: "Qual a diferença entre Module e Component no Angular?  #Curtinhas #Angular"
---
Vou começar a escrever além da série de dicas de Angular, uma série de curtinhas sobre o Angular. Hoje vou falar sobre a diferença entre Module e Component. Aprecio o feedback,principalmente senão tiver ficado claro a explicação =) 

O Component é simplesmente a Controller da View. Sim, a view é o HTML mesmo. É no component que nós cuidamos do que é necessário para trazer funcionalidade para as views, usando o Typescript para escrever o código. Por exemplo, é no component que nós usamos uma service para tazer valores e então passamos esses valores para alguma variável, para então poder exibí-la na view.

É convencionado no Angular nomear esses arquivos mais ou menos assim => `exemplo.component.ts`. Vale lembrar que estou me referindo ao que colocamos no arquivo `.component`. Dentro do component nós usamos um decorator chamado `@Component` para então declarar nossa View, o estilo(CSS,SASS e etc) e um seletor(nome do componente, que poderá ser chamado em outras views).


Os Modules diferentemente dos components não controlam nenhuma view(html). Um Module se constitui de um ou mais components, ou seja, é lá que você registra seus components. Uma aplicação Angular tem de ter no mínimo um Module que contenha mínimo um Component. 

Além de registrar components, outras responsabilidades do Module são declarar qual ou quais components podem ser usados por components que são de outros Modules, quais services serão injetados e qual componente será o componente inicial. Os Modules gerenciam os components e é com eles que nós podemos modularizar nossa aplicação.

Resumindo, bem a grosso modo: É como se o Module fosse um cômodo e os Components os móveis que preenchem aquele cômodo. 