module AreaRnd where

import qualified Data.List as L
import qualified Data.Set as S
import qualified System.Random as R

import Geometry
import Area
import Random

xyInArea :: Area -> Rnd (X, Y)
xyInArea (x0, y0, x1, y1) = do
  rx <- randomR (x0, x1)
  ry <- randomR (y0, y1)
  return (rx, ry)

connectGrid' :: (X, Y) -> S.Set (X, Y) -> S.Set (X, Y) -> [((X, Y), (X, Y))] ->
                Rnd [((X, Y), (X, Y))]
connectGrid' (nx, ny) unconnected candidates acc
  | S.null candidates = return (L.map normalize acc)
  | otherwise = do
      c <- oneOf (S.toList candidates)
      -- potential new candidates:
      let ns = S.fromList $ neighbors (0, 0, nx-1, ny-1) c
          nu = S.delete c unconnected  -- new unconnected
          -- (new candidates, potential connections):
          (nc, ds) = S.partition (`S.member` nu) ns
      new <- if S.null ds
             then return id
             else do
                    d <- oneOf (S.toList ds)
                    return ((c, d) :)
      connectGrid' (nx, ny) nu (S.delete c (candidates `S.union` nc)) (new acc)

connectGrid :: (X, Y) -> Rnd [((X, Y), (X, Y))]
connectGrid (nx, ny) = do
  let unconnected = S.fromList [ (x, y) | x <- [0..nx-1], y <- [0..ny-1] ]
  -- candidates are neighbors that are still unconnected; we start with
  -- a random choice
  rx <- randomR (0, nx-1)
  ry <- randomR (0, ny-1)
  let candidates  = S.fromList [ (rx, ry) ]
  connectGrid' (nx, ny) unconnected candidates []

randomConnection :: (X, Y) -> Rnd ((X, Y), (X, Y))
randomConnection (nx, ny) = do
  rb  <- randomR (False, True)
  if rb
    then do
           rx  <- randomR (0, nx-2)
           ry  <- randomR (0, ny-1)
           return (normalize ((rx, ry), (rx+1, ry)))
    else do
           ry  <- randomR (0, ny-2)
           rx  <- randomR (0, nx-1)
           return (normalize ((rx, ry), (rx, ry+1)))

data HV = Horiz | Vert
  deriving (Eq, Show, Bounded)

fromHV :: HV -> Bool
fromHV Horiz = True
fromHV Vert  = False

toHV :: Bool -> HV
toHV True  = Horiz
toHV False = Vert

instance R.Random HV where
  randomR (a, b0) g = case R.randomR (fromHV a, fromHV b0) g of
                        (b, g') -> (toHV b, g')
  random = R.randomR (minBound, maxBound)

-- | Create a corridor, either horizontal or vertical, with
-- a possible intermediate part that is in the opposite direction.
mkCorridor :: HV -> ((X, Y), (X, Y)) -> Area -> Rnd [(X, Y)] {- straight sections of the corridor -}
mkCorridor hv ((x0, y0), (x1, y1)) b =
  do
    (rx, ry) <- xyInArea b
    -- (rx, ry) is intermediate point the path crosses
    -- hv decides whether we start in horizontal or vertical direction
    case hv of
      Horiz -> return [(x0, y0), (rx, y0), (rx, y1), (x1, y1)]
      Vert  -> return [(x0, y0), (x0, ry), (x1, ry), (x1, y1)]

-- | Try to connect two rooms with a corridor.
-- The condition passed to mkCorridor is tricky; there might not always
-- exist a suitable intermediate point if the rooms are allowed to be close
-- together ...
connectRooms :: Area -> Area -> Rnd [(X, Y)]
connectRooms sa@(_, _, sx1, sy1) ta@(tx0, ty0, _, _) =
  do
    (sx, sy) <- xyInArea sa
    (tx, ty) <- xyInArea ta
    let xok = sx1 < tx0 - 3
    let xarea = normalizeArea (sx1+2, sy, tx0-2, ty)
    let yok = sy1 < ty0 - 3
    let yarea = normalizeArea (sx, sy1+2, tx, ty0-2)
    let xyarea = normalizeArea (sx1+2, sy1+2, tx0-2, ty0-2)
    (hv, area) <- if xok && yok then fmap (\ hv -> (hv, xyarea)) (binaryChoice Horiz Vert)
                  else if xok   then return (Horiz, xarea)
                                else return (Vert, yarea)
    mkCorridor hv ((sx, sy), (tx, ty)) area