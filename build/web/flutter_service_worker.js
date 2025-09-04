'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "395fb985afe549d52be18b54c9b257e8",
"version.json": "de8552d80a48ebcb8a4abf1f21abddbe",
"index.html": "478c5d8a8fef706b781bd577e59bb7e5",
"/": "478c5d8a8fef706b781bd577e59bb7e5",
"main.dart.js": "840da21f72f664738055b5133a6b5e84",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"favicon.png": "510e266a6d5a16d345a78dbedd761fee",
"icons/Icon-192.png": "145be9e2765d675cd6799bd37ee12047",
"manifest.json": "a116405e201e0e34ea922bdf92478101",
"assets/AssetManifest.bin.json": "8f4d483a98bfadcb3a8ceea55da31c13",
"assets/AssetManifest.json": "8dabfbb491c262d964ca695258e33c30",
"assets/NOTICES": "ca7cab3987c4f885ce306cb125e3cdfe",
"assets/FontManifest.json": "10d9e00453e3e73701e25e0e2a0e9df2",
"assets/png_logo.png": "605d43dbf77b0b41a251ebb850d35e9b",
"assets/png_thumnail.png": "5b69467a757eddb4044478dcb8a70d78",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/map_launcher/assets/icons/mappls.svg": "1a75722e15a1700115955325fe34502b",
"assets/packages/map_launcher/assets/icons/citymapper.svg": "58c49ff6df286e325c21a28ebf783ebe",
"assets/packages/map_launcher/assets/icons/naver.svg": "ef3ef5881d4a2beb187dfc87e23b6133",
"assets/packages/map_launcher/assets/icons/tencent.svg": "4e1babec6bbab0159bdc204932193a89",
"assets/packages/map_launcher/assets/icons/yandexNavi.svg": "bad6bf6aebd1e0d711f3c7ed9497e9a3",
"assets/packages/map_launcher/assets/icons/yandexMaps.svg": "3dfd1d365352408e86c9c57fef238eed",
"assets/packages/map_launcher/assets/icons/copilot.svg": "b412a5f02e8cef01cdb684b03834cc03",
"assets/packages/map_launcher/assets/icons/truckmeister.svg": "416d2d7d2be53cd772bc59b910082a5b",
"assets/packages/map_launcher/assets/icons/googleGo.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/mapyCz.svg": "f5a198b01f222b1201e826495661008c",
"assets/packages/map_launcher/assets/icons/tmap.svg": "50c98b143eb16f802a756294ed04b200",
"assets/packages/map_launcher/assets/icons/petal.svg": "76c9cfa1bfefb298416cfef6a13a70c5",
"assets/packages/map_launcher/assets/icons/here.svg": "aea2492cde15953de7bb2ab1487fd4c7",
"assets/packages/map_launcher/assets/icons/tomtomgofleet.svg": "5b12dcb09ec0a67934e6586da67a0149",
"assets/packages/map_launcher/assets/icons/mapswithme.svg": "87df7956e58cae949e88a0c744ca49e8",
"assets/packages/map_launcher/assets/icons/osmandplus.svg": "31c36b1f20dc45a88c283e928583736f",
"assets/packages/map_launcher/assets/icons/doubleGis.svg": "ab8f52395c01fcd87ed3e2ed9660966e",
"assets/packages/map_launcher/assets/icons/google.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/kakao.svg": "1c7c75914d64033825ffc0ff2bdbbb58",
"assets/packages/map_launcher/assets/icons/osmand.svg": "639b2304776a6794ec682a926dbcbc4c",
"assets/packages/map_launcher/assets/icons/tomtomgo.svg": "493b0844a3218a19b1c80c92c060bba7",
"assets/packages/map_launcher/assets/icons/flitsmeister.svg": "44ba265e6077dd5bf98668dc2b8baec1",
"assets/packages/map_launcher/assets/icons/baidu.svg": "22335d62432f9d5aac833bcccfa5cfe8",
"assets/packages/map_launcher/assets/icons/apple.svg": "6fe49a5ae50a4c603897f6f54dec16a8",
"assets/packages/map_launcher/assets/icons/sygicTruck.svg": "242728853b652fa765de8fba7ecd250f",
"assets/packages/map_launcher/assets/icons/waze.svg": "311a17de2a40c8fa1dd9022d4e12982c",
"assets/packages/map_launcher/assets/icons/amap.svg": "00409535b144c70322cd4600de82657c",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "bd38242ad3197532f60db2670109284f",
"assets/fonts/MaterialIcons-Regular.otf": "9d34cb15c64ec1ef87493b08c14b4f72",
"assets/assets/svg/svg_facebook.svg": "cbd694f99d0faba89e309299a2ce5ee4",
"assets/assets/svg/svg_arrow_down.svg": "bbea461fe1c803c1a80eb74cbe39f3a0",
"assets/assets/svg/svg_flower.svg": "e406c5988084227a3733c3e4a1ef9074",
"assets/assets/svg/svg_new_logo.svg": "40db6ebefa5ddca91e823b65f81873e8",
"assets/assets/svg/svg_zalo.svg": "0ef8843bc3fc34dc0e4817193a206bd0",
"assets/assets/svg/svg_instagram.svg": "c06f4e917187128efb2a7f5213226c33",
"assets/assets/svg/svg_cart.svg": "4df2de3c8aee26514d7ccbbe50b50fd5",
"assets/assets/svg/svg_tracking.svg": "cf7545da77ca4f2f71ee69397a8fd66c",
"assets/assets/svg/svg_menu.svg": "55fcefcf5b6cd58dffd926282f28e620",
"assets/assets/svg/svg_person.svg": "dbae36a09122333a451197aa1df8ea39",
"assets/assets/svg/svg_logo.svg": "ca0a77fdfc626358e0551b1a3b3c4002",
"assets/assets/svg/svg_find.svg": "5ff1eb2d985ccf2e4ff0c59c86bcc659",
"assets/assets/svg/svg_phone.svg": "df7b87e722313ec27ab0d07a74b93e1f",
"assets/assets/png/png_11.png": "64a7ea07a169f7f2de9a3ae3724d4712",
"assets/assets/png/png_10.png": "f6acc9de4993ab58a13c30a491949dd9",
"assets/assets/png/png_12.png": "1a652f7d5a5e88dd0858362224026090",
"assets/assets/png/png_13.png": "afa7c40caae82ca51ff701d4d64df7dd",
"assets/assets/png/png_17.png": "27370c179bfcc8b657fc42894870f4f9",
"assets/assets/png/png_16.png": "a23515e5b627948af480b990fbf1829f",
"assets/assets/png/aa.jpg": "ee7ee0fbf5fb5b4a721c93cda831cdab",
"assets/assets/png/png_14.png": "6e0e1941e62c00c239cd09adcb9d4c6f",
"assets/assets/png/png_28.png": "1c078e23d6e8dce2cf03d33f66deebf8",
"assets/assets/png/ab.png": "f2cf842f0f20e694adbfd1114722ea7d",
"assets/assets/png/png_29.png": "fe894c01fbd0ae768539c69638c21fe1",
"assets/assets/png/png_15.png": "27d6103af5ddf63382171e643f2d9492",
"assets/assets/png/png_1.png": "53031f6101299001d6edea4c93d7d232",
"assets/assets/png/png_logo.png": "605d43dbf77b0b41a251ebb850d35e9b",
"assets/assets/png/png_thumnail.png": "5b69467a757eddb4044478dcb8a70d78",
"assets/assets/png/png_2.png": "6bcbfd19ab3868d6d1ac22626a47b8b0",
"assets/assets/png/hh.jpg": "e7bfce501a061c87a242c679d538dd5b",
"assets/assets/png/png_3.png": "b42a34d7c4737e94c86c2e15d76dbb83",
"assets/assets/png/gg.jpg": "482526dce569fae05188faf308e38366",
"assets/assets/png/png_7.png": "f8020776a562899527dec20731da0605",
"assets/assets/png/ff.jpg": "f131806a7e45dd038b44ba2835726fa0",
"assets/assets/png/png_6.png": "b6d7bad392e732fe32f345c35417696f",
"assets/assets/png/png_4.png": "08677c323c998959654e87a5e447e025",
"assets/assets/png/png_5.png": "e5bf7bf3f0f72566e517c423572e5421",
"assets/assets/png/png_8.png": "ba362de5f8d9f357089659f4e9783c4e",
"assets/assets/png/png_9.png": "7c3605b7eb7d00351676e8fbf0032a30",
"assets/assets/png/png_be.png": "edce108a882703490d4e0a465c25b730",
"assets/assets/png/png_header_coffee.jpeg": "9320de99b60b464306a9368123e6f767",
"assets/assets/png/dd.jpg": "ce72c6394e1b9d4ee79c4a251895ffef",
"assets/assets/png/bc.jpg": "9894489d858432956b318333aacb1d14",
"assets/assets/png/b5.jpg": "3171062f2edf6e8b33c3f3a63f558526",
"assets/assets/png/png_18.png": "cef8a1b230d09cb53490133f458aa89d",
"assets/assets/png/png_30.png": "de5694715a39971cf0c4959bb0df6a87",
"assets/assets/png/png_24.png": "b546cecb0993113c6f428a062d39fa5a",
"assets/assets/png/png_shoppe.png": "a8a56323b3443831597a03f604090bc9",
"assets/assets/png/png_25.png": "937c8fdee213e0f5e36081d71a36cfb6",
"assets/assets/png/png_31.png": "9da241e1e5957fec42dbcddf6a3d7fa8",
"assets/assets/png/png_19.png": "3b13c5cd1473eb107689e137c9cf08ce",
"assets/assets/png/file%2520ten.rtf": "21473bf5da0b789e6264e07cd4fdbbe7",
"assets/assets/png/b4.jpg": "6e4d6cf0b283cf0bf6ba5e66c2dde29c",
"assets/assets/png/bb.jpg": "c1647f14931d454ced86811db6f7fc75",
"assets/assets/png/png_27.png": "832fb2888866081485dce01ae9ca6a65",
"assets/assets/png/png_33.png": "d90c5ba2b817ba6f0d86050a4019cc1f",
"assets/assets/png/7.png": "789ec574a32f79474f1b2aec2ed0c66a",
"assets/assets/png/png_32.png": "751c3a4d3fdd542322106edf4e4a3570",
"assets/assets/png/png_26.png": "0a93d301898df50dfe81f657061c7595",
"assets/assets/png/b3.jpg": "023cc61eed93a86d54a950b896b7ec1b",
"assets/assets/png/png_22.png": "f540d8a5b86779a2d3f14fe974703bd1",
"assets/assets/png/png_36.png": "0f87bf38f71d377d12419fa521ce7643",
"assets/assets/png/png_37.png": "4782fe5e60846091d04d71ef66c07346",
"assets/assets/png/png_23.png": "29239b0f4c88517e8938132a260f209c",
"assets/assets/png/b2.jpg": "c4bc9076b6a37e324d6507ebe4208ef2",
"assets/assets/png/png_35.png": "b5f599f6b07bf91bfd804966a26a66e6",
"assets/assets/png/png_21.png": "a5bede5cde5253e953250d520aea0172",
"assets/assets/png/png_20.png": "9e657487847ef7c018eb92d1d1e2d6e8",
"assets/assets/png/png_34.png": "317d73587fcb6e32362428dc0aea89d2",
"assets/assets/json/json_menu_white.json": "686bae17101ed96dbf7f10e83188a7a9",
"assets/assets/json/json_volume.json": "f91162cf829672a6acde6e6286c90880",
"assets/assets/json/You%2520X%2520Ventures%2520Wedding%2520Website.png": "0d35ca48e00196499640f00b5b618785",
"assets/assets/json/json_gif.gif": "b4916bc83bc6300391243cc7fde9abe7",
"assets/assets/json/json_loading_dot.json": "f713b6b29e83f9fe8aa470ead6ff0fef",
"assets/assets/json/json_menu.json": "5140d2258e43915d4a09adb070a487f4",
"assets/assets/mp3/golden_hour.mp3": "d651aa86c5a2abffd3df789e5156e28d",
"assets/assets/fonts/Roboto-Medium.ttf": "68ea4734cf86bd544650aee05137d7bb",
"assets/assets/fonts/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/assets/fonts/PlayfairDisplay-Bold.ttf": "7150373c62655e32d1720fd3b3890d09",
"assets/assets/fonts/PlayfairDisplay-ExtraBoldItalic.ttf": "f4e823b725b3d4fb5dcee448f9225462",
"assets/assets/fonts/Roboto-Black.ttf": "d6a6f8878adb0d8e69f9fa2e0b622924",
"assets/assets/fonts/PlayfairDisplay-Italic.ttf": "2d6979d4e6a9fa458c3037e6d8f9abb6",
"assets/assets/fonts/PlayfairDisplay-MediumItalic.ttf": "5a7593cfe47e44dc3b1ec10da24d8da3",
"assets/assets/fonts/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/assets/fonts/PlayfairDisplay-SemiBold.ttf": "f0713720c230460d5430d96d46f5cd28",
"assets/assets/fonts/Roboto-Thin.ttf": "66209ae01f484e46679622dd607fcbc5",
"assets/assets/fonts/Roboto-MediumItalic.ttf": "c16d19c2c0fd1278390a82fc245f4923",
"assets/assets/fonts/PlayfairDisplay-BoldItalic.ttf": "4f75ab298ac2ea9f107452bcbd2b58ff",
"assets/assets/fonts/PlayfairDisplay-Medium.ttf": "5a11632ed293fcfcc40970c2b22c858f",
"assets/assets/fonts/Roboto-BlackItalic.ttf": "c3332e3b8feff748ecb0c6cb75d65eae",
"assets/assets/fonts/PlayfairDisplay-Black.ttf": "90bd8fc6f4db46013bb128526ae4014f",
"assets/assets/fonts/Roboto-Light.ttf": "881e150ab929e26d1f812c4342c15a7c",
"assets/assets/fonts/PlayfairDisplay-ExtraBold.ttf": "c474656eff24a077b81bb584c5960b04",
"assets/assets/fonts/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/assets/fonts/PlayfairDisplay-BlackItalic.ttf": "da2c33c6381f3e560d337ed9049a0e81",
"assets/assets/fonts/Roboto-BoldItalic.ttf": "fd6e9700781c4aaae877999d09db9e09",
"assets/assets/fonts/Roboto-LightItalic.ttf": "5788d5ce921d7a9b4fa0eaa9bf7fec8d",
"assets/assets/fonts/PlayfairDisplay-Regular.ttf": "9116faa12b7016e93277294c7a0735b6",
"assets/assets/fonts/PlayfairDisplay-SemiBoldItalic.ttf": "7ccf7428080713963ca79b5a3ecfe7ea",
"assets/assets/fonts/Roboto-ThinItalic.ttf": "7bcadd0675fe47d69c2d8aaef683416f",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
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
