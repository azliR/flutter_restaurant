'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"main.dart.js": "2a8e852629e74f5aac945c9555dd31db",
"version.json": "1ac48139ae8950bfe35aa7d16f6e0ea2",
"assets/assets/images/maps-grid.png": "8a1f3c842119e4aee648e0c47ecc2516",
"assets/assets/images/app-logo.png": "5d4909a067c4163185fe615e8a44a5be",
"assets/assets/images/app-logo.svg": "2508289542fe4f5f42c60147e73ebaf1",
"assets/assets/images/app-logo-adaptive.png": "8ae3a14a94dffa91b1d6f76e2315b65c",
"assets/assets/images/app-logo.zip": "9a5f6eb4f23eb9456fb71842e6d5500f",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "e9f2f143310604845f8aa26c42ad5f55",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/shaders/ink_sparkle.frag": "e74d44250b8880f578d7342dee15bba6",
"assets/AssetManifest.json": "8e6cd0c8824bd6fc90a24ffa5e20c956",
"assets/FontManifest.json": "cf3c681641169319e61b61bd0277378f",
"assets/NOTICES": "df43f7c54190af665a1859b66b730d04",
"favicon.png": "6c734c0137592cccc4edbdb962f3a200",
"icons/favicon.png": "7a26ea9d4e61122fc023b84e5acdb148",
"icons/Icon-192.png": "cb9d5af86e4737fad85b3addcdba01cc",
"icons/Icon-512.png": "373990fc7a4236c32967bcbeb00b3939",
"icons/Icon-maskable-192.png": "cb9d5af86e4737fad85b3addcdba01cc",
"icons/Icon-maskable-512.png": "373990fc7a4236c32967bcbeb00b3939",
"index.html": "c08547585bf033e11432cf80df0d8104",
"/": "c08547585bf033e11432cf80df0d8104",
"manifest.json": "dcdf903bc605176a6f262dffdda3e883",
"splash/img/light-1x.png": "28f48cbc61a63d1f0475ee57666a7807",
"splash/img/light-2x.png": "7922043995ead395759c5fefd3ddbd49",
"splash/img/light-3x.png": "bb686c8dff6c8a20b0ec1ca6cc1805a8",
"splash/img/light-4x.png": "cb9d5af86e4737fad85b3addcdba01cc",
"splash/img/dark-1x.png": "28f48cbc61a63d1f0475ee57666a7807",
"splash/img/dark-2x.png": "7922043995ead395759c5fefd3ddbd49",
"splash/img/dark-3x.png": "bb686c8dff6c8a20b0ec1ca6cc1805a8",
"splash/img/dark-4x.png": "cb9d5af86e4737fad85b3addcdba01cc",
"splash/style.css": "cbb19a3279048c5215e582d46082f1dd",
"splash/splash.js": "c6a271349a0cd249bdb6d3c4d12f5dcf"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
