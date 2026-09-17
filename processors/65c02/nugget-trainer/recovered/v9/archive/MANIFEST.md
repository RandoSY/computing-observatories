# Nugget 65C02 Studio v9.4 — exact archive manifest

Recovered from a retained ChatGPT Library artifact on 2026-09-17 and preserved byte-for-byte as a deterministic gzip, Base64-encoded and split into seven text parts for repository-safe archival.

## Source artifact

- Filename: `65c02_nugget_studio_v9_4.html`
- Header identity: **Nugget 65C02 Studio — Version 9.4 · Debugger Studio · Marquee R&G Show**
- Raw size: **227,003 bytes**
- Raw SHA-256: `3ab31705cad6f2f7e48517286504a21d62798175e33be1dba9cce79edee4c961`

## Compressed archive

- Deterministic gzip size: **62,045 bytes**
- gzip SHA-256: `429c142e8743b64b6430b8d78944433171fcc7d48cf6f238f8c3e0946a8f809a`
- Base64 character count: **82,728**
- Parts: `part00` through `part06`

## Reassembly

From this directory on a POSIX shell:

```bash
cat 65c02_nugget_studio_v9_4.html.gz.b64.part* \
  | tr -d '\n\r ' \
  | base64 -d \
  > 65c02_nugget_studio_v9_4.html.gz

gunzip -c 65c02_nugget_studio_v9_4.html.gz \
  > 65c02_nugget_studio_v9_4.html

sha256sum 65c02_nugget_studio_v9_4.html
```

Expected raw SHA-256:

```text
3ab31705cad6f2f7e48517286504a21d62798175e33be1dba9cce79edee4c961  65c02_nugget_studio_v9_4.html
```

A local reconstruction test performed before archival produced seven parts, 62,045 gzip bytes, 227,003 reconstructed raw bytes, and an exact byte-for-byte match to the retained source artifact.

## Validation boundary

This is an **archival lineage artifact**. Its survival does not cause it to inherit the separate v6 validation claims. Keep the validated v6 baseline and later v8/v9 descendants distinct when describing provenance, testing, or release status.
