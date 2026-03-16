LinkML validation and review checklist

Schema-level checks (lint):
- prefixes mapping exists and contains at least one useful prefix
- No duplicate slot names or class names
- Every slot has an explicit range where appropriate
- identifier: true present or id strategy documented
- slot_usage used only for class-specific refinements
- No illegal cross-references or unresolved references
- Cardinalities make sense (min/max consistent)

Instance-level checks (validate):
- Instances conform to required slots and cardinalities
- Enum values match declared enums (case/format)
- Identifiers are well-formed CURIEs/URIs when expected
- Data types (xsd: types) match values

Acceptance checks (artefacts):
- Generated docs render the model and show examples
- JSON Schema (if generated) validates the same instances
- RDF/Turtle generation (where requested) maps prefixes correctly

Recommended commands (examples):
- ./scripts/lint_linkml.sh schema.yaml
- ./scripts/validate_linkml.sh schema.yaml instance.json
- ./scripts/gen_docs.sh schema.yaml docs-out/

When lint flags issues, include: severity, location (class/slot), suggested fix.