-- Copyright (c) 2008--2011 Andres Loeh
-- Copyright (c) 2010--2018 Mikolaj Konarski and others (see git history)
-- This file is a part of the computer game Allure of the Stars
-- and is released under the terms of the GNU Affero General Public License.
-- For license and copyright information, see the file LICENSE.
--
-- | Blast definitions.
module Content.ItemKindBlast
  ( blasts
  ) where

import Prelude ()

import Game.LambdaHack.Common.Prelude

import Game.LambdaHack.Common.Ability
import Game.LambdaHack.Common.Color
import Game.LambdaHack.Common.Dice
import Game.LambdaHack.Common.Flavour
import Game.LambdaHack.Common.Misc
import Game.LambdaHack.Content.ItemKind

blasts :: [ItemKind]
blasts =
  [burningOil2, burningOil3, burningOil4, firecracker1, firecracker2, firecracker3, firecracker4, firecracker5, spreadFragmentation, spreadFragmentation8, focusedFragmentation, spreadConcussion, spreadConcussion8, focusedConcussion, spreadFlash, spreadFlash8, focusedFlash, singleSpark, glassPiece, focusedGlass, fragrance, pheromone, mistCalming, odorDistressing, mistHealing, mistHealing2, mistWounding, distortion, smoke, boilingWater, glue, waste, mistAntiSlow, mistAntidote, mistSleep, denseShower, sparseShower, protectingBalmMelee, protectingBalmRanged, vulnerabilityBalm, resolutionDust, hasteSpray, slownessMist, eyeDrop, ironFiling, smellyDroplet, eyeShine, whiskeySpray, youthSprinkle, poisonCloud, blastNoSkMove, blastNoSkMelee, blastNoSkDisplace, blastNoSkAlter, blastNoSkWait, blastNoSkMoveItem, blastNoSkProject, blastNoSkApply, blastBonusSkMove, blastBonusSkMelee, blastBonusSkDisplace, blastBonusSkAlter, blastBonusSkWait, blastBonusSkMoveItem, blastBonusSkProject, blastBonusSkApply]
  -- Allure-specific
  ++ [cruiseAdHologram, outerAdHologram, victoriaClassHologram, allureIntroHologram]

burningOil2,    burningOil3, burningOil4, firecracker1, firecracker2, firecracker3, firecracker4, firecracker5, spreadFragmentation, spreadFragmentation8, focusedFragmentation, spreadConcussion, spreadConcussion8, focusedConcussion, spreadFlash, spreadFlash8, focusedFlash, singleSpark, glassPiece, focusedGlass, fragrance, pheromone, mistCalming, odorDistressing, mistHealing, mistHealing2, mistWounding, distortion, smoke, boilingWater, glue, waste, mistAntiSlow, mistAntidote, mistSleep, denseShower, sparseShower, protectingBalmMelee, protectingBalmRanged, vulnerabilityBalm, resolutionDust, hasteSpray, slownessMist, eyeDrop, ironFiling, smellyDroplet, eyeShine, whiskeySpray, youthSprinkle, poisonCloud, blastNoSkMove, blastNoSkMelee, blastNoSkDisplace, blastNoSkAlter, blastNoSkWait, blastNoSkMoveItem, blastNoSkProject, blastNoSkApply, blastBonusSkMove, blastBonusSkMelee, blastBonusSkDisplace, blastBonusSkAlter, blastBonusSkWait, blastBonusSkMoveItem, blastBonusSkProject, blastBonusSkApply :: ItemKind
-- Allure-specific
cruiseAdHologram,       outerAdHologram, victoriaClassHologram, allureIntroHologram :: ItemKind

-- We take care (e.g., in burningOil below) that blasts are not faster
-- than 100% fastest natural speed, or some frames would be skipped,
-- which is a waste of prefectly good frames.

-- * Parameterized blasts

burningOil :: Int -> ItemKind
burningOil n = ItemKind
  { isymbol  = '*'
  , iname    = "burning oil"
  , ifreq    = [(toGroupName $ "burning oil" <+> tshow n, 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = intToDice (4 + n * 4)
  , irarity  = [(1, 1)]
  , iverbHit = "sear"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity (min 100 $ n `div` 2 * 10)
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 2 ]
  , ieffects = [ Burn 1
               , toOrganBad "pacified" (1 `d` 2) ]
                   -- slips and frantically puts out fire
  , idesc    = "Sticky oil, burning brightly."
  , ikit     = []
  }
burningOil2 = burningOil 2  -- 2 steps, 2 turns
burningOil3 = burningOil 3  -- 3 steps, 2 turns
burningOil4 = burningOil 4  -- 4 steps, 2 turns
firecracker :: Int -> ItemKind
firecracker n = ItemKind
  { isymbol  = '*'
  , iname    = "firecracker"
  , ifreq    = [(toGroupName $ if n == 5
                               then "firecracker"
                               else "firecracker" <+> tshow n, 1)]
  , iflavour = zipPlain [brightCol !! ((n + 2) `mod` length brightCol)]
  , icount   = if n <= 3 then 1 `d` min 2 n else 2 + 1 `d` 2
  , irarity  = [(1, 1)]
  , iverbHit = if n >= 4 then "singe" else "crack"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine $ intToDice $ 1 + n `div` 2 ]
  , ieffects = [if n >= 4 then Burn 1 else RefillCalm (-2)]
               ++ [DropBestWeapon | n >= 4]
               ++ [ OnSmash $ Explode
                    $ toGroupName $ "firecracker" <+> tshow (n - 1)
                  | n >= 2 ]
  , idesc    = "Scraps of burnt paper, covering little pockets of black powder, buffeted by colorful explosions."
  , ikit     = []
  }
firecracker5 = firecracker 5
firecracker4 = firecracker 4
firecracker3 = firecracker 3
firecracker2 = firecracker 2
firecracker1 = firecracker 1

-- * Focused blasts

spreadFragmentation = ItemKind
  { isymbol  = '*'
  , iname    = "fragmentation burst"
  , ifreq    = [("violent fragmentation", 1)]
  , iflavour = zipPlain [Red]  -- flying shards; some fire and smoke
  , icount   = 16  -- strong but few, so not always hits target
  , irarity  = [(1, 1)]
  , iverbHit = "tear apart"
  , iweight  = 1
  , idamage  = 3 `d` 1  -- deadly and adjacent actor hit by 2 on average;
                        -- however, moderate armour blocks completely
  , iaspects = [ ToThrow $ ThrowMod 100 20 4  -- 4 steps, 1 turn
               , SetFlag Lobable, SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 3, AddSkill SkHurtMelee $ -12 * 5 ]
  , ieffects = [DropItem 1 maxBound COrgan "condition"]
  , idesc    = ""
  , ikit     = []
  }
spreadFragmentation8 = spreadFragmentation
  { iname    = "fragmentation burst"
  , ifreq    = [("fragmentation", 1)]
  , icount   = 8
  , iaspects = [ ToThrow $ ThrowMod 100 10 2  -- 2 steps, 1 turn
               , SetFlag Lobable, SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 3, AddSkill SkHurtMelee $ -12 * 5 ]
      -- smaller radius, so worse for area effect, but twice the direct damage
  }
focusedFragmentation = ItemKind
  { isymbol  = '`'
  , iname    = "deflagration ignition"  -- improvised fertilizer, etc.
  , ifreq    = [("focused fragmentation", 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = 4  -- 32 in total vs 16; on average 4 hits
  , irarity  = [(1, 1)]
  , iverbHit = "ignite"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toLinger 0  -- 0 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
      -- when the target position is occupied, the explosion starts one step
      -- away, hence we set range to 0 steps, to limit dispersal
  , ieffects = [OnSmash $ Explode "fragmentation"]
  , idesc    = ""
  , ikit     = []
  }
spreadConcussion = ItemKind
  { isymbol  = '*'
  , iname    = "concussion blast"
  , ifreq    = [("violent concussion", 1)]
  , iflavour = zipPlain [Magenta]  -- mosty shock wave; some fire and smoke
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "shock"
  , iweight  = 1
  , idamage  = 1 `d` 1  -- only air pressure, so not as deadly as fragmentation,
                        -- but armour can't block completely that easily
  , iaspects = [ ToThrow $ ThrowMod 100 20 4  -- 4 steps, 1 turn
               , SetFlag Lobable, SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 3, AddSkill SkHurtMelee $ -8 * 5 ]
      -- outdoors it has short range, but we only model indoors in the game;
      -- it's much faster than black powder shock wave, but we are beyond
      -- human-noticeable speed differences on short distances anyway
  , ieffects = [ DropItem maxBound 1 CEqp "misc armor"
               , PushActor (ThrowMod 400 25 1)  -- 1 step, fast; after DropItem
                   -- this produces spam for braced actors; too bad
               , DropItem 1 maxBound COrgan "condition"
               , toOrganBad "immobile" (2 + 1 `d` 2)   -- no balance
               , toOrganBad "deafened" (20 + 1 `d` 5) ]
  , idesc    = ""
  , ikit     = []
  }
spreadConcussion8 = spreadConcussion
  { iname    = "concussion blast"
  , ifreq    = [("concussion", 1)]
  , icount   = 8
  , iaspects = [ ToThrow $ ThrowMod 100 10 2  -- 2 steps, 1 turn
               , SetFlag Lobable, SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 3, AddSkill SkHurtMelee $ -8 * 5 ]
  }
focusedConcussion = ItemKind
  { isymbol  = '`'
  , iname    = "detonation ignition"  -- stabilized high explosive liquid
  , ifreq    = [("focused concussion", 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = 4
  , irarity  = [(1, 1)]
  , iverbHit = "ignite"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toLinger 0  -- 0 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [OnSmash $ Explode "concussion"]
  , idesc    = ""
  , ikit     = []
  }
spreadFlash = ItemKind
  { isymbol  = '`'
  , iname    = "magnesium flash"  -- or aluminum, but let's stick to one
  , ifreq    = [("violent flash", 1)]
  , iflavour = zipPlain [BrWhite]  -- very brigh flash
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "dazzle"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ ToThrow $ ThrowMod 100 20 4  -- 4 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 5 ]
  , ieffects = [toOrganBad "blind" 10, toOrganBad "weakened" 20]
                 -- Wikipedia says: blind for five seconds and afterimage
                 -- for much longer, harming aim
  , idesc    = "A flash of fire."
  , ikit     = []
  }
spreadFlash8 = spreadFlash
  { iname    = "spark"
  , ifreq    = [("spark", 1)]
  , icount   = 8
  , iverbHit = "blind"
  , iaspects = [ ToThrow $ ThrowMod 100 10 2  -- 2 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 5 ]
  }
focusedFlash = ItemKind
  { isymbol  = '`'
  , iname    = "magnesium ignition"
  , ifreq    = [("focused flash", 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = 4
  , irarity  = [(1, 1)]
  , iverbHit = "ignite"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toLinger 0  -- 0 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [OnSmash $ Explode "spark"]
  , idesc    = ""
  , ikit     = []
  }
singleSpark = spreadFlash
  { iname    = "single spark"
  , ifreq    = [("single spark", 1)]
  , icount   = 1
  , iverbHit = "spark"
  , iaspects = [ toLinger 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 3 ]
  , ieffects = []
  , idesc    = "A glowing ember."
  , ikit     = []
  }
glassPiece = ItemKind
  { isymbol  = '*'
  , iname    = "glass piece"
  , ifreq    = [("glass hail", 1)]
  , iflavour = zipPlain [Blue]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "cut"
  , iweight  = 1
  , idamage  = 2 `d` 1
  , iaspects = [ ToThrow $ ThrowMod 100 20 4  -- 4 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkHurtMelee $ -15 * 5 ]
                 -- brittle, not too dense; armor blocks
  , ieffects = []
  , idesc    = "Swift, sharp edges."
  , ikit     = []
  }
focusedGlass = glassPiece  -- when blowing up windows
  { ifreq    = [("focused glass hail", 1)]
  , icount   = 4
  , iaspects = [ toLinger 0  -- 0 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkHurtMelee $ -15 * 5 ]
  , ieffects = [OnSmash $ Explode "glass hail"]
  }

-- * Assorted non-temporary condition blasts

fragrance = ItemKind
  { isymbol  = '`'
  , iname    = "fragrance"  -- instant, fast fragrance
  , ifreq    = [("fragrance", 1)]
  , iflavour = zipPlain [Magenta]
  , icount   = 12
  , irarity  = [(1, 1)]
  , iverbHit = "engulf"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toLinger 10  -- 2 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [Impress, toOrganGood "rose-smelling" (40 + 1 `d` 20)]
  -- Linger 10, because sometimes it takes 2 turns due to starting just
  -- before actor turn's end (e.g., via a necklace).
  , idesc    = "A pleasant scent."
  , ikit     = []
  }
pheromone = ItemKind
  { isymbol  = '`'
  , iname    = "musky whiff"  -- a kind of mist rather than fragrance
  , ifreq    = [("pheromone", 1)]
  , iflavour = zipPlain [BrMagenta]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "tempt"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 10  -- 2 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [Dominate]
  , idesc    = "A sharp, strong scent."
  , ikit     = []
  }
mistCalming = ItemKind  -- unused
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [("calming mist", 1)]
  , iflavour = zipPlain [BrGreen]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "sooth"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [RefillCalm 2]
  , idesc    = "A soothing, gentle cloud."
  , ikit     = []
  }
odorDistressing = ItemKind
  { isymbol  = '`'
  , iname    = "distressing whiff"
  , ifreq    = [("distressing odor", 1)]
  , iflavour = zipFancy [BrRed]  -- salmon
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "distress"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toLinger 10  -- 2 steps, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [ RefillCalm (-10)
               , toOrganBad "foul-smelling" (20 + 1 `d` 5)
               , toOrganBad "impatient" (5 + 1 `d` 3) ]
  , idesc    = "It turns the stomach."  -- and so can't stand still
  , ikit     = []
  }
mistHealing = ItemKind
  { isymbol  = '`'
  , iname    = "mist"  -- powerful, so slow and narrow
  , ifreq    = [("healing mist", 1)]
  , iflavour = zipFancy [BrGreen]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "revitalize"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 1 ]
  , ieffects = [RefillHP 2]
  , idesc    = "It fills the air with light and life."
  , ikit     = []
  }
mistHealing2 = ItemKind
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [("healing mist 2", 1)]
  , iflavour = zipPlain [Green]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "revitalize"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast
               , AddSkill SkShine 2 ]
  , ieffects = [RefillHP 4]
  , idesc    = "At its touch, wounds close and bruises fade."
  , ikit     = []
  }
mistWounding = ItemKind
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [("wounding mist", 1)]
  , iflavour = zipPlain [BrRed]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "devitalize"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [RefillHP (-2)]
  , idesc    = "The air itself stings and itches."
  , ikit     = []
  }
distortion = ItemKind
  { isymbol  = 'v'
  , iname    = "vortex"
  , ifreq    = [("distortion", 1)]
  , iflavour = zipPlain [White]
  , icount   = 8  -- braced are immune to Teleport; avoid failure messages
  , irarity  = [(1, 1)]
  , iverbHit = "engulf"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toLinger 10  -- 2 steps, 1 turn
               , SetFlag Lobable, SetFlag Fragile, SetFlag Blast ]
  , ieffects = [Teleport $ 15 + 1 `d` 10]
  , idesc    = "The air shifts oddly, as though light is being warped."
  , ikit     = []
  }
smoke = ItemKind  -- when stuff burns out  -- unused
  { isymbol  = '`'
  , iname    = "smoke"
  , ifreq    = [("smoke", 1)]
  , iflavour = zipPlain [BrBlack]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "choke"  -- or "obscure"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 20  -- 4 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [toOrganBad "withholding" (5 + 1 `d` 3)]
                  -- choking and tears, can rougly see, but not aim
  , idesc    = "Twirling clouds of grey smoke."
  , ikit     = []
  }
boilingWater = ItemKind
  { isymbol  = '*'
  , iname    = "boiling water"
  , ifreq    = [("boiling water", 1)]
  , iflavour = zipPlain [White]
  , icount   = 18
  , irarity  = [(1, 1)]
  , iverbHit = "boil"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 30  -- 6 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [Burn 1]
  , idesc    = "It bubbles and hisses."
  , ikit     = []
  }
glue = ItemKind
  { isymbol  = '*'
  , iname    = "hoof glue"
  , ifreq    = [("glue", 1)]
  , iflavour = zipPlain [Cyan]
  , icount   = 8  -- Paralyze doesn't stack; avoid failure messages
  , irarity  = [(1, 1)]
  , iverbHit = "glue"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 20  -- 4 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [Paralyze 10]
  , idesc    = "Thick and clinging."
  , ikit     = []
  }
waste = ItemKind
  { isymbol  = '*'
  , iname    = "waste"
  , ifreq    = [("waste", 1)]
  , iflavour = zipPlain [Brown]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "splosh"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [ toOrganBad "foul-smelling" (30 + 1 `d` 10)
               , toOrganBad "dispossessed" (10 + 1 `d` 10) ]
  , idesc    = "Sodden and foul-smelling."
  , ikit     = []
  }
mistAntiSlow = ItemKind
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [("anti-slow mist", 1)]
  , iflavour = zipFancy [BrYellow]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "propel"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [DropItem 1 1 COrgan "slowed"]
  , idesc    = "A cleansing rain."
  , ikit     = []
  }
mistAntidote = ItemKind
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [("antidote mist", 1)]
  , iflavour = zipFancy [BrBlue]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "cure"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [DropItem 1 maxBound COrgan "poisoned"]
  , idesc    = "Washes away death's dew."
  , ikit     = []
  }
mistSleep = ItemKind
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [("sleep mist", 1)]
  , iflavour = zipFancy [BrMagenta]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "put to sleep"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [PutToSleep]
  , idesc    = "Luls weary warriors."
  , ikit     = []
  }

-- * Temporary condition blasts

-- Almost all have @toLinger 10@, that travels 2 steps in 1 turn.
-- These are very fast projectiles, not getting into the way of big
-- actors and not burdening the engine for long.
-- A few are slower 'mists'.

denseShower = ItemKind
  { isymbol  = '`'
  , iname    = "dense shower"
  , ifreq    = [("dense shower", 1)]
  , iflavour = zipFancy [Green]
  , icount   = 12
  , irarity  = [(1, 1)]
  , iverbHit = "strengthen"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "strengthened" (3 + 1 `d` 3)]
  , idesc    = "A thick rain of droplets."
  , ikit     = []
  }
sparseShower = ItemKind
  { isymbol  = '`'
  , iname    = "sparse shower"
  , ifreq    = [("sparse shower", 1)]
  , iflavour = zipFancy [Red]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "weaken"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganBad "weakened" (5 + 1 `d` 3)]
  , idesc    = "Light droplets that cling to clothing."
  , ikit     = []
  }
protectingBalmMelee = ItemKind
  { isymbol  = '`'
  , iname    = "balm droplet"
  , ifreq    = [("melee protective balm", 1)]
  , iflavour = zipFancy [Brown]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "balm"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "protected from melee" (3 + 1 `d` 3)]
  , idesc    = "A thick ointment that hardens the skin."
  , ikit     = []
  }
protectingBalmRanged = ItemKind
  { isymbol  = '`'
  , iname    = "balm droplet"
  , ifreq    = [("ranged protective balm", 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "balm"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "protected from ranged" (3 + 1 `d` 3)]
  , idesc    = "Grease that protects from flying death."
  , ikit     = []
  }
vulnerabilityBalm = ItemKind
  { isymbol  = '`'
  , iname    = "red paint"
  , ifreq    = [("red paint", 1)]
  , iflavour = zipPlain [BrRed]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "paint"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganBad "painted red" (3 + 1 `d` 3)]
  , idesc    = ""
  , ikit     = []
  }
resolutionDust = ItemKind
  { isymbol  = '`'
  , iname    = "resolution dust"
  , ifreq    = [("resolution dust", 1)]
  , iflavour = zipPlain [Brown]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "calm"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "resolute" (3 + 1 `d` 3)]
                 -- short enough duration that @calmEnough@ not a big problem
  , idesc    = "A handful of honest earth, to strengthen the soul."
  , ikit     = []
  }
hasteSpray = ItemKind
  { isymbol  = '`'
  , iname    = "haste spray"
  , ifreq    = [("haste spray", 1)]
  , iflavour = zipFancy [BrYellow]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "haste"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "hasted" (3 + 1 `d` 3)]
  , idesc    = "A quick spurt."
  , ikit     = []
  }
slownessMist = ItemKind
  { isymbol  = '`'
  , iname    = "slowness mist"
  , ifreq    = [("slowness mist", 1)]
  , iflavour = zipPlain [BrBlue]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "slow"
  , iweight  = 0
  , idamage  = 0
  , iaspects = [toVelocity 5, SetFlag Fragile, SetFlag Blast]
                 -- 1 step, 1 turn, mist, slow
  , ieffects = [toOrganBad "slowed" (3 + 1 `d` 3)]
  , idesc    = "Clammy fog, making each movement an effort."
  , ikit     = []
  }
eyeDrop = ItemKind
  { isymbol  = '`'
  , iname    = "eye drop"
  , ifreq    = [("eye drop", 1)]
  , iflavour = zipFancy [BrCyan]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "cleanse"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "far-sighted" (3 + 1 `d` 3)]
  , idesc    = "Not to be taken orally."
  , ikit     = []
  }
ironFiling = ItemKind
  { isymbol  = '`'
  , iname    = "iron filing"
  , ifreq    = [("iron filing", 1)]
  , iflavour = zipPlain [Red]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "blind"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganBad "blind" (10 + 1 `d` 10)]
  , idesc    = "A shaving of bright metal."
  , ikit     = []
  }
smellyDroplet = ItemKind
  { isymbol  = '`'
  , iname    = "smelly droplet"
  , ifreq    = [("smelly droplet", 1)]
  , iflavour = zipFancy [Blue]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "sensitize"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "keen-smelling" (5 + 1 `d` 3)]
  , idesc    = "A viscous lump that stains the skin."
  , ikit     = []
  }
eyeShine = ItemKind
  { isymbol  = '`'
  , iname    = "eye shine"
  , ifreq    = [("eye shine", 1)]
  , iflavour = zipFancy [Cyan]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "smear"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "shiny-eyed" (3 + 1 `d` 3)]
  , idesc    = "They almost glow in the dark."
  , ikit     = []
  }
whiskeySpray = ItemKind
  { isymbol  = '`'
  , iname    = "whiskey spray"
  , ifreq    = [("whiskey spray", 1)]
  , iflavour = zipFancy [Brown]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "inebriate"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [toOrganGood "drunk" (3 + 1 `d` 3)]
  , idesc    = "It burns in the best way."
  , ikit     = []
  }
youthSprinkle = ItemKind
  { isymbol  = '`'
  , iname    = "youth sprinkle"
  , ifreq    = [("youth sprinkle", 1)]
  , iflavour = zipFancy [BrGreen]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "sprinkle"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [toLinger 10, SetFlag Fragile, SetFlag Blast]
  , ieffects = [ toOrganGood "rose-smelling" (40 + 1 `d` 20)
               , toOrganNoTimer "regenerating" ]
  , idesc    = "Bright and smelling of the Spring."
  , ikit     = []
  }
poisonCloud = ItemKind
  { isymbol  = '`'
  , iname    = "poison cloud"
  , ifreq    = [("poison cloud", 1)]
  , iflavour = zipFancy [BrMagenta]
  , icount   = 16
  , irarity  = [(1, 1)]
  , iverbHit = "poison"
  , iweight  = 0
  , idamage  = 0
  , iaspects = [ ToThrow $ ThrowMod 10 100 2  -- 2 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [toOrganNoTimer "poisoned"]
  , idesc    = "Choking gas that stings the eyes."
  , ikit     = []
  }
blastNoStat :: Text -> ItemKind
blastNoStat grp = ItemKind
  { isymbol  = '`'
  , iname    = "mist"
  , ifreq    = [(toGroupName $ grp <+> "mist", 1)]
  , iflavour = zipFancy [White]
  , icount   = 12
  , irarity  = [(1, 1)]
  , iverbHit = "disable a stat of"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 10  -- 2 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [toOrganBad (toGroupName grp) (5 + 1 `d` 3)]
  , idesc    = ""
  , ikit     = []
  }
blastNoSkMove = blastNoStat "immobile"
blastNoSkMelee = blastNoStat "pacified"
blastNoSkDisplace = blastNoStat "irreplaceable"
blastNoSkAlter = blastNoStat "retaining"
blastNoSkWait = blastNoStat "impatient"
blastNoSkMoveItem = blastNoStat "dispossessed"
blastNoSkProject = blastNoStat "withholding"
blastNoSkApply = blastNoStat "parsimonious"
blastBonusStat :: Text -> ItemKind
blastBonusStat grp = ItemKind
  { isymbol  = '`'
  , iname    = "dew"
  , ifreq    = [(toGroupName $ grp <+> "dew", 1)]
  , iflavour = zipFancy [White]
  , icount   = 12
  , irarity  = [(1, 1)]
  , iverbHit = "increase a stat of"
  , iweight  = 1
  , idamage  = 0
  , iaspects = [ toVelocity 10  -- 2 steps, 2 turns
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [toOrganGood (toGroupName grp) (20 + 1 `d` 5)]
  , idesc    = ""
  , ikit     = []
  }
blastBonusSkMove = blastBonusStat "more mobile"
blastBonusSkMelee = blastBonusStat "more combative"
blastBonusSkDisplace = blastBonusStat "more displacing"
blastBonusSkAlter = blastBonusStat "more altering"
blastBonusSkWait = blastBonusStat "more patient"
blastBonusSkMoveItem = blastBonusStat "tidier"
blastBonusSkProject = blastBonusStat "more projecting"
blastBonusSkApply = blastBonusStat "more practical"

-- * Allure-specific

-- ** Lore blasts

-- They exist for a short time only, but the lore can be read
-- from the lore menu. Only optional story bits should go there,
-- becuase some players may not even notice them (at first, at least).
-- This is designed not to spam gameplay with story. Gameplay first.
-- Generally, 3 to 5 blasts of each kind should suffice for variety.
-- More would induce long repetition to see all (they are shown at random).
-- With mild exceptions, they should have no effects.

cruiseAdHologram = ItemKind
  { isymbol  = '`'
  , iname    = "cruise ad hologram"
  , ifreq    = [("cruise ad hologram", 1), ("advertisement", 10)]
  , iflavour = zipFancy [BrMagenta]
  , icount   = 8
  , irarity  = [(1, 1)]
  , iverbHit = "excite"
  , iweight  = 0  -- delay of 1 turn at the start, to easily read the text
  , idamage  = 0
  , iaspects = [ toVelocity 5  -- 1 step, 1 turn
               , SetFlag Fragile, SetFlag Blast ]
  , ieffects = [toOrganGood "resolute" (5 + 1 `d` 2), DropBestWeapon]
  , idesc    = "The fitful holographic clip shows a couple that laughs, watches in silence Saturn's rings through a huge window, throws treats to a little rhino frolicking in reduced gravity, runs through corridors wearing alien masks in a mock chase. An exited female voice proclaims: \"...safety, security and comfort...for each of your senses...personalized life support zones...robot servants...guessing your every wish...\""
  , ikit     = []
  }
outerAdHologram = cruiseAdHologram
  {  iname    = "cruise ad hologram"
  , ifreq    = [("advertisement", 20)]
  , icount   = 4
  , ieffects = []  -- weak, 4 particles, no effect
  , idesc    = "A composed young man in a hat looks straight into your eyes with unwavering stare and extols the opportunities, freedom and excitement of the outer Solar System frontier life with unshakable conviction. Names of Neptune-area realtors scroll at the bottom in small font with oversize serifs."
  }
victoriaClassHologram = outerAdHologram
  { iname    = "space fleet hologram"
  , ifreq    = [("story-telling", 20)]
  , iflavour = zipFancy [BrBlue]
  , icount   = 1
  , iverbHit = "bore"
  , idesc    = "A series of huge spaceships zoom in and out of view in a solemn procession. Male voice drones over crackling static: Victoria-class cruise liners are the largest passenger ships ever serially manufactured and the third largest in general, including transport vessel series. Bigger ships are sometimes cobbled ad-hoc, by wiring together cheap modules and primitive cargo hulls welded in space, but they are rarely certified for public commercial operation. Victoria-class passenger cruisers are produced for over three decades now, in slowly evolving configurations, one every two years on average. The design is as conservative, as possible. A disc large enough for comfortable artificial gravity through constant spinning. Fusion reactor in the middle of the axle powering engines protruding far back from the rear plane. Meteor shield at the front. Numerous redundant rechargeable power sources and autonomous life support areas within several independently pressurized slices of the disc, eliminating the \"all locked in a single can, breathing the same air\" space travel grievance. Actually, everything is redundant twice over, due to strict regulations. To sum it up, these are the most boring spaceships in the galaxy."
  }
allureIntroHologram = victoriaClassHologram
  { iname    = "spaceship hologram"
  , ifreq    = [("story-telling", 10)]
  , idesc    = "A wavy 3D wireframe of a spaceship rotates ponderously. Male voice drones: Allure of the Stars belongs to a long line of luxurious orbit-to-orbit cruise liners, the Victoria-class. It was named after the largest passenger sea vessel of the early 21st century and it shares the grandeur and the extravagance. This particular Victoria-class specimen was designed for long cruises to gas giants, their moons and the moon cities (with their notorious saloons). It has a meteor shield in the form of a flat, multi-layer. unpressurized cargo bay covering the front plane. Such extra cargo capacity enables long space journeys with no limits on resource usage. On shorter legs of the journeys it also enables opportunistic mass cargo transport (in accordance to strictest regulations and completely isolated from the airflow on passenger decks), which is always in demand at the profusely productive, but scarcely populated Solar System frontier. It also makes the unit much thicker than usual: the length from the tip of the cargo bay to the engines' exhausts is almost two thirds of the diameter of the disk. All in all, it is a particularly sturdy and self-sufficient member of a class famed for exceptional resilience and safety."
  }
