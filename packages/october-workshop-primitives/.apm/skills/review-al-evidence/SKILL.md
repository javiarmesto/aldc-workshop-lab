---
name: review-al-evidence
description: Review an AL change against its supplied specification and report actionable findings with evidence. Use for a requested review of an implemented workshop increment.
---

# Review an AL increment

Use the specification for this increment, its diff and the evidence supplied with the task. Preserve its business rules, object range and application version.

For a finding, identify the affected location, the expected behavior and the observation that supports it. Point to the relevant acceptance criterion or source. A missing test result is a limit on verification, not proof that the implementation is defective.

Separate code inspection and knowledge citations from executed compiler or test results. State which revision and environment the available execution evidence covers. Do not report a check as executed when the task only supplies expected output.

Recommend a focused correction only when the evidence supports it. If no actionable issue is found, report the scope inspected and any remaining uncertainty. Use the response format requested by the caller.

