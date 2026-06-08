# DICOM to BIDS Converter (MATLAB)

A set of MATLAB functions and scripts that convert raw MRI DICOM data into a
[BIDS](https://bids-standard.github.io/bids-validator/)-compliant dataset
(NIfTI + JSON sidecars). It wraps [`dcm2niix`](https://github.com/rordenlab/dcm2niix)
(and [`spec2nii`](https://github.com/wexeee/spec2nii) for spectroscopy),
generates BIDS-compliant filenames and directory layouts, fixes the metadata
that the converters cannot produce on their own (TaskName, phase units, fmap
identifiers, ASL context, …), and creates the mandatory top-level BIDS files
(`dataset_description.json`, `README`, `LICENSE`, `CHANGES`, `.bidsignore`).

> Brain, Mind and Behavioral Research Center — University of Granada.
> Contact: dlopez@ugr.es (David López-García)

---

## Table of contents

1. [Features](#features)
2. [Requirements & installation](#requirements--installation)
3. [Input data structure](#input-data-structure)
4. [Quick start](#quick-start)
5. [Configuration](#configuration)
   - [`configuration_file.m`](#1-configuration_filem--global-options)
   - [`dataset_description.m`](#2-dataset_descriptionm--dataset-level-metadata)
   - [`folders_to_convert.m`](#3-folders_to_convertm--what-to-convert)
6. [Field reference (`dcm{i}`)](#field-reference-dcmi)
7. [Use cases & examples](#use-cases--examples)
   - [Anatomical (`anat`)](#anatomical-anat)
   - [Functional (`func`)](#functional-func)
   - [Field maps (`fmap`)](#field-maps-fmap)
   - [Diffusion (`dwi`)](#diffusion-dwi)
   - [Spectroscopy (`mrs`)](#spectroscopy-mrs)
   - [Perfusion / ASL (`perf`)](#perfusion--asl-perf)
   - [Derivatives](#derivatives)
   - [Sourcedata (non-convertible series)](#sourcedata-non-convertible-series)
8. [BIDS filename construction](#bids-filename-construction)
9. [Output layout](#output-layout)
10. [How it works internally](#how-it-works-internally)
11. [Folder-matching behavior](#folder-matching-behavior)
12. [Notes, limitations & troubleshooting](#notes-limitations--troubleshooting)

---

## Features

- DICOM → NIfTI conversion via `dcm2niix`, spectroscopy via `spec2nii`.
- Automatic BIDS-compliant filenames and `sub-XX/ses-YY/<datatype>/` layout.
- Supported data types: `anat`, `func`, `fmap`, `dwi`, `mrs`, `perf`.
- Supported BIDS entities: `task-`, `acq-`, `rec-`, `dir-`, `run-`, `echo-`,
  `part-`, `desc-` (plus `sub-`/`ses-`).
- Special-case handling:
  - Phase-difference and EPI (TOPUP) field maps, including
    `B0FieldIdentifier`/`B0FieldSource` wiring.
  - Phase reconstructions (`part-phase`) with their `Units` metadata.
  - Single-band reference (`sbref`) images with magnitude/phase split.
  - Functional `TaskName` injection and (optional) dummy `events.tsv`.
  - Arterial Spin Labeling (`asl`) metadata and `aslcontext.tsv`.
- BIDS `derivatives/<pipeline>/` output with its own `dataset_description.json`.
- BIDS `sourcedata/` output for series that **cannot** be converted to NIfTI.
- Optional metadata anonymization.
- Dataset- and subject-level conversion modes; single- or multi-session.
- Auto-generation of `dataset_description.json`, `README`, `LICENSE`,
  `CHANGES` and `.bidsignore`.

---

## Requirements & installation

You need four things: this repository, MATLAB, `dcm2niix`, and (optionally)
`spec2nii`.

### 1. Get the converter

Clone or download this repository to a local folder:

```bash
git clone https://github.com/<your-org>/bids-converter-mri-matlab.git
```

In MATLAB, set the **working directory to the repository root**
(`bids-converter-mri-matlab`) before running. The entry script adds `src/` to
the path and reads the files in `templates/` using relative paths, so it must
be run from the repo root.

### 2. MATLAB

MATLAB **R2019b (9.7) or newer** is recommended. On versions older than
R2021a (9.10) the code automatically falls back to a non–pretty-printed
`jsonencode`; everything still works, the JSON sidecars are just not indented.
No additional toolboxes are required.

### 3. Install the converters

- **`dcm2niix`** (required for all data types except spectroscopy) —
  download it from its official repository and follow the installation
  instructions provided there: <https://github.com/rordenlab/dcm2niix>
- **`spec2nii`** (only required for MR spectroscopy / `mrs` data) — download
  it from its official repository and follow the installation instructions
  provided there: <https://github.com/wtclarke/spec2nii>

### 4. Point the configuration to the executables

The converters do **not** need to be on the system `PATH` beforehand.
`check_dependencies.m` prepends `cfg.dcm2niix_path` and `cfg.spec2nii_path` to
the `PATH` for the MATLAB session and then checks that each tool is reachable.

In `cfg/configuration_file.m`, set both fields to the **folder that contains
the executable** (not the executable itself):

```matlab
cfg.dcm2niix_path = '/Users/you/anaconda3/bin';
cfg.spec2nii_path = '/Users/you/anaconda3/bin';
```

If you don't know where the package was installed, ask your system for the
location of the executable and use its containing folder. Run the command that
matches your operating system **in your computer's terminal** (Terminal on
macOS, a shell on Linux, or Command Prompt / PowerShell on Windows):

```bash
which dcm2niix     # macOS / Linux
where dcm2niix     # Windows
```

(do the same for `spec2nii`). The reported path is the executable; drop the
final `dcm2niix` / `spec2nii` filename and use the folder that contains it.

When you run the converter, the console prints the result of the check:

```
Checking data converters:
  - Data converter dcm2niix > OK
  - Data converter spec2nii > OK
```

A missing tool produces a **warning, not a hard error** — a dataset without
spectroscopy still converts even if `spec2nii` is absent. If you see a warning
for `dcm2niix`, double-check that `cfg.dcm2niix_path` points to the folder
holding the binary.

---

## Input data structure

The raw dataset must be organized hierarchically as
**root → subjects → sessions → DICOM series folders**:

```
root_folder/
├── 0001/                         # subject  -> sub-0001
│   ├── pre/                      # session  -> ses-pre
│   │   ├── t1_mprage_sag.../     # one folder per acquired series
│   │   ├── ep2d_bold_rest.../
│   │   └── gre_field_mapping.../
│   └── post/                     # session  -> ses-post
│       └── ...
├── 0002/
│   └── ...
└── ...
```

Key rules:

- **Subject and session IDs** are derived from the folder names. Any
  non-alphanumeric character is stripped (`get_subjects_list.m`), and the
  prefixes `sub-`/`ses-` are added automatically. So `0001` → `sub-0001`,
  `pre` → `ses-pre`. Use clean, alphanumeric folder names.
- **The session level is always expected.** Even for single-session studies,
  each subject folder must contain at least one subfolder. See `cfg.sessions`
  below for how that subfolder is treated.
- Hidden folders (names starting with `.`, e.g. `.DS_Store`) are skipped.
- Duplicated subject IDs (after sanitization) abort the run.

---

## Quick start

1. Edit the three configuration files in `cfg/` (see next section).
2. From the repository root in MATLAB, run:

   ```matlab
   bids_mri_converter
   ```

The entry script `bids_mri_converter.m` performs, in order:

```matlab
run cfg/dataset_description.m;     % dataset-level metadata
run cfg/configuration_file.m;      % global options (paths, format, ...)
run cfg/folders_to_convert.m;      % list of series to convert (dcm{...})

initialize_bids_dataset(cfg);      % create output + top-level BIDS files
check_dependencies(cfg);           % verify dcm2niix / spec2nii
subjects = get_subjects_list(cfg); % discover subjects & sessions
start_bids_conversion(cfg,dcm,subjects);
```

---

## Configuration

All user editing happens in three files inside `cfg/`.

### 1. `configuration_file.m` — global options

Defines the `cfg` struct that drives the whole run:

| Field | Values | Meaning |
|---|---|---|
| `cfg.root_folder` | path | Root of the raw data (dataset mode) **or** the path to a single subject folder (single-subject mode). |
| `cfg.conversion_mode` | `'dataset'` \| `'single_subject'` | `dataset`: scan `root_folder` for subject subfolders. `single_subject`: treat `root_folder` itself as one subject folder (its parent becomes the root). |
| `cfg.bids_directory` | path | Output directory for the BIDS dataset. |
| `cfg.sessions` | `true` \| `false` | `true`: every subfolder of a subject is a session (`ses-<name>`). `false`: only the **first** subfolder is used and the session level is omitted from filenames (`ses` empty). |
| `cfg.data_format` | `'y'` \| `'n'` \| … | Passed to `dcm2niix -z`. `'y'` = compressed `.nii.gz`, `'n'` = uncompressed `.nii`. |
| `cfg.anonymization` | `'y'` \| `'n'` | `'y'` removes personal info (name, DoB, sex, weight, …) from the JSON/NIfTI metadata. |
| `cfg.dcm2niix_path` | path | Folder containing the `dcm2niix` executable. |
| `cfg.spec2nii_path` | path | Folder containing the `spec2nii` executable (only needed for `mrs`). |

### 2. `dataset_description.m` — dataset-level metadata

Populates `cfg.dataset_description.json.*`, which is serialized into the
mandatory `dataset_description.json`. Set once per dataset:

- `Name` *(required)* — dataset name.
- `BIDSVersion` *(required)* — BIDS version string (also reused as the
  `BIDSVersion` of every derivatives pipeline, see below).
- `DatasetType` — `'raw'` or `'derivative'` (default `'raw'`).
- `License` — license abbreviation; the matching file in
  `templates/licenses/` is copied to `LICENSE` (e.g. `CCBY`, `CC0`).
- `Authors`, `Acknowledgements`, `HowToAcknowledge`, `Founding`,
  `EthicsApprovals`, `ReferencesAndLinks`, `DatasetDOI` — optional metadata.

Generation flags (which top-level files to create):

```matlab
cfg.dataset_description.flag              = true;   % dataset_description.json
cfg.dataset_description.include_readme    = true;   % README (from templates/)
cfg.dataset_description.include_license   = true;   % LICENSE (from templates/licenses/)
cfg.dataset_description.include_changes   = true;   % CHANGES (with creation date)
cfg.dataset_description.include_bidsignore= true;   % .bidsignore (from templates/)
```

Each file is only created if it does not already exist, so re-running the
converter is safe.

### 3. `folders_to_convert.m` — what to convert

Defines a cell array `dcm{...}`, one cell per DICOM series you want to convert.
Each cell is a struct describing that series. Only the `dcm` index order
matters for readability; gaps/empties are skipped safely.

```matlab
dcm{1}.folder    = 't1_mprage_sag*';   % glob, matched inside each session
dcm{1}.data_type = 'anat';
dcm{1}.modality  = 'T1w';
```

`folder` is matched as a wildcard pattern **within each session folder** (a
trailing `*` is added automatically if you omit it). See
[Folder-matching behavior](#folder-matching-behavior) for how multiple matches
are resolved.

---

## Field reference (`dcm{i}`)

**Required**

| Field | Description |
|---|---|
| `folder` | Wildcard pattern of the DICOM series folder (relative to each session). |
| `data_type` | `anat`, `func`, `fmap`, `dwi`, `mrs`, or `perf`. |
| `modality` | Suffix/category, e.g. `T1w`, `T2w`, `bold`, `sbref`, `dwi`, `fieldmap`, `epi`, `svs`, `asl`, … |

**Optional BIDS entities** (mapped to the corresponding `key-label`)

| Field | Entity | Notes |
|---|---|---|
| `task` | `task-` | Required for functional task/rest data. |
| `acquisition` | `acq-` | Custom acquisition label. |
| `reconstruction` | `rec-` | Reconstruction algorithm label. |
| `dir` | `dir-` | Phase-encoding direction (e.g. `AP`, `PA`); required for EPI fmaps. |
| `run` | `run-` | Run index for repeated acquisitions. |
| `echo` | `echo-` | Echo index (requires `EchoTime` in metadata). |
| `part` | `part-` | Complex component, e.g. `mag`, `phase`. |
| `desc` | `desc-` | Free-form description; **last entity before the suffix**. Mainly used for derivatives. |

**Optional behavior flags**

| Field | Applies to | Description |
|---|---|---|
| `fmapid` | `func`, `dwi` | Label written as `B0FieldSource` in the sidecar; must match an fmap's `identifier`. |
| `identifier` | `fmap` | Label written as `B0FieldIdentifier`; referenced by `fmapid`. |
| `phase_units` | phase data | `Units` written to the phase JSON: `arbitrary`, `rad`, or `Hz`. |
| `import_empty_tsv` | `func` | If truthy, generate a dummy `events.tsv` (random onsets/durations — **placeholder only**). |
| `derivatives` | any | Pipeline name → output goes to `derivatives/<name>/…`. See [Derivatives](#derivatives). |
| `sourcedata` | any | Destination folder name → copy series verbatim to `sourcedata/…`, skip conversion. See [Sourcedata](#sourcedata-non-convertible-series). |

**ASL-specific** (`data_type = 'perf'`, `modality = 'asl'`)

| Field | Description |
|---|---|
| `M0Type` | e.g. `Included`, `Separate`, `Estimate`. If `Included`, an `m0scan` row is appended to the context file. |
| `PostLabelingDelay` | Post-labeling delay (s). |
| `BackgroundSuppression` | `true`/`false`. |
| `TotalAcquiredPairs` | Number of control/label pairs (drives the `aslcontext.tsv`). |

---

## Use cases & examples

### Anatomical (`anat`)

```matlab
dcm{1}.folder    = 't1_mprage_sag*';
dcm{1}.data_type = 'anat';
dcm{1}.modality  = 'T1w';

dcm{2}.folder    = 't2_tse_tra*';
dcm{2}.data_type = 'anat';
dcm{2}.modality  = 'T2w';
```

→ `sub-XX/ses-YY/anat/sub-XX_ses-YY_T1w.nii.gz` (+ `.json`).

### Functional (`func`)

Resting state and task, with the optional dummy events file and an fmap link:

```matlab
% Resting state
dcm{3}.folder    = 'Resting*';
dcm{3}.data_type = 'func';
dcm{3}.modality  = 'bold';
dcm{3}.task      = 'rest';
dcm{3}.fmapid    = 'FMAP';        % -> B0FieldSource

% Task with multiple runs
dcm{4}.folder           = 'gonogo_run1*';
dcm{4}.data_type        = 'func';
dcm{4}.modality         = 'bold';
dcm{4}.task             = 'gonogo';
dcm{4}.run              = '1';
dcm{4}.import_empty_tsv = 'true'; % -> placeholder events.tsv
```

The converter writes `TaskName` into the sidecar JSON (BIDS requires it), and
— if `import_empty_tsv` is set — generates a matching `..._events.tsv` with the
mandatory `onset`/`duration` columns filled with **random placeholder values**.
Replace them with real event data before any analysis.

### Field maps (`fmap`)

Two patterns are supported.

**(a) Phase-difference field map** (`modality = 'fieldmap'`). `dcm2niix`
produces `_ph`, `_e1`, `_e2` outputs; the converter renames them to the BIDS
`_phasediff`, `_magnitude1`, `_magnitude2`. The `identifier` is written as
`B0FieldIdentifier` into the `_phasediff` JSON:

```matlab
dcm{5}.folder     = 'gre_field_mapping*';
dcm{5}.data_type  = 'fmap';
dcm{5}.modality   = 'fieldmap';
dcm{5}.identifier = 'FMAP';       % referenced by func/dwi fmapid
```

**(b) EPI / "pepolar" field map for TOPUP** (`modality = 'epi'`). Requires the
`dir` entity. The `_epi` suffix is appended automatically. Put the `identifier`
on the magnitude entry; the phase entry is optional and, if included, needs
`part = 'phase'` plus `phase_units`:

```matlab
dcm{6}.folder     = 'ep2d_pepolar_PA_mag*';
dcm{6}.data_type  = 'fmap';
dcm{6}.modality   = 'epi';
dcm{6}.dir        = 'PA';
dcm{6}.part       = 'mag';
dcm{6}.identifier = 'TOPUP';
```

On the `func`/`dwi` side, set `fmapid = 'FMAP'` (or `'TOPUP'`) to write the
matching `B0FieldSource`, so preprocessing tools (e.g. fMRIPrep) can pair them.

### Diffusion (`dwi`)

```matlab
dcm{7}.folder    = 'ep2d_diff*';
dcm{7}.data_type = 'dwi';
dcm{7}.modality  = 'dwi';
dcm{7}.fmapid    = 'TOPUP';       % optional B0FieldSource
```

`dcm2niix` emits the `.bval`/`.bvec` files alongside the NIfTI automatically.

### Spectroscopy (`mrs`)

Spectroscopy is converted with `spec2nii` instead of `dcm2niix`. The tool
locates the single `.dcm` inside the folder and converts it; when
`cfg.anonymization = 'y'`, conversion is done in three steps
(`spec2nii auto` → `spec2nii anon` → `spec2nii extract`) to strip identifying
fields and re-emit the JSON:

```matlab
dcm{8}.folder    = 'svs_se_30*';
dcm{8}.data_type = 'mrs';
dcm{8}.modality  = 'svs';         % svs | mrsi | unloc | mrsref
```

> Assumption: each spectroscopy folder contains a single `.dcm` to convert.

### Perfusion / ASL (`perf`)

ASL needs extra metadata that DICOM does not carry, plus an `aslcontext.tsv`
describing the control/label/m0scan order:

```matlab
dcm{9}.folder               = 'asl_3d*';
dcm{9}.data_type            = 'perf';
dcm{9}.modality             = 'asl';
dcm{9}.M0Type               = 'Included';
dcm{9}.PostLabelingDelay    = 1.8;
dcm{9}.BackgroundSuppression= true;
dcm{9}.TotalAcquiredPairs   = 30;
```

The converter injects `M0Type`, `PostLabelingDelay`, `BackgroundSuppression`
and `TotalAcquiredPairs` into the JSON, and writes `..._aslcontext.tsv` with a
`control`/`label` sequence (assuming control-first) plus a trailing `m0scan`
row when `M0Type = 'Included'`.

### Derivatives

Series that are already-processed outputs (e.g. scanner-computed maps) belong
under `derivatives/<pipeline>/` per the BIDS standard, not in the raw root. Add
`derivatives = '<pipeline-name>'`; combine with `desc` to distinguish the
variants produced by the same pipeline:

```matlab
dcm{10}.folder      = 'ep2d_diff_mgh_1_ADC*';
dcm{10}.data_type   = 'dwi';
dcm{10}.modality    = 'dwi';
dcm{10}.derivatives = 'dwi-reconstruction';
dcm{10}.desc        = 'adc';

dcm{11}.folder      = 'ep2d_diff_mgh_1_FA*';
dcm{11}.data_type   = 'dwi';
dcm{11}.modality    = 'dwi';
dcm{11}.derivatives = 'dwi-reconstruction';
dcm{11}.desc        = 'fa';
```

→

```
derivatives/dwi-reconstruction/
├── dataset_description.json          # auto-generated (see below)
└── sub-XX/ses-YY/dwi/
    ├── sub-XX_ses-YY_desc-adc_dwi.nii.gz
    └── sub-XX_ses-YY_desc-fa_dwi.nii.gz
```

The first time a pipeline folder is used, `initialize_derivatives_pipeline.m`
writes its `dataset_description.json` with `Name = <pipeline>`,
`DatasetType = "derivative"`, `GeneratedBy = [{ "Name": "<pipeline>" }]`, and
the same `BIDSVersion` as the root dataset — which the BIDS validator requires
for a valid derivative sub-dataset.

### Sourcedata (non-convertible series)

Some DICOM series cannot be converted to NIfTI (e.g. the Siemens diffusion
`TENSOR` series). BIDS reserves the top-level `sourcedata/` directory for data
in its original, pre-conversion format. Set `sourcedata = '<folder-name>'`:
when present, the converter **copies the DICOM folder verbatim** and **skips
`dcm2niix` entirely** (any `derivatives`/`desc`/`modality` on the same entry is
ignored).

```matlab
dcm{12}.folder     = 'ep2d_diff_mgh_1_TENSOR*';
dcm{12}.data_type  = 'dwi';
dcm{12}.sourcedata = 'tensor';
```

→ `sourcedata/sub-XX/ses-YY/dwi/tensor/` containing the original DICOM files.
The leaf folder name is the **value** of `sourcedata`, not the original series
name. BIDS does not constrain the internal layout of `sourcedata/`; this tool
uses `sourcedata/sub-XX/ses-YY/<data_type>/<value>/`.

---

## BIDS filename construction

`generate_bids_filename.m` assembles the filename from the entities present,
in the BIDS-mandated order for each data type, and `remove_duplicate_char.m`
collapses the `_` left by absent entities (so an empty `ses` simply disappears).
`desc-` is always the last entity before the modality suffix.

| `data_type` | Entity order (before suffix) |
|---|---|
| `func` | `sub ses task acq rec dir run echo part desc` + `bold`/`sbref` |
| `anat` | `sub ses task acq rec run echo part desc` + `T1w`/`T2w`/… |
| `fmap` | `sub ses acq dir run echo part desc` (+ `epi` for EPI fmaps) |
| `dwi`  | `sub ses acq rec dir run part desc` + `dwi`/`sbref` |
| `mrs`  | `sub ses task acq rec run echo desc` + `svs`/… |
| `perf` | `sub ses acq rec dir run echo part desc` + `asl` |
| other  | `sub ses desc` + `modality` |

Companion files use a reduced entity set: `..._events.tsv` (func) and
`..._aslcontext.tsv` (perf) omit `echo`/`part`/`desc`/suffix.

---

## Output layout

A typical multi-session result combining raw, derivatives and sourcedata:

```
bids_directory/
├── dataset_description.json
├── README
├── LICENSE
├── CHANGES
├── .bidsignore
├── sub-0001/
│   └── ses-pre/
│       ├── anat/  sub-0001_ses-pre_T1w.nii.gz   (+ .json)
│       ├── func/  sub-0001_ses-pre_task-rest_bold.nii.gz (+ .json)
│       ├── fmap/  sub-0001_ses-pre_phasediff.nii.gz (+ magnitude1/2)
│       └── dwi/   sub-0001_ses-pre_dwi.nii.gz   (+ .json/.bval/.bvec)
├── derivatives/
│   └── dwi-reconstruction/
│       ├── dataset_description.json
│       └── sub-0001/ses-pre/dwi/sub-0001_ses-pre_desc-fa_dwi.nii.gz
└── sourcedata/
    └── sub-0001/ses-pre/dwi/tensor/<original DICOMs>
```

---

## How it works internally

Entry point **`bids_mri_converter.m`** loads the three config files and calls,
in order, the functions in `src/`:

**Initialization**
- `initialize_bids_dataset.m` — creates `bids_directory` and the top-level
  files (`dataset_description.json`, `README`, `LICENSE`, `CHANGES`,
  `.bidsignore`) from `templates/`, each only if missing.
- `check_dependencies.m` — adds the converter paths to `PATH` and verifies
  `dcm2niix`/`spec2nii` are reachable (warns if not).
- `get_subjects_list.m` — discovers subjects and their sessions, sanitizes
  names into `sub-`/`ses-` IDs, validates uniqueness. Handles both `dataset`
  and `single_subject` modes.

**Main loop — `start_bids_conversion.m`** iterates subjects → sessions → `dcm`
entries. For each entry:

1. `rename_existing_subject.m` — if `sub-XX/` already exists, rename it with a
   random suffix so previous results are never overwritten (per subject).
2. `get_sessions_list.m` — all subfolders when `cfg.sessions = true`; only the
   first (with empty `ses`) when `false`.
3. `get_dcm_folder.m` — resolves the `folder` wildcard to a concrete directory.
4. **Sourcedata branch** → `copy_to_sourcedata.m`, then skip the rest.
5. Build the output directory (`derivatives/<pipeline>/…` when `derivatives`
   is set, via `initialize_derivatives_pipeline.m`; otherwise the raw root).
6. `generate_bids_filename.m` — builds the BIDS filename.
7. **`dicom_to_bids.m`** — the conversion pipeline:
   - `generate_output_directories.m` — create the destination folder.
   - `generate_conversion_command.m` — build the `dcm2niix` (or `spec2nii`)
     command(s).
   - `run_conversion_command.m` — execute via `system`, report OK/ERROR.
   - `rename_bids_converted_files.m` — rename phase-difference fmaps
     (`_ph`/`_e1`/`_e2` → `_phasediff`/`_magnitude1`/`_magnitude2`), strip the
     `_ph` suffix from phase reconstructions, and split `sbref`
     magnitude/phase.
   - `update_taskname_json.m` — inject `TaskName` for functional data.
   - `update_phase_units_json.m` — inject `Units` for phase data.
   - `update_als_json.m` + `generate_asl_context_file.m` — ASL metadata and
     `aslcontext.tsv`.
   - `update_b0_field_json.m` — write `B0FieldSource` (func/dwi) and
     `B0FieldIdentifier` (fmap).
8. `import_tsv_file.m` — generate the placeholder `events.tsv` when requested.

**Shared helpers:** `update_json.m` (read-modify-write a JSON sidecar) and
`remove_duplicate_char.m` (collapse repeated `_` in filenames).

---

## Folder-matching behavior

`dcm{i}.folder` is a wildcard pattern matched inside each session directory
(`get_dcm_folder.m` appends a trailing `*` if missing). If **several** folders
match, they are sorted by name (ascending, ASCII/code-point order) and the
**first** one is used, with a warning printed to the console. If **none**
match, that entry is skipped for the current subject/session (no error — common
when a series is missing for some participants).

This sort order has a useful consequence. Digits (`0`–`9`) sort before
uppercase letters (`A`–`Z`), and a shorter string that is a prefix of a longer
one sorts first. So a generic pattern can select the "base" series while
specific patterns capture the derived ones — e.g. given
`ep2d_diff_mgh_1_37` (raw), `ep2d_diff_mgh_1_ADC_38`, `..._FA_40`,
`..._TENSOR_42`, the pattern `ep2d_diff_mgh_1*` resolves to the raw series
because its numeric suffix sorts ahead of the lettered map names. Name your
derived/sourcedata entries with specific patterns and reserve the broad pattern
for the base series.

---

## Notes, limitations & troubleshooting

- **Re-running is safe but renames.** An existing `sub-XX/` is moved aside with
  a random suffix rather than merged or overwritten.
- **`events.tsv` is fake.** `import_empty_tsv` only creates a placeholder with
  random onsets/durations. Replace before analysis.
- **MRS assumes one `.dcm` per folder.** Folders with multiple spectroscopy
  files would need a loop (not currently implemented).
- **ASL context assumes control-first** ordering and an M0 scan at the end when
  included; adjust `generate_asl_context_file.m` for other sequences.
- **`spec2nii` is optional.** Only required when converting `mrs` data; its
  absence just produces a warning.
- **Folder names matter.** Keep subject/session folder names alphanumeric;
  non-alphanumeric characters are stripped and could cause collisions.
- **`.bidsignore`** shipped in `templates/` ignores `*_swi.*` files by default;
  edit it to match your dataset's exceptions.
- **Conversion errors** are reported inline as `ERROR (status …)` with the
  command output; check that the matched folder actually contains valid DICOMs
  and that `dcm2niix`/`spec2nii` are on the configured paths.
