# 65C02 Nugget Curriculum — recovered text archives

These files preserve searchable text extracted from the surviving 65C02 Nugget curriculum PDFs recovered from the Intellectual Estate Library.

The original PDFs remain preserved in the Library. The GitHub text archives are compressed with deterministic gzip (`mtime=0`) and then Base64-encoded so they can be stored losslessly through the text-oriented GitHub connector.

## Recovered volumes

- `65C02_Nugget_Instructor_Curriculum_Guide.txt.gz.b64`
- `65C02_Nugget_Student_Laboratory_Workbook.txt.gz.b64`
- `65C02_Nugget_Assessments_Rubrics_and_Answer_Key.txt.gz.b64`

## Verified source text hashes

| Text edition | Size | SHA-256 |
|---|---:|---|
| Student Laboratory Workbook | 57,363 bytes | `cba383f88be6e419b92ca719063d0a986a962eb3ea8ca84435efe51d264b43c7` |
| Assessments, Rubrics and Answer Key | 10,169 bytes | `7accf41de80921293b4bfc34124c47dc4c12f0d5ee4a56fbe4b8c84e1008fa09` |

The Instructor Guide archive was recovered in the preceding pass and is preserved alongside these files.

## Reconstruction

Linux/macOS:

```sh
base64 -d 65C02_Nugget_Student_Laboratory_Workbook.txt.gz.b64 | gzip -dc > 65C02_Nugget_Student_Laboratory_Workbook.txt
```

Python:

```python
import base64, gzip
from pathlib import Path

src = Path('65C02_Nugget_Student_Laboratory_Workbook.txt.gz.b64')
out = Path('65C02_Nugget_Student_Laboratory_Workbook.txt')
out.write_bytes(gzip.decompress(base64.b64decode(src.read_text().strip())))
```

## Provenance / validation boundary

The curriculum is evidence of the instructional package built around the validated-v6 simulator. It does not by itself extend the validation claims of the simulator. Later v7/v8/v9 descendants are preserved as separate lineage and must retain their own stated validation status.
