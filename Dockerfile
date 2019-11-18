FROM swift:5.1 as builder

WORKDIR /app
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libssl-dev \
    libopus-dev \
    libsodium-dev \
    && rm -r /var/lib/apt/lists/*
COPY Package.swift Package.resolved ./
RUN swift package resolve
COPY Tests ./Tests
COPY Sources ./Sources
RUN swift build -c release

FROM swift:5.1-slim
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libopus0 \
    libsodium23 \
    && rm -r /var/lib/apt/lists/*
COPY --from=builder /app/.build/release/discord-timecard-bot /app/
CMD ["/app/discord-timecard-bot"]
