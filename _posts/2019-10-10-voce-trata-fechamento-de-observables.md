---
layout: post
title: Você faz o encerramento dos seus observables? Evite o vazamento de memória.#Dica #Angular #RxJs
---
Você sabia que é necessário "matar" seus observables para evitar vazamento de memória? Vamos lá que eu vou explicar o porquê e as maneiras de fazê-lo.

É muito comumm quando começamos a usar alguma tecnologia, fazer o uso errado dela por falta de experiência e conhecimento. Geralmente nós estamos trabalhando em projetos que tem algum prazo apertado e precisamos usar alguma tecnologia mais nova e nós simplesmente saímos implementando as features com base naquilo que já sabemos. Isso aconteceu com muitas pessoas(inclusive eu mesmo) quando saíram de usar algum framework que tinha promises ou callbacks de padrão e foram para o Angular sem entender o conceito de Observable.

Basicamente, o normal no início é fazer como no exemplo abaixo:

``` typescript
this.http
      .get<Fruits>('https://api.exemplo.com.br/fruits/')
      .subscribe((res: Fruits) => {
        this.fruits = data;
      });
```

Você sabia que no trecho acima mora um problema, que muitas vezes pode ser silencioso? Sim, ele não vai explodir nada no seu console, vai aparentemente funcionar perfeitamente e é por isso que é perigoso.

O problema acontece porque ao sair do componente que foi feita essa chamada, trocando de página, por exemplo, o Observable vai ficar ativo lá na memória porque você não tirou a inscrição dele. Então, vai ficar um observable aberto pra cada vez que o usuário entrar em uma página com esse tipo de requisição, mesmo se ele sair e entrar na mesma página várias vezes. Pra cada entrada e saída, mesmo que seja na mesma página e fazendo a mesma requisição, um novo observable nasce e fica jogado na sua memória!

Resultado: Você vai ter uma aplicação que vai ficar custosa pra máquina onde está hospedada, o desempenho geral vai ficar uma merda depois de minutos de uso.

Mas, como diria o Cristiano Ronaldo "Calma, eu to aqui". Existem várias soluções e eu vou te apresentar:

### Pipe Async

Se você usa no seu template o objeto exatamente como vem na request, a solução mais fácil e bonita é o Pipe Async do Angular. Basicamente você vai fazer a requsição no seu component, atribuindo a uma variável e sem usar o método `subscribe()` porque o pipe async já fará isso pra você! Ficaria mais ou menos assim:

``` html
<h1>Frutas</h1>
<div *ngIf="fruits$ | async as fruits">
    <section *ngFor="let fruit of fruits; trackBy: trackByFn">
      <p>Nome: {{ fruit.name }}</p>
      <p>Benefícios: {{ fruit.benefits }}</p>
      <p>Informações nutricionais: {{ fruit.nutritionInformation}}</p>
    <section>
</div>
```

Viu que beleza? O pipe async realiza o cancelamento da inscrição sempre que o componente é encerrado, e por isso você não precisa se preocupar em ter observables ocupando sua memória atoa. 

Mas, tome um cuidado! Se você fizer algo assim:

```html
<div>
    <section>
      <p>Nome: {{ (fruit$ | async).name }}</p>
      <p>Benefícios: {{ (fruit$ | async).benefits }}</p>
      <p>Informações nutricionais: {{ (fruit$ | async).nutritionInformation}}</p>
    <section>
</div>
```

### Unsubscribe 

### Take(1)

Se o observable for usado para pegar a informação uma única vez, basicamente um comportamento de promise, podemos usar também o operador `take` do RxJs com `1` de parâmetro. Só é importante ter consciência que o observable vai ser destruído(unsubscribe/completed) somente quando emitir o valor. Ou seja, se tiver alguma parte da aplicação que por um acaso seja acessada e destruída várias vezes em pouco tempo e a requisição é demorada, pode haver problemas na memória de qualquer forma.

Só deixando um exemplo:

``` typescript
    this.http
      .get<Fruits>('https://api.exemplo.com.br/fruits/')
      .pipe(take(1))
      .subscribe((data: Fruits) => {
        this.fruits = data;
      });
```

