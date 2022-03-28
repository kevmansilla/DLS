module Dibujo where

-- Definir el lenguaje (reemplazar `()` con lo que corresponda).
data Dibujo a = Basica a 
    | Rotar (Dibujo a) 
    | Espejar (Dibujo a) 
    | Rot45 (Dibujo a)
    | Apilar Int Int (Dibujo a) (Dibujo a)
    | Juntar Int Int (Dibujo a) (Dibujo a)
    | Encimar (Dibujo a) (Dibujo a)
    deriving (Show, Eq)

-- Composición n-veces de una función con sí misma.
comp :: (a -> a) -> Int -> a -> a
comp f 0 x = x
comp f n x = comp f (n-1) (f x) 

-- Rotaciones de múltiplos de 90.
r180 :: Dibujo a -> Dibujo a
r180 x = comp Rotar 2 x

r270 :: Dibujo a -> Dibujo a
r270 x = comp Rotar 3 x

-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) x y = Apilar 50 50 x y

-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) x y =  Juntar 50 50 x y

-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) x y = Encimar x y 

-- Dadas cuatro figuras las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto x y w z = (.-.) ((///) x y) ((///) w z) 

-- Una figura repetida con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a
encimar4 x = (///) ((///) (Rot45 x) (Rotar x)) ((///) (r180 x) (r270 x))

-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a
ciclar x = (.-.) ((///) (x) (Rotar x)) ((///) (r180 x) (r270 x))

-- Ver un a como una figura.
pureDib :: a -> Dibujo a
pureDib x = Basica x

-- map para nuestro lenguaje.
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib f (Basica x) = pureDib (f x)
mapDib f (Rotar x) = Rotar (mapDib f x)
mapDib f (Espejar x) = Espejar (mapDib f x)
mapDib f (Rot45 x) = Rot45 (mapDib f x)
mapDib f (Apilar i j x y) = Apilar i j (mapDib f x) (mapDib f y) 
mapDib f (Juntar i j x y) = Juntar i j (mapDib f x) (mapDib f y)
mapDib f (Encimar x y) = Encimar (mapDib f x) (mapDib f y)

-- Verificar que las operaciones satisfagan:
-- 1. mapDib id = id, donde id es la función identidad.
-- 2. mapDib (g ∘ f) = (mapDib g) ∘ (mapDib f).
-- Estructura general para la semántica (a no asustarse). Ayuda:
-- pensar en foldr y las definiciones de intro a la lógica

sem :: (a -> b) -> (b -> b) -> (b -> b) -> (b -> b) -> 
    (Int -> Int -> b -> b -> b) ->
    (Int -> Int -> b -> b -> b) ->
    (b -> b -> b) -> 
    Dibujo a -> b
sem f g h i j k l (Basica x) = f x
sem f g h i j k l (Rotar x) = g (sem f g h i j k l x)
sem f g h i j k l (Espejar x) = h (sem f g h i j k l x)
sem f g h i j k l (Rot45 x) = i (sem f g h i j k l x)
sem f g h i j k l (Apilar n m x y) = j n m (sem f g h i j k l x) (sem f g h i j k l y)
sem f g h i j k l (Juntar n m x y) = k n m (sem f g h i j k l x) (sem f g h i j k l y)
sem f g h i j k l (Encimar x y) = l (sem f g h i j k l x) (sem f g h i j k l y)

type Pred a = a -> Bool

-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por la figura básica indicada por el segundo argumento.
cambiar :: Pred a -> a -> Dibujo a -> Dibujo a
cambiar p n x = mapDib (\x -> if (p x) then n else x) x 

-- Alguna básica satisface el predicado.
-- anyDib :: Pred a -> Dibujo a -> Bool

-- Todas las básicas satisfacen el predicado.
-- allDib :: Pred a -> Dibujo a -> Bool

-- Los dos predicados se cumplen para el elemento recibido.
andP :: Pred a -> Pred a -> Pred a
andP p1 p2 x = p1 x && p2 x

-- Algún predicado se cumple para el elemento recibido.
orP :: Pred a -> Pred a -> Pred a
orP p1 p2 x = p1 x || p2 x

-- -- Describe la figura. Ejemplos:
-- --
-- desc (const "b") (Basica b) = "b"
-- --
-- desc (const "b") (Rotar (Basica b)) = "rot (b)"
-- --
-- desc (const "b") (Apilar n m (Basica b) (Basica b)) = "api n m (b)
-- (b)"

-- -- La descripción de cada constructor son sus tres primeros
-- -- símbolos en minúscula, excepto `Rot45` al que se le agrega el `45`.

desc :: (a -> String) -> Dibujo a -> String
desc f x = sem f descRot descEsp descRot45 descApi descJun descEnc x

descRot :: String -> String
descRot x = "Rot"++" "++"("++x++")"

descEsp :: String -> String
descEsp x = "Esp"++" "++"("++x++")"

descRot45 :: String -> String
descRot45 x = "Rot45"++" "++"("++x++")"

descApi :: Int -> Int -> String -> String -> String
descApi i j x y= "Api"++" "++"i"++" "++"j"++" "++"("++x++")"++" "++"("++y++")"

descJun :: Int -> Int -> String -> String -> String
descJun i j x y = "Jun"++" "++"i"++" "++"j"++" "++"("++x++")"++" "++"("++y++")"

descEnc :: String -> String -> String
descEnc x y = "Enc"++" "++"("++x++")"++" "++"("++y++")"

-- -- Junta todas las figuras básicas de un dibujo.
-- basicas :: Dibujo a -> [a]

-- -- Hay 4 rotaciones seguidas.

esRot360 :: Pred (Dibujo a)
esRot360 (Rotar(Rotar(Rotar(Rotar x)))) = True
esRot360 (Basica x) = False
esRot360 (Rotar x) = esRot360 x
esRot360 (Espejar x) = esRot360 x
esRot360 (Rot45 x) = esRot360 x
esRot360 (Apilar i j x y) = esRot360 x || esRot360 y
esRot360 (Juntar i j x y) = esRot360 x || esRot360 y
esRot360 (Encimar x y) = esRot360 x || esRot360 y

-- -- Hay 2 espejados seguidos.
esFlip2 :: Pred (Dibujo a)
esFlip2 (Espejar(Espejar x)) = True
esFlip2 (Basica x) = False
esFlip2 (Rotar x) = esFlip2 x
esFlip2 (Espejar x) = esFlip2 x
esFlip2 (Rot45 x) = esFlip2 x
esFlip2 (Apilar i j x y) = esFlip2 x || esFlip2 y
esFlip2 (Juntar i j x y) = esFlip2 x || esFlip2 y
esFlip2 (Encimar x y) = esFlip2 x || esFlip2 y

data Superfluo = RotacionSuperflua | FlipSuperfluo
               deriving (Show)

-- -- Aplica todos los chequeos y acumula todos los errores, y
-- -- sólo devuelve la figura si no hubo ningún error.
check :: Dibujo a -> Either [Superfluo] (Dibujo a)
check a | esRot360 a && esFlip2 a = Left [RotacionSuperflua,FlipSuperfluo]
        | esRot360 a = Left [RotacionSuperflua]
        | esFlip2 a = Left [FlipSuperfluo]
        | otherwise = Right a