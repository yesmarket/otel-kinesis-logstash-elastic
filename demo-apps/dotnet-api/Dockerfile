FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

ARG OTEL_VERSION=0.7.0

ADD https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v${OTEL_VERSION}/otel-dotnet-auto-install.sh otel-dotnet-auto-install.sh
RUN apt-get update && apt-get install -y unzip apt-utils curl && \
    OTEL_DOTNET_AUTO_HOME="/otel-dotnet-auto" sh otel-dotnet-auto-install.sh

WORKDIR /tmp

COPY ./*.sln ./*.csproj ./

COPY ./nuget.docker.config ./NuGet.Config
RUN dotnet restore ./dotnet-api.csproj

COPY . ./

RUN dotnet publish ./dotnet-api.csproj -c Release --self-contained false -o /opt/dotnet-api

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

ARG CONFIG_DIR=/etc/opt/dotnet-api/
ENV ASPNETCORE_URLS=http://*:5002
ENV CONFIG_DIR $CONFIG_DIR
ENV CORECLR_ENABLE_PROFILING="1"
ENV CORECLR_PROFILER='{918728DD-259F-4A6A-AC2B-B85E1B658318}'
ENV CORECLR_PROFILER_PATH="/otel-dotnet-auto/linux-x64/OpenTelemetry.AutoInstrumentation.Native.so"
ENV DOTNET_ADDITIONAL_DEPS="/otel-dotnet-auto/AdditionalDeps"
ENV DOTNET_SHARED_STORE="/otel-dotnet-auto/store"
ENV DOTNET_STARTUP_HOOKS="/otel-dotnet-auto/net/OpenTelemetry.AutoInstrumentation.StartupHook.dll"
ENV OTEL_DOTNET_AUTO_HOME="/otel-dotnet-auto"

# RUN useradd -m -s /bin/bash da

COPY --from=build /opt/dotnet-api/ /opt/dotnet-api/
COPY --from=build /opt/dotnet-api/appsettings*.json $CONFIG_DIR
COPY --from=build $OTEL_DOTNET_AUTO_HOME $OTEL_DOTNET_AUTO_HOME

# USER da
USER root

WORKDIR /opt/dotnet-api

EXPOSE 5002

ENTRYPOINT ["dotnet", "dotnet-api.dll"]
