FROM ghcr.io/imputnet/cobalt:11

# Koyeb automatically sets the PORT environment variable.
# Cobalt respects API_PORT, so we can map Koyeb's PORT to API_PORT before starting.
ENV API_PORT=9000
EXPOSE 9000

# You don't necessarily need a custom CMD for cobalt, but passing the port explicitly ensures it binds correctly.
CMD ["npm", "start"]
