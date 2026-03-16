Quick review checklist (use during PR reviews)

- Is there an explicit 'prefixes' mapping at the schema root?
- Are class and slot names clear and documented (short descriptions)?
- Is slot_usage only used for class-specific refinements?
- Do object-valued slots have explicit ranges?
- Is there a documented identifier strategy?
- Has linkml-lint been run and high-severity issues addressed?
- Are representative instances provided and validated?
- Are generated docs present for reviewer convenience?

If any of the above are missing, request a minimal patch showing the intended change plus commands to reproduce lint/validate results.