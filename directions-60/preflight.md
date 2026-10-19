# Before the workshop clock

1. Create your repository using the shared template and clone it. Open **directions-60/directions.code-workspace**, never the root workshop workspace for this edition.
2. Use an isolated Business Central sandbox and a test company. The earlier workshop uses the same object ranges: do not co-install it. Confirm permission to publish App/Test and run tests.
3. Install AL Language, your chosen coding assistant and ALDC. Select one primary harness for your own run; changing harness during the 60 minutes is not part of the exercise.
4. Baseline candidate: ALDC 5.0.3. The extension source manifest was 5.0.3 on 19 October; that is not evidence of the artifact installed on your machine. Record VSIX/plugin version, toolkit revision/profile and Doctor output. Use 5.0.4 only after its artifact is available and the exact route passes rehearsal. No mid-workshop updates.
5. In each App/Test folder create your own `.vscode/launch.json` using AL: Go! / your normal sandbox configuration. Keep credentials and tenant details out of commits. Use the same sandbox/company for both projects.
6. Download symbols for App. Compile and publish the empty scaffold. Download symbols for Test, compile/publish Test and execute `DR Control Test` 71300. Record actual results. This only validates the tool route.
7. Verify that the assistant can read the relevant symbols and call the tools you plan to demonstrate. If compile/publish/test are manual, that is acceptable: record who ran each operation and keep its output.
8. Open contract.md, api-contract.md and guide.md. Keep the instructor portal and Live Pulse available in a browser.

Version target: BC28 application / runtime16; sandbox may be BC29. All installation, login, symbols and permission issues must be resolved before minute zero. If blocked, pair with a prepared participant rather than spending the build time on setup.
