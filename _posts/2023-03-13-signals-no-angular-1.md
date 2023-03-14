---
layout: post
title: "Signals no Angular: O Futuro do Change Detection"
date: 2023-03-13 22:00:20
seo-image: '/assets/img/post-13-mar-2023/postagem-signals.png'
description: "O Angular contará com um mecanismo reativo chamado Signals para tornar a detecção de mudanças mais leve e poderosa." 
---

Sarah Drasner, que, como Diretora de Engenharia no Google, também chefia a equipe Angular, falou há alguns dias no Twitter de um renascimento Angular. É praticamente isso, porque nos últimos lançamentos houve realmente algumas inovações que tornam o Angular extremamente atraente. Provavelmente, as mais importantes são os standalone components e standalone APIs.

Em seguida, a equipe do Angular se encarrega de renovar a detecção de mudança. Ela deve ser mais leve e poderosa. Para isso, o Angular vai contar com um mecanismo reativo chamado "Signals", que já foi adotado por uma série de outros frameworks.

Os "Signals" estarão disponíveis na versão 16 do Angular. Semelhantes aos standalone components, eles vêm inicialmente como uma prévia para desenvolvedores, para que os primeiros desenvolvedores possam ganhar experiência inicial. Na época em que este artigo foi escrito, um primeiro beta com suporte de "Signals" já estava disponível.

Neste artigo vou entrar neste novo mecanismo e mostrar como ele pode ser usado em uma aplicação Angular.
📂 [Código fonte](https://github.com/manfredsteyer/standalone-example-cli)
(veja as **branches**  `signal` e `signal-rxjs-interop` )

### Detecção de mudanças hoje: Zone.js
O Angular atualmente assume que qualquer "event handler"(manipulador de eventos) pode, teoricamente, alterar qualquer dado vinculado. Por este motivo, após a execução de "event handlers", o framework verifica todos os dados vinculados em todos os componentes em busca de mudanças por padrão. No modo mais potente de OnPush, que se baseia em "immutables" e "observables", o Angular é capaz de limitar drasticamente o número de componentes a serem verificados.

Independentemente do comportamento padrão ou OnPush, o Angular precisa saber quando os "event handlers"(manipuladores de eventos) foram executados. Isto é um desafio porque o próprio navegador, não o framework, aciona os event handlers. É exatamente aqui que a Zone.js usada pelo Angular entra em jogo. Usando monkey patching(sim, é um termo de programação kkk), ele estende objetos JavaScript como `window` ou `document` e prototypes como `HtmlButtonElement`, `HtmlInputElement` ou `Promise`.

Modificando as construções padrão, o Zone.js pode descobrir quando um "event handler" ocorreu. Ele então notifica o Angular, que se encarrega da detecção da mudança:

![Change detection with Zone.js](https://www.angulararchitects.io/wp-content/uploads/2023/03/cd.png)

Embora esta abordagem tenha funcionado bem no passado, ela ainda vem com alguns pontos negativos:

-   Monkey patching do Zone.js é mágica. Os objetos do navegador são modificados e os erros são difíceis de diagnosticar.
- O Zone.js tem uma sobrecarga de cerca de 100 KB. Embora seja insignificante para aplicações maiores, isto é um obstáculo para implementar web components muito leves.
- O Zone.js não pode fazer o monkey-patch de `async` e `await`, pois são palavras-chave.  Portanto, a CLI ainda converte essas instruções em promises, mesmo que todos os navegadores suportados já suportem `async` e `await` nativamente.
- Quando são feitas mudanças, componentes inteiros, incluindo seus predecessores, são sempre verificados na árvore de componentes. Atualmente, não é possível identificar diretamente os componentes alterados.

Agora, exatamente essas desvantagens são compensadas com os "Signals".

### Change Detection Amanhã: Signals

Um signal é uma simples construção reativa: ele possui um valor que os consumers(consumidores) podem ler. Dependendo da natureza do signal, o valor também pode ser alterado, após o que o signal notifica a todos os consumers(consumidores):

![How Signals works in principle](https://www.angulararchitects.io/wp-content/uploads/2023/03/signals.png)

Se o consumer(consumidor) é data binding, ele pode trazer os valores alterados para o componente. Os componentes alterados podem, portanto, ser atualizados diretamente.

Na terminologia da equipe Angular, o signal ocorre como um chamado producer(produtor). Como descrito abaixo, existem outras construções que podem preencher esta função.

### Usando Signals

Na futura variante de detecção de mudanças, todas as propriedades a serem vinculadas são configuradas como signals:

```typescript
@Component([…])
export class FlightSearchComponent {

  private flightService = inject(FlightService);

  from = signal('Hamburg');
  to = signal('Graz');
  flights = signal<Flight[]>([]);

  […]

}
```

Deve-se notar aqui que um signal sempre tem um valor por definição. Portanto, um valor padrão deve ser passado para a função de signal. Se o tipo de dado não puder ser derivado disto, o exemplo o especifica explicitamente através de um parâmetro de tipo.

O getter do signal é usado para ler o valor de um signal. Tecnicamente, isto significa que o signal é chamado como uma função:

```typescript
async search(): Promise<void> {
  if (!this.from() || !this.to()) return;

  const flights = await this.flightService.findAsPromise(
    this.from(), 
    this.to(),
    this.urgent());

  this.flights.set(flights);
}
```

Para definir o valor, o signal oferece um setter explícito com o método set. O exemplo mostrado usa o setter para guardar os vôos carregados. O getter também é usado para o data binding no template: 
```html
<div *ngIf="flights().length > 0">
  {{flights().length}} flights found!
</div>

<div class="row">
  <div *ngFor="let f of flights()">
    <flight-card [item]="f" />
  </div>
</div>
```

No passado, as chamadas de métodos nos templates eram desaprovadas, especialmente porque podiam levar a gargalos de desempenho. No entanto, isto geralmente não se aplica a rotinas sem complexidade, tais como os getters. Além disso, o template aparecerá aqui como um consumer(consumidor) no futuro e, como tal, pode ser notificado de mudanças.

`from` e`to` estão vinculados a inputs de entrada para que o usuário possa definir o filtro de busca. TPara isso, ele usa uma property binding para `value` e um event binding para `keydown` (não mostrado aqui). Esta abordagem não convencional é necessária porque, nesta fase inicial, o suporte do formulário incluindo o `ngModel` ainda não está adaptado aos Signals.

## Atualizando os Signals

Além do setter mostrado anteriormente, os "Signals" vêm com dois outros métodos para atualizar seu conteúdo. Estes são particularmente úteis quando o novo valor é calculado a partir do antigo. Os exemplos seguintes utilizam o `mutate,` um destes dois métodos, para atrasar o primeiro vôo carregado em 15 minutos:

```typescript
this.flights.mutate(f => {
  const flight = f[0];
  flight.date = addMinutes(flight.date, 15);
});
```

A expressão lambda esperada pelo `mutate` pega o valor atual e o atualiza. Para retornar um novo valor baseado no antigo, você pode usar o update:

```typescript
this.flights.update(f => {
  const flight = f[0];
  const date = addMinutes(flight.date, 15);
  const updated = {...flight, date};

  return [
    updated,
    ...f.slice(1)
  ];
});
```

Logicamente, os exemplos nas duas listas anteriores levam ao mesmo resultado: o primeiro vôo é atrasado. De um ponto de vista técnico, porém,  `update`  permite trabalhar com imutáveis que são aplicados por algumas bibliotecas como a NGRX por razões de desempenho.

Para o desempenho do data binding baseado em Signals, no entanto, é irrelevante se é usada `mutate`  ou  `update`. Em ambos os casos, o signal notifica seus consumers(consumidores).

### Calculated Values, Side Effects(Efeitos colaterais), e Assertions

Alguns valores são derivados de valores existentes.  Angular fornece signals calculados para isso:
```typescript
flightRoute = computed(() => this.from() + ' to ' + this.to());
```

Esse  signal é somente leitura e aparece tanto como consumer quanto como producer. Como consumer, ele recupera os valores dos signals utilizados - aqui 'from' e 'to' - e é informado sobre as mudanças. Como producer, ele retorna um valor calculado.

Se você quiser consumir signals programaticamente, você pode utilizar a função `effect`:

```typescript
effect(() => {
  console.log('from:', this.from());
  console.log('route:', this.flightRoute());
});
```

A`effect function` executa a expressão lambda transferida e se registra como Consumer com os signals utilizados. Assim que um destes signals muda, o side effect introduzido desta forma é novamente desencadeado.

A maioria dos consumers usa mais de um signal. Se estes signals mudarem um após o outro, poderão ocorrer resultados intermediários indesejados. Vamos imaginar que mudamos o filtro de busca  `Hamburg - Graz`  para  `London - Paris`:

```typescript
setTimeout(() => {
  this.from.set('London');
  this.to.set('Paris');
}, 2000);
```
Aqui, `London - Graz` pode vir imediatamente após o setting  para `London`.  Como muitas outras implementações do Signal, a implementação do Angular evita tais ocorrências.  O [readme](https://github.com/angular/angular/blob/71d5cdae195f916e345d977f1f23f9490e09482e/packages/core/src/signals/README.md) da equipe Angular, que também explica o algoritmo push/pull usado, chama essa garantia desejável de "glitch-free"("livre de falhas").



### RxJS Interoperabilidade 

É certo que, à primeira vista, os signals são muito semelhantes a um mecanismo que a Angular vem utilizando há muito tempo, ou seja, os observables RxJS. Entretanto, os signals são deliberadamente mantidos mais simples e são suficientes em muitos casos.

Para todos os outros casos, os signals podem ser combinados com os observables. No momento em que este artigo foi escrito, houve um [pull request](https://github.com/angular/angular/pull/49154) de um membro do team core que estende os signals com duas funções simples que proporcionam interoperabilidade com o RxJS: A função  `fromSignal`  converte um signal em um observable, e `fromObservable` faz o oposto.

Os exemplos a seguir ilustram a utilização desses dois métodos, expandindo o exemplo mostrando uma busca type-ahead:  

```typescript
@Component([…])
export class FlightSearchComponent {
  private flightService = inject(FlightService);

  // Signals
  from = signal('Hamburg');
  to = signal('Graz');
  basket = signal<Record<number, boolean>>({ 1: true });
  urgent = signal(false);

  flightRoute = computed(() => this.from() + ' to ' + this.to());
  loading = signal(false);

  // Observables
  from$ = fromSignal(this.from);
  to$ = fromSignal(this.to);

  flights$ = combineLatest({ from: this.from$, to: this.to$ }).pipe(
    debounceTime(300),
    tap(() => this.loading.set(true)),
    switchMap((combi) => this.flightService.find(combi.from, combi.to)),
    tap(() => this.loading.set(false))
  );

  // Observable as Signal
  flights = fromObservable(this.flights$, []);

}
```

O exemplo converte os signals  `from` e `to` em observables `from$` e `to$` e os combina com `combineLatest`. Assim que um dos valores muda, o debouncing ocorre e os voos são então carregados. Enquanto isso, o exemplo define o signal `loading`. O exemplo converte o observable  resultante em um signal. Assim, o template mostrado acima não precisa ser alterado.

### NGRX e outras Stores?

Até agora, nós criamos e gerenciamos diretamente os Signals. Entretanto, stores como a NGRX proporcionarão alguma conveniência adicional.


De acordo com declarações da equipe da NGRX, eles estão trabalhando no apoio aos Signals. Para a store NGRX, a seguinte briding function pode ser encontrada em uma primeira sugestão do conhecido membro da equipe [Brandon Roberts](https://twitter.com/brandontroberts/status/1626364526449795073):

```typescript
flights = fromStore(selectFlights);
```
Aqui, a função  `fromStore`  captura a store via  `inject`  e recupera os dados com o selector  `selectFlights`. Internamente, NGRX retorna esta data como Observables. No entanto, a função  `fromStore`  converte converte o observable para um signal e o retorna.

### Conclusão

Os signals tornam o Angular mais leve e apontam o caminho para um futuro sem Zone.js. Eles permitem que a Angular descubra diretamente os componentes que precisam ser atualizados.

A equipe da Angular permanece fiel a si mesma: Os Signals não são escondidos na subestrutura ou atrás de proxies, mas são explícitos. Portanto, os desenvolvedores sempre sabem com qual estrutura de dados estão lidando de fato. Além disso, os Signals são apenas uma opção. Ninguém precisa mudar o código legado e será possível uma combinação de detecção de mudança tradicional e de detecção de mudança baseada em Signals.

Em geral, deve-se observar que os Signals ainda estão em uma fase inicial e serão adicionados com o Angular 16 como uma prévia do desenvolvedor. Isto permite que os primeiros desenvolvedores experimentem o conceito e forneçam feedback. Com isto, também, a equipe da Angular prova que a estabilidade do ecossistema é importante para eles - uma razão importante pela qual muitos grandes projetos empresariais confiam no framework criado pelo Google.

Este texto é uma tradução do artigo [Signals in Angular: The Future of Change Detection](https://www.angulararchitects.io/aktuelles/angular-signals/)