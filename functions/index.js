const functions = require("firebase-functions");

const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

let msgData;

exports.commentsTrigger = functions.firestore.document(
    "comments/{commentsid}"
).onCreate((snapshot, context) => {
    msgData = snapshot.data();
    var usersID = [];
    admin.firestore().collection('listing').where('id', "==", msgData.listid).get().then((snapshot) => {
        if(snapshot.empty){
            console.log("Listing Empty");
        }else{
            for(var user in snapshot.docs){
                usersID.push(user.data().user);
            }
            console.log(usersID);
        }
    })
});


