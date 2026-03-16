---
name: linkml-modelling-expert
description: Author, review, refactor, lint, and validate LinkML schemas using current official LinkML documentation and metamodel guidance. Use for classes, slots, enums, slot_usage, prefixes, inlining, validation, SchemaView-based inspection, and downstream artefact generation. Do not use for generic ontology advice or non-LinkML modelling tasks.
version: 1.0.0
argument-hint: "[action] <schema-file>"
tooling:
  linkml: "1.10.0"
  linkml-runtime: "1.10.0"
  note: "linkml-model (metamodel) is authoritative for schema specification; linkml-runtime provides runtime support (SchemaView, loaders, dumpers)."
---

Skill mission
------------
Author, refactor, review, lint, and validate LinkML schemas against the official LinkML documentation and metamodel guidance. Always produce operational artefacts (schema fragments, lint/validation commands, generated outputs) and an explicit modelling rationale.

Trigger boundary / routing signals
---------------------------------
Invoke this skill only for LinkML schema design, review, linting, instance validation, or artefact generation. Do NOT invoke for general ontology philosophy, non-LinkML modelling tasks, or purely conceptual discussions.

Operational workflow (deterministic)
------------------------------------
1. Classify structural form (must do first): flat table, tree (hierarchical), normalized relations (relational/joins), or ontology graph. Choose modelling patterns based on form.
2. Enforce modelling defaults:
   - Require explicit prefixes mapping at the schema root. Lint against known registries when available.
   - Use slot_usage for class-scoped refinements only. Prefer reusable base slots for global semantics.
   - Explicitly declare ranges for object slots and be deliberate about representation/inlining.
   - Provide an identifier slot (identifier: true) or an explicit id strategy.
3. Lint first, then validate instances, then generate proof artefacts (docs, JSON Schema, RDF). Use linkml-lint and the linkml CLI or runtime tools.
4. Produce a short profile (SchemaView) summarising classes, slots, enums, prefixes, and slot_usage occurrences.

Response requirements (always include)
-------------------------------------
For any substantive modelling answer include these five items:

1) Proposed schema fragment or revision (YAML). Keep fragments minimal and patch-like when possible.

2) Modelling rationale: concise bullets tying choices to structural form, downstream consumers, and LinkML best practice.

3) Lint and validation commands to run (exact CLI lines or script invocations). Prefer the local scripts in ./scripts/ where applicable.

4) Downstream artefacts worth generating (docs, JSON Schema, RDF/Turtle, TSV mappings, examples) and the commands to generate them.

5) Any unresolved ambiguity or trade-off that needs user decision.

Validation order (enforced)
---------------------------
1. linkml-lint (schema linting)
2. instance validation (linkml validate / linkml-validate)
3. proof artefacts (docs, generated JSON Schema, RDF) used as acceptance evidence

Scripts and helpers (paths in this skill bundle)
------------------------------------------------
- scripts/lint_linkml.sh  — run linkml-lint or linkml lint
- scripts/validate_linkml.sh — validate an instance against a schema
- scripts/gen_docs.sh — generate documentation (HTML/Markdown) using available generators
- scripts/profile_schema.py — quick SchemaView-based introspection using linkml-runtime

Source-of-truth hierarchy (hard-coded)
-------------------------------------
1. Official LinkML user documentation (linkml.io) — primary for modelling guidance
2. linkml-model (metamodel/specification) — authoritative for schema semantics
3. linkml-runtime behaviour (SchemaView, loaders/dumpers) — runtime expectations
4. Ecosystem tools (linkml-lint, generators) — practical tooling

Acceptance criteria
-------------------
- linkml-lint exits with zero and no high-severity findings, or findings are documented with remediation
- Example instances validate cleanly against the schema
- Generated documentation or JSON Schema exists and surfaces the model clearly

Testing and fixtures
--------------------
Include minimal fixtures: a minimal schema, an inheritance+slot_usage example, an explicit prefix example, a failing instance demonstrating a validation failure, and one case where the recommended action is to reject the modelling choice.

Notes for implementers
----------------------
- Always reference tool versions pinned above when recommending commands.
- Keep answers procedural and provide exact commands the user can run locally.
- If a user asks for high-level design only, still return the five items (use small example fragments and commands).

Examples (prompt -> answer sketch)
---------------------------------
Prompt: "Refactor this schema to use slot_usage for class-specific refinements"
Answer must include: (1) minimal YAML patch using slot_usage; (2) short rationale; (3) ./scripts/lint_linkml.sh schema.yaml; (4) docs/jsonschema to generate; (5) trade-offs (e.g., slot reuse vs duplication).
