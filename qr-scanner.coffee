qrReactiveDict = new ReactiveDict

@qrScanner =
  message: -> qrReactiveDict.get 'message'

  on : (eventName, callback) ->
    @[eventName] = callback

  off : (eventName) ->
    delete @[eventName]


$canvas = null
$video = null
ctx = null
showingCanvas = false

Template._qrScanner.rendered = ->
  showingCanvas = true
  @data?= {}
  w = @data.w?= 320
  h = @data.h?= 240
  $canvas = $('#qr-canvas')
  $video = $('#qr-scanner-video')
  load w, h

Template._qrScanner.destroyed = ->
  showingCanvas = false
  qrReactiveDict.set 'message', null
  qrScanner.off 'scan'

isCanvasSupported = ->
  elem = document.createElement("canvas")
  !!(elem.getContext and elem.getContext("2d"))

load = (w,h) ->
  if isCanvasSupported()
    initDom w, h
    initWebcam w, h
  else
    err = 'Your browser does not support canvas'
    console.log err

initDom = (w, h) ->
  $canvas.width(w).attr('width', w)
  $canvas.height(h).attr('height', h)
  ctx = $canvas[0].getContext("2d")
  ctx.clearRect 0, 0, w, h
  return

initWebcam = (w, h) ->
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

