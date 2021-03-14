use env_logger;
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};
//use log::{ info, error };
use std::convert::Infallible;
use std::env;
use std::net::SocketAddr;

async fn hello_world(_req: Request<Body>) -> Result<Response<Body>, Infallible> {
    println!("Handling request");
    Ok(Response::new("Hello, World".into()))
}

#[tokio::main]
async fn main() {
    env_logger::init();

    for (key, value) in env::vars() {
        println!("ENV {}: {}", key, value);
    }

    let port = env::var("PORT").unwrap().parse().unwrap();

    println!("Will listen on port {:?}", port);

    let addr = SocketAddr::from(([0, 0, 0, 0], port));

    let make_svc = make_service_fn(|_conn| async { Ok::<_, Infallible>(service_fn(hello_world)) });

    let server = Server::bind(&addr).serve(make_svc);
    println!("Bound");

    // Run this server for... forever!
    if let Err(e) = server.await {
        eprintln!("server error: {}", e);
    }
}
