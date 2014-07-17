Meteor QR Code Scanner
======================

**A no-nonsense QR Code *Scanner* for Meteor**

This package uses the [getUserMedia stream](http://caniuse.com/stream) API to record webcam or front-facing mobile cameras, constantly scanning frames to read and decode QR codes. The entire package is client-side only.

qr-scanner is made possible by [jsqrcode](https://github.com/LazarSoft/jsqrcode).

## Quickstart

Install with Meteorite.

```
$ mrt add qr-scanner
```

Add the video streaming template to your app.

```
{{> qrScanner}}
```

You can access the latest succesfully decoded message through the reactive variable `message`.

```
Template.myTmpl.qrCode = -> qrScanner.message()
```

You can also bind a callback to the `scan` event, which will be fired each time a scan takes place - every 500ms - even if no message is found.

```
qrScanner.on 'scan', (err, message) ->
  alert(message) if message?
```
You can then do as you please with the message.

## Video Quality

You can specify a [relatively](http://stackoverflow.com/a/15434766/2682159) specific video resolution if you want, but it can become a jumpy on mobile devices. More pixel data is needed to be analysed with higher resolutions.

```
{{> qrScanner w=1024 h=768}}
```

The default resolution is 320 x 240 px, which works smoothly and effectively on a Galaxy S4.

## Todo

* API for accessing scanned image data

## Credits / Licenses

* Packaged for Meteor by [Chris Hitchcott](https://github.com/hitchcott), 2014, MIT
* [jsqrcode](https://github.com/LazarSoft/jsqrcode) by [Lazar Laszlo](https://github.com/LazarSoft), 2011, Apache2