Recognising structural forms and recommended LinkML patterns

Structural forms (classify first):
- Flat table: records with atomic fields. Use simple slots, avoid deep nesting, prefer TSV/CSV mappings.
- Tree/hierarchical: parent-child nesting (e.g., document->sections). Use classes with containment slots and consider inlining for small children.
- Normalised relations: entities with many-to-many relationships. Model as separate classes connected by object-valued slots (use identifiers and join-friendly ranges).
- Ontology graph: richly typed nodes with graph semantics. Use classes, enums, prefixes and explicit CURIE-based identifiers; prepare RDF generation.

Patterns and practices
- Prefixes: always declare an explicit prefixes mapping at schema root. Map to stable registries where possible.
- slot_usage: use to refine a reusable slot in a class-specific context (e.g., change range/cardinality for a slot only in that class). Avoid ad-hoc duplication of slots.
- Inlining: choose inlining for small, embedded value objects; explicitly document why a slot is inlined and the cardinality implication.
- Identifiers: include an identifier slot (identifier: true) or clearly document the id strategy (CURIEs vs URIs).
- Ranges: always set explicit ranges for object-valued slots (class names) rather than free-text ranges.

Examples (small):
- slot_usage: show a base slot 'date' reused with different cardinality in two classes.
- inlining: child objects with max 1 cardinality can be inlined to simplify JSON output.

These patterns lead to predictable downstream artefacts (JSON Schema, RDF).