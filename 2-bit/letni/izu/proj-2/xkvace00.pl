% Zadani c. 12:
% Napiste program resici ukol dany predikatem u12(LIN), kde LIN je neprazdny
% vstupni seznam. Predikat je pravdivy (ma hodnotu true), pokud prvky seznamu
% LIN predstavuji palindrom, jinak je predikat nepravdivy (ma hodnotu false).

% Testovaci predikaty:
u12_1:- u12([2,1,k,r,k,1,2]).				% true
u12_2:- u12([j,e,l,e,n,o,v,i,p,i,v,o,n,e,l,e,j]).	% true
u12_3:- u12([j,e,l,e,n,o,v,i]).				% false
u12_r:- write('Zadej LIN: '),read(LIN),u12(LIN).

% Reseni:
u12(LIN):- palindrome(LIN), !.

palindrome([]).
palindrome([_]).
palindrome([H|T]):- my_append(R,[H],T), palindrome(R).

my_append([],L,L).
my_append([H|T],L,[H|R]):- my_append(T,L,R).
