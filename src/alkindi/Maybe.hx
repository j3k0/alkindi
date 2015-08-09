package alkindi;

import alkindi.Fxp;

class Maybe<T> {
    private var value:T;

    public static inline function
    of<T> (v:T = null)
        return new Maybe<T>(v);

    public static inline function
    arrayOf<T> (a:Array<T>): Array<Maybe<T>>
        return a.map(Maybe.of);

    public inline function new(v:T)
        value = v;

    public inline function isNothing():Bool
        return value == null;

    public inline function maybe<U>(a:U, f:T->U):U
        return isNothing() ? a : f(value);

    public inline function map<U>(f:T->U):Maybe<U>
        return isNothing() ? Maybe.of() : Maybe.of(f(value));

    public inline function chain<U>(f:T->Maybe<U>):Maybe<U>
        return isNothing() ? Maybe.of() : f(value);
}
