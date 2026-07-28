# Code Review Process

This repository uses **Claude Code** as an automated code reviewer on every pull request. This document outlines the review workflow, PR guidelines, and how to interpret review feedback.

## How It Works

When you open or update a pull request, a GitHub Action triggers Claude Code to review the changed `.sql` files. Claude Code reads the project rules defined in `CLAUDE.md` and evaluates your code against them. Review comments appear directly on the PR within a few minutes.

## Pull Request Guidelines

### Branch Naming

Use a descriptive branch name with a category prefix:

- `feature/` — new objects (tables, views, procedures)
- `fix/` — corrections to existing logic
- `refactor/` — structural improvements with no behavior change
- `docs/` — documentation-only changes

Examples: `feature/vw-product-inventory`, `fix/usp-search-products-sql-injection`, `refactor/remove-correlated-subqueries`.

### PR Structure

- **One logical change per PR.** A new stored procedure is one PR. Renaming columns across five tables is one PR. Don't mix unrelated changes.
- **Include a clear title and description.** State what the change does and why. Reference any related tickets or discussions.
- **Keep PRs small.** Aim for fewer than 300 lines changed. Large PRs get slower, lower-quality reviews from both humans and AI.

### Commit Messages

Follow this format:

```
<type>: <short summary>

<optional body explaining why, not what>
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`.

Examples:
```
feat: add vw_CustomerOrderSummary view

Aggregates order header and detail data per customer
to support the sales dashboard in Power BI.
```

```
fix: parameterize dynamic SQL in usp_SearchProducts

Replaces string concatenation with sp_executesql to
prevent SQL injection.
```

## Review Feedback Categories

Claude Code labels each comment with a severity level:

### Blocking

Must be resolved before the PR can be merged. These include:

- SQL injection vulnerabilities
- Incorrect JOIN logic that produces wrong results
- Missing error handling on DML operations
- Use of features unsupported in Microsoft Fabric

### Suggestion

Recommended improvements that are not merge-blocking:

- Formatting and naming convention alignment
- Performance optimizations
- Missing header comment blocks
- Code clarity improvements

### Positive

Claude Code also highlights good patterns — well-structured queries, proper NULL handling, clean naming. These reinforce team standards.

## Responding to Review Comments

- **Agree and fix** — Push a new commit addressing the feedback. Claude Code will re-review the updated files.
- **Disagree with reason** — Reply to the comment explaining your rationale. Not every suggestion needs to be accepted, but document why you're diverging from the standard.
- **Ask for clarification** — If a comment is unclear, reply and ask. The team can discuss in the PR thread.

## What Claude Code Checks

The full set of rules lives in `CLAUDE.md`. Here is a summary:

| Area | What Gets Flagged |
|---|---|
| **Correctness** | Wrong JOINs, missing NULL handling, logic errors |
| **Performance** | SELECT *, correlated subqueries, implicit conversions, missing EXISTS |
| **Security** | Dynamic SQL without parameterization, hardcoded credentials |
| **Standards** | Naming violations, lowercase keywords, missing semicolons |
| **Fabric Compatibility** | Unsupported features (CLR, linked servers, encryption functions) |
| **Best Practices** | Missing TRY...CATCH, missing SET NOCOUNT ON, no header comments |

## Merge Requirements

A PR is ready to merge when:

1. Claude Code review has no unresolved blocking comments.
2. At least one team member has approved the PR.
3. All CI checks pass.
4. The PR description is complete.

## File Checklist Before Opening a PR

- [ ] File is in the correct folder (`/views`, `/stored-procedures`, `/functions`, `/tables`).
- [ ] File name follows `SchemaName.ObjectName.sql` pattern.
- [ ] Header comment block is present with purpose, author, and date.
- [ ] SQL keywords are uppercase.
- [ ] No `SELECT *` in any view or procedure.
- [ ] Statement ends with a semicolon.
- [ ] Tested against the SalesLT database in Fabric.