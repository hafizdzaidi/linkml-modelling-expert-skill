#!/usr/bin/env python3
"""
Quick SchemaView-based schema profiler.
Usage: python profile_schema.py schema.yaml
Requires: linkml-runtime==1.10.0
"""
import sys

try:
    # Preferred import path
    from linkml_runtime.utils.schemaview import SchemaView
except Exception:
    try:
        from linkml_runtime import SchemaView
    except Exception:
        print("linkml-runtime not found. Install: pip install linkml-runtime==1.10.0")
        sys.exit(2)


def main(schema_path):
    sv = SchemaView(schema_path)
    classes = sv.all_classes() or {}
    slots = sv.all_slots() or {}
    enums = sv.all_enums() or {}
    prefixes = getattr(sv.schema, 'prefixes', {}) or {}

    # Counts and quick lists
    print(f"Classes: {len(classes)}")
    print(f"Slots: {len(slots)}")
    print(f"Enums: {len(enums)}")
    print(f"Prefixes: {len(prefixes)}")

    # Top-level snippet
    top_classes = list(classes.keys())[:10]
    print("Top-level classes:", ", ".join(top_classes) or "(none)")

    # Slots without a declared range
    no_range = [s.name for s in slots.values() if not getattr(s, 'range', None)]
    if no_range:
        print(f"Slots without range ({len(no_range)}): {', '.join(no_range[:20])}")
    else:
        print("All slots have explicit ranges.")

    # Classes with slot_usage
    classes_with_su = [c.name for c in classes.values() if getattr(c, 'slot_usage', None)]
    if classes_with_su:
        print("Classes with slot_usage:", ", ".join(classes_with_su[:20]))
    else:
        print("No slot_usage found in classes.")

    print('\nRecommended next steps:')
    print(f"- Run: ./scripts/lint_linkml.sh {schema_path}")
    print(f"- Validate example instances with ./scripts/validate_linkml.sh {schema_path} <instance>")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: profile_schema.py schema.yaml")
        sys.exit(2)
    main(sys.argv[1])
