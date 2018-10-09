extern crate libc;

#[no_mangle]
pub extern "C" fn elixir_package_extension_start() -> i64 {
    1
}

#[no_mangle]
pub extern "C" fn elixir_package_extension_stop() -> i64 {
    2
}
