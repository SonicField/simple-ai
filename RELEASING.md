# Release Validation

`simple-ai` describes and tests a coalition of independently released tools.
It does not make one component's build or release depend on another component.

The current executable integration check covers `simple-pty` working with
`simple-termshot`. It does not claim executable coverage of every project
listed in the Simple overview.

## Validate the current tools

1. Open the **Integration** workflow in the `simple-ai` GitHub repository.
2. Choose **Run workflow**.
3. Wait for the GNU/Linux and macOS jobs to finish.
4. Inspect the component test results and the cross-tool integration result.
5. Record the exact `simple-pty` and `simple-termshot` commit identifiers shown
   in the workflow summary, including failed or inconclusive runs.

The workflow checks out each component's current default branch. It does not
select a component tag or pin a component commit. Recorded commit identifiers
are evidence of what a particular run tested, not constraints on future runs.

## Publish an overall Simple version

After a successful validation run:

1. Review the component revisions and the integration evidence.
2. Record any known limitations or omitted checks in the release notes.
3. Create the chosen `simple-ai` tag and GitHub release manually.

The validation workflow does not create tags, publish releases, modify a
component repository, or run in response to component changes. A human decides
when the constellation is ready to receive an overall version.
