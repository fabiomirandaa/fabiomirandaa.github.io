---
layout: post
title: "O último guia de Angular Change Detection que você vai precisar"
seo-image: 'assets/img/post-04-nov-2020/postagem-change-detector.png'
date: 2020-11-04 00:15:15
description: "Este artigo fornece todas as informações necessárias que você precisa saber sobre Change Detection no Angular. A mecânica é explicada usando um projeto que foi construído para o artigo."
---

***Este artigo fornece todas as informações necessárias que você precisa saber sobre Change Detection no Angular. A mecânica é explicada usando um projeto que foi construído para o artigo. Uma tradução de ["The Last Guide For Angular Change Detection You'll Ever Need"](https://indepth.dev/the-last-guide-for-angular-change-detection-youll-ever-need/)***


Change Detection(detecção de mudanças) no Angular é um mecanismo central do framework, mas (pelo menos pela minha experiência) é muito difícil de entender. Infelizmente, não existe um guia oficial no site oficial do Angular sobre este assunto.

Nesta postagem do blog, fornecerei todas as informações necessárias que você precisa saber sobre Change Detection. Vou explicar a mecânica usando um projeto que construí para esta postagem do blog.

## O que é Change Detection

Dois dos principais objetivos do Angular são: ser previsível e ter desempenho. O framework precisa replicar o estado de nossa aplicação na UI combinando o estado e o modelo:

![](https://admin.indepth.dev/content/images/2020/07/data-template-dom.png)

Também é necessário atualizar o DOM se alguma mudança acontecer no estado. Este mecanismo de sincronização do HTML com nossos dados é chamado de "Detecção de Mudança". Cada framework de frontend usa sua implementação, por exemplo, o React usa o DOM Virtual, o Angular usa a detecção de mudanças e assim por diante. Eu posso recomendar o artigo [Detecção de mudanças nos  Frameworks JavaScript](https://teropa.info/blog/2015/03/02/change-and-its-dChange And Its Detection-in-j In JavasScript-f Frameworks.html) que dá uma boa visão geral deste tópico.

> Detecção de Mudança: O processo de atualização do DOM quando os dados são alterados

Como desenvolvedores, na maioria das vezes não precisamos nos preocupar com a detecção de mudanças até que precisemos otimizar o desempenho de nossa aplicação. A detecção de mudanças pode diminuir o desempenho em aplicações maiores, se não for tratada corretamente.


## Como funciona a Detecção de Mudança

Um ciclo de detecção de mudanças pode ser dividido em duas partes:

- O **O desenvolvedor** atualiza o modelo de aplicação
- O **Angular** faz a sincronização do modelo atualizado no DOM re-renderizando

Vamos dar uma olhada mais detalhada nesse processo:
1.  O desenvolvedor atualiza o modelo de dados, por exemplo, atualizando um binding do componente
2.  O Angular detecta a mudança
3.  A detecção de mudanças verifica **todos** os componentes da árvore de componentes de cima para baixo para ver se o modelo correspondente foi alterado
4.  Se houver um novo valor, ele atualizará a view do componente (DOM)

O GIF a seguir demonstra este processo de forma simplificada:

![](https://admin.indepth.dev/content/images/2020/08/cd-default.gif)

A imagem mostra uma árvore de componentes do Angular e seu detector de mudança (CD) para cada componente que é criado durante o processo de bootstrap da aplicação. Este detector compara o valor atual com o valor anterior da propriedade. Se o valor foi alterado, ele coloca `isChanged` para `true`. Olhe a [implementação no código do Framework](https://github.com/angular/angular/blob/885f1af509eb7d9ee049349a2fe5565282fbfefb/packages/core/src/util/comparison.ts#L13) , e repare que é apenas uma `===` comparação com tratamento especial para `NaN`.

> O Change Detection não realiza uma comparação profunda de objetos, ela apenas compara o valor anterior e atual das propriedades usadas pelo template

*Nota do tradutor: A partir de agora, vou chamar o Change Detection de Detecção de mudança, porque já considero que entenderam o contexto.*

### Zone.js

Em geral, uma zona pode acompanhar e interceptar qualquer tarefa assíncrona.

Uma zona normalmente tem as seguintes fases:
- ela começa estável
- torna-se instável se as tarefas forem executadas na zona
- se torna estável novamente se as tarefas forem concluídas

O Angular sobrescreve diversas APIs de baixo nível do navegador na inicialização para ser capaz de detectar mudanças na aplicação. Isto é feito usando o [zone.js](https://github.com/angular/angular/tree/master/packages/zone.js), que sobrescreve APIs tais como `EventEmitter`, DOM event listeners, `XMLHttpRequest`, `fs` API no Node.js e [mais](https://github.com/angular/angular/blob/master/packages/zone.js/STANDARD-APIS.md).

Em resumo, o framework desencadeará uma detecção de mudança se um dos seguintes eventos ocorrer:

-   qualquer evento do navegador (click, keyup, etc.)
-   `setInterval()`  e  `setTimeout()`
-   HTTP requests via  `XMLHttpRequest`

Angular usa sua zona chamada NgZone. Existe apenas uma NgZone e a detecção de mudanças só é acionada para operações assíncronas acionadas nesta zona.

## Performance

> Por padrão, a Detecção de Mudança do Angular verifica **todos os  componentes de cima para baixo** se um valor do template foi alterado.

O Angular é muito rápido fazendo a detecção de mudança para cada componente, pois pode realizar milhares de verificações durante milissegundos usando o [inline-caching](http://mrale.ph/blog/2012/06/03/explaining-js-vms-in-js-inline-caches.html) que gera um código otimizado para VM's(Máquinas Virtuais Javascript).

Se você quiser ter uma explicação mais profunda sobre este tópico, eu recomendaria assistir à palestra de [Victor Savkin’s](https://twitter.com/victorsavkin) com o título ["Detecção de Mudança Reinventada"](https://www.youtube.com/watch?v=jvKGQSFQf10).

Embora o Angular faça muitas otimizações nos bastidores, o desempenho ainda pode cair em aplicações maiores. No próximo capítulo, você aprenderá como melhorar ativamente o desempenho do Angular usando uma estratégia de detecção de mudança diferente.

### Estratégias de detecção de mudanças

Angular fornece duas estratégias para executar as detecções de mudanças:

-   `Default`(Padrão)
-   `OnPush`

Vamos analisar cada uma dessas estratégias de detecção de mudanças.

## Estratégia de detecção `Default`

Por padrão, a Angular usa a estratégia `ChangeDetectionStrategy.Default`. Essa estratégia padrão verifica cada componente da árvore de componentes de cima para baixo toda vez que um evento aciona a detecção de mudança(como eventos do usuário, timer, XHR, promises e etc). Essa forma conservadora de verificação sem fazer nenhuma previsão sobre as dependências do componente é chamada de **dirty checking**(verificação suja). Ela pode influenciar negativamente o desempenho de sua aplicação no cenário de grandes aplicações que possuem muitos componentes.

![](https://admin.indepth.dev/content/images/2020/08/cd-default-1.gif)

## Estratégia de detecção `OnPush`

#### OnPush Change Detection Strategy
Podemos mudar para a estratégia de detecção `ChangeDetectionStrategy.OnPush` adicionando a propriedade `ChangeDetection` aos metadados do decorator de component:

```ts
@Component({
    selector: 'hero-card',
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: ...
})
export class HeroCard {
}
```
Esta estratégia oferece a possibilidade de pular verificações desnecessárias para este componente e todos os seus componentes filhos.

O próximo GIF demonstra a possibilidade de ignorar partes da árvore de componentes usando a estratégia de detecção de mudança `OnPush`:

![](https://admin.indepth.dev/content/images/2020/08/cd-onpush.gif)

Usando essa estratégia, o Angular sabe que o componente só precisa ser atualizado se:

-   a referência do input tiver mudado
-   o componente ou um de seus filhos aciona um event handler
-   a detecção de mudanças é acionada manualmente
-   Um observable linkado no template via pipe async emite um novo valor

Vamos dar uma olhada mais atenta a este tipo de eventos.

## Mudanças na referência do input

Na estratégia padrão de detecção de mudanças, o Angular executará o detector de mudanças a qualquer momento que os dados de `@Input()`  são alterados ou modificados. Usando a estratégia `OnPush`, o detector de mudança só é acionado se uma **nova referência** for passada como valor para o `@Input()`.

Tudo em JavaScript é passado por referência, mas todos os primitivos são imutáveis e sua representação literal aponta para a mesma instância/referência primitiva. A modificação das propriedades do objeto ou itens de um array não cria uma nova referência e, portanto, não aciona a detecção de mudanças em um componente OnPush. Para acionar o detector de mudanças, é necessário passar uma nova referência/instância de objeto ou array.

Você pode testar este comportamento usando um [simples demo](https://angular-change-detection-demo.netlify.com/simple-demo):

1.  Modifique a idade do `HeroCardComponent`  com  `ChangeDetectionStrategy.Default`
2.  Verifique se o `HeroCardOnPushComponent`  com  `ChangeDetectionStrategy.OnPush`  não reflete a mudança de idade (visualizada por uma borda vermelha ao redor dos componentes)
3.  Clique em "Create new object reference" no card "Modify Heroes" 
4.  Verifique se o  `HeroCardOnPushComponent`  com  `ChangeDetectionStrategy.OnPush`  é verificado pela detecção de mudanças.
<br>

![](https://admin.indepth.dev/content/images/2020/07/cd-input-reference-change.gif)


Para evitar bugs de detecção de mudanças, pode ser útil construir a aplicação usando a detecção de mudanças `OnPush` em todos os lugares, usando apenas objetos e listas imutáveis. Objetos imutáveis só podem ser modificados criando uma nova referência de objeto para que possamos garantir que:

-   A detecção de modificação `OnPush`  é acionada para cada modificação
-   não esqueçamos de criar uma nova referência de objeto, o que poderia causar bugs.

[Immutable.js](https://facebook.github.io/immutable-js/)   é uma boa escolha e a biblioteca fornece estruturas de dados imutáveis persistentes para objetos (`Map`) e listas (`List`). A instalação da biblioteca via [npm](https://www.npmjs.com/package/immutable) fornece definições de tipo para que possamos tirar proveito dos tipos genéricos, detecção de erros e auto-completar em nossa IDE.

## Event Handler é acionado

A detecção de mudança (para todos os componentes na árvore de componentes) será acionada se o componente `OnPush` ou um de seus componentes filhos acionar um Event Handler(manipulador de eventos), como clicar em um botão.

Tenha cuidado, as seguintes ações não acionam a detecção de mudança usando a estratégia de detecção de mudança `OnPush`:

-   `setTimeout`
-   `setInterval`
-   `Promise.resolve().then()`, (e obviamente, o mesmo para  `Promise.reject().then()`)
-   `this.http.get('...').subscribe()`  (em geral, qualquer Observable Subscription do RxJS)

Você pode testar este comportamento usando um [simples demo](https://angular-change-detection-demo.netlify.com/simple-demo):

1.  Clique no botão "Change Age" em   `HeroCardOnPushComponent`  que usa  `ChangeDetectionStrategy.OnPush`
2.  Verifique se a detecção de mudança é acionada e checa todos os componentes
<br>
![](https://admin.indepth.dev/content/images/2020/07/cd-event-trigger.gif)

## Acionando a detecção de mudanças manualmente

Existem três métodos para acionar manualmente as detecções de mudanças:

-   `detectChanges()`  em `ChangeDetectorRef`  que executa a detecção de mudanças nessa view e seus filhos, mantendo em mente a estratégia de detecção de mudanças. Ele pode ser usado em combinação com o  `detach()`  para implementar verificações locais de detecção de mudanças.

-   `ApplicationRef.tick()`  que aciona a detecção de mudança para toda a aplicação, respeitando a estratégia de detecção de mudança dos componentes.

-   `markForCheck()`  em `ChangeDetectorRef`  que **não**  aciona a detecção de mudanças, mas marca todos os ancestrais `OnPush` como para serem verificados uma vez, seja como parte do ciclo de detecção de mudanças atual ou próximo. Ele executará a detecção de mudança nos componentes identificados, mesmo que eles estejam usando a estratégia `OnPush`.

> Executar a detecção de mudança manualmente não é um ***hack***, mas você só deve usá-la em casos razoáveis.

As ilustrações a seguir mostram os diferentes métodos ChangeDetectorRef em uma representação visual:
![](https://admin.indepth.dev/content/images/2020/07/changedetectorref-methods.png)

Você pode testar algumas destas ações usando os botões "DC" (`detectChanges()`) e "MFC" (`markForCheck()`) no [demo](https://angular-change-detection-demo.netlify.com/simple-demo).

## Pipe Async

O  [Pipe Async](https://angular.io/api/common/AsyncPipe)  subscreve um observável(Observable) e retorna o último valor que emitiu.

Internamente o  `Pipe Async`  chama o  `markForCheck`  cada vez que um novo valor é emitido, veja  [seu código fonte](https://github.com/angular/angular/blob/5.2.10/packages/common/src/pipes/async_pipe.ts#L139):
```ts
private _updateLatestValue(async: any, value: Object): void {
  if (async === this._obj) {
    this._latestValue = value;
    this._ref.markForCheck();
  }
}
```
Como mostrado, o `Pipe Async` funciona automaticamente usando a estratégia de detecção de mudança `OnPush`. Portanto, recomenda-se usá-lo o máximo possível para facilitar a mudança posterior da estratégia de detecção de mudança padrão para `OnPush`.

Você pode ver este comportamento em ação no [async demo](https://angular-change-detection-demo.netlify.com/async-pipe-demo).
<br/>

![](https://admin.indepth.dev/content/images/2020/07/cd-async-pipe.gif)

O primeiro componente faz diretamente um bind(one-way) no template com um Observable usando o `Pipe Async`
{% raw %}
```html
<mat-card-title>{{ (hero$ | async).name }}</mat-card-title>

```
{% endraw %}

```ts
  hero$: Observable<Hero>;

  ngOnInit(): void {
    this.hero$ = interval(1000).pipe(
        startWith(createHero()),
        map(() => createHero())
      );
  }

```

enquanto o segundo componente subscreve o Observable e atualiza uma variável com o valor para fazer o data binding:
{% raw %}
```html
<mat-card-title>{{ hero.name }}</mat-card-title>

```
{% endraw %}

```ts
  hero: Hero = createHero();

  ngOnInit(): void {
    interval(1000)
      .pipe(map(() => createHero()))
        .subscribe(() => {
          this.hero = createHero();
          console.log(
            'HeroCardAsyncPipeComponent new hero without AsyncPipe: ',
            this.hero
          );
        });
  }

```

Como você pode ver a implementação sem o `Async Pipe` não aciona a detecção de mudanças, então precisaríamos chamar manualmente o `detectChanges()` para cada novo evento que é emitido a partir do Observable.

### Evitando Loops de detecção de mudanças e o erro `ExpressionChangedAfterCheckedError`

No Angular vem incluso um mecanismo que detecta loops de detecção de mudanças. No modo de desenvolvimento, o framework executa a detecção de mudança duas vezes para verificar se o valor mudou desde a primeira execução. No modo de produção, a detecção de mudança só é executada uma vez para ter um melhor desempenho.

Eu forcei o error no meu [ExpressionChangedAfterCheckedError demo](https://angular-change-detection-demo.netlify.com/expression-changed-demo)  e você pode vê-lo se abrir o console do navegador:

![](https://admin.indepth.dev/content/images/2020/07/expression-change-error.png)

Nesse demo eu forcei o erro ao atualizar a propriedade `hero` no ciclo de vida `ngAfterViewInit`:

```ts
  ngAfterViewInit(): void {
    this.hero.name = 'Another name which triggers ExpressionChangedAfterItHasBeenCheckedError';
  }

```

Para entender por que isso causa esse erro, precisamos dar uma olhada nos diferentes passos durante uma execução de detecção de mudança:

![](https://admin.indepth.dev/content/images/2020/07/lifecycle-hooks.png)

Como podemos ver, o ciclo de vida `AfterViewInit` é chamado após as atualizações do DOM da view atual terem sido feitas. Se mudarmos o valor neste ciclo de vida, ele terá um valor diferente na segunda execução de detecção de mudança (que é acionada automaticamente no modo de desenvolvimento como descrito acima) e, portanto, a Angular lançará o famoso `ExpressionChangedAfterCheckedError`.

Posso recomendar fortemente o artigo [Tudo o que você precisa saber sobre detecção de mudanças no Angular ](https://blog.angularindepth.com/everything-you-need-to-know-about-change-detection-in-angular-8006c51d206f)  de  [Max Koretskyi](https://twitter.com/maxkoretskyi)  que explora a implementação e os casos de uso do famoso  `ExpressionChangedAfterCheckedError`  em mais detalhes.

## Rodando código sem detecção de mudanças

É possível executar certos blocos de código fora da "NgZone" para que não seja acionada a detecção de mudanças.

```ts
  constructor(private ngZone: NgZone) {}

  runWithoutChangeDetection() {
    this.ngZone.runOutsideAngular(() => {
      // o setTimeout a seguir não acionará a detecção de mudanças
      setTimeout(() => doStuff(), 1000);
    });
  }

```

O [simples demo](https://angular-change-detection-demo.netlify.com/simple-demo) fornece um botão para acionar uma ação fora da Zona Angular(NgZone):

![](https://admin.indepth.dev/content/images/2020/07/run-outside-zone-demo.png)

Veja que a ação está logada no console, mas os componentes `HeroCard` não são verificados, o que significa que sua borda não fica vermelha.

Este mecanismo pode ser útil para testes E2E executados por [Protractor](https://www.protractortest.org/#/),  especialmente se você estiver usando o `browser.waitForAngular`  em seus testes. Após cada comando enviado para o navegador, o Protractor esperará até que a zona se torne estável. Se você estiver usando o  `setInterval`  sua zona nunca se tornará estável e seus testes provavelmente darão ***timeout***.

O mesmo problema pode ocorrer para os Observables RxJS, portanto, é necessário adicionar uma versão corrigida para `polyfill.ts`, conforme descrito em [Zone.js's support for non-standard APIs](https://github.com/angular/angular/blob/master/packages/zone.js/NON-STANDARD-APIS.md#usage):

```js
import 'zone.js/dist/zone';  // Já incluso com o Angular CLI.
import 'zone.js/dist/zone-patch-rxjs'; // Importa o pacote RxJS para garantir que o RxJS funcione na zona correta

```
Sem este pacote, você poderia executar um código observável dentro de `ngZone.runOutsideAngular`, mas ele ainda seria executado como uma tarefa dentro de `'NgZone'`.

## Desativar a detecção de mudanças

Há casos especiais de uso em que faz sentido desativar a detecção de mudanças. Por exemplo, se você estiver usando um WebSocket para enviar muitos dados do backend para o frontend e os componentes correspondentes do frontend devem ser atualizados apenas a cada 10 segundos. Neste caso, podemos desativar a detecção de mudanças chamando `detectChanges()` e acioná-la manualmente utilizando `detectChanges()`:

```ts
constructor(private ref: ChangeDetectorRef) {
    ref.detach(); // desativa a detecção de mudanças
    setInterval(() => {
      this.ref.detectChanges(); // aciona manualmente a detecção de mudanças
    }, 10 * 1000);
  }

```

Também é possível desativar completamente o Zone.js durante o bootstrapping de uma aplicação Angular. Isto significa que a detecção automática de mudança está completamente desativada e precisamos acionar manualmente as mudanças de UI, por exemplo, chamando o `ChangeDetectorRef.detectChanges()`.

Primeiro, precisamos comentar a importação do Zone.js de   `polyfills.ts`:

```ts
import 'zone.js/dist/zone';  // Já incluso com o Angular CLI.

```

Em seguida, precisamos passar a zona como 'noop' em   `main.ts`:

```ts
platformBrowserDynamic().bootstrapModule(AppModule, {
      ngZone: 'noop';
}).catch(err => console.log(err));

```

Mais detalhes sobre a desativação da Zona.js podem ser encontrados no artigo [Angular Elements sem Zone.Js](https://www.softwarearchitekt.at/aktuelles/angular-elements-part-iii/).

## Ivy

Desde Angular 9, Angular usa [ Ivy, a próxima geração do pipeline de compilação e renderização do Angular](https://blog.angularindepth.com/all-you-need-to-know-about-ivy-the-new-angular-engine-9cde471f42cf) por padrão.

Ivy ainda manuseia todos os ciclos de vida do framework na ordem correta para que a detecção de mudanças funcione como antes. Assim, você ainda verá o mesmo `ExpressionChangedAfterCheckedError` em suas aplicações.

[Max Koretskyi](https://twitter.com/maxkoretskyi)  escreveu em [um artigo](https://blog.angularindepth.com/ivy-engine-in-angular-first-in-depth-look-at-compilation-runtime-and-change-detection-876751edd9fd):

> Como você pode ver, todas as operações familiares ainda estão aqui. Mas a ordem das operações parece ter mudado. Por exemplo, parece que agora a Angular verifica primeiro os componentes filhos e só depois as views embedadas. Como no momento não há um compilador para produzir resultados adequados para testar minhas suposições, não posso ter certeza.

Você pode encontrar mais dois artigos interessantes relacionados à Ivy na seção "Artigos Recomendados" no final deste post.

## Conclusão


A Detecção de Mudança do Angular é um poderoso mecanismo do framework que garante que nossa UI represente nossos dados de uma forma previsível e eficiente. É seguro dizer que a detecção de mudança simplesmente funciona para a maioria das aplicações, especialmente se elas não consistirem em mais de 50 componentes.

Como desenvolvedor, você geralmente precisa mergulhar profundamente nesse assunto por duas razões:

-   Você recebeu um  `ExpressionChangedAfterCheckedError`  e precisa resolver isso
-   Você precisa melhorar a performance da sua aplicação

Espero que este artigo possa ajudá-lo a ter uma melhor compreensão da Detecção de Mudança Angular. Sinta-se à vontade para usar meu [projeto demo](https://github.com/Mokkapps/angular-change-detection-demo)  para brincar com as diferentes estratégias de detecção de mudança.

## Artigos Recomendados

-   [Detecção de mudanças no Angular - Como funciona realmente?](https://blog.angular-university.io/how-does-angular-2-change-detection-really-work/)
-   [Detecção de Mudança Angular OnPush e Component Design - Evite as Armadilhas Comuns](https://blog.angular-university.io/onpush-change-detection-how-it-works/)
-   [Um Compreensivo Guia para a Estratégia de Detecção de Mudança Angular onPush](https://netbasal.com/a-comprehensive-guide-to-angular-onpush-change-detection-strategy-5bac493074a4)
-   [Detecção de mudança angular Explicada](https://blog.thoughtram.io/angular/2016/02/22/angular-2-change-detection-explained.html)
-   [Execução de detecção de mudança do Angular Ivy: você está preparado?](https://blog.angularindepth.com/angular-ivy-change-detection-execution-are-you-prepared-ab68d4231f2c)
-   [Entendendo o Angular Ivy: DOM Incremental e DOM Virtual](https://blog.nrwl.io/understanding-angular-ivy-incremental-dom-and-virtual-dom-243be844bf36)
