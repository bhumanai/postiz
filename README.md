## Postiz Backend on RunPod

This mini-repo builds a Docker image that contains the Postiz backend (NestJS API) precompiled with pnpm. The container is designed to run on RunPod Secure Cloud or any other container host. Speakeasy only needs the backend API, so the image does not start the dashboard/frontend.

### What's Inside

- `Dockerfile` – clones `gitroomhq/postiz-app`, installs dependencies, builds `apps/backend`, and exposes port `4455`.
- `speakeasy.env` – environment template that matches the settings Speakeasy expects (Set `FRONTEND_URL`, `NEXT_PUBLIC_BACKEND_URL`, etc.).

### Build and Push

```bash
# From the repo root
docker build -f Dockerfile -t <your-registry>/postiz-backend:latest --build-arg POSTIZ_REF=main .
docker push <your-registry>/postiz-backend:latest
```

Arguments:
- `POSTIZ_REPO` (default `https://github.com/gitroomhq/postiz-app.git`)
- `POSTIZ_REF`  (default `main`)

### Environment Variables Required at Runtime

| Variable | Description |
|----------|-------------|
| `PORT` | Keep `4455`. |
| `FRONTEND_URL` | Speakeasy UI base URL (e.g., `https://app.speakeasy.ai`) so OAuth redirects back correctly. |
| `NEXT_PUBLIC_BACKEND_URL` | Public HTTPS URL of this Postiz backend (e.g., `https://postiz-api.yourdomain.com`). |
| `BACKEND_INTERNAL_URL` | Usually `http://localhost:4455`. |
| `NOT_SECURED` | Must be `true` so the backend returns `auth` headers our Speakeasy bridge consumes. |
| `DATABASE_URL` | PostgreSQL connection string (Neon/RDS/etc.). |
| `REDIS_URL` | Redis connection string (ElastiCache/Upstash/etc.). |
| `JWT_SECRET` | Long random string. |
| `STORAGE_PROVIDER` | `local` (mount a volume) or `s3` (provide S3 credentials). |
| `UPLOAD_DIRECTORY` | Path inside container when using `local` storage (e.g., `/data/uploads`). |

Optional: S3 creds, Resend key, OAuth client secrets for LinkedIn/X/etc.

### Run on RunPod

1. Point RunPod’s GitHub integration at this repo/branch and redeploy (RunPod builds from the Dockerfile automatically).
2. Create a Secure Cloud pod (CPU is fine).
3. Add a persistent volume and mount it to `/data` (then set `UPLOAD_DIRECTORY=/data/uploads`).
4. Add the environment variables/secrets listed above.
5. Expose port `4455`. RunPod gives you a public HTTPS endpoint.
6. Update Speakeasy’s env: `POSTIZ_API_BASE_URL=https://<runpod-endpoint>`.
7. Redeploy Speakeasy, finish a video, click **Share**, connect a channel, and post.

That’s it—you now have a dedicated Postiz backend powering Speakeasy’s social publishing from RunPod.
