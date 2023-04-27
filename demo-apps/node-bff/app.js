const express = require("express");
const axios = require('axios');

const PORT = parseInt(process.env.PORT || "5000");
const app = express();

app.get("/students", (req, res) => {

   axios.get(`http://${process.env.HOST_DOMAIN}:5002/students`)
   .then(function (response) {
      console.log(response);
      axios.get(`http://${process.env.HOST_DOMAIN}:5001/api/v1/students/1`)
      .then(function (response) {
         console.log(response);
         res.send('success');
      })
      .catch(function (error) {
         console.log(error);
         res.send('failed');
      });
   })
   .catch(function (error) {
      console.log(error);
      res.send('failed');
   });

});

app.listen(PORT, () => {
   console.log(`Listening for requests on http://node-bff:${PORT}`);
});
