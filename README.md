# Laboratorio 1: DSL en Haskell

Este lab propone la implementación de un lenguaje pequeño específico para una tarea muy concreta: combinar dibujos básicos para crear diseños más interesantes. A este tipo de lenguajes se los suele conocer como DSL (Domain Specific Language: lenguaje de dominio específico) porque están pensados para proveer abstracciones adecuadas para resolver problemas acotados a cierto ámbito.

## Proceso de desarrollo

El desarrollo del proyecto fue realizado en junto por los integrantes del grupo, en las clases de laboratorio y por medio de un canal en discord.

El primer objetivo fue completar el archivo `Dibujo.hs` donde se define el lenguaje como un tipo de datos polimórfico, la tarea consistía en dar las definiciones necesarias para operar e interpretar las figuras. Al principio fue bastante sencillo darse cuenta que hacia cada función, tuvimos algunas complicaciones al entender las funciones que se encargan de la manipulación de figuras básicas como `mapDib` y `sem` está última se encarga de la estructura general de la semántica, fue la que más dificultades nos presento en esté módulo debido a la cantidad de argumentos que presenta.

Luego pasamos a codear `Interp.hs` que se encarga de la interpretación y por medio de `Gloss` genera los gráficos. En está parte no tuvimos complicaciones, la consigna era bastante clara sobre lo que había que realizar, nos ayudo la implementación del triángulo que venía en el esqueleto para entender como funcionaban las operaciones con vectores.

Al implementar `Escher.hs` nos fue de gran ayuda el paper de Henderson ya que tenía un "pseudocódigo" de las funciones que teníamos que codear, solo nos encargamos de traducirlas a Haskell.

Tuvimos una complicación en la salida del dibujo ya que no era el adecuado debido a que definimos mal los casos bases de las funciones `lado` y `esquina`, lo pudimos solucionar agregando un campo `Vacia` a la estructura del dibujo en `Dibujo.hs` y con esto en `Interp.hs` agregamos la interpretación a la función `interp` para que pinte de blanco aplicándole la función `simple` para que exista una correspondencia de tipos.

## Modo de ejecución

Una vez clonado el repositorio desde *bitbuket*, debemos escribir las siguientes instrucciones por línea de comando para ejecutar el programa:

```
> $ cd grupo11_lab01_2022/

> $ ghc -o main Main.hs

> $ ./main
```

## Preguntas a responder

1. a) ¿Por qué están separadas las funcionalidades en los módulos indicados? Explicar detalladamente la responsabilidad de cada módulo.

Al estar separadas las funcionalidades en distintos módulos nos permite separar un problema en varias partes más sencillas y poder ver de forma más clara como interactúa el lenjuaje, la interpretación geométrica y los usos del lenguaje.

También permite testear las funcionalidades de los módulos de forma independiente. En `Dibujo.hs` se realiza la declaración de la sintaxis del lenguaje de figuras, definiendo los constructores del tipo **Dibujo** y las funciones que se pueden utilizar.

En `Interp.hs` se conforma la semántica, esto permite dar una interpretación geométrica usando vectores, y en `Escher.hs` es donde se define la estructura de nuestro DSL en base al paper de Henderson.

Por último, el archivo `Main.hs` permite linkear a los otros módulos y con el uso de la librería `Gloss` realizar el dibujo.

b) El código original no está del todo prolijo. ¿Harían alguna modificación a la partición en módulos dada? ¿Qué otros cambios creen necesarios? Justificar e implementar los cambios.

No implementaríamos ningún cambio, ya que nos parece adecuada la presentación de los módulos para ver como funcionan la sintaxis, semántica y usos que se le puede dar al lenguaje.

2. ¿Por qué las funciones básicas no están incluidas en la definición del lenguaje, y en vez es un parámetro del tipo?

Las funciones básicas no están incluidas en la definición del lenguaje debido a que se le puede dar cualquier interpretación. Es por ello que se utiliza un tipo abstracto polimorfico porque hay infinitas figuras y dar una definición básica depende del tipo de figura que se quiera crear.

3. Explique cómo hace Interp.grid para construir la grilla, explicando cada pedazo de código que interviene. ¡Ojo! Si mal no recuerdo hay un error sutil..


## Integrantes del grupo:

* López, Leandro.
* Mansilla, Kevin Gaston.
* Ramirez, Lautaro.

## Referencias

- http://learnyouahaskell.com/syntax-in-functions
- https://hoogle.haskell.org/
- https://eprints.soton.ac.uk/257577/1/funcgeo2.pdf
- http://shashi.biz/ijulia-notebooks/funcgeo/
