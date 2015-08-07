package alkindi;

using Lambda;

class Fxp {
    public static inline function id<T>(t:T):T return t;

    public static inline function
    compose<A,B,C> (f:B->C, g:A->B): A->C
        return function(v:A) return f(g(v));

    public static inline function
    where<T>(f:T->Bool, a:Array<T>):Maybe<T>
        return Maybe.of(a.find(f));

    public static inline function last<T>(array:Array<T>):Maybe<T>
        return (array.length > 0
            ? Maybe.of(array[array.length - 1])
            : Maybe.of());

    public static inline function prop<T,U>(field:String, object:T):U
        return Reflect.field(object, field);
}

class Maybe<T> {
    private var value:T;

    public static inline function of<T>(v:T = null)
        return new Maybe<T>(v);

    public inline function new(v:T)
        value = v;

    public inline function isNothing():Bool
        return value == null;

    public inline function map<U>(f:T->U):Maybe<U>
        return isNothing() ? Maybe.of() : Maybe.of(f(value));

    public inline function chain<U>(f:T->Maybe<U>):Maybe<U>
        return isNothing() ? Maybe.of() : f(value);

    public inline function maybe<U>(a:U, f:T->U):U
        return isNothing() ? a : f(value);
}

