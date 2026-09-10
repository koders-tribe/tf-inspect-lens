# S3 bucket module

Private bucket for Inspect Lens photos and PDFs.

Always on: versioning, AES-256, block public access, bucket-owner-enforced, abort incomplete multipart uploads.

Optional: CORS (`cors_allowed_origins`) for browser presigned PUT/GET. Do not make the bucket public.

Object prefix used by the API: `orgs/*`.
