<style>
.shell { zoom:125% }
.header-level-1 { display:none }
img._ { display:none }
blockquote { background-image:none;padding:0 }
pre,.header-level-2,.highlight { border:0 }
.highlighter-rouge,pre.highlight,code { background:#111;padding:4px;border-radius:3px }
input { background:#eee;border:1px solid #111;border-radius:3px;color:#111;padding-left:3px }
h3 { margin-top:50px !important }
hr { margin:50px 0 0 }
div.highlighter-rouge { padding: 0 0 0 4px !important }
</style>
# _
<script src="https://cdnjs.cloudflare.com/ajax/libs/cryptico/0.0.1343522940/cryptico.min.js"></script>
<script>
'use strict';

const $hook_prefix = '_';
const $hook_key = $hook_prefix+'id';

let $hook_id = 0;
Object.defineProperty(Object.prototype, $hook_key, {
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
  this.innerHTML = (typeof trigger === typeof "" ? trigger : trigger.value).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
}

function setEscapedUri(trigger) {
  if (!trigger) return;
  this.innerHTML = encodeURI(typeof trigger === typeof "" ? trigger : trigger.value);
}

function renderTemplate(templateHtml, v, trigger) {
  if (!trigger) return;
  v[trigger.id] = trigger.value || trigger.dataset.value;
  this.innerHTML = eval('`'+templateHtml.replace(/`/g, "\\`")+'`');
}

const $hook_template_variable = /(\$)\({\.(.*?)}\)/g;
function compileTemplate(trigger) {
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
      variables[templatePart] = templatePart;
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

function replaceMarkdown(trigger) {
  console.log(arguments);
}

function generateKeys(trigger) {
    console.log(arguments);
    let passPhrase = "";
    let privateKey = cryptico.generateRSAKey(passPhrase, 2048);
    let publicKey = cryptico.publicKeyString(privateKey);
    $hook(privateKey, 'PRIVATE_KEY', setEscapedHtml);
    $hook(publicKey, 'PUBLIC_KEY', setEscapedHtml);
    return false;
}

$hook('$&#123;{secrets.GITHUB_TOKEN}}', 'GITHUB_TOKEN', replaceMarkdown);
$hook('$&#123;{secrets.UPLOAD_GIT}}', 'UPLOAD_GIT', replaceMarkdown);
$hook('$&#123;{secrets.UPLOAD_KEY}}', 'UPLOAD_KEY', replaceMarkdown);
$hook('$&#123;{secrets.UPLOADER_EMAIL}}', 'UPLOADER_EMAIL', replaceMarkdown);
$hook('$&#123;{secrets.UPLOADER_NAME}}', 'UPLOADER_NAME', replaceMarkdown);
</script>

### Port a Poo! Ho!

> "Never learn to do anything: if you don't learn, you'll always find someone else to do it for you." - Dead Asshole That Knew Some Shit


### What's This?

See Mark Twain's aforementioned words of wisdom.


### Build

Target: <label for="username">github.com/<input id="username" type="text" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your username"></label><label for="reponame">/<input id="reponame" type="text" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your repo"></label>

> 1. Create `build.sh || build/ubuntu.sh || build/linux.sh` in [github.com/$({.username})/$({.reponame})](https://github.com/$({.username})/$({.reponame})/new/master).
> 
> 2. Copy:
> 
> ```yaml
>     on: [ push, pull_request ]
>     
>     jobs:
>       Release:
>         runs-on: ubuntu-latest
>         env:
>           GITHUB_TOKEN: $({.GITHUB_TOKEN}}
>         steps:
>         - name: Checkout
>           uses: actions/checkout@master
>         - name: Build
>           uses: calebgray/portapoo.action@master
> ```
> 
> 3. [Paste](https://github.com/$({.username})/$({.reponame})/new/master): `.github/workflows/$({.reponame}).yml`
> 
> <img class="_" onload="compileTemplate(this)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>


### Upload _<sub><sup>[optional]</sup></sub>_

You: <label for="fullname"><input id="fullname" type="email" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="Your Name"></label><label for="useremail">/<input id="useremail" type="email" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your@e.mail"></label>

> 1. [Create](https://github.com/new) `$({.reponame})-builds` `{ type: private, readme: true }`
> 
> 2. Copy:
> 
> ```
> $({.PUBLIC_KEY})
> ```
> <form id="rsagen" onsubmit="return generateKeys(this)"><sub><sup><i>[optional]</i></sup></sub>Password? <input type="text" name="name" id="id" placeholder="password"/> <button type="submit">Regenerate!</button></form> (_<sub><sup>powered by the lovely</sup></sub>_ [cryptico](https://github.com/wwwtyro/cryptico))
> 
> 3. [Paste](https://github.com/$({.username})/$({.reponame})-builds/settings/keys/new): `portapoo` `{ write: true }`
> 
> 4. [Create](https://github.com/$({.username})/$({.reponame})/settings/secrets):
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
>       GITHUB_TOKEN: $({.GITHUB_TOKEN}}
>       UPLOAD_GIT: $({.UPLOAD_GIT}}
>       UPLOAD_KEY: $({.UPLOAD_KEY}}
>       UPLOADER_EMAIL: $({.UPLOADER_EMAIL}}
>       UPLOADER_NAME: $({.UPLOADER_NAME}}
>     steps:
>     - name: Checkout
>       uses: actions/checkout@master
>     - name: Build
>       uses: calebgray/portapoo.action@master
> ```
> 
> <img class="_" onload="compileTemplate(this)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>


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

... all works meticulously handcrafted from scratch (every single bit) with the utmost care, consideration, and true love of the art.