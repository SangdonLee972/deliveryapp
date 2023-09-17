const admin = require("firebase-admin");
const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");


const serviceAccount = require("./deliverydroneapp-89b9d-29741aa1cec4.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});


const app = express();
app.use(cors({origin: true}));

exports.pushFcm = functions.https.onRequest(app);

app.post("/insu", (req, res) => {
const token = req.body.token;

  const payload = {
    notification: {
      title: "드론 어플리케이션",
      body: "상품이 인수되었습니다.",
    },
  };

   admin.messaging().sendToDevice(token, payload)
     .then((response) => {
       console.log("Successfully sent message:", response);
       console.log(response.results[0].error);
       return true;
  })
  .catch((error) => {
    console.log("Error sending message:", error);
  });
});

app.post("/success", (req, res) => {
const token = req.body.token;

  const payload = {
    notification: {
      title: "드론 어플리케이션",
      body: "주문이 체결되었습니다!",
    },
  };

   admin.messaging().sendToDevice(token, payload)
     .then((response) => {
       console.log("Successfully sent message:", response);
       console.log(response.results[0].error);
       return true;
  })
  .catch((error) => {
    console.log("Error sending message:", error);
  });
});
