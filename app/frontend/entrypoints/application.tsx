import { createInertiaApp } from '@inertiajs/react'
import { createRoot, hydrateRoot } from 'react-dom/client'
import '../styles/application.css'

createInertiaApp({
  title: (title) => (title ? `${title} · Rails-Inertia-React` : 'Rails-Inertia-React'),
  resolve: (name) => {
    const pages = import.meta.glob<{ default: React.ComponentType }>('../pages/**/*.tsx', {
      eager: true,
    })
    const page = pages[`../pages/${name}.tsx`]
    if (!page) throw new Error(`Inertia page not found: ${name}`)
    return page.default
  },
  setup({ el, App, props }) {
    if (el.dataset.serverRendered === 'true') {
      hydrateRoot(el, <App {...props} />)
    } else {
      createRoot(el).render(<App {...props} />)
    }
  },
  progress: { color: '#4a7fff' },
})
