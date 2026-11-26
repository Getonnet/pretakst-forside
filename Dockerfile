# Production image. Replaces the Nixpacks build on Coolify: same build step (tools/build.js,
# which only uses Node's own modules) and the same start command (tools/serve.js).
FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production PORT=3000
COPY package.json package-lock.json ./
# Only nodemailer is needed at runtime; puppeteer-core and sharp are for local screenshots/resizing.
RUN npm ci --omit=dev --no-audit --no-fund
COPY . .
RUN node tools/build.js
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://127.0.0.1:3000/health >/dev/null || exit 1
CMD ["node", "tools/serve.js"]
