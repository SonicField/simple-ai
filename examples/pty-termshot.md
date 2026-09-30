# From PTY History to a Visible Screen

`simple-pty` and `simple-termshot` answer different questions about an
interactive terminal session:

- `simple-pty output` returns the complete byte history produced by the PTY.
- `simple-termshot` interprets those bytes and returns the final fixed-size
  screen a person would have seen.

The distinction matters when an application moves the cursor, clears the
screen, or overwrites earlier text. A raw capture can contain several values
that occupied the same screen location at different times.

## Deterministic example

This repository includes a small Bash application at
[`tests/fixtures/stateful-terminal.sh`](../tests/fixtures/stateful-terminal.sh).
The application accepts two commands:

| Command | Result |
|---|---|
| `render` | Clears the screen, writes `Progress: 10%`, overwrites it with `Progress: 100%`, and displays completion markers. |
| `quit` | Displays `BYE` and exits successfully. |

The application emits `READY` only after terminal echo has been disabled.
Automation can therefore wait for `READY` without guessing how long startup
will take or allowing sent commands to contaminate the visible screen.

The integration test follows the safe interaction loop:

1. Start the application in a 32-column by 6-row PTY.
2. Wait for `READY`.
3. Record the current raw-output position.
4. Send exactly one `render` command.
5. Wait for a new `DONE` marker after the recorded position.
6. Inspect the raw history and render the screen at the matching dimensions.
7. Send `quit`, verify a successful target exit, and remove the session.

The raw history must contain both progress values. The rendered screen must
contain only the final visible state:

```text
Progress: 100%
RESULT: complete
DONE
```

## Running it

Install `simple-pty` and `simple-termshot` somewhere on `PATH`, then run:

```sh
make test
```

During development, explicit executable paths can be supplied without relying
on any particular repository layout:

```sh
SIMPLE_PTY_BIN=/absolute/path/to/simple-pty \
SIMPLE_TERMSHOT_BIN=/absolute/path/to/simple-termshot \
make test
```

The test creates a private temporary `SIMPLE_PTY_DIR` and removes its session
on both successful and unsuccessful exits.
