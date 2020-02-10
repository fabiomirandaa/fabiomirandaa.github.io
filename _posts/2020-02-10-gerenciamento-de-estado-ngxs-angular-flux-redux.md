---
layout: post
title: "Gerenciamento de Estado com NGXS - Parte 1"
seo-image: 'assets/img/post-10-fev-2020/gerenciamento-estado-parte-um.jpeg'
---

Vamos abordar em dois artigos o que é estado e gerenciamento de estado e como implementá-lo em NGXS. 

Antes de tudo, o que é o tal "Estado"?

### O Estado  

Quando eu interagia com a comunidade em 2015/2016 eu escutava muito sobre React e Redux. E junto com os dois, muita gente falava “Po, o maneiro é que dá pra gerenciar estado, né?”. E era estado pra cá e pra lá nas conversas e palestras, enquanto eu humilde no AngularJS ainda não entendia muito bem isso.

Em 2017, eu comecei a trabalhar com o atual Angular e aí continuava ouvindo sobre estado e gerenciamento de estado em eventos de front e nas comunidades online. Ouvia coisas como “Angular usa os observables do RxJS, nem precisa de redux e outras libs pra *gerenciar o estado*.”

As pessoas falavam com tamanha naturalidade que eu pensava que era óbvio demais e que com certeza tinha algo de errado comigo que ainda não entendia o que era isso. Mas, quando eu resolvi perguntar que diabos era isso, pouca gente sabia definir muito bem o que era o tal do *estado*.

Sinceramente, após pesquisar eu descobri que não há definições cravadas em pedra do que seja um estado, mas hoje eu consigo definir o estado com mais ou menos duas definições:

-   Snapshot do atual momento da sua aplicação
	- Erros sendo exibidos
	- Dados sendo mostrados na tela
	- Dados salvos no localStorage
	- etc
-   Momento atual de uma estrutura de dados pré-definida na aplicação, que pode sofrer modificações em diferentes locais.
	- Por exemplo, uma definição de um Objeto de Checkout numa aplicação de e-commerce, que dependendo do Step ele estará preenchido como você pré-determinou. 

### **Gerenciamento de Estado**

  

Agora que temos uma ideia do que seja o estado, o que é gerenciar esse estado?

Mais uma vez em pesquisas, eu descobri que não era algo definido, com uma explicação clara e amplamente aceita pela comunidade. Para falar a verdade, eu descobri que “gerenciamento de estado” é algo meio genérico. 

Posso dizer que *Gerenciamento de Estado* é mais ou menos a maneira com que nós arquitetamos nossa aplicação. Por isso, gerenciar estado envolve coisas como:

-   Paradigma de programação escolhido
	- Imperativo
	- Funcional
	- Reativo
-   Arquitetura
	- MVC
	- MVVM
	- Flux
	- etc
-   Designs Patterns
	- Singleton
	- Facade
	- Proxy
	- Decorator
	- etc
-   E outros elementos de design de software.

“Então, agora saquei que gerenciar estado é um conceito amplo e tudo mais. O que vem agora?”

### **Facebook e o Flux**
Pesquisando mais sobre o assunto eu cheguei a um caso interessante, e que talvez tenha sido o que despertou todas as discussões sobre o gerenciamento de estado no Frontend.

Lembra quando o Facebook lá pra 2011/2012 implementou o chat(Antes não tinha) e depois de um tempo acontecia de ás vezes você receber uma notificação como se tivesse mensagem, abrir a seção do chat e não ter nada? Nego ia seco achando que era mensagem da cremosa e nada.

Esse bug acontecia porque, segundo o Facebook,a implementação do MVC tinha chegado no limite e não dava mais pra escalar. Segundo eles a arquiterura estava mais ou menos assim:

![Arquitetura MVC do Facebook]({{ site.baseurl }}/assets/img/post-10-fev-2020/mvc-scale-facebook.png)

Alguns dizem que eles não tinham uma boa implementação do MVC, outros dizem que o MVC é realmente limitado e etc. Mas, isso é uma outra discussão.

O Facebook tem uma conferência anual para desenvolvedores, e em uma edição em 2014, eles apresentaram uma solução para a comunidade. O apresentado foi uma nova arquitetura diferente do MVC, chamada Flux:
![Arquitetura Flux]({{ site.baseurl }}/assets/img/post-10-fev-2020/flux-facebook.png)

Basicamente temos algumas estruturas nessa Arquitetura:  
  
-   **Store** 
	- É onde fica o estado da aplicação e sua lógica de negócios.
-   **Action** 
	- Classes que descrevem a ação que atualizará a Store(que contém o Estado). Elas precisam de uma propriedade de tipo e opcionalmente podem ter algum metadado para atualizar uma propriedade do estado.
-   **Dispatcher** 
	- É basicamente uma central para emitir os eventos e registrar callbacks. Então, a Store que registrou um callback no Dispatcher vai receber os dados quando houver a emissão de alguma ação com dados.
-   **View** 
	- É onde os usuários podem visualizar o estado atual que vem da Store e podem disparar ou não mais actions.

Além dessa estrutura, o Flux vem com 3 princípios:

**Única fonte de verdade**

Dados são armazenados e consultados em uma única árvore de dados.

**Estados são apenas “read only”**

Os estados são apenas para consulta. Assim, não há risco de uma chamada a API mudar os dados, por exemplo.

**Mudanças são feitas por funções puras**

Para fazer uma mudança no estado, é preciso disparar uma ação. Nós usamos o estado anterior para fazer uma mudança específica da ação e então retornamos um novo estado.

Vale lembrar que o Flux é uma arquitetura e não uma lib ou algo do tipo. No React, que é a lib usada pelo Facebook para criação da interface, foi criado o Redux como uma lib que implementa o Flux. É interessante notar, que o Flux é uma arquitetura baseada em princípios, então nada do que foi exposto é obrigatório de ser implementado exatamente como foi mostrado. Por isso, o próprio Redux e outras Libs, como o NGXS, trazem a implementação desses conceitos de maneira um pouco diferente.

### Aplicações feitas em Angular, precisam disso?

É muito comum ver alguns desenvolvedores que usam Angular falando que não há uma necessidade de libs de gerenciamento de estado. Eles estão certos e errados. Eu sei que é muito clichê, mas a resposta a essa pergunta depende das necessidades do projeto.

#### RxJS

É preciso lembrar que diferente do React e do Vue, o Angular é uma framework e por isso ele já vem com uma série de soluções e estruturas pré definidas, para que possamos trabalhar com ele. Além do maravilhoso Typescript ❤, o Angular traz consigo uma lib incrível de programação reativa.

Vou mostrar um exemplo simples de como gerenciar o estado de um simples componente no Angular:
```typescript
import { Component } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'my-app',
  template: `
    <p>
      Contador: {{ contador$ | async }}
      <button (click)="incrementar()">+</button>
      <button (click)="decrementar()">-</button>
    </p>
  `
})
export class AppComponent  {
  // Inicia o Estado com zero
  public contador$: BehaviorSubject<number> = new BehaviorSubject(0); 
 
  public incrementar(): void { // Altera nosso Estado aumentando um número
    this.contador$.next( this.contador$.getValue() + 1 );
  }

  public decrementar(): void { // Altera nosso Estado removendo um número
    this.contador$.next( this.contador$.getValue() - 1 );
  }
}
```

Aqui, nós temos um `BehaviorSubject` chamado contador que é iniciado com o valor `0` e assim o estado inicial desse componente sempre será `0`.

Cada clique em um dos botões da View chama uma função que pega o valor do estado atual, adiciona ou diminui um número e então altera o estado com o novo valor.

Nesse cenário pequeno, é totalmente desnecessário uma aplicação do Flux. Dependendo da quantidade de componentes e complexidade da aplicação, só o RxJS supre com tranquilidade a demanda por gerenciar alguns dados.

Mas, geralmente em aplicações maiores precisamos navegar entre vários componentes, usando *inputs* e *outputs* até ser possível modificar os dados com consistência num service, muitas vezes tornando a mutação dos dados algo muito complicado e que pode dar uma verdadeira dor de cabeça.

A imagem abaixo ilustra o que pode acontecer num cenário com e sem gerência de estado.

![Sem Gerenciamento de Estado vs Com Gerenciamento de Estado]({{ site.baseurl }}/assets/img/post-10-fev-2020/gerenciamento-ngxs.png)

Sem contar que por não usar uma lib específica para o gerenciamento de estado, nós perdemos coisas como:

-   Capacidade de debugar de onde vieram as últimas alterações
-   Capacidade de salvar o Estado no localstorage com facilidade
-   Padronização de código com a comunidade
-   Dificuldade de manutenção

No próximo artigo, vou mostrar como implementar o NGXS para gerenciamento de estado em Angular de maneira prática. Até mais.