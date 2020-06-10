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
pre.highlight { max-height:30em;padding:4px 8px 4px;font-size:0.8em !important }
#loading { width:16px;height:16px;box-shadow:unset;border:0 }
.loading { animation:rotate 1s linear infinite }
@keyframes rotate { 100% { transform:rotate(360deg) } }
iframe { display:none }
</style>
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

function selectInner(target) {
  if (document.selection) {
    document.body.createTextRange().moveToElementText(target).select();
  } else if (window.getSelection) {
    const range = document.createRange();
    range.selectNode(target);
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);
  }
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

let loading;
function checkLoading() {
  if (!loading) loading = document.getElementById('loading');
  return loading.className === 'loading';
}

const rsagen = new Worker('rsagen.js');
rsagen.onmessage = function(e) {
  checkLoading();
  loading.className = '';
  const key = e.data.trim();
  if (key.startsWith('-----BEGIN PRIVATE KEY-----')) {
    $hook({ id: 'PRIVATE_KEY', value: key });
  } else if (key.startsWith('-----BEGIN PUBLIC KEY-----')) {
    $hook({ id: 'PUBLIC_KEY', value: key });
  }
};

function generateKeys(form) {
  if (checkLoading()) return;
  loading.className = 'loading';
  rsagen.postMessage(form[0].checked && form[0].value || form[1].checked && form[1].value || form[2].checked && form[2].value);
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
> <sub><sup><em> reference: [github.com/calebgray/psftp/build.sh](https://github.com/calebgray/psftp/blob/master/build.sh) </em></sup></sub>
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
> {:onclick="selectInner(this)"}
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
> {:onclick="selectInner(this)"}
> 
> <form onsubmit="generateKeys(this);return false">
> Strength:
> <label><input type="radio" name="rsabits" value="1024">1024</label>
> <label><input type="radio" name="rsabits" value="2048" checked="checked">2048</label>
> <label><input type="radio" name="rsabits" value="4096">4096</label>
> <button type="submit"><img id="loading" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAABWUlEQVRIx+3WPUubURQH8J8Roe3iYEqhVRRf6NJ2yN6PICIWoTro5OLgkMHJIZtbx1I6dVAKYqdQtyp+BSFzodAhTYd2UpKoy4k81DxPXrST/uHA5d57zv+83HvuHZCNMSzjNV5hBA38wHeUsY+qHjGK3TB20UEa+Ih8Qr+11hYL+BsbTrGDRUzgIYbxMiL7mnDiN+Y6EazjPBb38KyLaKdxFDp1rKYRzKMZstFjSnMohdHzdgRPUIvJov6x/U99rvA+Jsp9GM06AGAIlSjWzP8gaOWw4B73uFMoxNHv7bJ0iedxaSsYyt2y5wN4h0F8i+56LYLSDQg2w0YVj9ulqNVqt8KbXlAM/QZm0xrWSoR1gUNMdWF4HF9Cp4m1rI4o2GuJ9/YAS5jEAzyK8Vt8xlns/ZN4MjMJxO/hQyKaLKnjE56mVT0LebwJz15E4Zr4hRMcx6fgZ5qBSw+shXjl+RUFAAAAAElFTkSuQmCC"/></button>
> </form>
> 
> <sub><sup><em> powered by: [github.com/calebgray/rsagen](https://github.com/calebgray/rsagen) </em></sup></sub>
>
> C. [Paste](https://github.com/$({.username})/$({.reponame})-builds/settings/keys/new){:target="_blank"}: `portapoo` `{ write: true }`
> 
> D. [Set](https://github.com/$({.username})/$({.reponame})/settings/secrets){:target="_blank"}:
> 
> - `UPLOADER_NAME`: `$({.fullname})`
> 
> - `UPLOADER_EMAIL`: `$({.useremail})`
> 
> - `UPLOAD_GIT`: `git@github.com:$({.username})/$({.reponame})-builds.git`
> 
> - `UPLOAD_KEY`:
> 
> ```
> $({.PRIVATE_KEY})
> ```
> {:onclick="selectInner(this)"}
> 
> E. [Edit](https://github.com/$({.username})/$({.reponame})/edit/master/.github/workflows/$({.reponame}).yml){:target="_blank"}.
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
> {:onclick="selectInner(this)"}
> 
> <img class="_" onload="compileTemplate(this, variableFormats)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>


### Nearly Generic Dockerfile

This is the `Dockerfile` which endows GitHub with its action.

> ```dockerfile
> # Nearly Generic Dockerfile. (ACHTUNG: Dumps whole load on failure because this is for professionals that don't believe in standards but follow them anyway. That's an endless loop to insanity... isn't it...)
> FROM alpine
> COPY . .
> CMD ([ -x ./build.sh ] && ./build.sh) \
> || ([ -x ./build/ubuntu.sh ] && ./build/ubuntu.sh) \
> || ([ -x ./build/linux.sh ] && ./build/linux.sh) \
> || ([ -x /usr/sbin/init ] && /usr/sbin/init) \
> || (env && find /)
> ```

---
<p style="text-align:center">Zealously cultivated in the supernova of my sadness and compassion.</p>
