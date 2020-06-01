<style>.header-level-1{display:none}</style># _
<style>img._,blockquote._{display:none}</style>

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

function renderTemplate(trigger) {
  console.log(arguments);
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
      variables[templatePart] = '';
      templateHtml += '${v.'+templatePart+'}';
      continue;
    case 2:
      partType = 0;
      templateHtml += templatePart;
    }
  }

  for (const variable of Object.keys(variables)) {
    $hook(templateSource, variable, function(){
      let v = variables;
      renderTemplate`${templateHtml}`;
    });
  }
}

let passPhrase = "";
let privateKey = cryptico.generateRSAKey(passPhrase, 2048);
let publicKey = cryptico.publicKeyString(privateKey);
console.log(privateKey);
console.log(publicKey);
</script>

### Port a Poo!

<label for="username">User Name: <input id="username" type="text" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="username"></label>

<label for="reponame">Repo Name: <input id="reponame" type="text" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="reponame"></label>

<label for="useremail">Email: <input id="useremail" type="email" oninput="$hook(this)" onpropertychange="$hook(this)" placeholder="your@e.mail"></label>

> ### tl;dr
> 
> 0. [Create New Repo](https://github.com/$({.username})/$({.reponame})/new/master) `name: .github/workflows/$({.reponame}).yml, title: portapoo, body: `
> 
> ```yaml
> on: [ push, pull_request ]
> 
> jobs:
>   Release:
>     runs-on: ubuntu-latest
>     env:
>       GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
>     steps:
>     - name: Checkout
>       uses: actions/checkout@master
>     - name: Build
>       uses: calebgray/portapoo.action@master
> ```
> 
> ### Upload
> 
> 0. _<sub><sup>[optional]</sup></sub>_ [CreateRepo](https://github.com/new) `name: reponame-builds, type: private, readme: true`
> 
> 0. https://github.com/$({.username})/$({.reponame})-builds/settings/keys/new `title: portapoo, write: true, key: ssh-keygen -t rsa -b 4096 -C "useremail" -f portapoo -P '' && cat portapoo.pub | xclip || cat portapoo.pub | clip.exe`
> 
> 0. https://github.com/$({.username})/$({.reponame})/settings/secrets
> 
> 0. `UPLOAD_KEY` `cat portapoo | xclip || cat portapoo | clip.exe`
> 
> 0. `UPLOAD_GIT` git@github.com:$({.username})/$({.reponame})-builds.git
> 
> 0. `UPLOADER_EMAIL` your@e.mail
> 
> 0. `UPLOADER_NAME` Your Name
> 
> ```yaml
> on: [ push, pull_request ]
> 
> jobs:
>   Release:
>     runs-on: ubuntu-latest
>     env:
>       GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
>       UPLOAD_GIT: ${{secrets.UPLOAD_GIT}}
>       UPLOAD_KEY: ${{secrets.UPLOAD_KEY}}
>       UPLOADER_EMAIL: ${{secrets.UPLOADER_EMAIL}}
>       UPLOADER_NAME: ${{secrets.UPLOADER_NAME}}
>     steps:
>     - name: Checkout
>       uses: actions/checkout@master
>     - name: Build
>       uses: calebgray/portapoo.action@master
> ```
> 
> # The Dockerfile
> ```dockerfile
> # The Most Generic Dockerfile. ACHTUNG: Lists Filesystem on Execution Failure Because This is... For Development Only!!!
> FROM ubuntu
> COPY .. .
> CMD '[ -x ./build.sh ] && ./build.sh \
>     || [ -x ./build/ubuntu.sh ] && ./build/ubuntu.sh \
>     || [ -x ./build/linux.sh ] && ./build/linux.sh \
>     || [ -x /usr/sbin/init ] && /usr/sbin/init \
>     || find /'
> ```
> 
> <img class="_" onload="compileTemplate(this)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>
