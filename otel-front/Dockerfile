FROM otel/opentelemetry-collector-contrib-dev as base
ARG OTEL_AGENT_CONFIG

COPY ${OTEL_AGENT_CONFIG} /etc/otel-agent-config.yaml

FROM ubuntu:bionic as runtime

COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=base /otelcontribcol /otelcontribcol
COPY --from=base /etc/otel-agent-config.yaml /etc/otel-agent-config.yaml

EXPOSE 4317 4318 6831 8126 14268 55680 55679

USER root

ENTRYPOINT ["/otelcontribcol"]
CMD ["--config", "/etc/otel-agent-config.yaml"]
