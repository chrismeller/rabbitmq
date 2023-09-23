FROM rabbitmq:3.12.6-management-alpine AS base
LABEL maintainer="https://github.com/chrismeller"

FROM base AS build

ARG TEMP_INSTALL="curl jq"
RUN apk add --no-cache ${TEMP_INSTALL}

# download the latest version of the delayed message exchange plugin
RUN curl -sSL https://api.github.com/repos/rabbitmq/rabbitmq-delayed-message-exchange/releases/latest | jq '.assets[0].browser_download_url' | xargs -n 1 curl -sSLO --output-dir /tmp

FROM base AS release

COPY --from=build /tmp/*.ez $RABBITMQ_HOME/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange rabbitmq_consistent_hash_exchange rabbitmq_prometheus rabbitmq_shovel rabbitmq_shovel_management
