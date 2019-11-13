---
layout: post
title: "Entenda o flatmap, uma novidade no Javascript #JS #ES2019"
seo-image: '/assets/img/post-13-nov-2019/flatmap-es2019.png'
---

No [artigo anterior](http://fabiodemiranda.com.br/novidades-no-javascript!-na-es2019-vem-a%C3%AD-o-array.flat()-js-es2019/) eu falei um pouco sobre o uso do flat() em arrays. Hoje, eu vou falar um pouco sobre o FlatMap. O que é o FlatMap? É um Map com um Flat hahaha Sem brincadeira, é basicamente isso. É exatamente igual a um map seguido de um flat de nível 1, e vou mostrar como ele pode ser usado. 


Vou usar aqui de exemplo um array das últimas 5 partidas do Flamengo. O que eu desejo obter é um array com os últimos 5 gols que o Flamengo fez.

```javascript
let partidas = [
    {
    "partida": [
      {"time": "Flamengo", "gols": 1},
      {"time": "CSA", "gols": 0}
    ]
  },
  {
    "partida": [
      {"time": "Flamengo", "gols": 2},
      {"time": "Goias", "gols": 2}
    ]
  },
  {
    "partida": [
      {"time": "Flamengo", "gols": 4},
      {"time": "Corinthians", "gols": 1}
    ]
  },
    {
    "partida": [
      {"time": "Flamengo", "gols": 1},
      {"time": "Botafogo", "gols": 0}
    ]
  },
  {
    "partida": [
      {"time": "Flamengo", "gols": 3},
      {"time": "Bahia", "gols": 1}
    ]
  }
]
// Com FlatMap
let golsFlamengo = partidas.flatMap(({ partida }) => {
  return partida
  .filter(item => item.time === "Flamengo")
  .map(item => item.gols)
});

// Sem FlatMap
let golsFlamengo2 = partidas.map(item => {
  return item.partida
    .filter(item => item.time === "Flamengo")
    .map(item => item.gols);
})

console.log(golsFlamengo)
// Saída: [1,2,4,1,3]
console.log(golsFlamengo2)
// Saída: [[1], [2], [4], [1], [3]]
```

## Entendendo o que tá acontecendo

A gente pode ver que com o FlatMap nós temos basicamente um passo a menos, pois para obtermos o mesmo resultado ali onde demos o console.log na variável `golsFlamengo2` seria necessário dar um `flat(1)`, ficando mais ou menos assim:

```javascript
console.log(golsFlamengo2.flat(1));
// Saída: [1,2,4,1,3]
```  

## Quando usar e suporte atual dos navegadores

Bom, como o exemplo mostrou o FlatMap consegue fazer o "achatamento" de um nível e dependendo do cenário isso pode ser já o ideal. Mas, é importante conhecer bem as ferramentas e ver o que nos atende melhor. Há outros cenários onde poderemos usar o FlatMap e o Flat que abordei no artigo anterior e ter o melhor resultado.

Vale lembrar, que isso é uma das novidades do Javascript,  e por isso não há suporte em navegadores antigos. Atualmente quem já suporta essa funcionalidade são: Firefox 62+, Chrome 69+, Safari 12+ e Opera 52+. O NodeJs 11+ também já tem o Suporte!

Nos próximos artigos eu vou abordar mais novidades do Javascript e do Typescript. Fiquem ligados.

