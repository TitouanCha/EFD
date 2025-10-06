FROM node:22-alpine AS tsc-builder
WORKDIR /workspace
COPY . /workspace
RUN npm install
RUN npm run build

FROM node:22-alpine
WORKDIR /workspace
COPY package*.json /workspace/
RUN npm install --production
COPY --from=tsc-builder /workspace/dist /workspace/dist
EXPOSE $PORT
CMD ["npm", "start"]
