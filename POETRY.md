Poetry migration notes for linkml-modelling-expert

This skill has been migrated to use Poetry for environment management.

Requirements:
- Python >= 3.10

Setup:
1. Install Poetry: https://python-poetry.org/docs/#installation
2. In the skill directory, run:
   poetry install

Run scripts:
- Use: poetry run python scripts/profile_schema.py
- Or: poetry shell  # then run scripts normally

Notes:
- The pyproject pins LinkML tooling (linkml==1.10.0, linkml-runtime==1.10.0) to match the SKILL guidance.
