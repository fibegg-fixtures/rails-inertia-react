import { Head, useForm } from '@inertiajs/react'

interface HomeProps {
  name: string
  heartbeats: number
  uploads: { id: number; filename: string; url: string }[]
}

export default function Home({ name, heartbeats, uploads }: HomeProps) {
  const { data, setData, post, processing, progress, reset } = useForm<{ file: File | null }>({
    file: null,
  })

  return (
    <>
      <Head title="Home" />
      <div className="min-h-screen bg-base-200 text-base-content">
        <header className="navbar bg-base-100 shadow-sm">
          <div className="container mx-auto max-w-3xl">
            <h1 className="text-xl font-semibold">Rails-Inertia-React starter</h1>
          </div>
        </header>

        <main className="container mx-auto max-w-3xl px-4 py-8 space-y-8">
          <section className="card bg-base-100 shadow-md">
            <div className="card-body">
              <h2 className="card-title">Hello, {name} 👋</h2>
              <p>
                This page is rendered by an Inertia React component, served from a Rails controller,
                styled with Tailwind v4 + DaisyUI, bundled by Vite with HMR.
              </p>
              <p className="text-sm opacity-70">
                Heartbeat job has fired <strong>{heartbeats}</strong> times — Sidekiq cron is running.
              </p>
            </div>
          </section>

          <section className="card bg-base-100 shadow-md">
            <div className="card-body">
              <h2 className="card-title">MinIO upload</h2>
              <form
                onSubmit={(e) => {
                  e.preventDefault()
                  if (!data.file) return
                  post('/uploads', {
                    forceFormData: true,
                    onSuccess: () => reset('file'),
                  })
                }}
                className="flex flex-col gap-3"
              >
                <input
                  type="file"
                  className="file-input file-input-bordered"
                  onChange={(e) => setData('file', e.target.files?.[0] ?? null)}
                />
                {progress && (
                  <progress className="progress progress-primary" value={progress.percentage} max={100} />
                )}
                <button type="submit" className="btn btn-primary" disabled={processing || !data.file}>
                  Upload to MinIO
                </button>
              </form>

              <ul className="mt-4 divide-y divide-base-300">
                {uploads.map((u) => (
                  <li key={u.id} className="py-2 flex items-center justify-between">
                    <span>#{u.id} — {u.filename}</span>
                    <a href={u.url} target="_blank" rel="noreferrer" className="link link-primary">
                      open
                    </a>
                  </li>
                ))}
                {uploads.length === 0 && (
                  <li className="py-2 opacity-60 text-sm">Nothing uploaded yet.</li>
                )}
              </ul>
            </div>
          </section>
        </main>
      </div>
    </>
  )
}
