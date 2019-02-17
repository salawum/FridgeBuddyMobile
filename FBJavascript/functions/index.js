const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

//var msgData;

exports.generalNotify = functions.firestore.document(
  'Items/{ItemId}'
).onUpdate((change, context) => {
  var before = change.before.data();
  var after = change.after.data();

  //var compare = before.localeCompare(after);

  admin.firestore().collection('notifytokens').get().then((snapshots) =>{
    var tokens = [];
    if (snapshots.empty){
      console.log('Empty list');
    } else {

      if (before != after)
      {
        for (var token of snapshots.docs) {
          tokens.push(token.data().mobiletokens);
        }

        var payload = {
          notification: {
            "title": "Good news!",
            "body": "Fridges have been updated",
            "sound": "default"
          },
          data:{
            "sendername": "FridgeBuddy",
            "message": "test message"
          }
        }
      }
      /* for (var token of snapshots.docs) {
        tokens.push(token.data().mobiletokens);
      }

      var payload = {
        "notifications": {
          "title": "Good news!",
          "body": "Fridges have been updated",
          "sound": "default"
        }*/

        //"data":{
          //"sendername": "FridgeBuddy",
          //"message": "test message"
        //}
      }

      return admin.messaging().sendToDevice(tokens, payload).then((response) => {
        console.log('Push Completed.');
      }).catch((err) => {
          console.log(err);
      })
    })
    return 0;
  })
