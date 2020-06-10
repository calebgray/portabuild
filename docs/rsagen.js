'use strict';

const decoder = new TextDecoder('utf-8');
global.fs.writeSync = function(fd, buf) {
  postMessage(decoder.decode(buf));
  return buf.length;
};

const keyStrength = !window.location.hash ? '2048' : window.location.hash.substring(1);
const go = new Go();
onmessage = function(keyStrength) {
  go.argv = ['rsagen.wasm', keyStrength];
  WebAssembly.instantiateStreaming(fetch('rsagen.wasm', { cache: 'force-cache' }), go.importObject).then((result) => {
    go.run(result.instance);
  });
}