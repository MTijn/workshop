FROM nginx:1.19.7-alpine

COPY ./docs/.vuepress/dist /usr/share/nginx/html
