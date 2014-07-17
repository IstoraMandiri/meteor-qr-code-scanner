qrReactiveDict = new ReactiveDict

@qrScanner =
  qrcode : qrcode # the lib
  message: -> qrReactiveDict.get 'message'

$canvas = null
$video = null
ctx = null

Template.qrScanner.rendered = ->
  @data?= {}
  w = @data.w?= 320
  h = @data.h?= 240
  $canvas = $('#qr-canvas')
  $video = $('#qr-scanner-video')
  load w, h

Template.qrScanner.message = -> qrScanner.message()

isCanvasSupported = ->
  elem = document.createElement("canvas")
  !!(elem.getContext and elem.getContext("2d"))

load = (w,h) ->
  if isCanvasSupported() and window.File and window.FileReader
    initDom w, h
    initWebcam w, h
  else
    console.log 'Sorry, your browser doesnt support QR Code Scanner'

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
      if qrScanner.fail then qrScanner.fail err else console.log err
  else
    err = 'Your borwser doesnt support getUserMedia'
    if qrScanner.fail then qrScanner.fail err else console.log err

captureToCanvas = ->
  ctx.drawImage $video[0], 0, 0
  try
    message = qrcode.decode()
    qrReactiveDict.set 'message', message
    if qrScanner.done then qrScanner.done message else console.log message
  Meteor.setTimeout captureToCanvas, 500

