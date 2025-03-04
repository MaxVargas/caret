
Even though `(fmap return) (return x) = (return (return x))` for `x :: a` (this can be shown through the naturality property on `return` c.f. [[Applicatives]]), it isn't necessarily true that `fmap return = return`. Look at the monoid `[]`. It can be shown that `return [x1, ..., xn] = [[x1, ..., xn]]`, while `(fmap return) [x1, ..., xn] = [[x1], ..., [xn]]`.
