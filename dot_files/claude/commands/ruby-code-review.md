---
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git status:*)
description: Perform a comprehensive Ruby code review on the current branch
---

Perform a comprehensive code review on all changes in the current branch compared to `origin/main`.

## Steps

1. **Gather Changes**: Run `git diff origin/main...HEAD` to get all changes in the current branch.

2. **Identify Modified Files**: List all Ruby files (`.rb`) and spec files that have been modified or added.

3. **Launch Review Agent**: Use the `rails-solid-developer` agent to perform a comprehensive review of each changed file. The review must evaluate:

   ### Code Quality (Clean Code)
   - Methods should be 5-10 lines maximum
   - Classes should be 100-200 lines maximum
   - Descriptive naming that reveals intent
   - Guard clauses to reduce nesting
   - No magic numbers (use constants)
   - Command-Query Separation

   ### SOLID Principles
   - **Single Responsibility**: Each class/method has ONE reason to change
   - **Open/Closed**: Design for extension without modification
   - **Liskov Substitution**: Subtypes substitutable for base types
   - **Interface Segregation**: Minimal, focused interfaces
   - **Dependency Inversion**: Depend on abstractions, not concretions

   ### Ruby Best Practices
   - Proper use of ActiveRecord patterns
   - N+1 query prevention with `includes`, `joins`, `preload`
   - Appropriate use of concerns vs service objects
   - Rails conventions and idioms
   - Proper error handling

   ### BetterSpecs Standards (for spec files)
   - Descriptive `describe` and `context` blocks
   - One expectation per example when possible
   - Test behavior, not implementation
   - **Only test public methods** - never test private/protected directly
   - Use `let` for reusable test data
   - Use `subject` for the object under test
   - Present tense descriptions: "returns products" not "should return products"
   - Factories (FactoryBot) over fixtures

4. **Report Findings**: Present a structured report with:
   - **Summary**: Overall assessment of code quality
   - **Critical Issues**: Must-fix problems (N+1 queries, SOLID violations, security)
   - **Improvements**: Suggested refactorings with code examples
   - **Spec Issues**: BetterSpecs violations in test files
   - **Strengths**: What the code does well

## Output Format

```
## Code Review Summary

**Branch**: [branch name]
**Files Reviewed**: [count]
**Overall Assessment**: [brief assessment]

### Critical Issues
[List any critical issues that must be addressed]

### Code Quality Issues
[List any clean code violations with file:line references]

### SOLID Violations
[List any SOLID principle violations with explanations]

### Spec Issues (BetterSpecs)
[List any test file issues]

### Suggested Improvements
[Concrete suggestions with code examples]

### Strengths
[What the code does well]
```
