FROM rabbitmq:3.9.16-management-alpine AS base
LABEL maintainer="https://github.com/chrismeller"

FROM base AS build

ARG TEMP_INSTALL="curl"
RUN apk add --no-cache ${TEMP_INSTALL}

ARG DELAYED_MESSAGE_EXCHANGE_VERSION="3.9.0"
RUN curl -L https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/${DELAYED_MESSAGE_EXCHANGE_VERSION}/rabbitmq_delayed_message_exchange-${DELAYED_MESSAGE_EXCHANGE_VERSION}.ez > /tmp/rabbitmq_delayed_message_exchange-${DELAYED_MESSAGE_EXCHANGE_VERSION}.ez

FROM base AS release

COPY --from=build /tmp/*.ez $RABBITMQ_HOME/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange rabbitmq_consistent_hash_exchange rabbitmq_prometheus rabbitmq_shovel rabbitmq_shovel_management
