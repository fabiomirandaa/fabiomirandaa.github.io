---
layout: post
title: "Finalmente saiu o Angular 9! Confira as novidades"
seo-image: 'assets/img/post-06-fev-2020/novidades-angular-9.png'
---

Depois de uma longa espera, finalmente foi lançado o Angular versão 9, com o tão aguardado Ivy!

De todos os updates do Angular nesses anos, esse é o maior deles. Eles reescreveram o motor do framework, e agora as coisas serão bem melhor.

## Como fazer pra atualizar

Primeiro, é necessário estar na última versão do Angular 8. Se sua aplicação já estiver no Angular 8, é só rodar o comando:

    ng update @angular/cli @angular/core

Então, após atualizar os pacotes é só verificar o [guia](https://angular.io/guide/updating-to-version-9) do Angular sobre as break changes que precisam de modificação no seu projeto.

## Novidades

Ivy agora é o compilador Default e com isso nós ganhamos:

- Bundles menores
- Melhor debugging
- Melhor checagem de tipos
- Melhor exposição dos erros(Era meio bosta até hoje, pra ser sincero)
- AOT agora é ativado por padrão

Além disso, com a nova versão do Angular, temos o suporte ao Typescript 3.7 e com isso ganhamos coisas como o MARAVILHOSO Optional Chaining. 

Só para quem ainda não sabe o que é o Optional Chaining, ele é basicamente um operador para tratar acessos a uma referência de um objeto encadeado. Um exemplo:

```typescript
const times = {
carioca: {
serieA :['Flamengo', 'Vasco']}
} as  any

const timesSerieB = times?.carioca?.serieB

console.log(timesSerieB); // Console: undefined
```
`timesSerieB` fica undefined em vez de estourar um erro =) 

Para mais detalhes, veja [aqui](https://blog.angular.io/version-9-of-angular-now-available-project-ivy-has-arrived-23c97b63cfa3) postagem oficial no Blog do Angular