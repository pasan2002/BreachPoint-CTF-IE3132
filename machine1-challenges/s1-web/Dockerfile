FROM nginx:alpine

# Install ONLY exiftool (no buggy imagemagick dependencies)
RUN apk add --no-cache exiftool

COPY html/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf

# Step 1: Strip ALL existing metadata using exiftool (no convert needed)
RUN exiftool -all= -overwrite_original /usr/share/nginx/html/novatech_logo.png

# Step 2: Embed the flag into the clean file
RUN exiftool -overwrite_original \
    -Artist="m4st3r}" \
    -ImageDescription="NovaTech Corp Official Logo" \
    /usr/share/nginx/html/novatech_logo.png

EXPOSE 80