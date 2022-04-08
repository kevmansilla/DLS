module Basica.Ejemplo where
import Basica.Escher
import Dibujo
import Interp

type Basica = Escher

ejemplo :: Dibujo Basica
ejemplo = escher 2 True

interpBas :: Output Basica
interpBas True = trian2