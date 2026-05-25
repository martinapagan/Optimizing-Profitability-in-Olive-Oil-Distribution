* Exercise section 1.3.1. book Shapiro (manufacturer)

Set
i  output products  /i1,i2/
j  input parts      /j1*j3/
w  scenarios        /w1*w3/
;

Parameter
cost_input(j) euro per unit /
j1   20
j2   25
j3   22
/
selling_price(i) euro per unit 
/i1   50
i2    48
/
cost_transport(i) eur unit
/i1  5
i2   4
/
value_storage(j) eur unit
/j1  8
j2   10
j3   7
/
;

TABLE A(i,j) inputs required per unit of output
    j1      j2      j3
i1  0.20    0.50    0.30
i2  0.40    0.25    0.35
;

TABLE DEM(i,w) demand outputs
    w1      w2      w3
i1  100     110     95
i2  87      85      93
;

SCALAR prob probability of scenarios;
prob=1/card(w);


Variable
cost objective function value
;

Positive Variables
x(j)    amount of inputs bought from suppliers
z(i,w)  quantity produced of each output
y(j,w)  amount of input in the storage
;

EQUATIONS
objectiveFunction
StorageLevel
ProductionLevel
demand
;

objectiveFunction.. cost =e= sum(j,cost_input(j)*x(j)) + 
                              sum(w, prob*(sum(i,(cost_transport(i)-selling_price(i))*z(i,w))
                                           - sum(j,value_storage(j)*y(j,w))
                                           )
                                 );
StorageLevel(j,w)..  y(j,w) =e= x(j) - sum(i,A(i,j)*z(i,w));

ProductionLevel(i,w)..  z(i,w) =l= DEM(i,w);

demand(i,w)..    sum(j,A(i,j)*z(i,w)) =g= DEM(i,w);

model exercise /all/;

solve exercise minimizing cost using lp;

display cost.l, z.l, x.l, y.l;







