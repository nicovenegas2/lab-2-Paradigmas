date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


% Hechos

emptyList([]).




%   Significado salida paradimadocs =[nombre, Fecha creacion, Lista de usuarios, lista de Documentos, usuario activo]
paradigmadocs(Nombre, Date, [Nombre, Date, [], [], []]) :-
    string(Nombre),
    date(Dia, Mes, Agno,Date).



paraGetter([N, F, LU, LD, UA], [N, F, LU, LD, UA]).

paraIsLogin(Sn1) :-
    paraGetter(Sn1, [_, _, _, _, UA]),
    UA \= [].

usuario(Nombre, Password,Date, [Nombre, Password, Date]) :-
    string(Nombre),
    string(Password),
    date(Dia, Mes, Agno, Date).


documento(Id, Nombre, [Dia, Mes, Agno], Autor, Contenido, [Id, Nombre, Date, Autor, Contenido]) :-
    integer(Id),
    string(Nombre),
    date(Dia, Mes, Agno, Date),
    string(Autor),
    string(Contenido).


addDocument(Sn1, Document, SOut) :-
    paraGetter(Sn1, [N, F, LU, LD, UA]),
    append(LD, [Document], LD1),
    paraGetter([N, F, LU, LD1, UA], SOut).


    

create(Sn1, Fecha, Nombre, Contenido, SOut) :-
    ((paraIsLogin(Sn1),
    paraGetter(Sn1, [_, _, _, LD, UA]),
    date(Dia, Mes, Agno, Fecha),
    usuario(NombreA, _, _, UA),
    length(LD, Id),
    documento(Id, Nombre, Fecha, NombreA, Contenido, Document),
    addDocument(Sn1, Document, SOut))
    ; Sn1 = SOut).


 

    



canLogin(Nombre, Password, [[Nombre, Password,_]|Resto]).
canLogin(Nombre, Password, [[N, P,_]|Resto]) :-
    string(Nombre),
    string(Password),
    canLogin(Nombre, Password, Resto).




canRegister(Nombre, [[Nombre, _,_]|Resto]).
canRegister(Nombre, [[N, _,_]|Resto]) :-
    string(Nombre),
    canRegister(Nombre, Resto).


%ARREGLAR, solo parametros Sn1 y SOut
register(Nombre, Password, Date, [N, F, LU, LD, UA], [N, F, LUA, LD, UA]):-
    ((not(canRegister(Nombre, LU)),
    append(LU, [[Nombre, Password, Date]], LUA));
    LUA = LU).


%ARREGLAR, solo parametros Sn1 y SOut
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



