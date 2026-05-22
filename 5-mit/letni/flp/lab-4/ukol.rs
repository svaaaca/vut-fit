// UKOL 2: Za ??? doplnte vhodny kod, aby program vytiskl vypis v komentarich.

fn sum_i32(a: i32, b: i32) -> i32 {
    a + b
}

fn add_to_first(a: &mut i32, b: i32) {
    *a += b;
}

fn swap_i32(a: &mut i32, b: &mut i32) {
    let tmp = *a;
    *a = *b;
    *b = tmp;
}

fn main() {
    let mut a: i32 = 4;
    let mut b: i32 = 7;

    add_to_first(&mut a, b);
    swap_i32(&mut a, &mut b);
    println!("{}", sum_i32(a, b));  // 18
    println!("a={a} b={b}");       // a=7 b=11
}