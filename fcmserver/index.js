const admin = require("firebase-admin");
const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");


const serviceAccount = require("./dronquick-84db1-firebase-adminsdk-kuxm0-2cfff28556.json");

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
      title: "드론배송 어플리케이션",
      body: "상품 배송이 시작되었습니다.",
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
      title: "드론배송 어플리케이션",
      body: "상품이 배송 완료되었습니다!",
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

