Meteor QR Code Scanner
======================

**A no-nonsense QR Code *Scanner* for Meteor**

This package uses the [getUserMedia stream](http://caniuse.com/stream) API to record webcam or front-facing mobile cameras, constantly scanning frames to read and decode QR codes. The entire package is client-side only.

By default, qr-scanner will use the 'environment facing' camera (the main camera for smartphones) and falls back to 'face facing'.

qr-scanner is made possible by [jsqrcode](https://github.com/LazarSoft/jsqrcode).

## Quickstart

Install with Meteor.

```
meteor add hitchcott:qr-scanner
```

Add the video streaming template to your app.

```
{{> qrScanner}}
```

You can access the latest successfully decoded message through the reactive variable `message`.

```
Template.myTmpl.qrCode = -> qrScanner.message()
```

You can also bind a callback to the `scan` event, which will be fired each time a scan takes place - every 500ms - even if no message is found.

```
qrScanner.on 'scan', (err, message) ->
  alert(message) if message?
```

## Image Data

At any time you can access image data from the scanner using the following:

```
  qrScanner.imageData()     # ctx.getImageData()
  qrScanner.imageDataURL()  # canvas.toDataURL("image/jpeg")
```

## Video Quality

You can specify a [relatively](http://stackoverflow.com/a/15434766/2682159) specific video resolution if you want, but it can become a jumpy on mobile devices. More pixel data is needed to be analyzed with higher resolutions. The default is 640 x 480.

```
{{> qrScanner w=1024 h=768}}
```

The default resolution is 320 x 240 px, which works smoothly and effectively on a Galaxy S4.


## Stop Capture

Use the following to stop capturing

```
qrScanner.stopCapture()
```


## Credits / Licenses

* Packaged for Meteor by [Chris Hitchcott](https://github.com/hitchcott), 2014, MIT
* [jsqrcode](https://github.com/LazarSoft/jsqrcode) by [Lazar Laszlo](https://github.com/LazarSoft), 2011, Apache2
