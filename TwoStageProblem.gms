set
i        cities starting point   /1*11/
v        vehicles                /v1*v3/
w        scenarios               /w1*w3/
;

Alias (i,j);

Scalar
b       weight factor for the risk /0.2/
;

Parameter
D(i)    demand for city i
/2 700
3  800
4  200
5  1050
6  750
7  1150
8  800
9  600
10 700
11 350
/

k               production capacity in liters /8000/
p_first_stage   price per liter in the first stage /45.2/
p(w)            price per liter in each scenario /w1 43.5, w2 46.4, w3 48.2/
pg(w)           probability for each scenario /w1 0.570, w2 0.270, w3 0.160/
f               production cost per bottle of oil /30/
cost(i,j)       transportation cost between cities i and j
             /1.7 52, 7.6 21, 6.5 34, 5.4 42, 4.1 18,
              1.2 25, 2.11 14, 11.10 15, 10.9 21, 9.8 25, 8.1 38,
              1.3 22, 3.1 22/;
;

VARIABLES
z               objective function
eta             variable for the CVaR
;

BINARY VARIABLE
y(i, j, v) "1 if vehicle v travels from i to j, 0 otherwise"
;

POSITIVE VARIABLES
Q(w)            quantity produced for each scenario
ksi(w)          variable for the CVaR
Q_first_stage   quantity produced in the first stage
;


EQUATIONS
obj             objective function
production_cap  production capacity constraint
cvar_constraint CVaR constraint
Route_v1_1      "Route constraint for Vehicle 1 (1->3)"
Route_v1_2      "Route constraint for Vehicle 1 (3->4)"
Route_v1_3      "Route constraint for Vehicle 1 (4->1)"
Route_v1_4
Route_v1_5
Route_v2_1      "Route constraint for Vehicle 2 (1->2)"
Route_v2_2      "Route constraint for Vehicle 2 (2->11)"
Route_v2_3      "Route constraint for Vehicle 2 (11->10)"
Route_v2_4      "Route constraint for Vehicle 2 (10->9)"
Route_v2_5      "Route constraint for Vehicle 2 (9->8)"
Route_v2_6      "Route constraint for Vehicle 2 (8->1)"
Route_v3_1      "Route constraint for Vehicle 3 (1->5)"
Route_v3_2      "Route constraint for Vehicle 3 (5->6)"
production_demand_constraint
;

obj..    z =e= (1-b)*
                (((p_first_stage * Q_first_stage)+
                sum(w,pg(w)*(p(w)*Q(w)))
                            )
                   -
                (Q_first_stage + sum(w, pg(w)* Q(w)))*f -
                sum((i,j),cost(i,j))
                )-
                b*(eta-(1/0.1)*sum(w,pg(w)*ksi(w)));

production_cap(w)..        Q(w)+Q_first_stage =l= k;

production_demand_constraint(w).. 
    Q_first_stage +  Q(w) =g= sum(i, D(i));


* Route constraints for Vehicle 1
Route_v1_1.. Y('1', '7', 'v1') =e= 1;
Route_v1_2.. Y('7', '6', 'v1') =e= 1;
Route_v1_3.. Y('6', '5', 'v1') =e= 1;
Route_v1_4.. Y('5', '4', 'v1') =e= 1;
Route_v1_5.. Y('4', '1', 'v1') =e= 1;

* Route constraints for Vehicle 2
Route_v2_1.. Y('1', '2', 'v2') =e= 1;
Route_v2_2.. Y('2', '11', 'v2') =e= 1;
Route_v2_3.. Y('11', '10', 'v2') =e= 1;
Route_v2_4.. Y('10', '9', 'v2') =e= 1;
Route_v2_5.. Y('9', '8', 'v2') =e= 1;
Route_v2_6.. Y('8', '1', 'v2') =e= 1;

* Route constraints for Vehicle 3
Route_v3_1.. Y('1', '3', 'v3') =e= 1;
Route_v3_2.. Y('3', '1', 'v3') =e= 1;

cvar_constraint(w)..    ksi(w) =g= eta - ((Q_first_stage +  pg(w)* Q(w))*f -
                sum((i,j),cost(i,j)));

MODEL CVaRModel /all/;

SOLVE CVaRModel maximizing z using mip;

DISPLAY p, Q.l, Y.l, D, ksi.l, eta.l, z.l, Q_first_stage.l;