const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.messageTrigger = functions.firestore.document("messages/{messageId}").onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }
    var tokens = ['e-HZWsq5xlE:APA91bFxrUjwQ5Zifz5_vpdPHuOKFJ5MB8fzyL2oVBzbkpvqOVlpOdBaJFXJLD8y8_c2qzCf2rG3iSjJdK3O3ePQtLxflt0c8E2xOe0LI90owHfMUph78cvnMLL-xaft1bjx5rVEt0fT'];
    newData = snapshot.data;
    var payload = {
        notification: { title: 'Push Title', body: 'Push Body', sound: 'default' },
        data: {
            click_action: ' FLUTTER_NOTIFICATION_CLICK',
            message: 'Sample Push Message'
        }
    };
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (error) {
        console.log('Error sending notification');
    }
}
);


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
