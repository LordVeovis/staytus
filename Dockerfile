FROM ruby:2.7-alpine
LABEL maintainer="Veovis <veovis@kveer.fr>"

COPY . /opt/staytus

RUN set -xe; \
    cd /opt/staytus; \
    apk add --no-cache mariadb-connector-c nodejs tzdata openssl; \
    apk add --no-cache --virtual=_build alpine-sdk mariadb-dev shared-mime-info; \
    bundle update --bundler --conservative mimemagic; \
    #bundle update --bundler; \
    bundle config set without 'development:test'; \
    bundle install; \
    apk del _build

# Persists copies of other relevant files (DB config, custom themes). Contents of this are copied 
# to the relevant places each time the container is started
VOLUME /opt/staytus/persisted

WORKDIR /opt/staytus
EXPOSE 5000
ENTRYPOINT [ "/opt/staytus/docker-start.sh" ]
CMD bundle exec foreman start