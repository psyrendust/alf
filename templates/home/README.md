Zsh Configuration Files
=======================

| File            | Interactive login  | Interactive non-login  | Script | Description                                                                                    |
| --------------- | :----------------: | :--------------------: | :----: | :--------------------------------------------------------------------------------------------- |
| `/etc/zshenv`   | A                  | A                      | A      | Define environment vars.                                                                       |
| `~/.zshenv`     | B                  | B                      | B      | Define environment vars. Keep it lightweight for speed.                                        |
| `/etc/zprofile` | C                  |                        |        | Executable commands that do not change the shell environment.                                  |
| `~/.zprofile`   | D                  |                        |        | Executable commands that do not change the shell environment.                                  |
| `/etc/zshrc`    | E                  | C                      |        | Define aliases, functions, shell options, and key bindings.                                    |
| `~/.zshrc`      | F                  | D                      |        | Define aliases, functions, shell options, and key bindings.                                    |
| `~/.zshrcwork`  | G                  | E                      |        | Define custom Alf aliases, functions, shell options, and key bindings from work repo.          |
| `~/.zshrcuser`  | G                  | E                      |        | Define custom Alf aliases, functions, shell options, and key bindings from your own user repo. |
| `/etc/zlogin`   | H                  |                        |        | Executes file/folder creation, login message, and should not change the shell.                 |
| `~/.zlogin`     | I                  |                        |        | Executes file/folder creation, login message, and should not change the shell.                 |
| `/etc/zlogout`  | K                  |                        |        | Executes logout message and should not change the shell.                                       |
| `~/.zlogout`    | J                  |                        |        | Executes logout message and should not change the shell.                                       |

Author
------

Larry Gordon

License
-------

[The MIT License (MIT)](http://psyrendust.mit-license.org/2014/license.html)
