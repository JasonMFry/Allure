Allure of the Stars [![Build Status](https://secure.travis-ci.org/Mikolaj/Allure.png)](http://travis-ci.org/Mikolaj/Allure)
===================

This is an alpha release of Allure of the Stars,
a near-future Sci-Fi [roguelike] [2] and tactical squad game.
Long-term goals are high replayability and auto-balancing
through procedural content generation and persistent content
modification based on player behaviour. The game is written in [Haskell] [1]
using the [LambdaHack] [5] roguelike game engine.


Compilation and installation
----------------------------

The game is best compiled and installed via Cabal, which also takes care
of all dependencies. The latest official version of the game can be downloaded
automatically by Cabal from [Hackage] [4] as follows

    cabal install Allure

For a newer version, install a matching LambdaHack library snapshot
from a development branch, download the game source from [github] [3]
and run 'cabal install' from the main directory.


Compatibility notes
-------------------

The current code was tested with GHC 7.6, but should also work with
other GHC versions (see file .travis.yml for GHC 7.4 commands).

If you are using the curses or vty frontends,
numerical keypad may not work correctly depending on the versions
of curses, terminfo and terminal emulators.
Selecting heroes via number keys or SHIFT-keypad keys is disabled
with curses, because CTRL-keypad for running does not work there,
so the numbers produced by the keypad have to be used. With vty on xterm,
CTRL-direction keys seem to work OK, but on rxvt they do not.
Vi keys (ykuhlbjn) should work everywhere regardless. Gtk works fine, too.


Testing and debugging
---------------------

The Makefile contains many test commands. All that use the screensaver
game modes (AI vs. AI) are gathered in `make test`. Of these, travis
runs the set contained in `make test-travis` on each push to the repo.
Command `make testPeek-play' sets up a game mode where the player
peeks into AI moves each time an AI actor dies or autosave kicks in.
Run `Allure --help` to see a brief description of all debug options.
Of these, `--sniffIn` and `--sniffOut` are very useful (though verbose
and initially cryptic), for monitoring the traffic between clients
and the server. Some options in config files may turn out useful too,
though they mostly overlap with commandline options (and will be totally
merged at some point).

You can use HPC with the game as follows

    cabal clean
    cabal install --enable-library-coverage
    make test
    hpc report --hpcdir=dist/hpc/mix/Allure-0.4.10/ Allure
    hpc markup --hpcdir=dist/hpc/mix/Allure-0.4.10/ Allure

The debug option `--stopAfter` is required for any screensaver mode
game invocations that gather HPC info, because HPC needs a clean exit
to save data files and screensaver modes can't be cleanly stopped
in any other way.


Further information
-------------------

For more information, visit the [wiki] [6]
and see the files PLAYING.md, CREDITS and LICENSE.

Have fun!


Copyright
---------

Copyright (c) 2008--2011 Andres Loeh, 2010--2013 Mikolaj Konarski

Allure of the Stars is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in file LICENSE.
If not, see <http://www.gnu.org/licenses/>.



[1]: http://www.haskell.org/
[2]: http://roguebasin.roguelikedevelopment.org/index.php?title=Berlin_Interpretation
[3]: http://github.com/Mikolaj/Allure
[4]: http://hackage.haskell.org/package/Allure
[5]: http://github.com/kosmikus/LambdaHack
[6]: https://github.com/Mikolaj/Allure/wiki
