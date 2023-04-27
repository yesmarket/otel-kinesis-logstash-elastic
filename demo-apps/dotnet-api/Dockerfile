FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

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

EXPOSE 5002

#RUN useradd -m -s /bin/bash da

COPY --from=build /opt/dotnet-api/ /opt/dotnet-api/
COPY --from=build /opt/dotnet-api/appsettings*.json $CONFIG_DIR

#USER da
USER root

WORKDIR /opt/dotnet-api

ENTRYPOINT ["dotnet", "dotnet-api.dll"]
