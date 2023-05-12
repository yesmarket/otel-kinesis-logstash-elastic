const { NodeSDK } = require('@opentelemetry/sdk-node');
const { Resource } = require('@opentelemetry/resources');
const { SemanticResourceAttributes } = require('@opentelemetry/semantic-conventions');
// const { ConsoleSpanExporter } = require('@opentelemetry/sdk-trace-node');
// const { OTLPTraceExporter } =  require('@opentelemetry/exporter-trace-otlp-http');
const { OTLPTraceExporter } =  require('@opentelemetry/exporter-trace-otlp-proto');
// const { OTLPTraceExporter } =  require('@opentelemetry/exporter-trace-otlp-grpc');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
require('dotenv').config()

// console.log(process.env.COLLECTOR_OPTIONS)
// console.log(process.env.OTEL_SERVICE_NAME)
// console.log(process.env.OTEL_SERVICE_VERSION)
// console.log(process.env.NODE_ENV)

if (process.env.NODE_ENV) {

   const collectorOptions = JSON.parse(process.env.COLLECTOR_OPTIONS);

   // console.log(collectorOptions)

   const sdk = new NodeSDK({
      resource: new Resource({
         [SemanticResourceAttributes.SERVICE_NAME]: process.env.OTEL_SERVICE_NAME,
         [SemanticResourceAttributes.SERVICE_VERSION]: process.env.OTEL_SERVICE_VERSION,
         [SemanticResourceAttributes.DEPLOYMENT_ENVIRONMENT]: process.env.NODE_ENV,
      }),
      traceExporter: new OTLPTraceExporter(collectorOptions),
      instrumentations: [getNodeAutoInstrumentations()]
   });

   sdk.start()
}
