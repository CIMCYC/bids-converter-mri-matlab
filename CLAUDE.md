# Project guidelines

## Keep the README up to date

Whenever a change is made in this repository, consider whether `README.md`
needs to be updated, and update it if so. The README documents both the user
guide and the internal architecture, so it can drift out of sync with the code.

Check the README after changes such as:

- Adding, removing, or renaming a `dcm{i}` field in `cfg/folders_to_convert.m`
  (e.g. a new BIDS entity or behavior flag) — update the field reference table
  and the relevant use-case example.
- Changing the conversion flow or adding/removing functions in `src/` — update
  the "How it works internally" section.
- Changing options in `cfg/configuration_file.m` or
  `cfg/dataset_description.m` — update the corresponding configuration tables.
- Changing the supported data types, modalities, output layout, or
  filename-construction order.

If a change does not affect anything documented in the README, no update is
needed — but make that determination explicitly rather than skipping the check.

## Language & documentation

- All code, comments, and documentation in this repository are written in
  **English**, even when the project is discussed in another language.

## Code conventions

- One function per file in `src/`; the file name matches the function name.
- Use `snake_case` for function names and for `cfg` / `dcm` struct fields.
- The `cfg` struct is threaded through the pipeline: functions take `cfg` and
  return the modified `cfg` when they extend it.
- To write or modify JSON sidecars, reuse `update_json.m` (read-modify-write)
  and keep the `verLessThan('matlab','9.10')` guard around
  `jsonencode(..., 'PrettyPrint', true)`.
- Console output uses `fprintf` with `<strong>...</strong>` tags and the
  existing indentation style.
- Clean up duplicate underscores in generated filenames with
  `remove_duplicate_char`.

## BIDS compliance

- The purpose of this tool is to produce a valid BIDS dataset. When adding
  entities or fields, follow the BIDS specification
  (<https://bids-specification.readthedocs.io>).
- Preserve the BIDS-mandated entity order in `generate_bids_filename.m`
  (`desc-` stays last, just before the modality suffix).
- Do not break existing safeguards: never overwrite a subject's output
  (existing `sub-XX/` folders are renamed, not replaced), and create top-level
  or derivatives files only when they do not already exist.

## Verification & environment

- There are no automated tests. Verify changes by running `bids_mri_converter`
  on real DICOM data and inspecting the resulting dataset.
- `cfg/configuration_file.m` holds the user's local absolute paths (root
  folder, output directory, converter paths). Do not overwrite these real
  values when editing examples.
