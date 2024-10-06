# bless - Faking horizontal scrolling for unix shells

## Introduction:
Horizontal scrolling has (sometimes) been a (somewhat) contentious topic during (some) discussions on unix terminals.
There is (as far as I know) no standard, and few, if any, terminal emulators implement it in some form or another.
If an infinite vertical scrollback buffer is possible, why should simple horizontal scrolling be impossible?

## What is this?
This is a simple shell script to fake horizontal scrolling in unix shells.

## Requirements:
- a shell with job control (e.g. bash, dash, etc.)
- mktemp
- less
- unbuffer

## Usage:
```bash
. ./bless.sh
bless <any command or built-in and their args>
```

## Limitations:
- Once you exit less, you lose the ability to scroll horizontally.
- sdtout and stderr of the called command get irreversibly mixed
- job control messages are printed to stderr

## License:
bless - Fake horizontal scrolling for unix shells

Copyright (C) 2024  Jakob Kalus

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
