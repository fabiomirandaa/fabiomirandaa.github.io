---
layout: post
title: "A VERDADEIRA diferença entre os bindings [] e {{}} no Angular"
date: 2021-01-25 18:15:08
seo-image: '/assets/img/post-25-jan-2021/postagem-diferenca-bindings-angular.jpg'
description: "Uma das partes do Angular que a maioria dos desenvolvedores acha que entende, mas muitos não entendem, é a verdadeira natureza dos bindings `[]` e `{{}}`. Entenda de uma vez por todas isso."
---

Iniciando o ano, trago mais uma tradução. O link para o artigo original está abaixo. Qualquer correção, submetam um PR =)

Uma das partes do Angular que a maioria dos desenvolvedores acha que entende, mas muitos não entendem, é a verdadeira natureza dos bindings `[]` e {% raw %}`{{}}`{% endraw %}.

A falta de compreensão fundamental desses bindings pode se tornar uma questão importante quando se trabalha com templates e se tenta fazer com que eles façam exatamente o que queremos. Também pode ser a causa de passar uma quantidade desnecessária de horas tentando descobrir um bug.

Portanto, vou analisar exatamente o que esses dois bindings fazem, e o que é que muitos desenvolvedores não compreendem sobre eles.

Você provavelmente está familiarizado com o uso típico dos bindings {% raw %}`{{}}`{% endraw %} :

{% raw %}
```html
<h1>{{title}}</h1>
```
{% endraw %}

E provavelmente está familiarizado com o uso típico de `[]` ou bindings de propriedade: 

{% raw %}
```html
<img [src]="imgsrc">
```
{% endraw %}

Mas você realmente entende o que cada binding está fazendo? E por que os usamos nesta situação? Muitos, se não a maioria dos desenvolvedores sabem simplesmente usar {% raw %}`{{}}`{% endraw %} ao colocar texto em um elemento, e `[]` para binding de propriedades.

Mas você já se perguntou porque em reactive forms a propriedade `formControlName` não usa o binding  `[]`?

{% raw %}
```html
<input formControlName="title" >
```
{% endraw %}

Uma compreensão fundamental do que está acontecendo o ajudará a entender quando e por que você precisa usar `[]` ou {% raw %}`{{}}`{% endraw %} ou nada (como na propriedade `formControlName`).

Portanto, comecemos discutindo a diferença entre as duas linhas a seguir:

{% raw %}
```html
<img [src]="imgsrc">  
<img src="{{imgsrc}}">
```
{% endraw %}

Ambas realizarão a mesma coisa. Ambas definem o atributo `src` da tag de imagem.

Também é importante entender que ambas estão executando uma valoração na propriedade `imgsrc` que deve estar em seu componente. Em ambas, está sendo usado a sintaxe de expressão do Angular. Portanto, você pode fazer esse tipo de coisa a seguir:

{% raw %}
```html
<img [src]="'/images/' + name + '.png'">  
<img src="{{'/images/' + name + '.png'}}">
```
{% endraw %}

Esta é uma expressão que faz uma concatenação de string para finalmente chegar à URL da imagem, juntando o caminho do diretório raiz, um nome e uma extensão.

Note que você não pode misturar `[]` e {% raw %}`{{}}`{% endraw %} juntos no mesmo atributo, senão o Angular irá reclamar.

Então, qual é a diferença final entre os dois?

Resume-se a como eles funcionam. {% raw %}`{{}}`{% endraw %} é basicamente uma forma de inserção de strings. Você deve pensar nisso como simplesmente substituir a string HTML pelo valor do binding, e então o HTML é renderizado com o valor.

O binding de propriedade, `[]`, por outro lado, funciona de forma diferente. Você deve pensar nisso como manipulação do DOM *após* o HTML já ter sido processado pelo navegador.

Assim, o binding `[src]` realmente manipula a propriedade `src` do objeto de imagem, e *NÃO* o atributo `src` da tag `img`.

A razão disto importar é que o binding de propriedade - já que não é inserção de string - pode preservar os tipos de dados.

Considere a seguinte parte de um formulário:

{% raw %}
```html
<input formControlName="isVisible" name="isVisible" type="radio" value="true"> True  
<input formControlName="isVisible" name="isVisible" type="radio" value="false"> False
```
{% endraw %}

Este HTML não vincula a parte isVisible do formulário aos valores booleanos `true` e `false`. Se você achava que sim, você foi vítima das questões sutis com binding. Este código vincula a propriedade isVisible à string "true" (verdadeiro) ou à string "false" (falso). E qualquer string não vazia é verdadeira. Então, se você usou isso em uma expressão ngIf:

{% raw %}
```html
<h1 *ngIf="myForm.value.isVisible">Eu só estou visível se o radio button estiver setado como True</h1>
```
{% endraw %}

Isto não vai funcionar. O ngIf sempre avaliará como `true`(verdadeiro).
MAS, se você usar o binding de PROPRIEDADE:

{% raw %}
```html
<input formControlName="isVisible" name="isVisible" type="radio" [value]="true"> True  
<input formControlName="isVisible" name="isVisible" type="radio" [value]="false"> False
```
{% endraw %}

Então agora você está vinculando a propriedade isVisible a um booleano verdadeiro ou falso.

Mas você não pode fazer isso com o binding {% raw %}`{{}}`{% endraw %} 

{% raw %}
```html
<input formControlName="isVisible" name="isVisible" type="radio" value="{{true}}"> True  
<input formControlName="isVisible" name="isVisible" type="radio" value="{{false}}"> False
```
{% endraw %}

Isto produz o mesmo resultado que o primeiro exemplo. Em última análise, é apenas a string "verdadeira" e a string "falsa".

Essa é uma coisa fundamental que a maioria dos desenvolvedores Angular não entende. Os bindings de propriedades estão na verdade manipulando o DOM e conseguem preservar os tipos de dados. Os bindings de strings é a interpolação de strings do HTML e sempre resulta em strings.

Uma vez que você entende isto, você pode evitar muitos bugs potenciais.
Boa Codificação pra você.

Tradução do artigo ["The TRUE difference between \[\] and {{}} bindings in Angular"](https://medium.com/ngconf/the-true-difference-between-and-bindings-in-angular-1b9a854ea1d6)