ARG KEYCLOAK_VERSION

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure postgres database vendor
ENV KC_DB=postgres

ENV KC_FEATURES="token-exchange,scripts,preview"

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION
COPY --from=builder /opt/keycloak/ /opt/keycloak/

LABEL image.version=$KEYCLOAK_VERSION

RUN /opt/keycloak/bin/kc.sh show-config

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]