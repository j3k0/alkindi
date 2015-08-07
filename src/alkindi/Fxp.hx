package alkindi;

using Lambda;
import alkindi.Maybe;

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

    public static function thisMap<A,B>(it:Array<A>, f:Array<A>->A->B): Array<B>
		return [for (x in it) f(it, x)];
}
