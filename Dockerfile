FROM rabbitmq:3.10.0-management-alpine AS base
LABEL maintainer="https://github.com/chrismeller"

ARG TEMP_INSTALL="curl"
FROM base AS build

RUN apk add --no-cache ${TEMP_INSTALL}
RUN curl -L https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.9.0/rabbitmq_delayed_message_exchange-3.9.0.ez > /tmp/rabbitmq_delayed_message_exchange-3.9.0.ez

FROM base AS release

COPY --from=build /tmp/rabbitmq_delayed_message_exchange-3.9.0.ez $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.9.0.ez
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange rabbitmq_consistent_hash_exchange rabbitmq_prometheus