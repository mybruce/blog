# 依赖安装阶段
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm install

# 构建阶段
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# 运行阶段
FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/out ./out
COPY --from=deps /app/node_modules/serve ./node_modules/serve

EXPOSE 80

CMD ["node", "node_modules/serve/build/main.js", "-s", "out", "-l", "80"]