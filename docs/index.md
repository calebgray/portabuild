<style>
div.shell { zoom:120% }
body,div,p,blockquote,pre { font-size:0.99em !important;font-family:Tahoma,Geneva,sans-serif !important }
header h2 { font-size:1.4em }
blockquote { color:#544943;margin:0 }
img._ { display:none }
blockquote { background-image:none;padding:0 }
pre,.header-level-1,.highlight { border:0;padding:0;text-align:left;font-style:normal;font-size:1.3em }
.highlighter-rouge,pre.highlight,code { background:#111;color:#ddd;border-radius:3px }
code { padding:4px }
input { background:#eee;border:1px solid #111;border-radius:3px;color:#111;padding-left:3px }
h3 { margin-top:50px !important }
hr { margin:50px 0 0 }
pre.highlight { padding:4px 8px 4px }
</style>
<script src="wasm_exec.js"></script>
<script>
'use strict';

const $hook_prefix = '_';
const $hook_key = $hook_prefix+'id';

let $hook_id = 0;
Object.defineProperty(Function.prototype, $hook_key, {
  get: function() {
    Object.defineProperty(this, $hook_key, { value: $hook_id++, writable: false });
    return this[$hook_key];
  }
});

const $hook_ = {};
function $hook(context, id, hook) {
  switch (arguments.length) {
  case 1:
    id = context.id;
  case 2:
    if (!$hook_[id]) return;
    for (const hook of Object.values($hook_[id].hooks)) {
      for (const trigger of Object.values($hook_[id].triggers)) {
        hook.call(trigger, context);
      }
    }
    return;
  default:
    if (!$hook_[id]) {
      $hook_[id] = {
        triggers: { [context[$hook_key]]: context },
        hooks: { [hook[$hook_key]]: hook },
      };
    } else {
      $hook_[id].triggers[context[$hook_key]] = context;
      $hook_[id].hooks[hook[$hook_key]] = hook;
    }
    for (const hook of Object.values($hook_[id].hooks)) {
      hook.call(context);
    }
  }
}

function $unhook(context, hook, id) {
  switch (arguments.length) {
  case 2:
    id = context.id;
  case 3:
    delete $hook_[id].hooks[hook[$hook_key]];
    return;
  default:
    delete $hook_[context.id];
  }
}

function $hook_once(context, id, hook) {
  const unhook = function(trigger) {
    $unhook(this, unhook);
    hook.call(this, trigger);
  };
  $hook(context, id, unhook);
}

function setEscapedHtml(trigger) {
  if (!trigger) return;
  this.innerHTML = (typeof trigger === typeof '' ? trigger : trigger.value).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
}

function setEscapedUri(trigger) {
  if (!trigger) return;
  this.innerHTML = encodeURI(typeof trigger === typeof '' ? trigger : trigger.value);
}

function renderTemplate(templateHtml, v, trigger) {
  if (!trigger) return;
  v[trigger.id] = trigger.value || trigger.dataset.value;
  this.innerHTML = eval('`'+templateHtml.replace(/`/g, "\\`")+'`');
}

const $hook_template_variable = /(\$)\({\.(.*?)}\)/g;
function compileTemplate(trigger, formats) {
  const templateSource = trigger.parentNode.parentNode;
  trigger.parentNode.remove();

  if (!templateSource) return;
  const templateRaw = templateSource.innerHTML;
  if (!templateRaw) return;

  const variables = {};
  let templateHtml = '';

  const templateParts = templateRaw.split($hook_template_variable);
  let partType = templateParts[0] === '$' && templateParts.length > 0 ? 0 : 2;
  for (let templatePart of templateParts) {
    switch (partType) {
    case 0:
      partType = 1;
      continue;
    case 1:
      partType = 2;
      variables[templatePart] = !formats ? templatePart : formats.hasOwnProperty(templatePart) ? formats[templatePart].replace('{0}', templatePart) : formats.hasOwnProperty('_') ? formats._.replace('{0}', templatePart) : formats.replace('{0}', templatePart);
      templateHtml += '${v.'+templatePart+'}';
      continue;
    case 2:
      partType = 0;
      templateHtml += templatePart;
    }
  }

  renderTemplate.call(templateSource, templateHtml, variables, templateSource);
  for (const variable of Object.keys(variables)) {
    $hook(templateSource, variable, renderTemplate.bind(templateSource, templateHtml, variables));
  }
}

if (!WebAssembly.instantiateStreaming) WebAssembly.instantiateStreaming = async (resp, importObject) => {
  const source = await (await resp).arrayBuffer();
  return await WebAssembly.instantiate(source, importObject);
};

const go = new Go();
async function generateKeys(trigger) {
  let keyStrength;
  if (!trigger) {
    keyStrength = 2048;
  } else {
    keyStrength = Math.round(trigger[1].checked && trigger[1].value || trigger[2].checked && trigger[2].value || trigger[3].checked && trigger[3].value);
  }

  const getInt64 = (addr) => {
    const low = this.mem.getUint32(addr + 0, true);
    const high = this.mem.getInt32(addr + 4, true);
    return low + high * 4294967296;
  };

  const importObject = go.importObject;
  importObject.go['runtime.wasmWrite'] = (sp) => {
    const fd = getInt64(sp + 8);
    const p = getInt64(sp + 16);
    const n = this.mem.getInt32(sp + 24, true);
    fs.writeSync(fd, new Uint8Array(this._inst.exports.mem.buffer, p, n));
  };

  await WebAssembly.instantiateStreaming(fetch('rsagen.wasm'), importObject).then((result) => {
    go.run(result.instance);
    /* TODO: finished! */
  }).catch((err) => {
    console.error(err);
  });

  return false;
}

const variableFormats = {
  _: '{0}',
  GITHUB_TOKEN: '$&#123;{secrets.GITHUB_TOKEN}}',
  UPLOAD_GIT: '$&#123;{secrets.UPLOAD_GIT}}',
  UPLOAD_KEY: '$&#123;{secrets.UPLOAD_KEY}}',
  UPLOADER_EMAIL: '$&#123;{secrets.UPLOADER_EMAIL}}',
  UPLOADER_NAME: '$&#123;{secrets.UPLOADER_NAME}}',
};
</script>

### Port a Poo! Ho!

> "Never learn to do anything: if you don't learn, you'll always find someone else to do it for you." - Mark Twain


### Build

Target: <label for="username">github.com/<input id="username" type="text" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your username"></label><label for="reponame">/<input id="reponame" type="text" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your repo"></label>

> A. Create `build.sh || build/ubuntu.sh || build/linux.sh` in [github.com/$({.username})/$({.reponame})](https://github.com/$({.username})/$({.reponame})/new/master){:target="_blank"}.
> 
> B. Copy:
> 
> ```yaml
> on: [ push, pull_request ]
> 
> jobs:
>   Release:
>     runs-on: ubuntu-latest
>     env:
>       GITHUB_TOKEN: $({.GITHUB_TOKEN})
>     steps:
>     - name: Checkout
>       uses: actions/checkout@master
>     - name: Build
>       uses: calebgray/portapoo.action@master
> ```
> 
> C. [Paste](https://github.com/$({.username})/$({.reponame})/new/master){:target="_blank"}: `.github/workflows/$({.reponame}).yml`
> 
> <img class="_" onload="compileTemplate(this, variableFormats)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>


### Upload <sub><sup><em>[optional]</em></sup></sub>

You: <input id="fullname" type="email" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your name">/<input id="useremail" type="email" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your@e.mail">

> A. [Create](https://github.com/new){:target="_blank"} `$({.reponame})-builds` `{ type: private, readme: true }`
> 
> B. Copy:
> 
> ```
> $({.PUBLIC_KEY})
> ```
> 
> <form onsubmit="return generateKeys(this)">Strength: <label><input type="radio" name="rsabits" value="1024">1024</label> <label><input type="radio" name="rsabits" value="2048" checked="checked">2048</label> <label><input type="radio" name="rsabits" value="4096">4096</label> <button type="submit">Regenerate!</button></form>
> 
> C. [Paste](https://github.com/$({.username})/$({.reponame})-builds/settings/keys/new){:target="_blank"}: `portapoo` `{ write: true }`
> 
> D. [Set](https://github.com/$({.username})/$({.reponame})/settings/secrets){:target="_blank"}:
> 
> - `UPLOAD_KEY`: `$({.PRIVATE_KEY})`
> 
> - `UPLOAD_GIT`: `git@github.com:$({.username})/$({.reponame})-builds.git`
> 
> - `UPLOADER_NAME`: `$({.fullname})`
> 
> - `UPLOADER_EMAIL`: `$({.useremail})`
> 
> ```yaml
> on: [ push, pull_request ]
> 
> jobs:
>   Release:
>     runs-on: ubuntu-latest
>     env:
>       GITHUB_TOKEN: $({.GITHUB_TOKEN})
>       UPLOAD_GIT: $({.UPLOAD_GIT})
>       UPLOAD_KEY: $({.UPLOAD_KEY})
>       UPLOADER_EMAIL: $({.UPLOADER_EMAIL})
>       UPLOADER_NAME: $({.UPLOADER_NAME})
>     steps:
>     - name: Checkout
>       uses: actions/checkout@master
>     - name: Build
>       uses: calebgray/portapoo.action@master
> ```
> 
> <img class="_" onload="compileTemplate(this, variableFormats);generateKeys()" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>


### Nearly Generic Dockerfile

This is the `Dockerfile` which endows GitHub with its action.

> ```dockerfile
> # Nearly Generic Dockerfile. (ACHTUNG: Dumps whole load on failure because this is for professionals that don't believe in standards but follow them anyway. That's an endless loop to insanity... isn't it...)
> FROM ubuntu
> COPY . .
> CMD ([ -x ./build.sh ] && ./build.sh) \
> || ([ -x ./build/ubuntu.sh ] && ./build/ubuntu.sh) \
> || ([ -x ./build/linux.sh ] && ./build/linux.sh) \
> || ([ -x /usr/sbin/init ] && /usr/sbin/init) \
> || (env && find /)
> ```


---
<p style="text-align:center">Zealously cultivated in the supernova of my sadness and compassion.</p>
