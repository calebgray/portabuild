<style>img._{display:none};.header-level-1{display:none}</style># _

<script>
'use strict';

let _id = 0;
Object.defineProperty(Function.prototype, '_id', {
  get: function() {
    Object.defineProperty(this, '_id', {
      value: ++_id,
      writable: false,
    });
    return this._id;
  }
});

const $hand_ = {};
function $hand(self, key, hook) {
  switch (arguments.length) {
  case 1:
    key = self.id;
  case 2:
    if (!$hand_[key]) {
      $hand_[key] = { self: self, hooks: {} };
    } else {
      $hand_[key].self = self;
      for (const hook of Object.values($hand_[key].hooks)) {
        hook(self);
      }
    }
    return;
  case 3:
    if (!$hand_[key]) $hand_[key] = { hooks: {} };
    $hand_[key].hooks[hook._id] = hook;
    if ($hand_[key].self !== undefined) {
      for (const hook of Object.values($hand_[key].hooks)) {
        hook(self);
      }
    }
    return;
  }
}

function setText(self) {
  console.log(arguments);
}
</script>

<label for="a">A: <input id="a" type="text" onkeydown="$hand(this)" onpaste="$hand(this)" onchange="$hand(this)"></label>

<span>Change me!<img class="_" onload="$hand(this, 'a', setText)" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/></span>

### tl;dr

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

### Upload

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

# The Dockerfile
```dockerfile
# The Most Generic Dockerfile. ACHTUNG: Lists Filesystem on Execution Failure Because This is... For Development Only!!!
FROM ubuntu
COPY .. .
CMD '[ -x ./build.sh ] && ./build.sh \
    || [ -x ./build/ubuntu.sh ] && ./build/ubuntu.sh \
    || [ -x ./build/linux.sh ] && ./build/linux.sh \
    || [ -x /usr/sbin/init ] && /usr/sbin/init \
    || find /'
```