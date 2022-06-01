# Grupo 11		
## Corrección		
	Tag o commit corregido:	lab-1
		
### Entrega y git		89.50%
	Informe (sin preguntas)	100.00%
	Commits de cada integrante	100.00%
	En tiempo y con tag correcto	100.00%
	Commits frecuentes y con nombres significativos	50.00%
	Responden adecuadamente las preguntas (33% cada una)	90.00%
### Funcionalidad		90.50%
	Combinadores (comp, cuarteto, etc.)	95.00%
	pureDib, mapDib, sem	100.00%
	Predicados	50.00%
	Chequeos de rot360, esFlip2, check	100.00%
	Interpretación geométrica	95.00%
	Escher	100.00%
### Modularización y diseño		80.00%
	El tipo Dibujo está bien definido	100.00%
	Usan sem en casi todo (hasta 3 funciones con pattern-matching esta bien).	100.00%
	Hacen reuso de código (utilizan las funciones ya definidas)	50.00%
	Reutilizan funciones de librería	100.00%
### Calidad de código		97.50%
	Estilo de línea (identación y tamaño)	100.00%
	Estructuras de código simples	100.00%
	El código está bien estructurado	100.00%
	Estilo de código (claridad de lectura)	90.00%
### Opcionales		
	Puntos estrella	100.00%
		
# Nota Final		9.72
		
		
# Comentarios		
		
- Los mensajes de los commits son bastante escuetos, deberían mejorarlos, y sobre todo vean de que sean todos en el mismo idioma.		
- No describieron el error de la pregunta 3		
- Los operadores deben usarse de manera infija (i.e. al medio)		
- Las funciones de interpretación de los predicados para casos de `Rotar`, `Rot45`, `Espejar` son la identidad		
- Las funciones `all_bool3` y `any_bool3` en realidad se pueden reemplazar por los operadores `(&&)` y `(||)`		
-  Usar `V.negate` en lugar de restar a `zero` en los vectores.		
- No son consistentes con el código, cuiden los espacios y demás.		
- Los nombres de los parámetros de la función `sem` dejan mucho que desear, hubiesen puesto algo como `sem bas rot r45...`		