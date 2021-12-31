date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


% Hechos

emptyList([]).




%   Significado salida paradimadocs =[nombre, Fecha creacion, Lista de usuarios, lista de Documentos, usuario activo]
paradigmadocs(Nombre, Date, [Nombre, Date, [], [], []]) :-
    string(Nombre),
    date(_, _, _,Date).



paraGetter([N, F, LU, LD, UA], [N, F, LU, LD, UA]).

paraIsLogin(Sn1) :-
    paraGetter(Sn1, [_, _, _, _, UA]),
    UA \= [].

usuario(Nombre, Password,Date, [Nombre, Password, Date]) :-
    string(Nombre),
    string(Password),
    date(_, _, _, Date).

%                                                           [id, nombre, fecha, autor, contenido, lista de permisos, lista de usuarios compartidos]
documento(Id, Nombre, Date, Autor, Contenido, [Id, Nombre, Date, Autor, Contenido, [], []]) :-
    integer(Id),
    string(Nombre),
    date(_, _, _, Date),
    string(Autor),
    string(Contenido).

documentGetter([Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos], [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos]).

addDocument(Sn1, Document, SOut) :-
    paraGetter(Sn1, [N, F, _, LD, _]),
    append(LD, [Document], LD1),
    paraGetter([_, _, _, LD1, _], SOut).


getDocumentById([Document|_], Id, DocumentOut) :-
    documentGetter(Document, [Id, _, _, _, _, _, _]),
    DocumentOut = Document.
getDocumentById([_|Resto], Id, DocumentOut) :-
    getDocumentById(Resto, Id, DocumentOut).

create(Sn1, Fecha, Nombre, Contenido, SOut) :-
    ((paraIsLogin(Sn1),
    paraGetter(Sn1, [N, F, A, LD, UA]),
    date(_, _, _, Fecha),
    usuario(NombreA, _, _, UA),
    length(LD, Id),
    documento(Id, Nombre, Fecha, NombreA, Contenido, Document),
    addDocument(Sn1, Document, SOut),
    paraGetter(SOut, [N, F, A, _, []]) )
    ; Sn1 = SOut).



 

    



canLogin(Nombre, Password, [[Nombre, Password,_]|_]).
canLogin(Nombre, Password, [[_, _,_]|Resto]) :-
    string(Nombre),
    string(Password),
    canLogin(Nombre, Password, Resto).




canRegister(Nombre, [[Nombre, _,_]|_]).
canRegister(Nombre, [[_, _,_]|Resto]) :-
    string(Nombre),
    canRegister(Nombre, Resto).


%ARREGLAR, solo parametros Sn1 y SOut
register(Nombre, Password, Date, [N, F, LU, LD, UA], [N, F, LUA, LD, UA]):-
    ((not(canRegister(Nombre, LU)),
    append(LU, [[Nombre, Password, Date]], LUA));
    LUA = LU).


%ARREGLAR, solo parametros Sn1 y SOut
login( Nombre, Password, [N, F, LU, LD, UA], [N, F, LU,LD, NUA]):-
    (
        (
            not(paraIsLogin([N, F, LU, LD, UA])),
            canLogin(Nombre, Password, LU),
            append(UA, [Nombre, Password, [-1,-1,-1]], NUA)
        );
        NUA = UA
    ).











/*

paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1), register("nico", "123424234", Word1, Word2).

paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),              
login("nico", "1234", Word1, Word2).


paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),   
login("nico", "1234", Word1, Word2),
create(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3).

*/



