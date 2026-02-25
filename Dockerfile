FROM ghcr.io/imputnet/cobalt:11

# Force update youtubei.js to the absolute latest to fix "Failed to extract signature decipher algorithm"
# We run this in the image's default WORKDIR
RUN npm install youtubei.js@latest

# Koyeb automatically sets the PORT environment variable.
# Cobalt respects API_PORT, so we can map Koyeb's PORT to API_PORT before starting.
ENV API_PORT=9000
ENV COOKIE_PATH=/cookies.json
ENV YOUTUBE_POT=Mnpsd3V2LxNr32fQYIp83f33T3XZs:CgszbVp0d3ZaUUJEiBzyoM3uysAbU-NSIvlA
EXPOSE 9000
COPY cookies.json /cookies.json
# You don't necessarily need a custom CMD for cobalt, but passing the port explicitly ensures it binds correctly.
CMD ["npm", "start"]

