Generators and SchemaView (runtime)

linkml-runtime provides SchemaView which is the canonical runtime representation for introspection. Use SchemaView for:
- counting classes/slots/enums
- finding slot_usage occurrences
- discovering prefixes and CURIE resolution
- producing targeted reports used in reviews

Generators
- LinkML supports multiple generators (JSON Schema, Markdown/HTML docs, RDF/Turtle). Use them as "proof artefacts" during acceptance.
- When recommending a generator, include the exact command and expected output path.

Notes
- Prefer SchemaView-based profiling for programmatic checks instead of ad-hoc YAML scanning.
- Keep generated artefacts under a clearly named output directory for review (e.g., docs/ or generated/).