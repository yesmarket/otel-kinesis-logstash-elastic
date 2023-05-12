const express = require("express");
const axios = require('axios');
const logger = require('./logs.js');
const metrics = require('./metrics.js');
require('dotenv').config()

const PORT = parseInt(process.env.PORT || "5000");
const app = express();

// add the prometheus middleware to all routes
app.use(metrics)

app.get("/students/:id", (req, res) => {

   // logger.info(req.params.id);
   axios.get(`http://${process.env.HOST_DOMAIN}:5002/api/v1/students/${req.params.id}`)
   .then(function (response) {
      console.log(response);
      axios.get(`http://${process.env.HOST_DOMAIN}:5001/api/v1/students/${req.params.id}`)
      .then(function (response) {
         logger.info("asdfgh12345");
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

   // logger.info('asdfgh12345');
   // res.send('test');

});

app.listen(PORT, () => {
   console.log(`Listening for requests on http://node-bff:${PORT}`);
});
