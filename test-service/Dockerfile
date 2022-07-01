FROM alpine:3.10 AS tracer

WORKDIR /tmp

RUN apk --update add wget unzip
RUN wget https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v0.1.0-beta.1/opentelemetry-dotnet-instrumentation-linux-glibc.zip
RUN unzip -q opentelemetry-dotnet-instrumentation-linux-glibc.zip
RUN rm opentelemetry-dotnet-instrumentation-linux-glibc.zip

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /tmp

COPY ./*.sln ./*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p ${file%.*}/ && mv $file ${file%.*}/; done

COPY ./nuget.docker.config ./NuGet.Config
RUN dotnet restore ./TestService.WebApi/TestService.WebApi.csproj

COPY . ./

RUN dotnet publish ./TestService.WebApi/TestService.WebApi.csproj -c Release --self-contained false -o /opt/TestService.WebApi

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

ARG CONFIG_DIR=/etc/opt/TestService.WebApi/
ENV ASPNETCORE_URLS=http://*:5001
ENV CONFIG_DIR $CONFIG_DIR

EXPOSE 5001

COPY --from=build /opt/TestService.WebApi/ /opt/TestService.WebApi/
COPY --from=build /opt/TestService.WebApi/appsettings*.json $CONFIG_DIR

RUN mkdir -p /opt/opentelemetry && \
    mkdir -p /var/log/opentelemetry/dotnet && \
    chmod a+rwx /var/log/opentelemetry/dotnet

COPY --from=tracer /tmp/ /opt/opentelemetry/

ENV CORECLR_ENABLE_PROFILING=1 \
    CORECLR_PROFILER={918728DD-259F-4A6A-AC2B-B85E1B658318} \
    CORECLR_PROFILER_PATH=/opt/opentelemetry/OpenTelemetry.AutoInstrumentation.Native.so \
    DOTNET_ADDITIONAL_DEPS=/opt/opentelemetry/AdditionalDeps \
    DOTNET_SHARED_STORE=/opt/opentelemetry/store \
    DOTNET_STARTUP_HOOKS=/opt/opentelemetry/netcoreapp3.1/OpenTelemetry.AutoInstrumentation.StartupHook.dll \
    OTEL_DOTNET_AUTO_HOME=/opt/opentelemetry \
    OTEL_DOTNET_AUTO_INTEGRATIONS_FILE=/opt/opentelemetry/integrations.json \
    OTEL_SERVICE_NAME=test \
    OTEL_DOTNET_AUTO_TRACES_ENABLED_INSTRUMENTATIONS=AspNet,HttpClient,SqlClient \
    OTEL_DOTNET_AUTO_METRICS_ENABLED_INSTRUMENTATIONS=AspNet,HttpClient,NetRuntime \
    OTEL_DOTNET_AUTO_DEBUG=true \
    OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true \
    OTEL_DOTNET_AUTO_METRICS_CONSOLE_EXPORTER_ENABLED=true \
    OTEL_EXPORTER=otlp \
    OTEL_EXPORTER_OTLP_ENDPOINT=http://otel:4318 \
    OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf

WORKDIR /opt/TestService.WebApi

ENTRYPOINT ["dotnet", "TestService.WebApi.dll"]
