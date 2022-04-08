module Interp where
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Graphics.Gloss.Geometry.Angle
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import Dibujo
type FloatingPic = Vector -> Vector -> Vector -> Picture
type Output a = a -> FloatingPic

-- el vector nulo
zero :: Vector
zero = (0,0)

half :: Vector -> Vector
half = (0.5 V.*)

-- comprender esta función es un buen ejericio.
hlines :: Vector -> Float -> Float -> [Picture]
hlines (x,y) mag sep = map (hline . (*sep)) [0..]
  where hline h = line [(x,y+h),(x+mag,y+h)] 

-- Una grilla de n líneas, comenzando en v con una separación de sep y
-- una longitud de l (usamos composición para no aplicar este
-- argumento)
grid :: Int -> Vector -> Float -> Float -> Picture
grid n v sep l = pictures [ls,translate 0 (l*toEnum n) (rotate 90 ls)]
  where ls = pictures $ take (n+1) $ hlines v sep l

-- figuras adaptables comunes
trian1 :: FloatingPic
trian1 a b c = line $ map (a V.+) [zero, half b V.+ c , b , zero]

trian2 :: FloatingPic
trian2 a b c = line $ map (a V.+) [zero, c, b,zero]

trianD :: FloatingPic
trianD a b c = line $ map (a V.+) [c, half b , b V.+ c , c]

rectan :: FloatingPic
rectan a b c = line [a, a V.+ b, a V.+ b V.+ c, a V.+ c,a]

simple :: Picture -> FloatingPic
simple p _ _ _ = p

fShape :: FloatingPic
fShape a b c = line . map (a V.+) $ [ zero,uX, p13, p33, p33 V.+ uY , p13 V.+ uY 
                 , uX V.+ 4 V.* uY ,uX V.+ 5 V.* uY, x4 V.+ y5
                 , x4 V.+ 6 V.* uY, 6 V.* uY, zero]    
  where p33 = 3 V.* (uX V.+ uY)
        p13 = uX V.+ 3 V.* uY
        x4 = 4 V.* uX
        y5 = 5 V.* uY
        uX = (1/6) V.* b
        uY = (1/6) V.* c

-- Dada una función que produce una figura a partir de un a y un vector
-- producimos una figura flotante aplicando las transformaciones
-- necesarias. Útil si queremos usar figuras que vienen de archivos bmp.
transf :: (a -> Vector -> Picture) -> a -> Vector -> FloatingPic
transf f d (xs,ys) a b c  = translate (fst a') (snd a') .
                             scale (magV b/xs) (magV c/ys) .
                             rotate ang $ f d (xs,ys)
  where ang = radToDeg $ argV b
        a' = a V.+ half (b V.+ c)

-- Función interp
interp :: Output a -> Output (Dibujo a)
interp f Vacia = simple blank
interp f (Basica x) = f x
interp f (Rotar x) = interp_rotar (interp f x)
interp f (Rot45 x) = interp_rot45 (interp f x)
interp f (Espejar x) = interp_espejar (interp f x) 
interp f (Encimar x y) = interp_encimar (interp f x) (interp f y)
interp f (Juntar i j x y) = interp_juntar i j (interp f x) (interp f y)
interp f (Apilar i j x y) = interp_apilar i j (interp f x) (interp f y)

-- funciones para la semántica
interp_rotar :: FloatingPic -> FloatingPic
interp_rotar f x y z = f (x V.+ y) z (zero V.- y) 

interp_rot45 :: FloatingPic -> FloatingPic
interp_rot45 f x y z = f (x V.+ (half(y V.+ z))) (half(y V.+ z)) (half(z V.- y))

interp_espejar :: FloatingPic -> FloatingPic
interp_espejar f x y z = f (x V.+ y) (zero V.- y) z 

interp_encimar :: FloatingPic -> FloatingPic -> FloatingPic
interp_encimar f g x y z= pictures[f x y z, g x y z ]

interp_juntar :: Int -> Int -> FloatingPic -> FloatingPic -> FloatingPic
interp_juntar i j f g x y z = pictures[f x y' z, g (x V.+ y') (r' V.* y) z]
  where a = fromInteger (toInteger i)
        b = fromInteger (toInteger j)
        r = a/(b+a)
        r' = b/(b+a)
        y' = r V.* y

interp_apilar :: Int -> Int -> FloatingPic -> FloatingPic -> FloatingPic
interp_apilar i j f g x y z = pictures[f (x V.+ z') y (r V.* z), g x y z']
  where a = fromInteger (toInteger i)
        b = fromInteger (toInteger j)
        r = a/(b+a)
        r' = b/(b+a)
        z' = r' V.* z