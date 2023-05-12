const { createLogger, format, transports } = require('winston');
require('winston-syslog').Syslog;
require('dotenv').config()

const logLevels = {
   fatal: 0,
   error: 1,
   warn: 2,
   info: 3,
   debug: 4,
};

// console.log(process.env.NODE_ENV);
// console.log(process.env.OTEL_EXPORTER_OTLP_ENDPOINT_HOST);
// console.log(process.env.LOG_LEVEL);

var myTransports = [new transports.Console()];
if (process.env.NODE_ENV !== "dev") {
   const options = {
      host: process.env.OTEL_EXPORTER_OTLP_ENDPOINT_HOST,
      port: 54526,
      type: "RFC3164"
   }
   myTransports.push(new transports.Syslog(options));
}
// console.log(myTransports);

const logger = createLogger({
   levels: logLevels,
   level: process.env.LOG_LEVEL || 'info',
   format: format.combine(
      format.timestamp(),
      format.json()
   ),
   transports: myTransports,
});

module.exports = logger
