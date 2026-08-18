// HR Medical Resources - Service Worker v6.1
const CACHE = 'hr-v6.1';
const PRECACHE = [
  '/', '/app.js', '/manifest.json',
  '/icon-72.png', '/icon-96.png', '/icon-128.png',
  '/icon-144.png', '/icon-152.png', '/icon-192.png',
  '/icon-384.png', '/icon-512.png', '/og-image.png'
];

self.addEventListener('install', e => {
  console.log('[SW v6.1] Installing...');
  e.waitUntil(
    caches.open(CACHE)
      .then(c => c.addAll(PRECACHE).catch(err => console.warn('[SW] Partial cache:', err)))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  if (!e.request.url.startsWith(self.location.origin)) return;
  e.respondWith(
    caches.open(CACHE).then(c =>
      c.match(e.request).then(cached => {
        const fresh = fetch(e.request).then(r => {
          if (r && r.ok) c.put(e.request, r.clone());
          return r;
        }).catch(() => cached);
        return cached || fresh;
      })
    )
  );
});

self.addEventListener('push', e => {
  const d = e.data ? e.data.json() : {title:'الموارد الطبية', body:'تنبيه جديد'};
  e.waitUntil(
    self.registration.showNotification(d.title, {
      body: d.body, icon: '/icon-192.png', badge: '/icon-96.png',
      dir: 'rtl', lang: 'ar', vibrate: [200,100,200], tag: 'hr'
    })
  );
});

self.addEventListener('notificationclick', e => {
  e.notification.close();
  e.waitUntil(clients.matchAll({type:'window'}).then(l => {
    if (l.length) return l[0].focus();
    return clients.openWindow('/');
  }));
});