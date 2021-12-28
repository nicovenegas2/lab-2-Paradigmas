date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


%   Significado salida paradimadocs =[nombre, Fecha creacion, Lista de usuarios, lista de Documentos]
paradigmadocs(Nombre, [Dia, Mes, Agno], [Nombre, Date, [], []]) :-
    string(Nombre),
    date(Dia, Mes, Agno,Date).


usuario(Nombre, Password, [Nombre, [Dia, Mes, Agno]]) :-
    string(Nombre),
    string(Password),
    date(Dia, Mes, Agno, [Dia, Mes, Agno]).



canLogin(Nombre, Password, [[Nombre, Password, _]|Resto]).
canLogin(Nombre, Password, [[Nombre, Password, _]|Resto]) :-
    string(Nombre),
    string(Password),
    canLogin(Nombre, Password, Resto).




canRegister(Nombre, [[Nombre, _]|Resto]).
canRegister(Nombre, [[N, _]|Resto]) :-
    string(Nombre),
    canRegister(Nombre, Resto).


register(Nombre, Password, [N, F, LU, LD], [N, F, LUA, LD]):-
    not(canRegister(Nombre, LU)),
    append(LU, [[Nombre, Password]], LUA).











/*

paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", Word, Word1), register("nico", "123424234", Word1, Word2).




*/



