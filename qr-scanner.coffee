qrReactiveDict = new ReactiveDict

@qrScanner =
  message: -> qrReactiveDict.get 'message'

  on : (eventName, callback) ->
    @[eventName] = callback

  off : (eventName) ->
    delete @[eventName]

  imageData : -> ctx.getImageData(0, 0, w, h)

  imageDataURL: -> $canvas[0].toDataURL("image/jpeg")

$canvas = null
$video = null
ctx = null
w = null
h = null

showingCanvas = false

Template._qrScanner.rendered = ->
  showingCanvas = true
  @data?= {}
  w = @data.w?= 320
  h = @data.h?= 240
  $canvas = $('#qr-canvas')
  $video = $('#qr-scanner-video')
  load()

Template._qrScanner.destroyed = ->
  showingCanvas = false
  qrReactiveDict.set 'message', null
  qrScanner.off 'scan'

isCanvasSupported = ->
  elem = document.createElement("canvas")
  !!(elem.getContext and elem.getContext("2d"))

load = ->
  if isCanvasSupported()
    initDom()
    initWebcam()
  else
    err = 'Your browser does not support canvas'
    console.log err

initDom = ->
  $canvas.width(w).attr('width', w)
  $canvas.height(h).attr('height', h)
  ctx = $canvas[0].getContext("2d")
  ctx.clearRect 0, 0, w, h
  return

initWebcam = ->
  navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia
  if navigator.getUserMedia
    navigator.getUserMedia
      video:
        mandatory:
          maxWidth:w
          maxHeight:h
        optional:[]
      audio:false
    , (stream) ->
      if navigator.webkitGetUserMedia
        $video[0].src = window.webkitURL.createObjectURL(stream)
      else if navigator.mozGetUserMedia
        $video[0].mozSrcObject = stream
        $video[0].play()
      else
        $video[0].src = stream
      Meteor.setTimeout captureToCanvas, 500
    , (err) ->
      console.log err
  else
    console.log 'Your borwser doesnt support getUserMedia'

captureToCanvas = ->
  ctx.drawImage $video[0], 0, 0
  try
    message = qrcode.decode()
    qrReactiveDict.set 'message', message
    if qrScanner.scan then qrScanner.scan null, message
  catch
    err = "The QR code isnt visible or couldn't be read"
    if qrScanner.scan then qrScanner.scan err, null

  if showingCanvas
    Meteor.setTimeout captureToCanvas, 500

