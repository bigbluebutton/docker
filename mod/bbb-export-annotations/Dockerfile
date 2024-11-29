FROM node:18-bullseye-slim AS builder

COPY --from=bigbluebutton /bbb-export-annotations /bbb-export-annotations
RUN cd /bbb-export-annotations && npm ci && npm install

# --------------------

FROM node:18-bullseye-slim

#depends on;
#Depends: nodejs,npm,bbb-apps-akka,bbb-web,cairosvg,ghostscript,imagemagick, nodejs (>= 18), nodejs (<< 20)
#see repo https://ubuntu.bigbluebutton.org/focal-270/ bigbluebutton-focal main
#apt info bbb-export-annotations
#missing dependency: poppler-utils for pdftocairo bin -> covert background / original presentation to png
RUN apt update && apt install -y \
    nodejs npm cairosvg ghostscript imagemagick nodejs poppler-utils
#    && useradd --uid 2004 --create-home --user-group bbb-export

COPY --from=builder /bbb-export-annotations /bbb-export-annotations
#we need acces to volume bigbluebutton!
USER root
COPY ./config/settings.json /bbb-export-annotations/config/settings.json
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
