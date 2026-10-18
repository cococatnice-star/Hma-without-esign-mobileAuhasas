---
name: Artifact source sync
description: Preserve Replit artifact registration when importing a source tree into an existing artifact.
---

When syncing source files into a registered artifact, keep the artifact directory and its Replit-generated `.replit-artifact/artifact.toml` in place. Replace its contents without removing the artifact root.

**Why:** removing a registered artifact directory during a bulk source import caused Replit to unregister that artifact and stop its workflow, even after the directory was recreated.

**How to apply:** stage imported files elsewhere, then copy or replace children in the registered directory while preserving its root, generated manifest, and any active `node_modules` or build output. If it has already been unregistered, recreate it through the artifact flow before copying the source files back.
