FROM nginx:1.19-alpine

COPY ./docs/.vuepress/dist /usr/share/nginx/html
