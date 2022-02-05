use std::ffi::CStr;
use std::os::raw::c_char;
use std::io::Read;

#[no_mangle]
pub unsafe extern "C" fn uses_ecosystem(bytes: *const c_char, len_bytes: usize, target: *const c_char) -> bool {
    let buf = std::slice::from_raw_parts(bytes as *const u8, len_bytes);
    let target = CStr::from_ptr(target);
    let target = target.to_string_lossy();
    let mut read = buf;
    parse_msgpack_pattern(&mut read, &*target).unwrap()
}

pub fn parse_msgpack_pattern(mut input: &mut dyn Read, target: &str) -> Result<bool, anyhow::Error> {
    let len = rmp::decode::read_str_len(&mut input)?;
    let mut buf = vec![0u8; len as usize];
    let pattern = rmp::decode::read_str(
        &mut input,
        &mut buf
    ).map_err(|err| anyhow::Error::msg(format!("{}", err)))?.to_owned();
    cfg_if::cfg_if! {
        if #[cfg(feature = "regex-rust")] {
            let pattern = regex::Regex::new(&pattern)?;
            Ok(pattern.is_match(target))
        } else if #[cfg(feature = "regex-onig")] {
            let pattern = onig::Regex::new(&pattern)?;
            Ok(pattern.is_match(target))
        } else {
            compile_error!("Unknown regex backend")
        }
    }
}
