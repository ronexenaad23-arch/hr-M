const CACHE='hr-v5';
const ASSETS=['/','/app.js','/manifest.json','/icon-192.png','/icon-512.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS).catch(()=>{})).then(()=>self.skipWaiting()));});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));});
self.addEventListener('fetch',e=>{
  if(e.request.method!=='GET'||!e.request.url.startsWith(self.location.origin))return;
  e.respondWith(caches.open(CACHE).then(c=>c.match(e.request).then(cached=>{
    const fresh=fetch(e.request).then(r=>{if(r&&r.ok)c.put(e.request,r.clone());return r;}).catch(()=>cached);
    return cached||fresh;
  })));
});
self.addEventListener('push',e=>{
  const d=e.data?e.data.json():{title:'الموارد الطبية',body:'تنبيه جديد'};
  e.waitUntil(self.registration.showNotification(d.title,{body:d.body,icon:'/icon-192.png',dir:'rtl',vibrate:[200,100,200],tag:'hr'}));
});
self.addEventListener('notificationclick',e=>{e.notification.close();e.waitUntil(clients.matchAll({type:'window'}).then(l=>{if(l.length)return l[0].focus();return clients.openWindow('/');}));});