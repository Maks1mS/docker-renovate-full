# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=34.108.5

# Base image
#============
FROM simaofsilva/containerbase-buildpack:5.10.2@sha256:99bfb817b1eda9974c7cb00ba735000af84ddb59dba1b49bb95861af2b9571eb AS base

# renovate: datasource=github-tags depName=nodejs/node
RUN install-tool node v19.4.0

# renovate: datasource=npm depName=yarn versioning=npm
RUN install-tool yarn 1.22.19

WORKDIR /usr/src/app

# renovate: datasource=docker versioning=docker
RUN install-tool docker 20.10.23

# renovate: datasource=adoptium-java
RUN install-tool java 17.0.6+10

# renovate: datasource=gradle-version versioning=gradle
RUN install-tool gradle 7.6

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.14.3

# # renovate: datasource=github-releases lookupName=containerbase/php-prebuild
# RUN install-tool php 8.2.1

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.5.1

# renovate: datasource=golang-version
RUN install-tool golang 1.19.5

# # renovate: datasource=github-releases lookupName=containerbase/python-prebuild
# RUN install-tool python 3.11.1

# renovate: datasource=pypi
RUN install-pip pipenv 2022.12.19

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.3.2

# renovate: datasource=pypi
RUN install-pip hashin 0.17.0

# renovate: datasource=pypi
RUN install-pip pip-tools 6.12.1

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.66.1

# # renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
# RUN install-tool ruby 3.2.0

# renovate: datasource=rubygems versioning=ruby
RUN install-tool bundler 2.4.5

# renovate: datasource=rubygems versioning=ruby
RUN install-tool cocoapods 1.11.3

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 6.0.405

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 7.25.0

# renovate: datasource=npm versioning=npm
RUN install-npm lerna 6.4.1

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.11.0

# renovate: datasource=github-releases lookupName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

COPY bin/ /usr/local/bin/
CMD ["renovate"]

ARG RENOVATE_VERSION

RUN apt update && \
    apt install -y --no-install-recommends python3 make g++ && \
    install-tool renovate && \
    apt autoremove -y python3 make g++ && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /usr/share/doc /usr/share/man

# Compabillity, so `config.js` can access renovate and deps
RUN ln -sf /opt/buildpack/tools/renovate/${RENOVATE_VERSION}/node_modules ./node_modules;

RUN set -ex; \
  renovate --version; \
  renovate-config-validator; \
  node -e "new require('re2')('.*').exec('test')"; \
  true

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
