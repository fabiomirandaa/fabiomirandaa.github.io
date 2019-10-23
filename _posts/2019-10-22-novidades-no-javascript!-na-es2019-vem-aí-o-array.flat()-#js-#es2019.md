---
layout: post
title: "Novidades no Javascript! Na ES2019 vem aí o Array.flat() #JS #ES2019"
seo-image: '/assets/img/post-22-out-2019/array-flat-es2019.png'
---

Vou apresentar pra vocês as novidades do Javascript, e a novidade de hoje é como achatar sub-arrays em um único Array. Com esse artigo, se inicia mais uma série de artigos aqui!

Mas, vamos direto ao ponto. Com a ES2019 chegando aí, já temos implementado no Chrome essa facilidade para "achatar" arrays e deixar eles planos. Vamos a um exemplo de como funciona:

``` javascript
const timesGruposCarioca = [
    ["Flamengo", "Botafogo", "Bangu", "Cabofriense", "Boavista"],
    "Convidado 1", "Convidado 2",
    ["Volta Redonda", "Vasco", "Fluminense", "Resende", "Madureira"]
];
console.log(timesGruposCarioca);

// Saída: [Array(5), "Convidado 1", "Convidado 2", Array(5)]

const timesCariocas = timesGruposCarioca.flat();
console.log(timesCariocas);

// Saída: ["Flamengo", "Botafogo", "Bangu", "Cabofriense", "Boavista", "Convidado 1", "Convidado 2", "Volta Redonda", "Vasco", "Fluminense", "Resende", "Madureira"]
```

## Entendendo o que tá acontecendo

No código acima, nós podemos ver que o array inicial chamado `timesGruposCarioca` é um array que contém um outro nível com dois arrays e tem dois itens únicos na sua raiz. Esse é um array que contém os times que jogarão o carioca e está separado pelos dois grupos da competição. Na constante `timesCariocas` é feito o achatamento do array, conseguindo obter assim um array de único nível com todos os times cariocas que vão participar da elite da competição.

É interessante que você pode definir em qual nível você quer o achatamento. Digamos que você tivesse algo assim:

``` javascript
const groupedNumbers = [15, 24, [47, 50, [25, 59]]];
```

Se nesse caso você fizer apenas um `.flat()` sem definir valor de profundidade, a profundidade default é `1` e então nós teríamos algo assim:

``` javascript
const groupedNumbers = [15, 24, [47, 50, [25, 59]]].flat();
console.log(groupedNumbers);

// Saída: [15,24,47,50,[25,59]]
```

Então, se nós quisermos um array totalmente plano, nós só precisamos fazer isso:

``` javascript
const groupedNumbers = [15, 24, [47, 50, [25, 59]]].flat();
const megasenaNumbers = groupedNumbers.flat(2);
console.log(megasenaNumbers);

// Saída: [15,24,47,50,25,59]
```

Sério, isso é maravilhoso né? O nível de profundidade é você que escolhe, simplesmente pode colocar qualquer um!(Tá, se você botar o número de átomos do universo, vai ficar difícil né hahaha).

## Suporte atual dos navegadores e soluções com ES6/ES7

É preciso ter consciência que essa função é uma novidade no Javascript nativo e por isso pode ser que muitos navegadores ainda não deem suporte. Então, vou mostrar como isso pode ser feito com implementações que já temos na linguagem.

Usando nosso primeiro caso de achatamento de nível 1, ficaria assim em ES6:

``` javascript
const timesGruposCarioca = [
    ["Flamengo", "Botafogo", "Bangu", "Cabofriense", "Boavista"],
    "Convidado 1", "Convidado 2",
    ["Volta Redonda", "Vasco", "Fluminense", "Resende", "Madureira"]
];

const timesCariocas = timesGruposCarioca.reduce((accumulator, item) => accumulator.concat(item), []);

console.log(timesCariocas);

// Saída: ["Flamengo", "Botafogo", "Bangu", "Cabofriense", "Boavista", "Convidado 1", "Convidado 2", "Volta Redonda", "Vasco", "Fluminense", "Resende", "Madureira"]
```

Agora, para mais níveis o negócio começa a ficar doido. Precisa usar recursividade para fazer o achatamento, e ficaria mais ou menos assim: 

``` javascript
const groupedNumbers = [15, 24, [47, 50, [25, 59]]];

const megasenaNumbers = (function achatamentoMultiNivel(groupedNumbers) {
    return groupedNumbers.reduce((accumulator, item) =>
        Array.isArray(item) ?
        accumulator.concat(achatamentoMultiNivel(item)) :
        accumulator.concat(item), []);
})(groupedNumbers);

console.log(megasenaNumbers);

// Saída: [15,24,47,50,25,59]
```

Como puderam ver até é possível fazer com o que temos de maduro no Javascript atual, mas é muito mais difícil de ler e muito pouco clean code comparado ao novo método `.flat()` .

Em breve, trarei mais novidades do Javascript!

