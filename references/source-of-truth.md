Source-of-truth hierarchy for the linkml-modelling-expert skill

1. Official LinkML user documentation (https://linkml.io/) — primary guidance for schema designers: how to structure classes, slots, enums, prefixes, slot_usage, inlining and generators.

2. linkml-model (the metamodel/specification stream) — the formal schema that defines LinkML semantics. Treat as authoritative for schema fields and types.

3. linkml-runtime (SchemaView, loaders/dumpers) — runtime behaviour, introspection APIs, and how the schema is exposed to code and validators.

4. Ecosystem tools (linkml-lint, linkml CLI, generators) — used for linting, validation, and artefact generation. Use these only after the schema design is stable.

When in doubt, prefer the official docs for modelling guidance, consult linkml-model for exact field semantics, then verify runtime behaviour with linkml-runtime (SchemaView).