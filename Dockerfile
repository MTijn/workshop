FROM nginx:1.17.8-alpine

COPY ./docs/.vuepress/dist /usr/share/nginx/html