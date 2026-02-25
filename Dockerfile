FROM ghcr.io/imputnet/cobalt:latest

# Install git (required for fetching edge version of youtubei.js from GitHub)
# Use root to install system packages, then switch back to node if needed
# (Assuming Debian-based image which is common for cobalt)
USER root
RUN apt-get update && apt-get install -y git || apk add --no-cache git

# Force update youtubei.js to fix signature decipher error
# Use a temporary directory to install the edge version and its new dependencies (like meriyah)
# This completely bypasses the PNPM workspace errors
WORKDIR /tmp/patch
# We need to install undici explicitly because youtubei.js edge might rely on newest peer deps
RUN npm init -y && npm install github:LuanRT/YouTube.js#main undici meriyah --no-save

# Copy the completely updated modules directly into the Cobalt app's node_modules
# The /app directory is the root of the production build in the new image
RUN cp -rf /tmp/patch/node_modules/youtubei.js /app/node_modules/ && \
    cp -rf /tmp/patch/node_modules/meriyah /app/node_modules/ 2>/dev/null || true

WORKDIR /app

# Koyeb automatically sets the PORT environment variable.
ENV API_PORT=9000
ENV COOKIE_PATH=/cookies.json
# Using the FULL non-truncated PO Token
ENV YOUTUBE_POT=MnjO-io973Ojo87G90nspX-Zi8B1FExLoBhuZYMXvJsDrEMViAc9dawaciJtNCh8PLl5YiesnxTWCWoBZEAnzpmNBV5X0KRvoYUKrkpkR6EI283SixKqnV240jzUr_MqZw12SMXSXm3h8cLxNr32fQYIp83f33T3XZs=:CgszbVp0d3ZaUUJESSiilvvMBjIKCgJMSxIEGgAgFw%3D%3D
EXPOSE 9000
COPY cookies.json /cookies.json
CMD ["npm", "start"]

