trait Recommendable {
    fn title(&self) -> &str;
    fn score(&self) -> u32;
}

#[derive(Debug)]
struct Movie {
    title: String,
    rating: u32,
}

#[derive(Debug)]
struct Course {
    title: String,
    students: u32,
}

impl Recommendable for Movie {
    fn title(&self) -> &str {
        &self.title
    }

    fn score(&self) -> u32 {
        self.rating
    }
}

impl Recommendable for Course {
    fn title(&self) -> &str {
        &self.title
    }

    fn score(&self) -> u32 {
        self.students
    }
}

fn better_of<'a, T: Recommendable>(a: &'a T, b: &'a T) -> &'a T {
    // Vratte lepsi z dvojice podle score().
    // Pokud jsou score stejna, vratte a.

    if a.score() >= b.score() {
        a
    } else {
        b
    }
}

fn best_in<'a, T: Recommendable>(items: &'a [T]) -> Option<&'a T> {
    // Najdete nejlepsi polozku v celem poli / slice.
    // Pouzijte iterator a postupne porovnavani pres better_of().
    // Pokud je kolekce prazdna, vratte None.

    let mut iter = items.iter();
    let mut best = iter.next()?;

    for item in iter {
        best = better_of(best, item);
    }

    Some(best)
}

fn main() {
    // ---------------------------------
    // Use-case 1: doporuceni filmu
    // ---------------------------------
    let m1 = Movie {
        title: String::from("Inception"),
        rating: 90,
    };

    let m2 = Movie {
        title: String::from("Avatar"),
        rating: 75,
    };

    let m3 = Movie {
        title: String::from("Interstellar"),
        rating: 95,
    };

    // Nejprve test pouze na better_of()
    let better_movie = better_of(&m1, &m2);
    println!("better movie = {} ({})", better_movie.title(), better_movie.score());
    assert_eq!(better_movie.title(), "Inception");
    assert_eq!(better_movie.score(), 90);

    let movies = vec![m1, m2, m3];

    let best_movie = best_in(&movies).unwrap();
    println!("best movie = {} ({})", best_movie.title(), best_movie.score());
    assert_eq!(best_movie.title(), "Interstellar");
    assert_eq!(best_movie.score(), 95);

    // ---------------------------------
    // Use-case 2: doporuceni kurzu
    // ---------------------------------
    let c1 = Course {
        title: String::from("Rust Basics"),
        students: 120,
    };

    let c2 = Course {
        title: String::from("Advanced Rust"),
        students: 80,
    };

    let c3 = Course {
        title: String::from("Parallel Rust"),
        students: 150,
    };

    // Nejprve test pouze na better_of()
    let better_course = better_of(&c1, &c2);
    println!("better course = {} ({})", better_course.title(), better_course.score());
    assert_eq!(better_course.title(), "Rust Basics");
    assert_eq!(better_course.score(), 120);

    let courses = vec![c1, c2, c3];

    let best_course = best_in(&courses).unwrap();
    println!("best course = {} ({})", best_course.title(), best_course.score());
    assert_eq!(best_course.title(), "Parallel Rust");
    assert_eq!(best_course.score(), 150);

    // ---------------------------------
    // Prazdna kolekce
    // ---------------------------------
    let empty_movies: Vec<Movie> = vec![];
    assert!(best_in(&empty_movies).is_none());

    println!("Vsechny testy prosly.");
}
