# Simple

Simple is a loose coalition of tools and practices for helping AI agents write
good software and helping humans and agents work together.

The project is not a single framework, runtime, or required stack. Each part is
useful on its own. Together, the parts support a workflow in which an agent can
operate real development tools, inspect what a human would see, communicate
through durable documents, and make engineering claims that another person or
agent can check.

## The projects

| Project | Role |
|---|---|
| [Verifiable Practice](https://github.com/SonicField/verifiable-practice) | A vendor-neutral practice for goal-aligned, falsification-first, evidence-led software work. |
| [simple-pty](https://github.com/SonicField/simple-pty) | A persistent pseudo-terminal interface for operating interactive programs such as GDB, Vim, and REPLs from ordinary command-line automation. |
| [simple-termshot](https://github.com/SonicField/simple-termshot) | A terminal renderer that turns captured PTY bytes into the final screen a person would have seen. |
| [simple-md](https://github.com/SonicField/simple-md) | A terminal Markdown viewer for presenting durable, human-readable documents without leaving the command line. |
| [Honest](https://github.com/SonicField/honest) | A typed, self-describing interchange format with command-line tools for validating, formatting, querying, building, and extracting structured documents. |
| [simple-ansi](https://github.com/SonicField/simple-ansi) | A streaming filter that removes terminal control sequences while preserving the remaining bytes in their original order. |
| [simple-decision](https://github.com/SonicField/simple-decision) | An append-only Markdown decision log for recording what was decided, why, and what later superseded it. |

These are complementary projects, not hard dependencies. A user can adopt one
without adopting the others, and a workflow should use only the parts it needs.

## How they fit together

Verifiable Practice supplies the working discipline. It asks an agent to
identify the real goal, state what evidence could disprove an important claim,
make changes in testable steps, and report observed results rather than
performed confidence.

Honest supplies typed, self-describing structured data. Each document carries
the declarations needed to understand its values, so a person, script, or
agent can inspect an interchange document without consulting a separate schema
registry. Its command-line tools keep validation and transformation available
through ordinary streams, files, and exit statuses.

`simple-pty` supplies a missing mechanical capability. Many important software
tools are interactive terminal applications rather than request-response
commands. A persistent PTY lets an agent operate an unmodified application over
time, preserving its raw output as evidence.

Raw PTY output is not the same thing as plain text or a terminal screen. It
includes cursor movement, overwritten text, colours, and other control
sequences. `simple-ansi` is the linear choice: it removes those sequences while
preserving the order of the remaining bytes, which is useful for logs and text
pipelines. It does not apply cursor movement or reconstruct overwritten text.

When the visible screen is the evidence that matters, `simple-termshot` is the
right choice. It interprets the terminal byte stream and reconstructs the
screen a person would have seen. The two tools therefore answer different
questions rather than acting as interchangeable ANSI removers.

`simple-decision` preserves durable decision history in append-only Markdown.
It records the participants, rationale, status, supporting artefacts, risks,
and supersession links without requiring a service or hidden database. It is
for decisions rather than general progress notes: replacing an earlier choice
adds a linked decision instead of rewriting history.

Markdown provides a durable boundary between agent work and human review. An
agent can record a plan, investigation, test evidence, or explanation in a
plain Markdown file. `simple-md` makes that document pleasant to read and
navigate in the same command-line environment where the work happened.

A debugging workflow might therefore look like this:

1. Use Verifiable Practice to state the fault hypothesis and the observation
   that would falsify it.
2. Start GDB with `simple-pty` and interact with one known state at a time.
3. Synchronise on raw output markers, use `simple-ansi` when ordered plain text
   is sufficient, or use `simple-termshot` when visible screen state matters.
4. Exchange machine-checked structured results as Honest documents when types
   and validation matter more than free-form prose.
5. Record consequential choices and later replacements with
   `simple-decision`.
6. Record the wider experiment, observations, failures, and remaining
   uncertainty in Markdown.
7. Review the resulting document with `simple-md` and decide what to do next.

The same pattern applies to editors, REPLs, text interfaces, build tools, and
other command-line software. Not every task needs an interactive session, a
rendered screen, or a formal report. The parts compose when those needs arise.

## Composition examples

The worked [PTY-to-screen example](examples/pty-termshot.md) uses a
deterministic interactive Bash fixture to show `simple-pty` and
`simple-termshot` operating together. Its integration test verifies that the
raw PTY history retains an overwritten progress value while the rendered
screen contains only the final value.

The [linear-output and decision example](examples/ansi-decision.md) shows the
complementary path: use `simple-ansi` when chronological text is the useful
artefact, record a consequential conclusion with `simple-decision`, and review
the resulting Markdown with `simple-md`.

The PTY-to-screen example is executable. With both tools installed on `PATH`,
run:

```sh
make test
```

The test also accepts absolute executable paths through `SIMPLE_PTY_BIN` and
`SIMPLE_TERMSHOT_BIN`. It does not assume that component repositories are
siblings of this repository.

## Why command-line tools

The command line is a useful common interface. Humans already use it to build,
test, debug, inspect, and administer software. Agents can use the same tools
through process execution, standard input and output, files, and exit status.

This does not make the tools independent of an operating system or supporting
libraries. It keeps their integration boundary small, explicit, and widely
available. They do not require a particular AI provider, agent SDK, editor, or
application-specific extension.

That distinction matters. An agent should be able to use an existing tool as
it is, and a human should be able to reproduce the interaction without adopting
the agent that performed it.

## A loose coalition

“Simple” describes a direction rather than a central architecture. Projects in
the coalition should aim to be:

- useful to humans, agents, or the boundary between them;
- operable through documented command-line interfaces;
- focused on one bounded job with explicit behavior;
- composable through ordinary mechanisms such as arguments, streams, files,
  and exit status;
- independent of a particular model vendor or agent framework;
- honest about platform requirements, limitations, and unsupported behavior;
- tested against realistic and adversarial cases;
- documented well enough that claims can be checked.

A project does not need to share source code, a release cycle, or an
installation mechanism with the existing tools. It should earn its place by
closing a real gap in human-agent software work while remaining independently
understandable and useful.

Possible future projects might help agents preserve evidence, inspect other
stateful interfaces, exchange reviewable specifications, or connect existing
developer tools without hiding their behavior behind a proprietary service.
Those are possibilities, not a roadmap. The coalition should grow in response
to demonstrated needs rather than accumulate tools for their own sake.

## Current status

Simple is presently a description of a family of independent projects. This
repository contains the shared overview, worked composition examples, and
manually invoked integration checks. Implementation, issue tracking, releases,
and project-specific documentation remain in each project's own repository.

The current executable example covers `simple-pty` with `simple-termshot`; it
does not claim executable integration coverage of every listed project. The
current Honest, `simple-ansi`, and `simple-decision` changes have passed their
local project gates, but that is not a claim that their hosted CI has run.
See [Release Validation](RELEASING.md) for the manual overall-version process.
