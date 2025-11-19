<!--
Sync Impact Report - Version 1.1.0
================================================================================
VERSION CHANGE: 1.0.0 → 1.1.0

BUMP RATIONALE: MINOR - Added new principle for documentation language requirements

PRINCIPLES MODIFIED:
  ✓ V. Documentation Language Standards (new) - Mandates Traditional Chinese for user-facing docs

SECTIONS MODIFIED:
  ✓ Governance - Updated execution guidance to reference language requirements

TEMPLATES STATUS:
  ✅ plan-template.md - Compatible, plan documents should use zh-TW
  ✅ spec-template.md - Compatible, specifications should use zh-TW
  ✅ tasks-template.md - Compatible, task descriptions should use zh-TW
  ✅ checklist-template.md - Compatible, checklist items should use zh-TW
  ✅ agent-file-template.md - Compatible with language requirements
  ⚠️  All templates - Teams should update examples to demonstrate zh-TW usage

FOLLOW-UP TODOS:
  - Update template examples to use Traditional Chinese
  - Ensure existing specs/plans migrate to zh-TW format

AMENDED: 2025-11-19
================================================================================
-->

# Money Manager Frontend Constitution

## Core Principles

### I. Code Quality Standards

All code MUST adhere to the following quality standards:

- **Type Safety**: MUST use TypeScript strict mode (`strict: true`), prohibit `any` type unless explicitly documented with rationale
- **Code Style**: MUST pass ESLint and Prettier checks with zero warnings and zero errors
- **Component Design**: Components MUST follow the Single Responsibility Principle, each handling exactly one concern
- **Readability**: Functions MUST remain concise (≤50 lines), complex logic MUST be decomposed into smaller testable helper functions
- **Documentation**: All public APIs, complex algorithms, and non-obvious decisions MUST include JSDoc comments explaining intent and usage

**Rationale**: Type safety catches errors at compile time, reducing runtime failures. Consistent code style reduces cognitive load and accelerates code reviews. Clear structure and documentation facilitate knowledge sharing, lower maintenance costs, and enable new team members to onboard quickly.

### II. Testing Discipline (NON-NEGOTIABLE)

Testing MUST follow strict test-first discipline:

- **Test-First Workflow**: All new features and bug fixes MUST follow this flow:
  1. Write tests describing expected behavior
  2. Verify tests fail (Red)
  3. Implement minimal code to make tests pass (Green)
  4. Refactor to improve design (Refactor)
- **Test Coverage**: MUST maintain minimum 80% code coverage; critical business logic (financial calculations, data validation) MUST achieve 100%
- **Layered Testing Strategy**:
  - **Unit Tests**: MUST test pure functions, utilities, business logic (isolated tests, fast execution <1 second)
  - **Component Tests**: MUST test UI component rendering, user interactions, state management (using Testing Library principles)
  - **Integration Tests**: MUST test API integrations, data flows, cross-component communication (mock external services)
  - **End-to-End Tests**: MUST cover critical user journeys and business workflows (login, transaction creation, report generation)
- **Test Quality**: Tests MUST run independently (no order dependencies), have descriptive names, verify behavior not implementation details

**Rationale**: Test-First ensures code testability and forces requirements clarification. High coverage builds confidence for refactoring. Layered testing strategy balances execution speed with comprehensiveness, catching defects at all levels early in development.

### III. User Experience Consistency

User interfaces MUST follow consistency and accessibility standards:

- **Design System**: MUST use unified design token system defining colors, font sizes, spacing, border radius, shadows, and other visual properties
- **Component Library**: MUST prioritize reusable components from shared library, avoid duplicating similar functionality
- **Responsive Design**: All interfaces MUST support the following breakpoints with appropriate layouts:
  - Mobile: ≥375px (primary target)
  - Tablet: ≥768px
  - Desktop: ≥1024px
- **Accessibility (WCAG 2.1 AA)**: MUST meet the following standards:
  - All interactive elements MUST support keyboard navigation (Tab, Enter, Escape)
  - Color contrast MUST meet 4.5:1 (regular text) and 3:1 (large text and UI components)
  - Images and icons MUST have meaningful alt text
  - Form fields MUST have associated labels and clear error messages
  - Use semantic HTML (`<button>`, `<nav>`, `<main>`)
- **Loading States**: All asynchronous operations MUST provide visual feedback (loading indicators, skeleton screens, or progress bars)
- **Error Handling**: Error messages MUST be clear, actionable, user-friendly, avoiding technical jargon (e.g., "Unable to save transaction data" not "HTTP 500 error")

**Rationale**: Consistent design reduces user learning curve and builds trust. Accessibility ensures all users (including those with visual or motor impairments) can use the application and meets regulatory requirements. Immediate feedback improves perceived performance and reduces user anxiety.

### IV. Performance Requirements

Performance MUST meet the following measurable standards (based on Core Web Vitals):

- **Initial Load Performance**:
  - First Contentful Paint (FCP) MUST ≤1.5 seconds
  - Largest Contentful Paint (LCP) MUST ≤2.5 seconds
  - Time to Interactive (TTI) MUST ≤3.5 seconds
- **Interaction Performance**:
  - First Input Delay (FID) MUST ≤100ms
  - Cumulative Layout Shift (CLS) MUST ≤0.1
  - All user actions (button clicks, form inputs) MUST provide visual feedback within 100ms
- **Bundle Size Limits**:
  - Initial JavaScript bundle MUST ≤200KB (gzipped)
  - Total asset size on first load MUST ≤1MB
  - Routes and large third-party libraries MUST use code splitting for lazy loading
- **Resource Optimization**:
  - Images MUST use modern formats (WebP, AVIF) with appropriate sizes per device
  - Critical CSS MUST be inlined in HTML, non-critical CSS lazy loaded
  - Third-party scripts MUST load asynchronously and be periodically evaluated for necessity
  - MUST implement font subsetting to reduce font file sizes
- **Performance Monitoring**: MUST implement Real User Monitoring (RUM) in production to collect real user data and set performance degradation alerts

**Rationale**: Performance directly impacts user satisfaction, retention, and conversion rates. Measurable metrics provide objective accountability and support data-driven optimization decisions. Continuous monitoring ensures performance doesn't degrade over time.

### V. Documentation Language Standards

Documentation MUST follow language requirements based on audience:

- **User-Facing Documentation**: MUST be written in Traditional Chinese (zh-TW):
  - Feature specifications (`spec.md`)
  - Implementation plans (`plan.md`)
  - Task lists (`tasks.md`)
  - User guides and quickstart documents
  - Product requirements and acceptance criteria
  - UI text, error messages, and user notifications
- **Developer Documentation**: MAY be written in English:
  - Code comments and JSDoc annotations
  - Technical architecture documents
  - API contracts (when consumed only by developers)
  - Git commit messages
- **Constitution**: MUST remain in English as the authoritative governance document
- **Templates**: SHOULD provide examples in Traditional Chinese to demonstrate expected usage

**Rationale**: Traditional Chinese as the primary language ensures clarity for the target user base and product stakeholders. English for technical documentation leverages industry-standard terminology and facilitates integration with international tools and libraries. The constitution remains in English to serve as a stable, language-agnostic governance foundation.

## Quality Gates

Before code merge, the following quality gates MUST all pass:

### Automated Checks (CI Pipeline)

- ✅ **TypeScript Compilation**: `tsc --noEmit` with no errors
- ✅ **Linting**: `eslint` passes with zero errors and zero warnings
- ✅ **Formatting**: `prettier --check` passes
- ✅ **Test Execution**: All tests (unit, component, integration) pass
- ✅ **Test Coverage**: Overall coverage ≥80%, new code coverage ≥90%
- ✅ **Bundle Size Analysis**: Bundle growth ≤10% (exceeding requires documentation)
- ✅ **Accessibility Testing**: `axe-core` or equivalent tool with no violations
- ✅ **Security Scanning**: Dependencies have no known high-severity vulnerabilities

### Code Review (Manual)

- ✅ At least one team member approval
- ✅ All review comments resolved or explicitly documented for follow-up
- ✅ New features have corresponding tests (test-first: write test, verify failure, then implement)
- ✅ Breaking changes have documentation and migration guide
- ✅ Performance impact assessed (provide benchmark results when necessary)
- ✅ Complies with constitution principles (code quality, testing, UX, performance, documentation language)

### Pre-Deployment Verification

- ✅ Verified in staging environment
- ✅ Critical user flows manually tested
- ✅ Lighthouse performance score ≥90 (mobile and desktop)
- ✅ Cross-browser testing complete (Chrome, Firefox, Safari latest two versions)
- ✅ Visual regression testing passed (using screenshot comparison or visual testing tools)

## Governance

### Constitutional Authority

This constitution defines the non-negotiable principles and standards for this project:

- This constitution **SUPERSEDES** all other development practices, team conventions, and individual preferences
- All Pull Requests MUST pass constitutional compliance checks before merging
- Code reviewers MUST verify that changes comply with all constitutional principles
- Code violating the constitution MUST NOT be merged to main branch unless following the exemption process (see below)

### Exemption Process

In rare cases where constitutional principles must be violated, MUST follow this process:

1. **Document Violation**: Clearly state in Pull Request description:
   - Which principle is violated?
   - Why must it be violated?
   - What alternatives were evaluated? Why were they rejected?
2. **Proposal Review**: Propose at least one simpler alternative and explain why it's not viable
3. **Multiple Approvals**: Requires explicit approval from at least two senior developers
4. **Technical Debt Tracking**: Create an issue to track this violation with resolution plan and timeline

### Amendment Process

Constitutional amendments MUST follow a structured process to ensure thoughtful consideration:

1. **Proposal Phase**: Create an issue in project repository detailing:
   - Proposed amendment content
   - Rationale and background
   - Impact scope on existing codebase
2. **Discussion Period**: Team members discuss for at least 3 business days, gathering feedback and concerns
3. **Documentation**: Update constitution document, including:
   - Complete description of changes
   - Rationale and impact analysis
   - Examples demonstrating how to apply new principles
4. **Migration Plan**: If amendment affects existing code, MUST provide:
   - Clear migration steps
   - Timeline and milestones
   - Responsible parties and resource requirements
5. **Approval Mechanism**: Requires team consensus (at least 75% member approval)
6. **Version Update**: Update version number according to semantic versioning rules:
   - **MAJOR (X.0.0)**: Remove or redefine principles (breaking changes)
   - **MINOR (0.X.0)**: Add new principles or significantly expand existing guidance
   - **PATCH (0.0.X)**: Clarify wording, fix errors, non-semantic improvements

### Compliance Review

Regular reviews ensure the constitution remains effective:

- **Quarterly Review**: Review constitutional compliance status every quarter
- **Identify Patterns**: Collect systemic violations or common exemption requests
- **Improvement Plans**: Develop remediation measures for problem areas
- **Tool Updates**: Update linting rules, automated checks, CI pipeline to better enforce principles
- **Education & Training**: Conduct team workshops or knowledge sharing based on review findings

### Runtime Guidance

Daily development MUST use the following resources to ensure constitutional compliance:

- Use templates in `.specify/templates/` for feature specifications, plans, and task breakdown
- Use Speckit commands in `.github/prompts/` to automate specification workflows (`/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, etc.)
- New team members MUST read and understand this constitution during their first week of onboarding
- Technical decision discussions MUST reference constitutional principles as the decision framework
- Dispute resolution MUST use constitutional principles as the final arbiter
- **All specifications, plans, and user-facing documentation MUST be written in Traditional Chinese (zh-TW)** per Principle V

**Version**: 1.1.0 | **Ratified**: 2025-11-19 | **Last Amended**: 2025-11-19
