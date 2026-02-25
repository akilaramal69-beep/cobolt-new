FROM ghcr.io/imputnet/cobalt:latest

# Install git (required for fetching edge version of youtubei.js from GitHub)
# Use root to install system packages, then switch back to node if needed
# (Assuming Debian-based image which is common for cobalt)
USER root
RUN apt-get update && apt-get install -y git || apk add --no-cache git

# Force update youtubei.js to fix signature decipher error
# We use the EDGE version directly from GitHub as it often has the latest decipher fixes
RUN mkdir -p /tmp/patch && cd /tmp/patch && npm init -y && \
    npm install github:LuanRT/YouTube.js#main --no-save

# Inject the updated library into EVERY node_modules/youtubei.js directory found
RUN find /home/node/app -name youtubei.js -type d -exec echo "Patching: {}" \; -exec cp -rf /tmp/patch/node_modules/youtubei.js/. {}/ \;

# Koyeb automatically sets the PORT environment variable.
ENV API_PORT=9000
ENV COOKIE_PATH=/cookies.json
# Using the FULL non-truncated PO Token
ENV YOUTUBE_POT=MnjO-io973Ojo87G90nspX-Zi8B1FExLoBhuZYMXvJsDrEMViAc9dawaciJtNCh8PLl5YiesnxTWCWoBZEAnzpmNBV5X0KRvoYUKrkpkR6EI283SixKqnV240jzUr_MqZw12SMXSXm3h8cLxNr32fQYIp83f33T3XZs=:CgszbVp0d3ZaUUJESSiilvvMBjIKCgJMSxIEGgAgFw%3D%3D
EXPOSE 9000
COPY cookies.json /cookies.json
CMD ["npm", "start"]

