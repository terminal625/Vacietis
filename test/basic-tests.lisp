(in-package #:vacietis.test.basic)
(in-readtable vacietis:vacietis)

(in-suite vacietis.test::basic-tests)

(eval-test addition0
  "1 + 2;"
  3)

(eval-test subtraction0
  "3-2;"
  1)

(eval-test global-var
  "int foobar = 10;
foobar;"
  10)

(eval-test for-loop0
  "int foobar = 0;
for (int x = 0, foobar = 0; x <= 10; x++) foobar += x;
foobar;"
  0) ;; comes out to 0 because of foobar scope, bug or feature?
;; gcc says 0 with -std=c99
;; for.c: In function ‘main’:
;; for.c:4:17: error: redefinition of ‘foobar’
;; for (int x = 0, foobar = 0; x <= 10; x++) foobar += x;
;;                 ^
;; for.c:3:5: note: previous definition of ‘foobar’ was here
;; int foobar = 0;
;;     ^
;; for.c:4:1: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
;;  for (int x = 0, foobar = 0; x <= 10; x++) foobar += x;
;;  ^
;; for.c:4:1: note: use option -std=c99, -std=gnu99, -std=c11 or -std=gnu11 to compile your code

;;

(eval-test for-loop1
  "int foobar = 0;
for (int x = 0; x <= 10; x++) foobar += x;
foobar;"
  55)

(eval-test array-initializer1 "
double
main(void)
{
  double x = 0.5f;
  double y[2] = {1.0, x};
  return y[0]+y[1];
}
main();
" 1.5)

(eval-test string-literal
  "char foobar[] = \"foobar\";
foobar;"
  "foobar")

(eval-test h&s-while-string-copy
  "char source_array[] = \"foobar\", dest_array[7];
  char *source_pointer = source_array, *dest_pointer = dest_array;
while ( *dest_pointer++ = *source_pointer++ );
dest_pointer - 7;"
  "foobar")

(eval-test define-foo
  "#define FOO 1
int x = FOO;
x;"
  1)

(eval-test define-foo1
  "#define foo 2
int baz = foo * 2;
baz;"
  4)

(eval-test define-foo2
  "#define foo 1 + 4
int baz = foo * 2;
baz;"
  9)

(eval-test preprocessor-if-1
  "#if 2 < 1
int baz = 5;
baz;
#endif"
  nil)

(eval-test preprocessor-if-2
  "int baz = 123;
#if 2 >= 1
baz = 456;
#endif
baz;"
  456)

(eval-test preprocessor-ifdef
  "#define FOOMAX
int baz = 1;
#ifdef FOOMAX
int baz = 2;
#endif
baz;"
  2)

(eval-test preprocessor-define-template
  "#define foo(x, y) x+y
foo(1,2);"
  3)

(eval-test sizeof-static-array
  "static char buf[10];
sizeof buf;"
  10)

(eval-test sizeof-int
  "int foo;
sizeof foo;"
  1)

(eval-test sizeof-int1
  "int foo1 = 120;
sizeof foo1;"
  1)

(eval-test sizeof0
  "char foobar;
sizeof (foobar);"
  1)

(eval-test sizeof1
  "long foobar;
1 + sizeof (foobar);"
  2)

(eval-test sizeof2
  "sizeof int;"
  1)

(eval-test sizeof3
  "sizeof (int);"
  1)

(eval-test if-then-else1
  "int baz;
if (2 < 1) {
  baz = 2;
} else {
  baz = 3;
}
baz;"
  3)

(eval-test if-then-none
  "int baz = 0;
if (2 < 1) {
  baz = 2;
}
baz;"
  0)

(eval-test do-while1
  "int foo = 0;
do foo++; while (foo < 1);
foo;"
  1)

(eval-test setf-aref
  "int foo[3];
foo[0] = 123;
foo[0];"
  123)

(eval-test strlength1
  "#include <string.h>
strlen(\"foobar\");"
  6)

(eval-test reverse
  "
#include <string.h>
void creverse(char *str) {
  char * end = str;
  char tmp;

  if (str) {
    while (*end) {
      ++end;
    }

    --end;

    while (str < end) {
      tmp = *str;
      *str++ = *end;
      *end-- = tmp;
    }
  }
}

char foo[7];
strcpy(foo, \"foobar\");
creverse(foo);
foo;"
  "raboof")

(eval-test strcmp
           "
int strcmp (char *s1, char *s2) {
  char c1, c2;

  while (*s1 || *s2) {
    c1 = *s1++;
    c2 = *s2++;
    if (c1 < c2) return -1;
    if (c1 > c2) return 1;
  }
  return 0;
}
char *foo = \"foo\";
char *bar = \"foo?\";
int r = strcmp(foo, bar);
r;
" -1)

(eval-test sprintf-padchar
  "#include <stdio.h>
char foo[6];
char *r = sprintf(foo, \"%-5c\", 'X');
0+r;"
  "X    ")

(eval-test typedef
  "typedef int Baz;
Baz baz = 4;
baz;"
  4)

(eval-test typedef-struct1 "
typedef struct point {
  int x;
  int y;
} point_t, *point_ptr_t, points_t[2];
point_t p = {1, 2};
p.x+p.y;
"
           3)

(eval-test typedef-struct2 "
struct point {
  int x;
  int y;
};
typedef struct point point_t;
point_t p = {1, 2};
p.x+p.y;
"
           3)

(eval-test function-returns-struct "
typedef struct point {
  int x;
  int y;
} point_t;
point_t _p;
point_t make_point (int c[]) {
  _p.x = c[0];
  _p.y = c[1];
  return _p;
}
int c[2] = {1, 2};
point_t p = make_point(c);
p.x+p.y;
"
           3)
(eval-test function-returns-struct* "
typedef struct point {
  int x;
  int y;
} point_t;
point_t _p;
point_t *make_point (int c[]) {
  _p.x = c[0];
  _p.y = c[1];
  return &_p;
}
int c[2] = {1, 2};
point_t *p = make_point(c);
p->x+p->y;
"
           3)


(eval-test define-define
  "#define FOO 1
#define BAR FOO
BAR;"
  1)

(eval-test define-define1
  "#define fo0(x, y) x >> y
#define Bar fo0
Bar(0xFFF, 2);"
  1023)

(eval-test function-pointer1
  "int add(int *x, int *y) {
  return *x + *y;
}

int apply(int ((*fun))(int *, int *), int x, int y) {
  return (*fun)(&x, &y);
}

apply((int (*)(int *, int *)) add, 2, 3);"
  5)

(eval-test simple-function1
  "void foo(int a, int b) {
return a + b;
}
foo(11, 13);"
  24)

(eval-test function0
  "int max(int a, int b)
{
return a > b ? a : b;
}
max(-3, 10);"
  10)

(eval-test function1
  "extern int max(int a, int b)
{
return a > b ? a : b;
}
max(234, 0);"
  234)

(eval-test no-arg-function
  "int a = -4, b = 7;
void foo() {
return a + b;
}
foo();"
  3)

(eval-test labeled-statement1
  "void foo() {
int a = 2, b = 5;
int c = 3;
goto baz;
c = 7;
baz:
return a + b + c;
}
foo();"
  10)

(eval-test h&s-while1
  "int pow(int base, int exponent)
{
    int result = 1;
    while (exponent > 0) {
        if ( exponent % 2 ) result *= base;
        base *= base;
        exponent /= 2;
    }
    return result;
}
pow(3, 4);"
  81)

(eval-test enums
  "enum foo { bar, baz };
enum foo x = bar;
enum foo y = baz;
int A = 0;

if (x == bar) A = 3;
A;"
  3)

(eval-test enums1
  "enum foo { bar, baz } x = bar, y = baz;
int A = 0;

if (x == bar) A = 3;
A;"
  3)

(eval-test struct1
  "struct point {
  int x;
  int y;
};

struct point pt = { 7, 11 };
pt.x + pt.y;"
  18)

(eval-test structs2
  "struct point {
  int x;
  int y;
};

struct rect {
  struct point pt1;
  struct point pt2;
};

struct rect screen;

screen.pt1.x = 3;
screen.pt2.y = 5;

screen.pt1.x + screen.pt2.y;"
  8)

(eval-test structs3
  "struct point {
  int x;
  int y;
};

struct rect {
  struct point pt1;
  struct point pt2;
};

struct rect r, *rp = &r;

r.pt2.y = 3;

r.pt2.y + rp->pt2.y + (r.pt2).y + (rp->pt2).y;"
  12)

(eval-test structs4 "
struct vel {
  float x;
  float y;
};
struct point {
  int x;
  int y;
  char z;
  struct vel vel;
};

struct point pt = { 7, 11, 1, {0.0f, 0.0f} };
pt.x + pt.y + pt.z;
"
           19)

(eval-test struct-arrays1 "
struct point {
  int x;
  int y;
};

struct point pts[] = {{ 7, 11 },};
pts[0].x + pts[0].y;
"
           18)

(eval-test ptr-addr-decl1
  "int x, *y = &x;
x = 3;
x * *y;"
  9)

(eval-test struct-ptr-decl1
  "struct point {
  int x;
  int y;
} *foo, bar;

bar.x = 7;
bar.y = 11;
foo = &bar;
foo->x * (*foo).y;"
  77)

(eval-test pointer-lvalue
  "int i = 1;
int *j = &i;
*j += 1;
i;"
  2)

(eval-test pointer-lvalue1
  "int foo[3];
int *x = &foo[1];

foo[1] = 3;
foo[2] = 5;

*x;"
  3)

(eval-test pointer-lvalue2
  "int foo[3];
int *x = &foo[1];

foo[1] = 3;
foo[2] = 5;

*(x + 1);"
  5)

(eval-test main-args "
#include <string.h>
int main (int argc, char *argv[]) {
  return strlen(*(argv+(argc-1)));
}
char *argv[2];
argv[0] = \"main\";
argv[1] = \"12345\";
main(2, argv);
"
           5)

(eval-test main-args-2* "
#include <string.h>
int main (int argc, char **argv) {
  return strlen(*(argv+(argc-1)));
}
char *argv[2];
argv[0] = \"main\";
argv[1] = \"12345\";
main(2, argv);
"
           5)

(eval-test main-args-[]access "
#include <string.h>
int main (int argc, char *argv[]) {
  return strlen(argv[argc-1]);
}
char *argv[2];
argv[0] = \"main\";
argv[1] = \"12345\";
main(2, argv);
"
           5)
