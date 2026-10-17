# Clean State Checklist (Session Exit)

Before closing the session or committing work, all 5 checklist items MUST be verified:

- [ ] **1. Build Passes**: `make check` exits with return code 0.
- [ ] **2. Feature List Updated**: Active feature marked with correct status (`passing` or `blocked`) and evidence is populated.
- [ ] **3. PROGRESS.md Updated**: `Current State` contains latest commit hash and test status; `Next Steps` has concrete action.
- [ ] **4. No Debug Artifacts**: Temporary logs, `.tmp` files, and print/debug statements have been removed.
- [ ] **5. Clean Startup**: `./init.sh` runs cleanly from a fresh terminal.
