date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


% Hechos

emptyList([]).




%   Significado salida paradimadocs =[nombre, Fecha creacion, Lista de usuarios, lista de Documentos, usuario activo]
paradigmadocs(Nombre, [Dia, Mes, Agno], [Nombre, Date, [], [], []]) :-
    string(Nombre),
    date(Dia, Mes, Agno,Date).


usuario(Nombre, Password, [Nombre, [Dia, Mes, Agno]]) :-
    string(Nombre),
    string(Password),
    date(Dia, Mes, Agno, [Dia, Mes, Agno]).



canLogin(Nombre, Password, [[Nombre, Password]|Resto]).
canLogin(Nombre, Password, [[N, P]|Resto]) :-
    string(Nombre),
    string(Password),
    canLogin(Nombre, Password, Resto).




canRegister(Nombre, [[Nombre, _]|Resto]).
canRegister(Nombre, [[N, _]|Resto]) :-
    string(Nombre),
    canRegister(Nombre, Resto).


register(Nombre, Password, [N, F, LU, LD, UA], [N, F, LUA, LD, UA]):-
    ((not(canRegister(Nombre, LU)),
    append(LU, [[Nombre, Password]], LUA));
    LUA = LU).

login( Nombre, Password, [N, F, LU, LD UA], [N, F, LU,LD NUA]):-
    (
        (
            emptyList(UA),
            not(canLogin(Nombre, Password, LU)),
            append(LU, [Nombre, Password], NUA)
        );
        NUA = UA
    ).











/*

paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", Word, Word1), register("nico", "123424234", Word1, Word2).




*/



