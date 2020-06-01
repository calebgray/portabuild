<style>.header-level-1{display:none}</style># _
<style>img._,blockquote._{display:none}</style>
<script>
'use strict';

let $hand_id = 0;
Object.defineProperty(Function.prototype, '_id', {
  get: function() {
    Object.defineProperty(this, '_id', { value: $hand_id++, writable: false });
    return this._id;
  }
});

const $hand_ = {};
function $hand(context, id, hook) {
  switch (arguments.length) {
  case 1:
    id = context.id;
  case 2:
    if (!$hand_[id]) return;
    for (const hook of Object.values($hand_[id].hooks)) {
      hook.call($hand_[id].self, context);
    }
    return;
  default:
    if (!$hand_[id]) {
      $hand_[id] = {self: context, hooks: {}};
    } else {
      $hand_[id].self = context;
    }
    $hand_[id].hooks[hook._id] = hook;
    for (const hook of Object.values($hand_[id].hooks)) {
      hook.call(context);
    }
  }
}

function $unhook(context, hook, id) {
  switch (arguments.length) {
  case 2:
    id = context.id;
  case 3:
    delete $hand_[id].hooks[hook._id];
    return;
  default:
    delete $hand_[context.id];
  }
}

function $hand_once(context, id, hook) {
  const unhook = function(trigger) {
    $unhook(this, unhook);
    hook.call(this, trigger);
  };
  $hand(context, id, unhook);
}

function setEscapedHtml(trigger) {
  if (!trigger) return;
  this.innerHTML = (typeof trigger === typeof "" ? trigger : trigger.value).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
}

function setEscapedUri(trigger) {
  if (!trigger) return;
  this.innerHTML = encodeURI(typeof trigger === typeof "" ? trigger : trigger.value);
}

const $hand_template_variable = /\(\(\.(.*?)\)\)/g;
function compileTemplate() {
  let template = this.innerHTML;
  this.innerHTML = '';
  
  let match, last = 0;
  while ((match = $hand_template_variable.exec(template)) !== null) {
    let variable = document.createElement('b');
    variable.innerHTML = match[1];

    let div = document.createElement('div');
    div.innerHTML = template.substring(last, match.index);
    div.appendChild(variable);

    this.appendChild(div);
    
    $hand(variable, match[1], setEscapedHtml);
    
    last = $hand_template_variable.lastIndex;
  }
  let div = document.createElement('div');
  div.innerHTML = template.substring(last);
  this.appendChild(div);  
}
</script>

### Port a Poo!

<label for="username">User Name: <input id="username" type="text" oninput="$hand(this)" onpropertychange="$hand(this)" placeholder="username"></label>

<label for="reponame">Repo Name: <input id="reponame" type="text" oninput="$hand(this)" onpropertychange="$hand(this)" placeholder="reponame"></label>

<label for="useremail">Email: <input id="useremail" type="email" oninput="$hand(this)" onpropertychange="$hand(this)" placeholder="your@e.mail"></label>

> ### tl;dr
> 
> 0. [Create New Repo](https://github.com/((.username))/((.reponame))/new/master) `name: .github/workflows/((.reponame)).yml, title: portapoo, body: `
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
> 0. https://github.com/((.username))/((.reponame))-builds/settings/keys/new `title: portapoo, write: true, key: ssh-keygen -t rsa -b 4096 -C "useremail" -f portapoo -P '' && cat portapoo.pub | xclip || cat portapoo.pub | clip.exe`
> 
> 0. https://github.com/((.username))/((.reponame))/settings/secrets
> 
> 0. `UPLOAD_KEY` `cat portapoo | xclip || cat portapoo | clip.exe`
> 
> 0. `UPLOAD_GIT` git@github.com:((.username))/((.reponame))-builds.git
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
> <p class='specialParagraph' markdown='1'>
>   Inner Paragraph?
> </p>
> 
> <img class="_" onload="compileTemplate.call(this.parentNode.parentNode)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>
