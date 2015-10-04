if Meteor.isClient
  qrScanner.on 'scan', (err, message) ->
    alert(message) if message?
