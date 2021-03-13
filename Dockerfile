FROM rust as builder
WORKDIR /usr/src/greenring
COPY . .
RUN cargo install --path .

FROM alpine
RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/greenring /usr/local/bin/greenring
CMD ["greenring"]
