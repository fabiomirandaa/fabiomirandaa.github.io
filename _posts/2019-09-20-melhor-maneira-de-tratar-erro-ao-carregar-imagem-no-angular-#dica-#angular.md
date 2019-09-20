---
layout: post
title: "Melhor maneira de tratar erro ao carregar imagem no Angular #Dica1 #Angular"
---

Eu estive afastado da escrita de artigos por um tempo e decidi voltar. Para isso, vou iniciar aqui uma série de pequenos artigos que serão algumas dicas pequenas de boas práticas com Angular. Hoje eu começo falando sobre como você pode colocar aquela imagem default, que geralmente colocamos quando não carrega a imagem que deveria(Se ainda não faz, já pode começar :p )

Primeiro, vamos analisar algumas formas de fazer esse tratamento. Eu já vi muitos códigos assim:

![Jeito 1 de ser feito]({{ site.baseurl }}/assets/img/post-20-set-2019/jeito-1.png)

O que tá acontecendo aqui? Aqui está sendo feito um ternário para verificar se existe algo em `item.user.picture` e senão houver coloca a imagem default. Funciona, mas poderia ser melhor. Mais um detalhe com esse código: A sintaxe `src={{image}}` funciona, mas é uma boa prática usar o databinding do angular pra isso, ficando `[src]='image'`. 

Há também uma segunda maneira de se fazer esse tratamento de imagem, e é comum vê-la por aí:

![Jeito 2 de ser feito]({{ site.baseurl }}/assets/img/post-20-set-2019/jeito-2.png)

Aqui está sendo usado duas `div` e mais dois `*ngIf` para que seja verificado no se tem a imagem no `item.user.picture` e caso tenha, carrega a primeira `div`, senão carrega a segunda. Vale lembrar que o `*ngIf` realmente não renderiza o elemento que não atender a condição, diferente do `[hidden]` que só esconde o elemento como um `display:none`. Essa maneira também funciona, mas ela não é tão boa.

"Já falou pra cacete, eu faço isso daí mesmo. Qual é o cacete da dica?". Beleza, vamos lá! 

Olha só que coisa linda e elegante: 

![Jeito certo de ser feito]({{ site.baseurl }}/assets/img/post-20-set-2019/jeito-certo.png)

Para ser bem sincero, o que está sendo feito aqui nem tem a ver com o Angular. No maravilhoso HTML5 foi implementado alguns events em certas tags e o `onError` é justamente um desses events, que claramente como o nome diz é disparado quando há erro no carregamento de um arquivo.

Por hoje é só, espero que essa dica tenha sido válida e ajude você a escrever um código mais clean. Até a próxima.