---
layout: post
title: "Fazendo sua aplicação parecer mais rápida usando prefetching com NgRx"
seo-image: 'assets/img/post-03-set-2020/postagem-angular.png'
---

***O prefetching pode ser usado para fazer sua aplicação parecer mais rápida. Isto é trivial em uma aplicação que está usando uma Store NgRx global, já que a Store global é apenas um objeto de cache. Apenas criando uma action e ouvindo essa action em um Effect, podemos pré-carregar o cache.***

O NgRx pode ajudar a fazer sua aplicação parecer mais rápida. Como [Alex Okrushko](https://twitter.com/AlexOkrushko) mostrou em ["5 Dicas para melhorar a experiência do usuário de sua aplicação angular com NgRx"](https://medium.com/angular-in-depth/5-tips-to-improve-user-experience-of-your-angular-app-with-ngrx-6e849ca99529#f7bd), você pode usar uma Store Global NgRx como cache para exibir dados requisitados (em cache) instantaneamente em vez de esperar por uma resposta do servidor.

Em vez de apresentar aos seus usuários uma tela em branco enquanto uma solicitação HTTP está pendente, outra opção (melhor) é mostrar os dados que já estão disponíveis na Store Global (um cache). Se for necessário, você pode recuperar os dados em segundo plano para atualizar os dados em cache.

Mas e se for a primeira vez que o usuário navega para a página? Nenhum dado estará disponível, e a aplicação ainda parecerá lenta.

Para garantir uma experiência suave do usuário, podemos pré-configurar os dados antes que uma navegação ocorra.

## A experiência inicial

Como ponto de partida, usamos o Tour of Heroes como um exemplo.
O exemplo contém um dashboard com os heróis, e tem uma página de detalhes para cada herói.

Sem a Store global, a navegação entre as views parece lenta e, portanto, não proporciona uma boa experiência. Isto ocorre porque os dados são (re)buscados em cada navegação.

Podemos fazer melhor para a experiência dos nossos usuários.

![When a navigation occurs there's always a blank screen until the HTTP request resolves.](https://timdeschryver.dev/blog/making-your-application-feel-faster-by-prefetching-data-with-ngrx/images/initial.gif)

## Dados em cache

Quando armazenamos os dados dentro da store global, podemos usar esses dados quando a página é carregada.

Mas quando é a primeira vez que o usuário navega para uma página, ele ainda tem que olhar para uma tela em branco porque os dados ainda não estão disponíveis até que a requisição HTTP seja resolvida.
Isto é uma melhoria, mas isto tem que ser melhorado para nossos usuários.

![The second time that the page loads, the data from the global Store is used.](https://timdeschryver.dev/blog/making-your-application-feel-faster-by-prefetching-data-with-ngrx/images/ngrx.gif)

## Prefetching

É aqui que entram em ação os dados obtidos com prefetching.
Prefetching significa que o cache é construído em segundo plano antes que o usuário navegue para uma página. Esta técnica garante uma transição suave entre as páginas e uma melhor experiência para o usuário.

Se você já estiver usando NgRx, o prefetching é fácil de implementar porque a store global serve como cache. Como a maioria das coisas dentro de uma aplicação que está usando NgRx, tudo começa com uma action. Para iniciar o processo de prefetch, tudo o que temos que fazer é o dispatch de uma action.

Dependendo do caso de uso, você pode querer "pré fetar"(sei traduzir isso não haha) os dados o mais rápido possível ou então quando estiver quase certo de que o usuário precisa dos dados. Abstraí esta lógica em uma diretiva, ela emite um aviso para o consumer quando ele quer "pré fetar" os dados.

Para cobrir os dois casos, a diretiva emite um aviso quando:

- está carregada
- o usuário está com o mouse sobre ele

```typescript

@Directive({
  selector: '[prefetch]',
})
export class PrefetchDirective implements OnInit {
  @Input()
  prefetchMode: ('load' | 'hover')[] = ['hover'];
  @Output()
  prefetch = new EventEmitter<void>();

  loaded = false;

  ngOnInit() {
    if (this.prefetchMode.includes('load')) {
      this.prefetchData();
    }
  }

  @HostListener('mouseenter')
  onMouseEnter() {
    if (!this.loaded && this.prefetchMode.includes('hover')) {
      this.loaded = true;
      this.prefetchData();
    }
  }

  prefetchData() {
    if (navigator.connection.saveData) {
      return undefined;
    }
    this.prefetch.next();
  }
}

```

O primeiro caso de uso, para pré carregar os dados o mais rápido possível, é demonstrado no snippet abaixo.

Estamos na view do dashboard onde os itens mais populares são mostrados. Como o número de itens é limitado e temos a certeza de que o usuário navegará até um dos itens do dashboard, escolhemos carregar todos os detalhes do herói em segundo plano.

```typescript
@Component({
  selector: 'app-dashboard',
  template: `
    <h3>Top Heroes</h3>
    <div class="grid grid-pad">
      <a
        *ngFor="let hero of heroes$ | async"
        class="col-1-4"
        routerLink="/detail/{{ hero.id }}"
        (prefetch)="prefetch(hero.id)"
        [prefetchMode]="['load']"
      >
        <div class="module hero">
          <h4>{{ hero.name }}</h4>
        </div>
      </a>
    </div>
  `,
})
export class DashboardComponent {
  heroes$ = this.store.select(selectHeroesDashboard);
  constructor(private store: Store) {}

  prefetch(id) {
    this.store.dispatch(heroDetailLoaded({ id }));
  }
}
```
Se você der uma olhada na aba network no GIF abaixo, você pode ver que os detalhes são carregados uma vez que a lista de heróis é renderizada.

![All the hero details are loaded when we click on a hero, thus the details are instantly shown.](https://timdeschryver.dev/blog/making-your-application-feel-faster-by-prefetching-data-with-ngrx/images/ngrx-load.gif)


O segundo caso de uso é a página de resumo onde todos os heróis são listados. Como esta pode ser uma lista grande e não sabemos qual herói será clicado, escolhemos carregar os detalhes do herói uma vez que o usuário esteja com o mouse em cima.

Isto não é tão rápido quanto o exemplo anterior, mas é mais rápido do que antes, o outro lado positivo é que não buscamos dados em demasia.

> Nota: Esta é uma abordagem popular que é usada para geradores de sites estáticos.

<br/>

```typescript
@Component({
  selector: 'app-heroes',
  template: `
    <h2>My Heroes</h2>
    <ul class="heroes">
      <li *ngFor="let hero of heroes$ | async">
        <a routerLink="/detail/{{ hero.id }}" (prefetch)="prefetch(hero.id)">
          <span class="badge">{{ hero.id }}</span> {{ hero.name }}
        </a>
      </li>
    </ul>
  `,
})
export class HeroesComponent {
  heroes$ = this.store.select(selectHeroes)
  constructor(private store: Store) {}

  prefetch(id: number) {
    this.store.dispatch(heroDetailHovered({ id }));
  }
}
```

Se você prestar atenção à aba network no GIF abaixo, você pode ver que os detalhes do herói são requisitados quando você está com o mouse sobre um herói.

![The hero details are requested on hover, with as result that the details are shown directly.](https://timdeschryver.dev/blog/making-your-application-feel-faster-by-prefetching-data-with-ngrx/images/ngrx-hover.gif)

O Effect de requisitar os detalhes ouve a action `heroDetailLoaded` e a action `heroDetailHovered`, ficando mais ou menos assim:

```typescript
@Injectable()
export class HeroesEffects {
  detail$ = createEffect(() => {
    return this.actions$.pipe(
      // 👂 Ouve as duas actions
      ofType(heroDetailLoaded, heroDetailHovered),
      // ⚙ Carrega tudo em paralelo
      // @link https://rxjs.dev/api/operators/mergeMap
      mergeMap(({ id: heroId }) =>
        this.heroesService
          .getHero(heroId)
          .pipe(map((hero) => heroDetailFetchSuccess({ hero }))),
      ),
    )
  });

  constructor(private actions$: Actions, private heroesService: HeroService) {}
}
```

Como você deve ter percebido nos exemplos acima, os detalhes do herói são buscados todas as vezes, mesmo quando os detalhes já estejam na Store global. Isto nem sempre é o ideal.

Podemos ajustar o Effect para buscar apenas os detalhes do herói que não estão armazenados na Store, como mostrado em ["Comece a usar os Efeitos para isto"](https://timdeschryver.dev/blog/start-using-ngrx-effects-for-this).

```typescript
@Injectable()
export class HeroesEffects {
  detail$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(heroDetailLoaded, heroDetailHovered),
      concatMap((action) =>
        of(action).pipe(
          withLatestFrom(this.store.select(selectHeroDetail(action.id))),
        ),
      ),
      filter(([_action, detail]) => Boolean(detail) === false),
      mergeMap(([{ id: heroId }]) =>
        this.heroesService
          .getHero(heroId)
          .pipe(map((hero) => heroDetailFetchSuccess({ hero }))),
      ),
    )
  });

  constructor(
    private actions$: Actions,
    private store: Store,
    private heroesService: HeroService,
  ) {}
}
```

## Conclusão

O prefetching pode ser usado para fazer sua aplicação parecer mais rápida. Desde que você tenha um cache para gravar os dados, você pode usar esta técnica para melhorar a experiência do usuário.

Isto é muito fácil em uma aplicação que está usando uma Store NgRx global, já que a Store global é apenas um objeto de cache. Apenas criando uma ação e ouvindo essa ação dentro de um Efeito, podemos pré-carregar o cache.

Este artigo foi a tradução do artigo original em inglês ["Making your application feel faster by prefetching data with NgRx
"](https://indepth.dev/making-your-application-feel-faster-by-prefetching-data-with-ngrx/)