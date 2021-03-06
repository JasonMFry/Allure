-- Copyright (c) 2008--2011 Andres Loeh
-- Copyright (c) 2010--2018 Mikolaj Konarski and others (see git history)
-- This file is a part of the computer game Allure of the Stars
-- and is released under the terms of the GNU Affero General Public License.
-- For license and copyright information, see the file LICENSE.
--
-- | Definitions of items embedded in map tiles.
module Content.ItemKindEmbed
  ( embeds
  ) where

import Prelude ()

import Game.LambdaHack.Common.Prelude

import Game.LambdaHack.Common.Ability
import Game.LambdaHack.Common.Color
import Game.LambdaHack.Common.Dice
import Game.LambdaHack.Common.Flavour
import Game.LambdaHack.Common.Misc
import Game.LambdaHack.Content.ItemKind

embeds :: [ItemKind]
embeds =
  [scratchOnWall, obscenePictogram, subtleFresco, treasureCache, treasureCacheTrap, signboardExit, signboardEmbed, fireSmall, fireBig, frost, rubble, doorwayTrapTemplate, doorwayTrap1, doorwayTrap2, doorwayTrap3, stairsUp, stairsDown, escape, staircaseTrapUp, staircaseTrapDown, pulpit, shallowWater, straightPath, frozenGround]
  -- Allure-specific
  ++ [blackStarrySky, disengagedDocking, ruinedFirstAidKit, wall3dBillboard, depositBox, jewelryCase, liftUp, liftDown, liftTrap, liftTrap2, shuttleHardware, machineOil, crudeWeld]

scratchOnWall,    obscenePictogram, subtleFresco, treasureCache, treasureCacheTrap, signboardExit, signboardEmbed, fireSmall, fireBig, frost, rubble, doorwayTrapTemplate, doorwayTrap1, doorwayTrap2, doorwayTrap3, stairsUp, stairsDown, escape, staircaseTrapUp, staircaseTrapDown, pulpit, shallowWater, straightPath, frozenGround :: ItemKind
-- Allure-specific
blackStarrySky,       disengagedDocking, ruinedFirstAidKit, wall3dBillboard, depositBox, jewelryCase, liftUp, liftDown, liftTrap, liftTrap2, shuttleHardware, machineOil, crudeWeld :: ItemKind

-- Make sure very few walls are substantially useful, e.g., caches,
-- and none that are secret. Otherwise the player will spend a lot of time
-- bumping walls, which is boring compare to fights or dialogues
-- and ever worse, the player will bump all secret walls, wasting time
-- and foregoing the fun of guessing how to find entrance to a disjoint part
-- of the level by bumping the least number of secret walls.
scratchOnWall = ItemKind
  { isymbol  = '?'
  , iname    = "claw mark"
  , ifreq    = [("scratch on wall", 1)]
  , iflavour = zipPlain [BrBlack]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "scratch"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [ Temporary "start making sense of the scratches"
               , Detect DetectHidden 3 ]
  , idesc    = "A seemingly random series of scratches, carved deep into the wall."
  , ikit     = []
  }
obscenePictogram = ItemKind
  { isymbol  = '*'
  , iname    = "repulsing graffiti"
  , ifreq    = [("obscene pictogram", 1)]
  , iflavour = zipPlain [BrMagenta]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "infuriate"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = [Timeout 7, SetFlag Durable]
  , ieffects = [ Recharging $ Temporary "enter unexplainable rage at a glimpse of the inscrutable graffiti"
               , Recharging $ RefillCalm (-20)
               , Recharging $ OneOf
                   [ toOrganGood "strengthened" (3 + 1 `d` 2)
                   , CreateItem CInv "sandstone rock" timerNone ] ]
  , idesc    = ""
  , ikit     = []
  }
subtleFresco = ItemKind
  { isymbol  = '*'
  , iname    = "subtle mural"
  , ifreq    = [("subtle fresco", 1)]
  , iflavour = zipPlain [BrGreen]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "sooth"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = [Timeout 7, SetFlag Durable]
  , ieffects = [ Temporary "feel refreshed by the subtle fresco"
               , RefillCalm 2
               , Recharging $ toOrganGood "far-sighted" (3 + 1 `d` 2)
               , Recharging $ toOrganGood "keen-smelling" (3 + 1 `d` 2) ]
                 -- hearing gets a boost through bracing, so no need here
  , idesc    = "Expensive yet tasteful."
  , ikit     = []
  }
treasureCache = ItemKind
  { isymbol  = 'O'
  , iname    = "set of odds and ends"
  , ifreq    = [("abandoned cache", 1)]
  , iflavour = zipPlain [BrBlue]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "crash"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [CreateItem CGround "common item" timerNone]
  , idesc    = "If this stash is hidden, it's in plain sight. Or, more probably, it's just tucked aside so that it doesn't get lost. There are clear signs that many artisans shaped and reshaped these halls over the yeats. They needed to store their tools and personal belongings between shifts and, apparently, not in every case were able to return and retrive them."
  , ikit     = []
  }
treasureCacheTrap = ItemKind
  { isymbol  = '^'
  , iname    = "anti-theft protection"
  , ifreq    = [("jewelry display trap", 1)]
  , iflavour = zipPlain [Red]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "taint"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = []  -- not Durable, springs at most once
  , ieffects = [OneOf [ toOrganBad "blind" (40 + 1 `d` 10)
                      , RefillCalm (-99)
                      , Explode "focused concussion"
                      , RefillCalm (-1), RefillCalm (-1), RefillCalm (-1) ]]
  , idesc    = "You didn't think such kingly trinkets are on display without any protection, did you? Especially that some of the goods let you fry video monitoring equipment at the other side of the hall."
  , ikit     = []
  }
signboardExit = ItemKind
  { isymbol  = '?'
  , iname    = "sticker"
  , ifreq    = [("signboard", 80)]
  , iflavour = zipPlain [BrMagenta]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "whack"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [Detect DetectExit 100]  -- low tech, hence fully operational
  , idesc    = "Mandatory emergency exit information in low-tech form."
                 -- This is a rare tile so use it to convey some more backstory.
  , ikit     = []
  }
signboardEmbed = signboardExit
  { iname    = "notice"
  , ifreq    = [("signboard", 20)]
  , ieffects = [Detect DetectEmbed 12]  -- low tech, hence fully operational
  , idesc    = "Detailed schematics for the maintenance crew."
                 -- This is a rare tile so use it to convey some more backstory.
  }
fireSmall = ItemKind
  { isymbol  = '%'
  , iname    = "small fire"
  , ifreq    = [("small fire", 1)]
  , iflavour = zipPlain [BrRed]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "burn"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [Burn 1, Explode "single spark"]
  , idesc    = "A few small logs, burning brightly."
  , ikit     = []
  }
fireBig = fireSmall
  { isymbol  = 'O'
  , iname    = "big fire"
  , ifreq    = [("big fire", 1)]
  , ieffects = [ Burn 2, Explode "spark"
               , CreateItem CInv "wooden torch" timerNone ]
  , idesc    = "Glowing with light and warmth."
  , ikit     = []
  }
frost = ItemKind
  { isymbol  = '^'
  , iname    = "frost"
  , ifreq    = [("frost", 1)]
  , iflavour = zipPlain [BrBlue]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "burn"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [ Burn 1  -- sensory ambiguity between hot and cold
               , RefillCalm 20  -- cold reason
               , PushActor (ThrowMod 400 10 1) ]  -- slippery ice
  , idesc    = "Intricate patterns of shining ice."
  , ikit     = []
  }
rubble = ItemKind
  { isymbol  = '&'
  , iname    = "rubble"
  , ifreq    = [("rubble", 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "bury"
  , iweight  = 100000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [OneOf [ Explode "focused glass hail"
                      , Summon "animal" $ 1 `dL` 2
                      , toOrganNoTimer "poisoned"
                      , CreateItem CGround "common item" timerNone
                      , RefillCalm (-1), RefillCalm (-1), RefillCalm (-1)
                      , RefillCalm (-1), RefillCalm (-1), RefillCalm (-1) ]]
  , idesc    = "Broken chunks of foam concrete, glass and torn and burned equipment."
  , ikit     = []
  }
doorwayTrapTemplate = ItemKind
  { isymbol  = '+'
  , iname    = "doorway trap"
  , ifreq    = [("doorway trap unknown", 1)]
  , iflavour = zipPlain brightCol
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "cripple"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [HideAs "doorway trap unknown"]
      -- not Durable, springs at most once
  , ieffects = []
  , idesc    = "Just turn the handle..."
  , ikit     = []
  }
doorwayTrap1 = doorwayTrapTemplate
  { ifreq    = [("doorway trap", 50)]
  , ieffects = [toOrganBad "blind" $ (1 `dL` 4) * 10]
  -- , idesc    = ""
  }
doorwayTrap2 = doorwayTrapTemplate
  { ifreq    = [("doorway trap", 25)]
  , ieffects = [toOrganBad "slowed" $ (1 `dL` 4) * 10]
  -- , idesc    = ""
  }
doorwayTrap3 = doorwayTrapTemplate
  { ifreq    = [("doorway trap", 25)]
  , ieffects = [toOrganBad "weakened" $ (1 `dL` 4) * 10 ]
  -- , idesc    = ""
  }
stairsUp = ItemKind
  { isymbol  = '<'
  , iname    = "flight of steps"
  , ifreq    = [("staircase up", 1)]
  , iflavour = zipPlain [BrWhite]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "crash"  -- the verb is only used when the item hits,
                        -- not when it's applied otherwise, e.g., from tile
  , iweight  = 100000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [Ascend True]
  , idesc    = "Stairs that rise towards the spaceship core."
  , ikit     = []
  }
stairsDown = stairsUp
  { isymbol  = '>'
  , iname    = "flight of steps"
  , ifreq    = [("staircase down", 1)]
  , ieffects = [Ascend False]
  , idesc    = "Stairs that descend towards the outer ring."
  }
escape = stairsUp
  { isymbol  = 'E'
  , iname    = "way"
  , ifreq    = [("escape", 1)]
  , iflavour = zipPlain [BrYellow]
  , ieffects = [Escape]
  , idesc    = ""  -- generic: moon outdoors, in spaceship, everywhere
  }
staircaseTrapUp = ItemKind
  { isymbol  = '^'
  , iname    = "staircase trap"
  , ifreq    = [("staircase trap up", 1)]
  , iflavour = zipPlain [Red]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "buffet"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = []  -- not Durable, springs at most once
  , ieffects = [ Temporary "be caught in decompression blast"
               , Teleport $ 3 + 1 `dL` 10 ]
  , idesc    = ""
  , ikit     = []
  }
-- Needs to be separate from staircaseTrapUp, to make sure the item is
-- registered after up staircase (not only after down staircase)
-- so that effects are invoked in the proper order and, e.g., teleport works.
staircaseTrapDown = staircaseTrapUp
  { ifreq    = [("staircase trap down", 1)]
  , iverbHit = "open up under"
  , ieffects = [ Temporary "tumble down the stairwell"
               , toOrganGood "drunk" (20 + 1 `d` 5) ]
  , idesc    = "A treacherous slab, to teach those who are too proud."
  }
pulpit = ItemKind
  { isymbol  = '?'
  , iname    = "VR harness"
  , ifreq    = [("pulpit", 1)]
  , iflavour = zipFancy [BrYellow]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "immerse"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = []  -- not Durable, springs at most once
  , ieffects = [ OneOf [ CreateItem CGround "any scroll" timerNone
                       , Detect DetectAll 20
                       , Paralyze $ (1 `dL` 6) * 10
                       , toOrganGood "drunk" (20 + 1 `d` 5) ]
               , Explode "story-telling" ]
  , idesc    = ""
  , ikit     = []
  }
shallowWater = ItemKind
  { isymbol  = '~'
  , iname    = "shallow water"
  , ifreq    = [("shallow water", 1)]
  , iflavour = zipFancy [BrCyan]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "impede"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [ParalyzeInWater 2]
  , idesc    = ""
  , ikit     = []
  }
straightPath = ItemKind
  { isymbol  = '.'
  , iname    = "straight path"
  , ifreq    = [("straight path", 1)]
  , iflavour = zipFancy [BrRed]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "propel"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [InsertMove 2]
  , idesc    = ""
  , ikit     = []
  }
frozenGround = ItemKind
  { isymbol  = '.'
  , iname    = "frozen ground"
  , ifreq    = [("frozen ground", 1)]
  , iflavour = zipFancy [BrBlue]
  , icount   = 50  -- very thick ice and refreezes
  , irarity  = [(1, 1)]
  , iverbHit = "betray"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = []  -- no Durable or some items would be impossible to pick up
  , ieffects = [PushActor (ThrowMod 400 10 1)]
  , idesc    = ""
  , ikit     = []
  }

-- * Allure-specific

blackStarrySky = ItemKind
  { isymbol  = ' '
  , iname    = "black starry sky"
  , ifreq    = [("black starry sky", 1)]
  , iflavour = zipPlain [Black]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "awe"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [ Temporary "look into the void and it looks back"
               , OneOf [RefillCalm 5, RefillCalm (-5)] ]
  , idesc    = "Occasionally a planet zips by, but is unable to disperse the blackness. The black starscape is constantly rotating. The frantic dance is silent, muted, indifferent. There is not even a hint of vibration, just the sense of heaviness and dizziness."  -- appears only on 100% flavour tiles, useless and trivial to notice, so the writeup can be longer
  , ikit     = []
  }
disengagedDocking = ItemKind
  { isymbol  = '<'
  , iname    = "disengaged docking gear"
  , ifreq    = [("disengaged docking", 1)]
  , iflavour = zipPlain [BrBlack]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "disappoint"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = [RefillCalm (-10)]
  , idesc    = "Unfortunately this airlock is disengaged. Many small craft were originally docked with such sockets and clamps as these, but just after the spaceship commenced spontanously leaving its Triton orbit, a lot of them has been spotted jettisoned and drifting astern. What a waste."
  , ikit     = []
  }
ruinedFirstAidKit = ItemKind
  { isymbol  = '?'
  , iname    = "ruined first aid kit"
  , ifreq    = [("ruined first aid kit", 1)]
  , iflavour = zipPlain [BrGreen]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "prick"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = []  -- not Durable, springs at most once
  , ieffects = [ Temporary "inspect a tattered CPR instruction soaked in a residue of oily drugs"
               , OneOf [ toOrganNoTimer "poison resistant"
                       , toOrganNoTimer "slow resistant"
                       , toOrganGood "drunk" (20 + 1 `d` 5) ]
               , CreateItem CInv "needle" timerNone ]
  , idesc    = ""  -- regulations require; say HP not regenerated; how to regain
  , ikit     = []
  }
wall3dBillboard = ItemKind
  { isymbol  = '*'
  , iname    = "3D display"
  , ifreq    = [("3D display", 1)]
  , iflavour = zipPlain [BrGreen]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "push"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = [Timeout 3, SetFlag Durable]
  , ieffects = [ Recharging $ Temporary "make it cough up a wobbly standalone hologram once more"
               , Recharging $ OneOf [ Explode "advertisement"
                                    , Explode "story-telling" ] ]
  , idesc    = "One can still make out excited moves of bleached shapes."
  , ikit     = []
  }
depositBox = treasureCache
  { iname    = "intact deposit box"
  , ifreq    = [("deposit box", 1)]
  , ieffects = [CreateItem CGround "valuable" timerNone]
  , idesc    = "The reports of intact deposit boxes in the ship's safes have been greatly exaggerated, but there are still a few with glittering gems and gold, just waiting to be taken. Whomever looted these halls wasn't thorough or, judging from the damage to some of the boxes, was in a hurry."
  }
jewelryCase = treasureCache
  { iname    = "jewelry case"
  , ifreq    = [("jewelry case", 1)]
  , ieffects = [CreateItem CGround "any jewelry" timerNone]
  , idesc    = "The customers of these shops must have been extremely well off, judging from abundance and quality of the jewelry, often extremely valuable in each of the artistic, material and nanotechnology aspects. Outer Solar System trips are expensive, but even more importantly, they offer unique trade and investment opportunities, often of the kind that can't be negotiated outside a fully electronically isolated room screened by both parties. Some of the jewelry are precisely portable versions of such screening hardware --- in a breathtaking package, no less."
  }
liftUp = stairsUp
  { iname    = "carriage"
  , ifreq    = [("lift up", 1)]
  , idesc    = ""  -- describe inner levels of the ship
  }
liftDown = stairsDown
  { iname    = "carriage"
  , ifreq    = [("lift down", 1)]
  , idesc    = ""  -- describe outer levels of the ship
  }
liftTrap = staircaseTrapUp
  { iname    = "elevator trap"  -- hat tip to US heroes
  , ifreq    = [("lift trap", 100)]
  , iverbHit = "squeeze"
  , ieffects = [ Temporary "be crushed by the sliding doors"
               , DropBestWeapon, Paralyze 10 ]
  , idesc    = ""
  }
liftTrap2 = liftTrap
  { ifreq    = [("lift trap", 50)]
  , iverbHit = "choke"
  , ieffects = [ Temporary "inhale the gas lingering inside the cab"
               , toOrganBad "slowed" $ (1 `dL` 4) * 10 ]
  , idesc    = ""
  }
shuttleHardware = ItemKind
  { isymbol  = '#'
  , iname    = "shuttle hardware"
  , ifreq    = [("shuttle hardware", 1)]
  , iflavour = zipPlain [BrWhite]
  , icount   = 1
  , irarity  = [(1, 1)]
  , iverbHit = "resist"
  , iweight  = 10000
  , idamage  = 0
  , iaspects = [SetFlag Durable]
  , ieffects = []
  , idesc    = "While the hull of the spacecraft is intact, the flight hardware that normally lines the walls seems broken, worn out and often missing. This shuttle was probably scavenged for spare parts to repair other craft and it's unlikely that anything of use remains. This was a tiny shuttle to being with, designed for lunar and orbital courier duties and single family trips. The kind is relatively cheap to operate, because no permanent airlock needs to be leased. Instead, the craft can be brought through a large airlock into the mothership and stored and serviced inside. The design is compact, efficient and space-worthy, but even if repaired, the craft doesn't have enough fuel capacity for an inter-planetary flight."
  , ikit     = []
  }
machineOil = ItemKind
  { isymbol  = '!'
  , iname    = "oil layer"
  , ifreq    = [("machine oil", 1)]
  , iflavour = zipPlain [BrYellow]
  , icount   = 3  -- not durable, wears off
  , irarity  = [(1, 1)]
  , iverbHit = "oil"
  , iweight  = 1000
  , idamage  = 0
  , iaspects = []
  , ieffects = [PushActor (ThrowMod 600 10 1)]
                  -- the high speed represents gliding rather than flying
                  -- and so no need to lift actor's weight off the ground;
                  -- low linger comes from abrupt halt over normal surface
  , idesc    = "Slippery run out, probably from a life support equipment or vehicle engine. Surprisingly uncommon given so many years of neglect."
  , ikit     = []
  }
crudeWeld = ItemKind  -- this is also an organ
  { isymbol  = '_'
  , iname    = "crude weld"
  , ifreq    = [("crude weld", 1)]
  , iflavour = zipPlain [BrMagenta]
  , icount   = 1  -- not durable, destroyed on activation
  , irarity  = [(1, 1)]
  , iverbHit = "weld"
  , iweight  = 3000
  , idamage  = 0
  , iaspects = [AddSkill SkMove (-1), AddSkill SkDisplace (-1)]
  , ieffects = [Explode "spark"]
  , idesc    = "This is a messy and irregularly layered weld, but no ammount of kicking nor hammering makes any impression on it. A heavy duty cutting tool would be required."
  , ikit     = []
  }
