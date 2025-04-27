'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "73404dec2f0c8b087bfc5c3f7c68c370",
".git/config": "154067ffb191259b302e62ed36bc7ddc",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "a76f9be2ce7e1de98a23817fb151794e",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "05ec45e276428081c35db03c702d2e4b",
".git/logs/refs/heads/main": "732326ec737864378667fffec245e817",
".git/objects/05/a9058f513cce5faf1704e06e3c150688b0a01f": "e8d02f60cf87abd4c1de4b153dd696dc",
".git/objects/0a/579abb5740b7ba35bbf3a6796a1e002f6a639a": "256eb6809aaa6b6aa9f599649f7873a2",
".git/objects/0d/5e9b4693a6ee01f24d73ddbc40ec4841497148": "2d94540fde351ab7c431a26d750297be",
".git/objects/0e/de770253b788ce130f7a89727019281571b510": "391b08fb085ec65dc10a97d158aa630d",
".git/objects/19/9a86840daced00d2ad4adf7563e98c8fd1907f": "ec9240ef33156719a1ef8ae942d2700a",
".git/objects/19/af8468b9f09f52ebe16ec3768a32faee28d892": "e3fea0b8a3df11487fb5ed8a95d57cc3",
".git/objects/27/0b279ad0ea98f9ff958cfb0c47870c9fb16b45": "7d065f8cd78f0a3148b516a4c27de40a",
".git/objects/27/a297abdda86a3cbc2d04f0036af1e62ae008c7": "51d74211c02d96c368704b99da4022d5",
".git/objects/3e/62b1f43819f2c82a6302c56f7431da8c81629d": "49a95571f702ae5e27351d0a39b22844",
".git/objects/43/ed4f5ee6cb01173b448af26edb9d7459f9d365": "f186d42343e916c98435cd538a94e1b8",
".git/objects/47/1e89a39bbeafd17908381f0619bd1c886ab83b": "053cf599251500a4a438cfbb1f49d4cb",
".git/objects/47/eb68afb86e61951e9218a6d4773889d4b15872": "5d02a949772ea12c6d0e90c9b459bf17",
".git/objects/63/6931bcaa0ab4c3ff63c22d54be8c048340177b": "8cc9c6021cbd64a862e0e47758619fb7",
".git/objects/68/f2accce69e47c6f0e49644e3f7f32748d4020b": "d979a691874fa78e401f82f0f46c1c42",
".git/objects/6d/5f0fdc7ccbdf7d01fc607eb818f81a0165627e": "2b2403c52cb620129b4bbc62f12abd57",
".git/objects/73/1d511bd328e1b834427ad96f284079904d4be6": "68e20abad88a56b93321d4803fe94de4",
".git/objects/73/7f149c855c9ccd61a5e24ce64783eaf921c709": "1d813736c393435d016c1bfc46a6a3a6",
".git/objects/77/df4ea30f74b3fffd5f33b6742e39182007e3dd": "ea7b25d00567739495be385a1642acde",
".git/objects/79/a37f2b878bfe1764fe172f7a4d4032dcc65f41": "9672403a1e1e8071331f3b6f6611c3a5",
".git/objects/8a/698391e38e416448aa80f6c0c46705cc873ad4": "c9bfa0c5cf6c436e030a714921e35c1d",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/59773bee8314a8ffb4431593d0fb49f52e34c6": "2eb993d30677573ffd0e58484cc6a514",
".git/objects/8f/610290a1355754f57bd11871827f5c84375839": "bb415ccdd861cecb94602b875530f28c",
".git/objects/97/8a4d89de1d1e20408919ec3f54f9bba275d66f": "dbaa9c6711faa6123b43ef2573bc1457",
".git/objects/99/36cca4562cf8e4c7fcfd6d907e5975ede71c11": "4ac2c89aa3dc6b604e9b89c2cdcdc3b0",
".git/objects/9e/939a3367aeaac94dac53f8327eef9fd18639d1": "67087170cd5f914b9893644f8dd89a8c",
".git/objects/af/31ef4d98c006d9ada76f407195ad20570cc8e1": "a9d4d1360c77d67b4bb052383a3bdfd9",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/afd5429fbe3cc7a88b89f454006eb7b018849a": "e4c2e016668208ba57348269fcb46d7b",
".git/objects/b1/bd457f7a2081f08566748a55e770650c97ec21": "7f8d61ea0458b9b30d914ad62686efc5",
".git/objects/b6/f48becbe528f4eb4b5019de396207d002a7c81": "9eb0c05251640dcc94c84ab633ae4301",
".git/objects/bd/aa88374b9b7d01aaf301ae97b91e3bb5fcabf7": "3aabc8c0d58a4539ed457bc143f88046",
".git/objects/c3/e81f822689e3b8c05262eec63e4769e0dea74c": "8c6432dca0ea3fdc0d215dcc05d00a66",
".git/objects/c6/06caa16378473a4bb9e8807b6f43e69acf30ad": "ed187e1b169337b5fbbce611844136c6",
".git/objects/c7/670385a8d12543af41732bfbaaa684c3bb0897": "64440bb11e5e95555749c3c82902a17e",
".git/objects/d1/d024034f4d046dacd4a0596a4e3bf007ef7256": "eee0ba9bba0431decd5a3d67013fec19",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/dc/fd7c9d2db053992029f3878fd314300bbe5258": "d960e56e279e95fde7f932bb3691c653",
".git/objects/e1/05c5321c763c394526fc01eeabddd58ee2408b": "d21f7b13ec1fe083fa6dd3efb2d2f33b",
".git/objects/e2/0673ad9061a47a937adde18ff4edbb90103f6d": "8dd0e814d7b7d031275d6602466e73c6",
".git/objects/e3/1b51e3e9388ae61767c692885e5d77ff7b5346": "6ed4eb6a450521a70e40d120888b347a",
".git/objects/e7/b032f307afbe06ba40eb231c126b732135d6e5": "65dd6e7e8a6ef83788154beffb77a204",
".git/objects/ec/361605e9e785c47c62dd46a67f9c352731226b": "d1eafaea77b21719d7c450bcf18236d6",
".git/objects/ee/4292b1b255b0f5e1f97cf8c19ecdfe0c995b38": "600e0846624affeabddc95ef92ee9542",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f6/7a7c42ec7b158c1f6bd627874193cf0ccf3c22": "03b238df2329ed26c492830ba9db03a8",
".git/objects/f6/b1698f475bc9a273b57c811a568deedbfc315f": "a71e0217e9b18ba68d828236c539a199",
".git/objects/f7/5d521fb98c3ed5ed0c3fe39cbeec2417a4482c": "86237abd02e648df8e0c9e68a6a38118",
".git/objects/f8/9bf1c2097b22a047fb64e8cf17326aaefcdfcf": "019c91a305901f0c39c1aa366acfe0b0",
".git/refs/heads/main": "0f6408a5771e058c9918f0f41da1ef60",
"assets/AssetManifest.bin": "2db4f3215bbedb948bd78424cbf00e24",
"assets/AssetManifest.bin.json": "f14e66a46072e65d3967128ecbedbf56",
"assets/AssetManifest.json": "6cd65a86896a9b296abc7d456b3c28f2",
"assets/assets/backgrounds/purple-bg.jpg": "94f93a673914062f017c0e6af58070cc",
"assets/assets/fonts/Inter-Italic-VariableFont_opsz,wght.ttf": "6dce17792107f0321537c2f1e9f12866",
"assets/assets/fonts/Inter-VariableFont_opsz,wght.ttf": "0a77e23a8fdbe6caefd53cb04c26fabc",
"assets/FontManifest.json": "9ce202b43c98e85f7420baf43ca971eb",
"assets/fonts/MaterialIcons-Regular.otf": "8fa4698310c83d22bec0e7a4755db2e9",
"assets/NOTICES": "81533db996fd8ce2ca36c54cb3382a27",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "8f0c93bfc405e987e383dcc0a9819143",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.ico": "6c1198ed70201c6608f0122c5f8f6ef5",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "fcba000a7533822d566bb42dd84a64b9",
"icons/favicon-32x32.png": "8ac302bc1e6162d0780198007e553f17",
"icons/Icon-192.png": "7c9da82a59aceea2389a9bc1437fbdaf",
"icons/Icon-512.png": "6503abe88d99d335ed7779b2f51de542",
"icons/Icon-maskable-192.png": "ab480b43ea0d3ae8af5964e1fbac0af4",
"icons/Icon-maskable-512.png": "6503abe88d99d335ed7779b2f51de542",
"index.html": "43bdf3d4115dde907a452d361168ba6e",
"/": "43bdf3d4115dde907a452d361168ba6e",
"main.dart.js": "e563652dc09862839a45fd39206b6151",
"manifest.json": "1d95cadb8b1bc21fb2b3864ab959da60",
"version.json": "4421f97b2ff92242c03e776f62112479"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
