extern crate libc;

#[no_mangle]
pub extern "C" fn elixir_package_extension_start() -> *const u8 {
    "Hello, world!\0".as_ptr()
}

#[no_mangle]
pub extern "C" fn elixir_package_extension_stop() -> *const u8 {
    "Bye, world!\0".as_ptr()
}
