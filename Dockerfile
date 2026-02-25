FROM ghcr.io/imputnet/cobalt:11

# Force update youtubei.js to fix signature decipher error
# We install in a separate directory to avoid "workspace:" protocol errors from the monorepo
RUN mkdir -p /tmp/patch && cd /tmp/patch && npm init -y && npm install youtubei.js@latest --no-save

# Inject the updated library into the Cobalt app
# We use a wildcard search to find the correct node_modules location
RUN YJS_TARGET=$(find /home/node/app -name youtubei.js -type d | head -n 1) && \
    if [ -n "$YJS_TARGET" ]; then \
    echo "Patching youtubei.js at $YJS_TARGET"; \
    cp -rf /tmp/patch/node_modules/youtubei.js/. "$YJS_TARGET/"; \
    else \
    echo "Warning: youtubei.js not found in /home/node/app"; \
    fi

# Koyeb automatically sets the PORT environment variable.
ENV API_PORT=9000
ENV COOKIE_PATH=/cookies.json
# Using the FULL non-truncated PO Token
ENV YOUTUBE_POT=MnjO-io973Ojo87G90nspX-Zi8B1FExLoBhuZYMXvJsDrEMViAc9dawaciJtNCh8PLl5YiesnxTWCWoBZEAnzpmNBV5X0KRvoYUKrkpkR6EI283SixKqnV240jzUr_MqZw12SMXSXm3h8cLxNr32fQYIp83f33T3XZs=:CgszbVp0d3ZaUUJESSiilvvMBjIKCgJMSxIEGgAgFw%3D%3D
EXPOSE 9000
COPY cookies.json /cookies.json
CMD ["npm", "start"]

