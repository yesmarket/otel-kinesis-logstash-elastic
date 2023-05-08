const express = require("express");
const axios = require('axios');

const PORT = parseInt(process.env.PORT || "5000");
const app = express();

const promBundle = require("express-prom-bundle");
// Add the options to the prometheus middleware most option are for http_request_duration_seconds histogram metric
const metricsMiddleware = promBundle({
    includeMethod: true,
    includePath: true,
    includeStatusCode: true,
    includeUp: true,
    customLabels: {project_name: 'hello_world', project_type: 'test_metrics_labels'},
    promClient: {
        collectDefaultMetrics: {
        }
      }
});
// add the prometheus middleware to all routes
app.use(metricsMiddleware)

app.get("/students", (req, res) => {

   // axios.get(`http://${process.env.HOST_DOMAIN}:5002/students`)
   // .then(function (response) {
   //    console.log(response);
   //    axios.get(`http://${process.env.HOST_DOMAIN}:5001/api/v1/students/1`)
   //    .then(function (response) {
   //       console.log(response);
   //       res.send('success');
   //    })
   //    .catch(function (error) {
   //       console.log(error);
   //       res.send('failed');
   //    });
   // })
   // .catch(function (error) {
   //    console.log(error);
   //    res.send('failed');
   // });

   console.log('test');
   res.send('test');

});

app.listen(PORT, () => {
   console.log(`Listening for requests on http://node-bff:${PORT}`);
});
