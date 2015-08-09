package alkindi;

using Lambda;
import alkindi.Maybe;

import haxe.macro.Expr;
import haxe.macro.Context;

class Fxp {
    public static inline function id<T>(t:T):T return t;

    public static inline function
    compose<A,B,C> (f:B->C, g:A->B): A->C
        return function(v:A) return f(g(v));

    public static inline function
    where<T> (f:T->Bool, a:Iterable<T>):Maybe<T>
        return Maybe.of(a.find(f));

    public static inline function
    last<T> (array:Array<T>):Maybe<T>
        return (array.length > 0
            ? Maybe.of(array[array.length - 1])
            : Maybe.of());

    public static inline function
    thisMap<A,B> (it:Array<A>, f:Array<A>->A->B): Array<B>
        return [for (x in it) f(it, x)];

    public static inline function
    equals<T> (a:T, b:T): Bool
        return a == b;

    public static inline function
    waterfall<A,B> (array:Array<A>, fn:B->A->B, initial:B): Array<B>
        return array.map(function(x) {
            return (initial = fn(initial, x));
        });

    public static inline function
    not<T> (f:T->Bool): T->Bool
        return function(x:T)
            return !f(x);

    public static macro function
    arity (f:Expr):ExprOf<Null<Int>> {
        var fType = Context.typeof(f);
        if (Reflect.hasField(fType, 'args')) {
            var fArgs:Array<Dynamic> = Reflect.field(fType, 'args');
            return macro $v{fArgs[0].length};
        } else {
            return macro null;
        }
    }
}
