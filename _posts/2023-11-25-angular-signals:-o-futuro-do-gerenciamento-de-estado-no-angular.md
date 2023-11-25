---
layout: post
title: "Angular Signals: O futuro do gerenciamento de estado no Angular"
date: 2023-11-25 00:14:18
seo-image: '/assets/img/post-25-nov-2023/angular-signals-o-futuro-do-gerenciamento-de-estado-no-angular.png'
description: "Angular Signals é uma nova funcionalidade introduzida no Angular 16 que está prestes a revolucionar a forma como a detecção de mudanças é tratada em aplicações Angular"
---


Angular Signals é uma nova funcionalidade introduzida no Angular 16 que está prestes a revolucionar a forma como a detecção de mudanças é tratada em aplicações Angular. Os Signals oferecem uma maneira mais granular e eficiente de rastrear alterações no estado, o que pode resultar em melhorias significativas de desempenho, especialmente em aplicações grandes e complexas.

## O que são Signals?

Um signal é um wrapper em torno de um valor que pode notificar consumers interessados quando esse valor é alterado. Signals podem conter qualquer valor, desde simples primitivos até estruturas de dados complexas. Os Signals podem ser graváveis(writable) ou somente leitura(read-only).

Os Signals são semelhantes aos Observables, mas há algumas diferenças chave. Primeiro, os Signals são projetados para serem usados para detecção de mudanças, enquanto os Observables são mais de propósito geral. Em segundo lugar, os Signals são imutáveis, o que significa que não podem ser alterados diretamente. Em vez disso, um novo signal deve ser criado com o valor atualizado. Isso torna os Signals mais fáceis de serem compreendidos e evita efeitos colaterais inesperados.

Aqui está um exemplo de como usar Signals em uma aplicação Angular:

```typescript
import { signal, computed } from '@angular/core';

export class AppComponent {
  count: WritableSignal<number> = signal(0);
  doubleCount: Signal<number> = computed(() => this.count() * 2);

  increment() {
    this.count.set(this.count() + 1);
  }

  decrement() {
    this.count.set(this.count() - 1);
  }
}
```

Neste exemplo, definimos dois signals: ´count´ e ´doubleCount´. O signal `count` é um signal gravável(writable), o que significa que seu valor pode ser alterado. O signal `doubleCount` é um signal computado, o que significa que seu valor é derivado do signal `count`.

A função `computed` recebe uma função de derivação como argumento. A função de derivação é chamada sempre que os signals dos quais ela depende são alterados. Neste caso, o signal `doubleCount` depende do signal `count`. Isso significa que o signal `doubleCount` será atualizado sempre que o signal `count` mudar.

Para usar os signals, podemos simplesmente nos inscrever neles. Por exemplo, poderíamos nos inscrever no signal doubleCount e atualizar o DOM sempre que seu valor mudar:

```html
<p>O double count é {{ doubleCount | async }}</p>
```

## Por que usar Signals?

Existem várias vantagens em utilizar signals em aplicações Angular:

1. **Desempenho:** Signals podem resultar em melhorias significativas de desempenho ao reduzir a quantidade de detecções de mudanças necessárias. Isso ocorre porque os signals são mais granulares do que o mecanismo atual de detecção de mudanças, que se baseia em dirty checking.

2. **Simplicidade:** Signals são mais fáceis de usar e compreender do que o mecanismo atual de detecção de mudanças. Isso acontece porque os signals são imutáveis e possuem uma API clara.

3. **Flexibilidade:** Signals podem ser utilizados para implementar uma variedade de padrões reativos diferentes, como signals derivados, memoização e carregamento preguiçoso.

## Casos de Uso Exclusivos para Signals:

Aqui estão alguns casos de uso exclusivos para signals em aplicações Angular:

1. **Sincronização de dados em tempo real:** Signals podem ser empregados para sincronizar dados em tempo real entre diferentes componentes em uma aplicação Angular. Isso é útil para construir aplicativos, como aplicativos de chat e painéis.

2. **Animação eficiente:** Signals podem ser utilizados para animar elementos de maneira eficiente em uma aplicação Angular. Isso acontece porque os signals podem ser usados para rastrear mudanças de estado e atualizar o DOM apenas quando necessário.

3. **Lazy loading:** Signals podem ser utilizados para implementar o Lazy loading de componentes e módulos em uma aplicação Angular. Isso pode aprimorar o desempenho das aplicações ao carregar apenas os componentes e módulos necessários.

## Casos Avançados de Uso para Signals

Além dos casos de uso listados anteriormente, os signals também podem ser empregados para implementar padrões de reatividade mais avançados, como:

1. **Máquinas de Estado:** Signals podem ser utilizados para implementar máquinas de estado em aplicações Angular. Isso é útil para construir aplicações complexas com vários estados.

2. **Interações de Interface do Usuário (UI):** Signals podem ser usados para implementar interações de interface do usuário mais complexas, como arrastar e soltar (drag-and-drop) e redimensionamento.

3. **Validação de Dados:** Signals podem ser utilizados para implementar validação de dados em aplicações Angular. Isso é útil para garantir que os dados inseridos pelos usuários sejam válidos.


## Exemplos de Uso de Signals

Aqui estão alguns exemplos de como utilizar signals em aplicações Angular:

Exemplo 1: Sincronização de Dados em Tempo Real

O exemplo a seguir demonstra como utilizar signals para sincronizar dados em tempo real entre dois componentes:

```typescript
import { signal } from '@angular/core';

export class ChatComponent {
  messages: Signal<string[]> = signal([]);

  sendMessage(message: string) {
    this.messages.push(message);
  }
}

export class MessageListComponent {
  messages: Signal<string[]> = signal([]);

  ngOnInit() {
    this.messages.subscribe(messages => {
      this.messages = messages;
    });
  }
}
```

Neste exemplo, o `ChatComponent` possui um signal chamado `messages` que contém uma array de mensagens. O `MessageListComponent` também possui um signal chamado `messages` que contém uma array de mensagens.

Quando o usuário envia uma mensagem no `ChatComponent`, o signal `messages` é atualizado. O `MessageListComponent`' está inscrito no signal `messages`, então ele é atualizado sempre que o signal `messages` é modificado. Isso garante que o `MessageListComponent` sempre exiba as mensagens mais recentes.

## Exemplo 2: Animação Eficiente

```typescript
import { signal } from '@angular/core';

export class AppComponent {
  // Define um Signal para o elemento a ser animado.
  element: Signal<HTMLElement> = signal(null);

  // Inscreve-se no Signal e atualiza o DOM conforme necessário.
  ngOnInit() {
    this.element.subscribe(element => {
      // Anima o elemento.
    });
  }

  // Atualiza o estado usando um Signal gravável.
  setElement(element: HTMLElement) {
    this.element.set(element);
  }
}

```

Neste exemplo, utilizamos um signal para rastrear o elemento a ser animado. Também nos inscrevemos no signal e atualizamos o DOM conforme necessário sempre que o signal emite. Por fim, usamos um signal gravável para atualizar o elemento a ser animado.

Para utilizar este exemplo, primeiro precisaríamos criar um modelo que contenha o elemento que desejamos animar. Por exemplo:

```html
<div id="my-element"></div>
```


Em seguida, precisaríamos injetar o AppComponent no seu componente e atribuir o elemento ao signal element. Por exemplo: 

```typescript
import { Component } from '@angular/core';
import { AppComponent } from './app.component';

@Component({
  selector: 'my-component',
  templateUrl: './my-component.component.html'
})
export class MyComponent {
  constructor(private appComponent: AppComponent) {}

  ngOnInit() {
    this.appComponent.element.set(document.getElementById('my-element'));
  }
}
```

Por fim, precisaríamos escrever o código para animar o elemento. Por exemplo: 

```typescript
import { animate, style } from '@angular/animations';

@Component({
  selector: 'my-component',
  templateUrl: './my-component.component.html',
  animations: [
    animate('1s', style({
      transform: 'translateY(100px)'
    }))
  ]
})
export class MyComponent {
  constructor(private appComponent: AppComponent) {}

  ngOnInit() {
    this.appComponent.element.set(document.getElementById('my-element'));
  }

  animate() {
    // Anima o elemento
    this.appComponent.element.value.classList.add('animated');
  }
}
```
Quando chamamos o método `animate()`, o elemento será animado para mover 100 pixels para baixo na página.

## Exemplo 3: Signals Derivados

O exemplo a seguir mostra como usar signals para implementar um signal derivado:

```typescript
import { signal, computed } from '@angular/core';

export class AppComponent {
  count: WritableSignal<number> = signal(0);
  isEven: Signal<boolean> = computed(() => this.count() % 2 === 0);

  increment() {
    this.count.set(this.count() + 1);
  }

  decrement() {
    this.count.set(this.count() - 1);
  }
}
```

Neste exemplo, o signal `isEven` é um signal derivado que depende do signal `count`. Sempre que o signal `count` é alterado, o signal `isEven` é atualizado de acordo.

O signal `isEven` pode então ser usado para renderizar elementos condicionalmente no DOM. Por exemplo, poderíamos renderizar uma cor diferente dependendo se o signal `isEven` é verdadeiro ou falso:

{% raw %}
```html
<p class="even" *ngIf="isEven | async">O count é even.</p>
<p class="odd" *ngIf="!isEven | async">O count é odd.</p>
```
{% endraw %}

## Exemplo 4: Memoização

O exemplo a seguir mostra como usar signals para implementar a memoização:

```typescript
import { signal, memoized } from '@angular/core';

export class AppComponent {
  // Utiliza o memoized para memoizar o resultado de uma computação cara.
  expensiveComputation: Signal<number> = memoized(() => {
    // Realiza uma computação cara aqui.
    return 123;
  });

  // Método para renderizar.
  render() {
    // Exibe o resultado da computação cara.
    return this.expensiveComputation();
  }
}
```

Neste exemplo, o signal `expensiveComputation` é um signal memoizado. Isso significa que o cálculo é realizado apenas uma vez, e o resultado é armazenado em cache. Chamadas subsequentes ao signal `expensiveComputation` simplesmente retornam o resultado em cache.

Isso pode ser útil para melhorar o desempenho de aplicações que realizam cálculos custosos.

## Exemplo 5: Lazy Loading

O exemplo a seguir mostra como utilizar signals para implementar o lazy loading:

```typescript
import { signal, lazy } from '@angular/core';

export class AppComponent {
  modules: Signal<Array<() => Promise<any>>> = signal([]);

  loadModule(moduleName: string) {
    const moduleLoader = lazy(() => import(`./modules/${moduleName}.module`));
    this.modules.push(moduleLoader);
  }
}
```

Neste exemplo, o signal `modules` contém uma array de funções que carregam módulos. Quando o usuário clica em um botão para carregar um módulo, o método `loadModule()` é chamado. Este método adiciona uma função de carregamento de módulo ao signal `modules`.

O signal `modules` é então inscrito. Sempre que o signal `modules` sofre alterações, as funções de carregamento de módulo são executadas. Isso carrega os módulos sob demanda.

## Conclusão

Angular Signals é um novo recurso poderoso que pode ser utilizado para aprimorar o desempenho, a simplicidade e a flexibilidade das aplicações Angular.

O texto é uma tradução do artigo [Angular Signals: The Future of State Management in Angular](https://blog.stackademic.com/angular-signals-the-future-of-state-management-in-angular-13fd60cec349)

