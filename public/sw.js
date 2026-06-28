const CACHE="hr-v4";
const ASSETS=["/","/app.js","/manifest.json"];
self.addEventListener("install",e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS).catch(()=>{})));self.skipWaiting();});
self.addEventListener("activate",e=>{e.waitUntil(caches.keys().then(ks=>Promise.all(ks.filter(k=>k!==CACHE).map(k=>caches.delete(k)))));self.clients.claim();});
self.addEventListener("fetch",e=>{if(e.request.method!=="GET")return;e.respondWith(caches.match(e.request).then(c=>{if(c)return c;return fetch(e.request).then(r=>{if(r.ok){const cl=r.clone();caches.open(CACHE).then(ca=>ca.put(e.request,cl));}return r;}).catch(()=>c);}));});
self.addEventListener("push",e=>{const d=e.data?.json()||{title:"الموارد الطبية",body:"تنبيه جديد"};e.waitUntil(self.registration.showNotification(d.title,{body:d.body,icon:"/icon-192.png",dir:"rtl",lang:"ar",vibrate:[200,100,200],tag:"hr-notif"}));});