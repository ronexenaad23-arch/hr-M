const CACHE = 'hr-v6.1-20260907';
const ASSETS = ['/', '/app.js', '/manifest.json',
  '/icon-72.png','/icon-96.png','/icon-128.png',
  '/icon-144.png','/icon-152.png','/icon-192.png',
  '/icon-384.png','/icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => c.addAll(ASSETS).catch(() => {}))
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
  if(e.request.method !== 'GET') return;
  if(!e.request.url.startsWith(self.location.origin)) return;
  e.respondWith(
    caches.open(CACHE).then(c =>
      c.match(e.request).then(cached => {
        const fresh = fetch(e.request).then(r => {
          if(r && r.ok) c.put(e.request, r.clone());
          return r;
        }).catch(() => cached);
        return cached || fresh;
      })
    )
  );
});

self.addEventListener('push', e => {
  const d = e.data ? e.data.json() : {title:'\u0627\u0644\u0645\u0648\u0627\u0631\u062F \u0627\u0644\u0637\u0628\u064A\u0629', body:'\u062A\u0646\u0628\u064A\u0647 \u062C\u062F\u064A\u062F'};
  e.waitUntil(self.registration.showNotification(d.title, {
    body:d.body, icon:'/icon-192.png', badge:'/icon-96.png',
    dir:'rtl', vibrate:[200,100,200], tag:'hr'
  }));
});

self.addEventListener('notificationclick', e => {
  e.notification.close();
  e.waitUntil(clients.matchAll({type:'window'}).then(l => {
    if(l.length) return l[0].focus();
    return clients.openWindow('/');
  }));
});