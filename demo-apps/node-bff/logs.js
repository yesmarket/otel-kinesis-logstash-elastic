const { createLogger, format, transports } = require('winston');
require('winston-syslog').Syslog;

const logLevels = {
   fatal: 0,
   error: 1,
   warn: 2,
   info: 3,
   debug: 4,
};

var myTransports = [new transports.Console()];
if (process.env.NODE_ENV !== "dev") {
   const options = {
      host: "otel-front",
      port: 54526,
      type: "RFC3164"
   }
   myTransports.push(new transports.Syslog(options));
}

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
