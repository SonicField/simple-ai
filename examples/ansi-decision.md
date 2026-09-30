# From Terminal History to a Recorded Decision

`simple-ansi` and `simple-decision` support two different parts of an agent's
work: producing a readable chronological record and preserving the conclusion
drawn from that evidence.

## Choose the right terminal representation

Start with the raw output retained by `simple-pty`:

```sh
simple-pty output "$session" >session.raw
```

When event order matters, remove terminal controls without interpreting cursor
movement:

```sh
simple-ansi session.raw >session.txt
```

The result is suitable for searches and line-oriented tools, but it is not a
reconstruction of the visible screen. Progress updates and overwritten text
can both remain. Use `simple-termshot` instead when the final screen is the
evidence being examined:

```sh
simple-termshot --width=120 --height=40 session.raw >screen.txt
```

## Record the conclusion

After inspecting the relevant evidence, record the decision rather than
burying it in transient session output:

```sh
simple-decision add decisions.md \
  'Keep the streaming parser' \
  --participants='human reviewer, implementation agent' \
  --rationale='The chunk-boundary and malformed-input checks passed.' \
  --risk-tags='terminal compatibility' \
  --artefacts='session.txt, parser test report'
```

The command returns an ID such as `D-1`. If later evidence changes the choice,
append a replacement instead of editing history:

```sh
simple-decision add decisions.md \
  'Replace the parser after the compatibility review' \
  --participants='human reviewer, implementation agent' \
  --rationale='The new evidence invalidated the earlier compatibility claim.' \
  --supersedes=D-1
```

Validate and review the durable record with ordinary command-line tools:

```sh
simple-decision check decisions.md
simple-decision list decisions.md
simple-md decisions.md
```

These tools remain independent. The filenames in `--artefacts` are descriptive
references, not hidden links or managed attachments, and `simple-decision`
does not invoke the other tools.
