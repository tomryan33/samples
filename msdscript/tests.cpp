//
// Created by ryanc on 2/1/2022.
//

#include "expr.h"
#include "catch.h"
#include "parse.h"
#include "val.h"
#include "env.h"
#include <sstream>

using namespace std;

string test_print(PTR(Expr) ex);
string test_pp(PTR(Expr) ex);
static PTR(Expr) test_parse(const char *string);

// TESTS
TEST_CASE("NumExpr"){
    PTR(Expr) num1 = NEW(NumExpr)(1);
    PTR(Expr) num2 = NEW(NumExpr)(2);
    CHECK( num1->equals(num1) == true );
    CHECK( num1->equals(num2) == false );
    CHECK(num1->equals(NEW(VarExpr)("Hello")) == false);

    CHECK( num1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(1) ) == true );
    CHECK( num2->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(1) ) == false );

    //CHECK( num1->subst("x", NEW(NumExpr)(3) )->equals( NEW(NumExpr)(1) ) );

    CHECK( num1->to_string() == "1");
}

TEST_CASE("BoolExpr"){
    PTR(Expr) bool1 = NEW(BoolExpr)("_true");
    PTR(Expr) bool2 = NEW(BoolExpr)("_false");
    CHECK(bool1->equals(bool1) == true);
    CHECK(bool1->equals(bool2) == false);
    CHECK(bool1->equals( NEW(NumExpr)(1) ) == false);

    CHECK(bool1->interp(EmptyEnv::empty_)->equals( NEW(BoolVal)("_true") ) == true);
    CHECK(bool2->interp(EmptyEnv::empty_)->equals( NEW(BoolVal)("_true") ) == false);
    PTR(Expr) addBool = NEW(AddExpr)( NEW(NumExpr)(3), NEW(BoolExpr)("_true") );
    CHECK_THROWS_WITH( addBool->interp(EmptyEnv::empty_), "add of non-number" );

    //CHECK(bool1->subst( "x", NEW(BoolExpr)("_false") )->equals( NEW(BoolExpr)("_true") ) );

    CHECK( bool1->to_string() == "_true" );

    CHECK_THROWS_WITH(test_parse("_true+_true")->interp(EmptyEnv::empty_), "Cannot add a boolean.");
    CHECK_THROWS_WITH(test_parse("_true*_true")->interp(EmptyEnv::empty_), "Cannot multiply a boolean.");
}

TEST_CASE("EqualsExpr"){
    PTR(Expr) equal1 = NEW(EqualExpr)( NEW(NumExpr)(1), NEW(NumExpr)(1) ); // 1 == 1
    PTR(Expr) equal2 = NEW(EqualExpr)( NEW(NumExpr)(1), NEW(NumExpr)(2) ); // 1 == 2
    PTR(Expr) equal3 = NEW(EqualExpr)( NEW(BoolExpr)("_true"), NEW(NumExpr)(3) ); // _true == 3
    CHECK( equal1->equals(equal1) == true );
    CHECK( equal1->equals(equal2) == false );
    CHECK( equal1->equals( NEW(AddExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2) ) ) == false );

    CHECK( equal1->interp(EmptyEnv::empty_)->equals( NEW(BoolVal)("_true") ) );
    CHECK( equal2->interp(EmptyEnv::empty_)->equals( NEW(BoolVal)("_false") ) );
    CHECK( equal3->interp(EmptyEnv::empty_)->equals( NEW(BoolVal)("_false") ) );
    CHECK( equal2->interp(EmptyEnv::empty_)->equals( NEW(BoolVal)("_true") ) == false );


}

TEST_CASE("AddExpr"){
    PTR(Expr) add1 = NEW(AddExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2) );  // 1 + 2
    PTR(Expr) add2 = NEW(AddExpr)(NEW(NumExpr)(2), NEW(NumExpr)(3) );  // 2 + 3
    CHECK( add1->equals(add1) == true );
    CHECK( add1->equals(add2) == false );
    CHECK(add1->equals(NEW(MultExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2))) == false);

    CHECK( add1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(3) ) );
    CHECK( add2->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(3) ) == false );

    PTR(Expr) add3 = NEW(AddExpr)(NEW(NumExpr)(1), NEW(VarExpr)("haha"));  // 1 + haha

    //CHECK( add3->subst("haha", NEW(VarExpr)("lol"))->equals(NEW(AddExpr)(NEW(NumExpr)(1), NEW(VarExpr)("lol"))) );
    //CHECK( add1->subst("x", NEW(VarExpr)("y"))->equals(NEW(AddExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2))) );

    CHECK( add1->to_string() == "(1+2)" );
    CHECK( add2->to_string() != "2+3" );
}

TEST_CASE("Multi"){
    PTR(Expr) mult1 = NEW(MultExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2) );  // 1 * 2
    PTR(Expr) mult2 = NEW(MultExpr)(NEW(NumExpr)(2), NEW(NumExpr)(3) );  // 2 * 3
    CHECK( mult1->equals(mult1) == true );
    CHECK( mult1->equals(mult2) == false );
    CHECK(mult1->equals(NEW(AddExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2))) == false);

    CHECK( mult1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(2) ) == true );
    CHECK( mult2->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(6) ) == true );
    CHECK( mult2->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(0) ) == false );

    PTR(Expr) mult3 = NEW(MultExpr)(NEW(NumExpr)(1), NEW(VarExpr)("haha") );  // 1 * haha

    //CHECK( mult3->subst("haha", NEW(VarExpr)("lol"))->equals(NEW(MultExpr)(NEW(NumExpr)(1), NEW(VarExpr)("lol"))) );
    //CHECK( mult1->subst("x", NEW(VarExpr)("y"))->equals(NEW(MultExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2))) );

    CHECK( mult1->to_string() == "(1*2)" );
    CHECK( mult3->to_string() == "(1*haha)" );
}

TEST_CASE("CallExpr"){
    PTR(Expr) call1 = NEW(CallExpr)( NEW(FunExpr)("x", NEW(AddExpr)( NEW(VarExpr)("x"), NEW(NumExpr)(1) ) ), NEW(NumExpr)(10) );
    CHECK( call1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(11) ) == true );
}

TEST_CASE("VarExpr"){
    PTR(Expr) var1 = NEW(VarExpr)("Hello");
    PTR(Expr) var2 = NEW(VarExpr)("World");
    CHECK( var1->equals(var1) == true );
    CHECK( var1->equals(var2) == false );
    CHECK(var1->equals(NEW(NumExpr)(1)) == false);

    //CHECK_THROWS_WITH( var1->interp(EmptyEnv::empty_), "Variable cant return an int." );

    //CHECK( var1->subst("Hello", NEW(VarExpr)("Bye"))->equals(NEW(VarExpr)("Bye") ) );
    //CHECK( var2->subst("Hello", NEW(VarExpr)("Oh no"))->equals(NEW(VarExpr)("World") ) );

    CHECK( var1->to_string() == "Hello" );
}

TEST_CASE("LetExpr"){
    PTR(Expr) let1 = NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(3), NEW(AddExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5) ));
    PTR(Expr) let2 = NEW(LetExpr)(NEW(VarExpr)("y"), NEW(NumExpr)(6), NEW(MultExpr)(NEW(VarExpr)("y"), NEW(NumExpr)(9) ));
    PTR(Expr) let3 = NEW(LetExpr)(NEW(VarExpr)("z"), NEW(AddExpr)(NEW(NumExpr)(5), NEW(NumExpr)(2) ), NEW(MultExpr)(NEW(VarExpr)("z"), NEW(NumExpr)(10) ) );
    CHECK( let1->equals(let1) == true );
    CHECK( let1->equals(let2) == false );
    CHECK(let1->equals( NEW(NumExpr)(5) ) == false );

    CHECK( let1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(8) ) == true );
    CHECK( let2->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(54) ) == true );
    CHECK( let3->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(70) ) == true );

    //CHECK( let1->subst("x", NEW(NumExpr)(99) )->equals(let1 ) );
    //CHECK( let2->subst("x", NEW(NumExpr)(50))->equals(let2));
}

TEST_CASE("If-Then-Else"){
    PTR(Expr) if1 = NEW(IfExpr)( NEW(EqualExpr)( NEW(NumExpr)(3), NEW(NumExpr)(3) ), NEW(AddExpr)( NEW(NumExpr)(1), NEW(NumExpr)(2) ), NEW(BoolExpr)("_false") );
    PTR(Expr) if2 = NEW(IfExpr)( NEW(BoolExpr)( "_false" ), NEW(AddExpr)( NEW(NumExpr)(4), NEW(BoolExpr)("_true") ), NEW(NumExpr)(5) );
    CHECK( if1->equals(if1) == true );
    CHECK( if1->equals(if2) == false );
    CHECK( if1->equals( NEW(NumExpr)(0) ) == false );

    CHECK( if1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(3) ) == true );
    CHECK( if2->interp(EmptyEnv::empty_)->to_string() == "5" );

    PTR(Expr) if3 = NEW(IfExpr)( NEW(EqualExpr)( NEW(VarExpr)("x"), NEW(NumExpr)(6) ), NEW(NumExpr)(1), NEW(NumExpr)(2) );
    //CHECK( if3->subst("x", NEW(NumExpr)(6))->interp()->to_string() == "1" );
    //CHECK( if3->subst("x", NEW(NumExpr)(9))->interp()->to_string() == "2" );

}

TEST_CASE("FunExpr && CalExpr"){
    PTR(Expr) fun1 = NEW(FunExpr)( "x", NEW(AddExpr)( NEW(VarExpr)("x"), NEW(NumExpr)( 1 ) ) );
    PTR(Expr) fun2 = NEW(FunExpr)( "y", NEW(MultExpr)( NEW(VarExpr)("y"), NEW(VarExpr)("y") ) );
    CHECK( fun1->equals(fun1) == true );
    CHECK( fun1->equals(fun2) == false );
    CHECK( fun1->equals( NEW(NumExpr)(0) ) == false );

    PTR(Expr) call1 = NEW(CallExpr)(fun1, NEW(NumExpr)(5));
    PTR(Expr) call2 = NEW(CallExpr)(fun2, NEW(NumExpr)(10));
    CHECK( call1->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(6) ) == true );
    CHECK( call2->interp(EmptyEnv::empty_)->equals( NEW(NumVal)(100) ) == true );

    CHECK( call1->equals(call1) == true );
    CHECK( call1->equals(call2) == false );
    CHECK( call1->equals( NEW(NumExpr)(5) ) == false );

    PTR(Expr) factrl = test_parse("_let factrl = _fun (factrl) _fun (x) _if x == 1 _then 1 _else x * factrl(factrl)(x + -1) _in  factrl(factrl)(10)");
    CHECK( test_pp(factrl) == "_let factrl = _fun (factrl) _fun (x) (_if (x==1) _then 1 _else (x*factrl(factrl)((x+-1))))\n_in  factrl(factrl)(10)");
    //CHECK(factrl->interp()->equals( NEW(NumVal)(3628800) ) == true );
}

TEST_CASE(".print()"){

    PTR(Expr) add4 = NEW(AddExpr)(NEW(NumExpr)(5), NEW(AddExpr)(NEW(NumExpr)(6), NEW(NumExpr)(7) ) );  // 5 + 6 + 7
    CHECK( test_print(add4) == "(5+(6+7))" );

    PTR(Expr) mult4 = NEW(MultExpr)(NEW(MultExpr)(NEW(NumExpr)(6), NEW(NumExpr)(7) ), NEW(NumExpr)(5) );  // (6 * 7) * 5
    CHECK( test_print(mult4) == "((6*7)*5)" );

    PTR(Expr) mult5 = NEW(MultExpr)(NEW(NumExpr)(5), NEW(AddExpr)(NEW(NumExpr)(6), NEW(NumExpr)(7) ) );   // 5 * (6 + 7)
    CHECK( test_print(mult5) == "(5*(6+7))" );

    PTR(Expr) let1 = NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5), NEW(AddExpr)(NEW(LetExpr)(NEW(VarExpr)("y"), NEW(NumExpr)(3), NEW(AddExpr)(NEW(VarExpr)("y"), NEW(NumExpr)(2) ) ), NEW(VarExpr)("x") ) );
    CHECK( test_print(let1) == "(_let x=5 _in ((_let y=3 _in (y+2))+x))" );

    PTR(Expr) equal1 = NEW(EqualExpr)( NEW(NumExpr)(3), NEW(BoolExpr)("_false") );
    CHECK( test_print(equal1) == "(3==_false)" );

    PTR(Expr) if1 = NEW(IfExpr)( NEW(EqualExpr)( NEW(NumExpr)(3), NEW(NumExpr)(3) ), NEW(AddExpr)( NEW(NumExpr)(1), NEW(NumExpr)(2) ), NEW(BoolExpr)("_false") );
    CHECK( test_print(if1) == "(_if (3==3) _then (1+2) _else _false)" );

    PTR(Expr) fun1 = NEW(FunExpr)( "x", NEW(AddExpr)( NEW(VarExpr)("x"), NEW(NumExpr)( 1 ) ) );
    CHECK( test_print(fun1) == "_fun (x) (x+1)" );

    PTR(Expr) call1 = NEW(CallExpr)(fun1, NEW(NumExpr)(5));
    CHECK( test_print(call1) == "_fun (x) (x+1)(5)" );

}

TEST_CASE(".pretty_print()"){

    PTR(Expr) eq1 = NEW(AddExpr)(NEW(NumExpr)(1), NEW(MultExpr)(NEW(NumExpr)(2), NEW(NumExpr)(3) ) );   // 1 + 2 * 3
    CHECK( test_pp(eq1) == "1 + 2 * 3");

    PTR(Expr) eq2 = NEW(MultExpr)(NEW(NumExpr)(1), NEW(AddExpr)(NEW(NumExpr)(2), NEW(NumExpr)(3) ) );  // 1 * (2 + 3)
    CHECK( test_pp(eq2)  == "1 * (2 + 3)");

    PTR(Expr) eq3 = NEW(MultExpr)(NEW(MultExpr)(NEW(NumExpr)(2), NEW(NumExpr)(3) ), NEW(NumExpr)(4) ); // (2 * 3) * 4
    CHECK( test_pp(eq3)  == "(2 * 3) * 4");

    PTR(Expr) eq4 = NEW(MultExpr)(NEW(NumExpr)(2), NEW(MultExpr)(NEW(NumExpr)(3), NEW(NumExpr)(4) ) ); // 2 * 3 * 4
    CHECK( test_pp(eq4)  == "2 * 3 * 4");

    PTR(Expr) eq5 = NEW(AddExpr)(NEW(AddExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2) ), NEW(NumExpr)(3) );    // (1 + 2) + 3
    CHECK( test_pp(eq5)  == "(1 + 2) + 3");

    PTR(Expr) eq6 = NEW(AddExpr)(NEW(NumExpr)(1), NEW(NumExpr)(2) );    // 1 + 2
    CHECK( test_pp(eq6)  == "1 + 2");

    PTR(Expr) eq7 = NEW(MultExpr)(NEW(NumExpr)(3), NEW(NumExpr)(4) );  // 3 * 4
    CHECK( test_pp(eq7)  == "3 * 4");

    PTR(Expr) num = NEW(NumExpr)(99);
    CHECK( test_pp(num)  == "99");

    PTR(Expr) eq8 = NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5), NEW(AddExpr)(NEW(LetExpr)(NEW(VarExpr)("y"), NEW(NumExpr)(3), NEW(AddExpr)(NEW(VarExpr)("y"), NEW(NumExpr)(2) ) ), NEW(VarExpr)("x") ) );
    CHECK( test_pp(eq8)  == "_let x = 5\n_in  (_let y = 3\n      _in  y + 2) + x" );

    PTR(Expr) eq9 = NEW(AddExpr)(NEW(MultExpr)(NEW(NumExpr)(5), NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5), NEW(VarExpr)("x") ) ), NEW(NumExpr)(1) );
    CHECK( test_pp(eq9)  == "5 * (_let x = 5\n     _in  x) + 1" );

    PTR(Expr) eq10 = NEW(AddExpr)(NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5), NEW(VarExpr)("x") ), NEW(NumExpr)(1) );
    CHECK( test_pp(eq10)  == "(_let x = 5\n _in  x) + 1" );

    PTR(Expr) eq11 = NEW(MultExpr)(NEW(NumExpr)(5), NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5), NEW(AddExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(1) ) ) );
    CHECK( test_pp(eq11)  == "5 * _let x = 5\n    _in  x + 1" );

    PTR(Expr) eq12 = NEW(LetExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(5), NEW(AddExpr)(NEW(VarExpr)("x"), NEW(NumExpr)(1) ) );
    CHECK(test_pp(eq12) == "_let x = 5\n_in  x + 1" );

    PTR(Expr) eq13 = NEW(LetExpr)( NEW(VarExpr)("same"), NEW(EqualExpr)( NEW(NumExpr)(3), NEW(NumExpr)(3) ), NEW(EqualExpr)( NEW(VarExpr)("same"), NEW(BoolExpr)("_true") ) );
    CHECK(test_pp(eq13) == "_let same = 3 == 3\n_in  same == _true" );

    PTR(Expr) if1 = NEW(IfExpr)( NEW(EqualExpr)( NEW(NumExpr)(3), NEW(NumExpr)(3) ), NEW(AddExpr)( NEW(NumExpr)(1), NEW(NumExpr)(2) ), NEW(BoolExpr)("_false") );
    CHECK(test_pp(if1) == "_if 3 == 3\n_then 1 + 2\n_else _false");

    PTR(Expr) eq15 = NEW(EqualExpr)( NEW(NumExpr)(1), NEW(NumExpr)(2) );
    CHECK(test_pp(eq15) == "1 == 2");

}

TEST_CASE("parse"){

    CHECK( test_pp(test_parse("5+5==5")) == "5 + (5 == 5)");
    CHECK( test_pp(test_parse("5+5")) == "5 + 5" );
    CHECK( test_pp(test_parse("5*5")) == "5 * 5");
    CHECK( test_pp(test_parse("  1 *(2     +3)")) == "1 * (2 + 3)" );
    CHECK( test_pp(test_parse("-10 +_let x = 6 _in x*50")) == "-10 + _let x = 6\n      _in  x * 50" );
    CHECK( test_pp(test_parse("5+ _let y = 6== 5 _in x == _false")) == "5 + _let y = 6 == 5\n    _in  x == _false" );
    CHECK( test_pp(test_parse("6+_if _true _then _if 6== 7 _then _false +6 _else(6*3) _else 70")) == "6 + _if _true\n    _then _if 6 == 7\n          _then _false + 6\n          _else 6 * 3\n          _else 70");
    CHECK( test_pp(test_parse("5 *(_if 9 == 9_then7_else 20) +3")) == "5 * (_if 9 == 9\n     _then 7\n     _else 20) + 3" );

    CHECK( test_parse("1 + 2 * 3")->equals( NEW(AddExpr)(NEW(NumExpr)(1), NEW(MultExpr)(NEW(NumExpr)(2), NEW(NumExpr)(3) ) ) ) );

    CHECK_THROWS_WITH(test_parse("10*(10+10"), "missing close parenthesis");
    CHECK_THROWS_WITH(test_parse("5+?"), "invalid input");
    CHECK_THROWS_WITH(test_parse("_lt x=1 _in x+2"), "invalid expression");
    CHECK_THROWS_WITH(test_parse("_let ?=1 _in x+2"), "invalid variable");
    CHECK_THROWS_WITH(test_parse("_let x 1 _in x+2"), "invalid expression");
    CHECK_THROWS_WITH(test_parse("_let x=1 _i x+2"), "invalid expression");
    CHECK_THROWS_WITH(test_parse("5=+5"), "invalid '==' expression");

}

string test_print(PTR(Expr) ex){
    ostringstream os;
    ex->print(os);
    return os.str();
}

string test_pp(PTR(Expr) ex){
    ostringstream os;
    ex->pretty_print(os);
    return os.str();
}

static PTR(Expr) test_parse(const char *string) {
    istringstream is(string);
    return parse_expr(is);
}
