FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY backend/ ./backend/
WORKDIR /src/backend
RUN dotnet restore src/Api/FamilyVeda.Api.csproj
RUN dotnet publish src/Api/FamilyVeda.Api.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
RUN apt-get update \
    && apt-get install -y --no-install-recommends tesseract-ocr tesseract-ocr-eng \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app/publish .
RUN mkdir -p /app/storage/lab-reports /app/keys && chown -R app:app /app
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENV Ocr__TesseractDataPath=/usr/share/tesseract-ocr/5/tessdata
EXPOSE 8080
USER app
ENTRYPOINT ["dotnet", "FamilyVeda.Api.dll"]
