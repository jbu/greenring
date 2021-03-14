FROM rust as builder
WORKDIR /usr/src/greenring
COPY . .
RUN cargo build --release

FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir /app
WORKDIR /app
ENV PORT=8080 RUST_LOG=info RUST_BACKTRACE=1
EXPOSE ${PORT}
COPY --from=builder /usr/src/greenring/target/release/greenring /app/greenring
CMD ["/app/greenring"]
