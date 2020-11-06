---
layout: post
title: "A Importância da imutabilidade em aplicações Angular"
date: 2020-11-06 15:30:26
seo-image: '/assets/img/post-06-nov-2020/imutabilidade.png'
description: "Em aplicações Angular, o termo imutabilidade é mencionado principalmente quando você lida com a estratégia OnPush de detecção de mudanças. Padrões de atualização mutáveis podem não só impedir que você tire proveito da diminuição de uma árvore de componentes sujeitos à detecção de mudança, mas também levar a bugs/pegadinhas difíceis de detectar."

---

**Em aplicações Angular, o termo imutabilidade é mencionado principalmente quando você lida com a estratégia OnPush de detecção de mudanças. Padrões de atualização mutáveis podem não só impedir que você tire proveito da diminuição de uma árvore de componentes sujeitos à detecção de mudança, mas também levar a bugs/pegadinhas difíceis de detectar. Uma tradução de ["Immutability importance in Angular applications"](https://indepth.dev/immutability-importance-in-angular-applications/)**

Com o advento do [Redux](https://redux.js.org/), padrões imutáveis de atualização se tornaram muito populares. Em poucas palavras, a idéia é criar um novo objeto em vez de alterar o existente quando for necessário realizar uma ação de atualização. Quando se trata de aplicações Angular, o termo imutabilidade é mencionado principalmente quando você lida com  [**a estratégia OnPush de detecção de mudanças**](https://angular.io/api/core/ChangeDetectionStrategy), a fim de melhorar o desempenho em tempo de execução 🚀.

No entanto, a adesão a padrões de atualização mutáveis pode não só impedir que você aproveite a redução de uma árvore de componentes submetida ao processo de detecção de mudanças, mas também levar a alguns bugs/pegadinhas difíceis de detectar.

Neste post, vou abordar as consequências de não seguir a abordagem recomendada de utilizar estruturas de dados imutáveis.

## Exemplo

Vamos supor que você queira fazer uma lista de desenvolvedores, onde cada um deles tem as seguintes propriedades:

```typescript
export interface Dev {
  id: number;
  name: string;
  skill: number;
}
```

É necessário renderizar _name_, _skill_ e nível de senioridade, computados com base no valor _skill_, para cada entidade:

![](https://admin.indepth.dev/content/images/2020/10/image-28.png)

Além disso, você pode alterar a propriedade _skill_ usando os botões de ação:

```html
<div class="card-deck">
  <app-dev-card-v1 class="card" *ngFor="let dev of devs" [dev]="dev">
    <app-dev-actions (skillChange)="onSkillChange(dev.id, $event)">
    </app-dev-actions>
  </app-dev-card-v1>
</div>
```

Por padrão, a mudança é realizada de forma mutável:

```typescript
import { Component } from "@angular/core";
import { Dev } from "../../dev.model";

@Component({
  selector: "app-devs-list",
  templateUrl: "./devs-list.component.html"
})
export class DevsListComponent {
  // Variável que configura qual modo de mudança será usado,
  // vindo a forma mutável como padrão  
  public immutableUpdatesActive = false; 
  public devs: Dev[] = [
    { id: 1, name: "Wojtek", skill: 50 },
    { id: 2, name: "Tomek", skill: 80 }
  ];

  private skillDelta = 10;

  public onSkillChange(devId: number, increase: boolean): void {
    if (this.immutableUpdatesActive) {
      this.immutableChange(devId, increase);
    } else {
      this.mutableChange(devId, increase);
    }
  }
  // Método que faz a mudança no padrão imutável
  private immutableChange(devId: number, increase: boolean): void {
    const multiplier = increase ? 1 : -1;

    this.devs = this.devs.map(dev =>
      dev.id === devId
        ? {
            ...dev,
            skill: dev.skill + multiplier * this.skillDelta
          }
        : dev
    );
  }

  // Método que faz a mudança no padrão mutável
  private mutableChange(devId: number, increase: boolean): void {
    const dev = this.devs.find(({ id }) => id === devId);

    if (dev) {
      const multiplier = increase ? 1 : -1;

      dev.skill = dev.skill + multiplier * this.skillDelta;
    }
  }
}
```

----------

## Estratégia de detecção de mudanças

Por uma questão de simplicidade, vamos apenas renderizar o valor de _skill_ sem a informação do nível de senioridade:

![](https://admin.indepth.dev/content/images/2020/10/image-29.png)

Usando a **estratégia Default de detecção de mudanças** (que é habilitada, como o nome sugere, por padrão), tudo funciona como esperado, ou seja, **a view é atualizada uma vez que o modelo tenha mudado** clicando nos botões de ação ✔️.

```typescript
import { Component, Input } from "@angular/core";

import { Dev } from "../../../dev.model";

@Component({
  selector: "app-dev-card-v2",
  templateUrl: "./dev-card-v2.component.html"
})
export class DevCardV2Component {
  @Input() public dev: Dev;
}
```
Entretanto, você **não pode tirar vantagem da estratégia OnPush de detecção de mudanças se fizer uso de estruturas de dados mutáveis**:

```typescript
import { Component, Input, ChangeDetectionStrategy } from "@angular/core";

import { Dev } from "../../../dev.model";

@Component({
  selector: "app-dev-card-v1",
  templateUrl: "./dev-card-v1.component.html",
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DevCardV1Component {
  @Input() public dev: Dev;
}
```

**Agora, o template do card não será atualizado assim que você alterar o valor de _skill_ de um desenvolvedor, uma vez que ainda é o mesmo objeto JavaScript referenciado pela propriedade de entrada _dev_.** O Angular realiza uma *verificação referencial*, portanto, do ponto de vista do Angular, os dados não mudaram e não há necessidade de tomar medidas(Como atualizar a view, por exemplo).

## O ciclo de vida ngOnChanges

Existem situações em que é necessário realizar alguns cálculos para determinar o valor de um modelo usado na view uma vez que os dados do input tenham mudado. O Angular disponibiliza o hook⚓ de ciclo de vida __ngOnChanges__  ️para esses cenários:

```typescript
import { Component, Input, OnChanges, SimpleChanges } from "@angular/core";

import { Dev, SeniorityLevel } from "../../../dev.model";

@Component({
  selector: "app-dev-card-v3",
  templateUrl: "./dev-card-v3.component.html"
})
export class DevCardV3Component implements OnChanges {
  @Input() public dev: Dev;

  public seniorityLevel: SeniorityLevel;

  private get skill(): number {
    return this.dev.skill;
  }

  ngOnChanges(simpleChanges: SimpleChanges) {
    if (!simpleChanges.dev) {
      return;
    }

    this.seniorityLevel = this.getSeniorityLevel();
  }

  private getSeniorityLevel(): SeniorityLevel {
    if (this.skill < 40) {
      return SeniorityLevel.Junior;
    }

    if (this.skill >= 40 && this.skill < 80) {
      return SeniorityLevel.Regular;
    }

    return SeniorityLevel.Senior;
  }
}
```

**Se você usar a estratégia de detecção de mudança Default, o ciclo de vida _ngOnChanges_ não será invocado se você atualizar a propriedade do input _dev_ de forma mutável.** Mais uma vez, o Angular realiza uma verificação referencial por causa de desempenho. Isso pode levar a que dados obsoletos sejam apresentados na view.

## Usando Setter na propriedade Input

Como alternativa para aproveitar o ciclo de vida _ngOnChanges_ , você pode definir uma propriedade de input como um setter e realizar cálculos quando um novo valor é passado:

```typescript
import { Component, Input, OnChanges, SimpleChanges } from "@angular/core";

import { Dev, SeniorityLevel } from "../../../dev.model";

@Component({
  selector: "app-dev-card-v4",
  templateUrl: "./dev-card-v4.component.html"
})
export class DevCardV4Component {
  @Input() public set dev(val: Dev) {
    this._dev = val;
    this.seniorityLevel = this.getSeniorityLevel();
  }

  public get dev(): Dev {
    return this._dev;
  }

  public seniorityLevel: SeniorityLevel;

  private _dev: Dev;

  private get skill(): number {
    return this.dev.skill;
  }

  private getSeniorityLevel(): SeniorityLevel {
    if (this.skill < 40) {
      return SeniorityLevel.Junior;
    }

    if (this.skill >= 40 && this.skill < 80) {
      return SeniorityLevel.Regular;
    }

    return SeniorityLevel.Senior;
  }
}
```

Infelizmente, surgem os mesmos problemas que aparecem usando o ciclo de vida _ngOnChanges_.  **O setter não será chamado, já que a verificação referencial de uma propriedade(variável) atualizada de forma mutável indica que ela não foi alterada** 😢.

## Getter para dados da view

Se você não puder mudar facilmente para padrões de atualização imutáveis, uma maneira de resolver o problema de renderização de dados obsoletos é **calcular os dados do modelo em tempo real usando os getters**.

```typescript
import { Component, Input, OnChanges, SimpleChanges } from "@angular/core";

import { Dev, SeniorityLevel } from "../../../dev.model";
@Component({
  selector: "app-dev-card-v5",
  templateUrl: "./dev-card-v5.component.html"
})
export class DevCardV5Component {
  @Input() public dev: Dev;
	
  // Criado aqui o Getter pra view usar o valor correto
  public get seniorityLevel(): SeniorityLevel {
    console.log("seniorityLevel getter called");
    return this.getSeniorityLevel();
  }

  private get skill(): number {
    return this.dev.skill;
  }

  private getSeniorityLevel(): SeniorityLevel {
    if (this.skill < 40) {
      return SeniorityLevel.Junior;
    }

    if (this.skill >= 40 && this.skill < 80) {
      return SeniorityLevel.Regular;
    }

    return SeniorityLevel.Senior;
  }
}
```

Entretanto, você ainda não pode fazer uso da estratégia *OnPush* de detecção de mudança para o componente. Além disso, **o getter é chamado durante cada ciclo de detecção de mudança**, portanto, para cálculos pesados você deve considerar fazer uso da técnica **memoization** 📝.

## O ciclo de vida ngDoCheck 

Outra opção é realizar cálculos no hook⚓ do ciclo de vida _ngDoCheck_ . É considerado como um último recurso, uma vez que, de forma semelhante aos getters, **é invocado durante cada ciclo de detecção de mudanças**:

```typescript
import { Component, DoCheck, Input } from "@angular/core";

import { Dev, SeniorityLevel } from "../../../dev.model";

@Component({
  selector: "app-dev-card-v6",
  templateUrl: "./dev-card-v6.component.html"
})
export class DevCardV6Component implements DoCheck {
  @Input() public dev: Dev;

  public seniorityLevel: SeniorityLevel;

  private get skill(): number {
    return this.dev.skill;
  }

  ngDoCheck() {
    console.log("ngDoCheck called");
    this.seniorityLevel = this.getSeniorityLevel();
  }

  private getSeniorityLevel(): SeniorityLevel {
    if (this.skill < 40) {
      return SeniorityLevel.Junior;
    }

    if (this.skill >= 40 && this.skill < 80) {
      return SeniorityLevel.Regular;
    }

    return SeniorityLevel.Senior;
  }
}
```

Note que [o hook do ciclo de vida *ngDoCheck* é chamado para um componente com a estratégia *OnPush* de detecção de mudança também](https://indepth.dev/if-you-think-ngdocheck-means-your-component-is-being-checked-read-this-article/). Entretanto, ainda não é possível aplicá-lo ao componente do card, uma vez que seu template(view) não será atualizado - **para atualizar os bindings de um componente no DOM , ele deve estar sujeito ao processo de detecção de mudança**.

## Pipes puros

**A melhor maneira de calcular um valor que será usado na view é fazer uso de um [pipe puro](https://indepth.dev/the-essential-difference-between-pure-and-impure-pipes-in-angular-and-why-that-matters/)** (habilitado por padrão). Você obtém a memoization 📝 fora da caixa e pode facilmente compartilhar uma lógica comum entre diferentes partes de sua aplicação:

```typescript
import { Pipe, PipeTransform } from "@angular/core";

import { SeniorityLevel } from "../../dev.model";

@Pipe({
  name: "seniorityLevel"
})
export class SeniorityLevelPipe implements PipeTransform {
  transform(skill: number): SeniorityLevel {
    return this.getSeniorityLevel(skill);
  }

  private getSeniorityLevel(skill: number): SeniorityLevel {
    if (skill < 40) {
      return SeniorityLevel.Junior;
    }

    if (skill >= 40 && skill < 80) {
      return SeniorityLevel.Regular;
    }

    return SeniorityLevel.Senior;
  }
}
```

Agora, o componente do card fica pequenininho:

```typescript
import { Component, Input } from "@angular/core";

import { Dev } from "../../../dev.model";

@Component({
  selector: "app-dev-card-v7",
  templateUrl: "./dev-card-v7.component.html"
})
export class DevCardV7Component {
  @Input() public dev: Dev;
}
```

```html
<div class="card-body">
  <h5 class="card-title">{{dev.name}}</h5>
  <p class="card-text">
    Skill value: <span class="badge badge-pill badge-primary">{{dev.skill}}</span>
  </p>
  <p class="card-text">
    Seniority level: 
    <span class="badge badge-primary">
      {{dev.skill | seniorityLevel}}
    </span>
  </p>
  <ng-content></ng-content>
</div>
```

**A abordagem não leva a cálculos desnecessários, já que o método _transform_ só é chamado uma vez que o valor de _skill_ foi alterado 🏆.** Mesmo assim, você ainda não pode fazer uso da estratégia OnPush de detecção de mudanças .

## Conclusões

Sem dúvida, você deve **aderir a estruturas de dados imutáveis em aplicações Angular**. Isso não só permite melhorar o desempenho em tempo de execução usando a estratégia *OnPush* de detecção de mudanças, mas também evita que você tenha problemas de ter dados obsoletos apresentados na sua view.

Mas, você pode acabar em uma situação em que precisa corrigir rapidamente um bug e não pode fazer uma refatoração, ou seja, mudar para os padrões de atualização imutáveis. Nesses cenários, vale a pena ter em mente soluções baseadas em *getters*, o ciclo de vida _ngDoCheck_ e pipes puros. Como outra alternativa, você pode calcular o valor do modelo que será usado na view com antecedência e passar dados já prontos diretamente para um componente.

Fique à vontade para brincar com os exemplos:


<figure class="video_container">
  <iframe src="https://stackblitz.com/edit/ng-immutability-wt?embed=1&file=src/app/dev/devs-list/devs-list.component.ts&theme=dark"  width="750px" height="450px" > </iframe>
</figure>

Espero que tenham gostado do post e tenham aprendido algo novo 👍.

