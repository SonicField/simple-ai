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

These are complementary projects, not hard dependencies. A user can adopt one
without adopting the others, and a workflow should use only the parts it needs.

## How they fit together

Verifiable Practice supplies the working discipline. It asks an agent to
identify the real goal, state what evidence could disprove an important claim,
make changes in testable steps, and report observed results rather than
performed confidence.

`simple-pty` supplies a missing mechanical capability. Many important software
tools are interactive terminal applications rather than request-response
commands. A persistent PTY lets an agent operate an unmodified application over
time, preserving its raw output as evidence.

Raw PTY output is not the same thing as a terminal screen. It includes cursor
movement, overwritten text, colours, and other control sequences.
`simple-termshot` interprets that byte stream and produces the visible screen,
giving the agent and human a more faithful view of the application's state.

Markdown provides a durable boundary between agent work and human review. An
agent can record a plan, investigation, test evidence, or explanation in a
plain Markdown file. `simple-md` makes that document pleasant to read and
navigate in the same command-line environment where the work happened.

A debugging workflow might therefore look like this:

1. Use Verifiable Practice to state the fault hypothesis and the observation
   that would falsify it.
2. Start GDB with `simple-pty` and interact with one known state at a time.
3. Synchronise on raw output markers and use `simple-termshot` when the visible
   screen is the evidence that matters.
4. Record the experiment, observations, failures, and remaining uncertainty in
   Markdown.
5. Review the resulting document with `simple-md` and decide what to do next.

The same pattern applies to editors, REPLs, text interfaces, build tools, and
other command-line software. Not every task needs an interactive session, a
rendered screen, or a formal report. The parts compose when those needs arise.

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
repository contains the shared overview; implementation, issue tracking,
releases, and project-specific documentation remain in each project's own
repository.
