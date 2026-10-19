# Run the acceptance tests in Business Central

Use a sandbox and the published App/Test versions from your own working copy. Local compiler success is not runtime evidence.

## Route A � native VS Code Test Explorer (BC28+)

1. Open directions.code-workspace and configure App/Test for the same sandbox and company.
2. After implementing the agreed API, run `./tools/Enable-AcceptanceTests.ps1` from directions-60.
3. Download symbols and compile App, then Test. Publish App before Test if doing it manually.
4. Open the **Testing** view in VS Code. Find **Directions Customer Review Tests**, then **DR Control Test** (71300) and **DR Acceptance Tests** (71301).
5. Select **Publish & Run** to publish changed projects/dependencies and execute the selected tests. Run both test codeunits. Capture Test Results, failures and the published versions.
6. Expect 1 control + 16 functional methods to be discovered, not a promised passing count. Inspect A12_RollbackOnHistoryFailure explicitly. Complete A14 manually using guide.md.

Native Test Explorer does **not** execute DR Test Runner 71304. It uses `RequiredTestIsolation = Function` on the acceptance codeunit. The supplied failure worker is an ordinary codeunit and is invoked by A12, not selected as a test.

## Route B � an existing verified test-runner integration

Run **DR Test Runner 71304** through the integration you already use. It invokes 71300 and 71301 with Function isolation. Do not invent a web-client URL that can run codeunits. If the integration cannot show individual outcomes, use native Test Explorer or fix the evidence route before class.

The fixture uses synthetic Customer records and intentionally avoids a dependency on Library - Sales. It does not test sales/posting setup or user permissions. A12 commits fixture setup before Boolean Codeunit.Run; Function isolation rolls back test database changes, including setup commits. No explicit Commit is allowed in the application operation.

## Instructor baseline

The extension repository has a published [ALDC 5.0.3 VSIX](https://github.com/javiarmesto/aldc-vscode-extension/releases/tag/v5.0.3), verified on 19 October 2026. Use this available artifact as the baseline for today's rehearsal; this does not certify your installed toolkit or workflow. No 5.0.4 release was listed in that repository at the check. Do not delay the content freeze waiting for it.

Reference: [Microsoft: Run AL tests from Visual Studio Code](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-test-explorer-vscode). Route instructions verified against documentation; execution in this workshop's sandbox is still pending.

