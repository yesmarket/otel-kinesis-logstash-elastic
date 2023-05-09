require('dotenv').config()
const express = require("express");
const axios = require('axios');
const logger = require('./logs.js');
const metrics = require('./metrics.js');
require('./traces.js');

const PORT = parseInt(process.env.PORT || "5000");
const app = express();

// add the prometheus middleware to all routes
app.use(metrics)

app.get("/students", (req, res) => {

   axios.get(`http://${process.env.HOST_DOMAIN}:5002/students`)
   .then(function (response) {
      console.log(response);
      axios.get(`http://${process.env.HOST_DOMAIN}:5001/api/v1/students/1`)
      .then(function (response) {
         logger.info(response);
         res.send('success');
      })
      .catch(function (error) {
         logger.info('failed');
         res.send('failed');
      });
   })
   .catch(function (error) {
      logger.info('failed');
      res.send('failed');
   });

   // logger.info('test');
   // res.send('test');

});

app.listen(PORT, () => {
   console.log(`Listening for requests on http://node-bff:${PORT}`);
});
