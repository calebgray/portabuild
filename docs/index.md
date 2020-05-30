<style>.header-level-1{display:none}</style># _

<style>img._{display:none}</style>

<script>
'use strict';

let _id = 0;
Object.defineProperty(Function.prototype, '_id', {
  get: function() {
    Object.defineProperty(this, '_id', {
      value: _id++,
      writable: false,
    });
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
  }

  if (!$hand_[id]) {
    $hand_[id] = {self: context, hooks: {}};
  } else {
    $hand_[id].self = context;
  }
  $hand_[id].hooks[hook._id] = hook;
  for (const hook of Object.values($hand_[id].hooks)) {
    hook.apply(context, arguments);
  }
}

function setEscapedHtml(trigger) {
  if (!trigger) return;
  this.innerHTML = trigger.value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
}
</script>

<label for="yourname">Your Name: <input id="yourname" type="text" oninput="$hand(this)" onpropertychange="$hand(this)" placeholder="yourname"></label>

<label for="target">Target: <input id="target" type="text" oninput="$hand(this)" onpropertychange="$hand(this)"></label>

<span>yourname<img class="_" onload="$hand(this.parentNode, 'yourname', setEscapedHtml)" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/></span>

> ### tl;dr
> 
> 0. https://github.com/yourname/yourappname/new/master `name: .github/workflows/yourappname.yml, title: portapoo, body: `
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
> <img class="_" onload="$hand(this.parentNode, 'target', setEscapedHtml, this)" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/>
> 
> ### Upload
> 
> 0. _<sub><sup>[optional]</sup></sub>_ [CreateRepo](https://github.com/new) `name: yourappname-builds, type: private, readme: true`
> 
> 0. https://github.com/yourname/yourappname-builds/settings/keys/new `title: portapoo, write: true, key: ssh-keygen -t rsa -b 4096 -C "your@e.mail" -f portapoo -P '' && cat portapoo.pub | xclip || cat portapoo.pub | clip.exe`
> 
> 0. https://github.com/yourname/yourappname/settings/secrets
> 
> 0. `UPLOAD_KEY` `cat portapoo | xclip || cat portapoo | clip.exe`
> 
> 0. `UPLOAD_GIT` git@github.com:yourname/yourappname-builds.git
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
