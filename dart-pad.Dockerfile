FROM dart:2.14.4

# install nodejs
RUN apt-get update && \
  apt-get install -y unzip protobuf-compiler && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update -y
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# install vulcanize
RUN npm i -g vulcanize


RUN groupadd --system dart && \
  useradd --no-log-init --system --home /home/dart --create-home -g dart dart

# Work around https://github.com/dart-lang/sdk/issues/47093
RUN find /usr/lib/dart -type d -exec chmod 755 {} \;

COPY . /dart-pad
RUN chown -R dart:dart /dart-pad
RUN chmod a+x /dart-pad/dart-pad_run.sh

USER dart

# install the dependence
WORKDIR /dart-pad
RUN dart pub get
RUN export PATH="$PATH":"$HOME/.pub-cache/bin"

# install grinder globally
RUN dart pub global activate grinder
RUN pub global activate protoc_plugin
RUN dart pub get
#RUN grind serve serveLocalBackend
ENTRYPOINT ["/dart-pad/dart-pad_run.sh"]

