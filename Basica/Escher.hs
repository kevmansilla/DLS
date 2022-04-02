module Basica.Escher where
import Graphics.Gloss
import Dibujo

-- Supongamos que eligen.
type Escher = Bool

-- El dibujoU.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = Encimar (Encimar (Espejar (Rot45 p)) (Rotar (Espejar (Rot45 p)))) 
                (Encimar (r180 (Espejar (Rot45 p))) (r270 (Espejar (Rot45 p))))

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = Encimar p (Encimar (Espejar (Rot45 p)) (r270 p))

-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 0 p = p 
esquina n p = cuarteto (esquina (n-1) p) 
                (lado (n-1) p) 
                (Rotar (lado (n-1) p)) 
                (dibujoU p)

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 0 p = p
lado n p = cuarteto (lado (n-1) p) 
                (lado (n-1) p) 
                (Rotar (dibujoT p)) 
                (dibujoT p)

-- Por suerte no tenemos que poner el tipo!
noneto p q r s t u v w x = Apilar 1 2
                        (Juntar 1 2 p (Juntar 1 1 q r))
                        (Apilar 1 1 (Juntar 1 2 s (Juntar 1 1 t u)) (Juntar 1 2 v (Juntar 1 1 w x)))

-- El dibujo de Escher: squarelimit
escher :: Int -> Escher -> Dibujo Escher
escher n p = noneto (esquina n (Basica p))
                (lado n (Basica p))
                (r270 (esquina n (Basica p)))
                (Rotar (lado n (Basica p)))
                (dibujoU (Basica p))
                (r270 (lado n (Basica p)))
                (Rotar (esquina n (Basica p)))
                (r180 (lado n (Basica p)))
                (r180 (esquina n (Basica p)))
