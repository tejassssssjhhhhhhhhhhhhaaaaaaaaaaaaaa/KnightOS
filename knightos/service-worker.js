const CACHE_NAME = 'knightos-v6-cache-v1';
const ASSETS = [
  'taskpane.html',
  'knightos.css',
  'knightos.js',
  'dataProvider.js',
  'manifest.webmanifest'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS);
    })
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});
