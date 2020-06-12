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
#rsagen img { width:16px;height:16px;box-shadow:unset;border:0 }
#rsagen:disabled img { animation:rotate 1s linear infinite }
@keyframes rotate { 100% { transform:rotate(360deg) } }
iframe { display:none }
</style>
<script src="-hooker.min.js"></script>
<script>
const rsagen = new Worker('rsagen.js');
rsagen.onmessage = function(e) {
  if (rsagen.button !== undefined) rsagen.button.disabled = false;
  const key = e.data.trim();
  if (key.startsWith('-----BEGIN PRIVATE KEY-----')) {
    $hook({ id: 'PRIVATE_KEY', value: key });
  } else if (key.startsWith('-----BEGIN PUBLIC KEY-----')) {
    $hook({ id: 'PUBLIC_KEY', value: key });
  }
};

function generateKeys(form) {
  rsagen.button = form[3];
  rsagen.button.disabled = true;
  rsagen.postMessage(form[0].checked && form[0].value || form[1].checked && form[1].value || form[2].checked && form[2].value);
}

function imbueWithVanilla(power) {
  document.getElementsByClassName('ribbon-inner')[1].appendChild(power);
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

> A. Create `build.sh`{:onclick="selectInner(this)"} `||` `build/ubuntu.sh`{:onclick="selectInner(this)"} `||` `build/linux.sh`{:onclick="selectInner(this)"} in [github.com/$({.username})/$({.reponame})](https://github.com/$({.username})/$({.reponame})/new/master){:target="_blank"}.
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
> <form onsubmit="return false">
> Strength:
> <label><input type="radio" name="rsabits" value="1024">1024</label>
> <label><input type="radio" name="rsabits" value="2048" checked="checked">2048</label>
> <label><input type="radio" name="rsabits" value="4096">4096 <sub><sup><em>(slow)</em></sup></sub></label>
> <button id="rsagen" type="submit" onclick="generateKeys(this.parentNode)"><img alt="Regenerate Keys" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAABWUlEQVRIx+3WPUubURQH8J8Roe3iYEqhVRRf6NJ2yN6PICIWoTro5OLgkMHJIZtbx1I6dVAKYqdQtyp+BSFzodAhTYd2UpKoy4k81DxPXrST/uHA5d57zv+83HvuHZCNMSzjNV5hBA38wHeUsY+qHjGK3TB20UEa+Ih8Qr+11hYL+BsbTrGDRUzgIYbxMiL7mnDiN+Y6EazjPBb38KyLaKdxFDp1rKYRzKMZstFjSnMohdHzdgRPUIvJov6x/U99rvA+Jsp9GM06AGAIlSjWzP8gaOWw4B73uFMoxNHv7bJ0iedxaSsYyt2y5wN4h0F8i+56LYLSDQg2w0YVj9ulqNVqt8KbXlAM/QZm0xrWSoR1gUNMdWF4HF9Cp4m1rI4o2GuJ9/YAS5jEAzyK8Vt8xlns/ZN4MjMJxO/hQyKaLKnjE56mVT0LebwJz15E4Zr4hRMcx6fgZ5qBSw+shXjl+RUFAAAAAElFTkSuQmCC"/></button>
> </form>
> 
> <sub><sup><em>(powered by <a href="https://github.com/calebgray/rsagen">github.com/calebgray/rsagen</a>)</em></sup></sub>
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
> {:ondblclick="selectInner(this)"}
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
<p style="text-align:center">zealously cultivated in the supernova of my sadness and compassion</p>
<p>
  <sub><sup><em>(imbued with vanilla powers by <a href='https://github.com/calebgray/-hooker'>$hooker</a>)</em></sup></sub>
  <img class="_" onload="imbueWithVanilla(this.parentNode)" src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'/>"/>
</p>