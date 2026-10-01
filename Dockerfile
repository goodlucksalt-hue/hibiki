FROM node:22-alpine AS build
RUN corepack enable
WORKDIR /app
COPY source.tar.gz /tmp/source.tar.gz
RUN tar -xzf /tmp/source.tar.gz -C /app
RUN pnpm install --frozen-lockfile --ignore-scripts
ENV RAILWAY_BUILD=1
RUN pnpm run build:railway

FROM node:22-alpine
RUN corepack enable
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=build /app /app
EXPOSE 3000
CMD ["sh", "-c", "pnpm run start:railway"]
