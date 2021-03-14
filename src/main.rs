#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;

use askama::Template;

#[derive(Template)]
#[template(path = "index.html")]
struct HelloTemplate<'a> {
    name: &'a str,
}

#[get("/")]
fn index() -> String {
    let hello = HelloTemplate { name: "world" };
    return format!("{}", hello.render().unwrap());
}

fn main() {
    rocket::ignite().mount("/", routes![index]).launch();
}
