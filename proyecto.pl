date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


% Hechos

emptyList([]).




cambiar(E, [E|Cola], NEl, [NEl|Cola]).
cambiar(E, [AE|Cola], NEl, [AE|NC]):-
    cambiar(E, Cola, NEl, NC).





%   Significado salida paradimadocs =[nombre, Fecha creacion, Lista de usuarios, lista de Documentos, usuario activo]
paradigmadocs(Nombre, Date, [Nombre, Date, [], [], []]) :-
    string(Nombre),
    date(_, _, _,Date).


% GAS = Getter And Setter
paraGAS([N, F, LU, LD, UA], [N, F, LU, LD, UA]).

paraIsLogin(Sn1) :-
    paraGAS(Sn1, [_, _, _, _, UA]),
    UA \= [].

paraEditDocument(Sn1, IDoc, NDoc, SOut) :-
    paraGAS(Sn1, [N, F, LU, LD, UA]),
    getDocumentById(LD, IDoc, Doc),
    cambiar(Doc, LD, NDoc, NLD),
    paraGAS(SOut, [N, F, LU, NLD, UA]).

paraLogOut(Sn1, SOut) :-
    paraGAS(Sn1, [N, F, LU, LD, UA]),
    paraGAS(SOut, [N, F, LU, LD, []]).



usuario(Nombre, Password,Date, [Nombre, Password, Date]) :-
    string(Nombre),
    string(Password),
    date(_, _, _, Date).
 





%                                             [id, nombre, fecha, autor, contenido, lista de permisos, lista de usuarios compartidos, lista de versiones]
documento(Id, Nombre, Date, Autor, Contenido, [Id, Nombre, Date, Autor, Contenido, [], [], []]) :-
    integer(Id),
    string(Nombre),
    date(_, _, _, Date),
    string(Autor),
    string(Contenido).

documentGAS([Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones], [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]).

documentAddPermiso(Sn1, Permisos, Sn2) :-
    documentGAS(Sn1, [Id, Nombre, Date, Autor, Contenido, Permiso, UsuariosCompartidos, Versiones]),
    append(Permiso, Permisos, NuevosPermisos),
    documentGAS(Sn2, [Id, Nombre, Date, Autor, Contenido, NuevosPermisos, UsuariosCompartidos, Versiones]).

documentAddUsers(Sn1, Usuarios, Sn2) :-
    documentGAS(Sn1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    append(UsuariosCompartidos, Usuarios, NuevosUsuarios),
    documentGAS([Id, Nombre, Date, Autor, Contenido, Permisos, NuevosUsuarios, Versiones], Sn2).

documentAddContent(Doc1, Content, DOut) :-
    documentGAS(Doc1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    string_concat(Contenido, Content, NuevoContenido),
    documentGAS([Id, Nombre, Date, Autor, NuevoContenido, Permisos, UsuariosCompartidos, Versiones], DOut).

documentAddVersion(Doc1, Version, DOut) :-
    documentGAS(Doc1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    append(Versiones, [Version], NuevasVersiones),
    documentGAS([Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, NuevasVersiones], DOut).

documentSetContent(Doc1, Content, DOut) :-
    documentGAS(Doc1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    documentGAS([Id, Nombre, Date, Autor, Content, Permisos, UsuariosCompartidos, Versiones], DOut).


addDocument(Sn1, Document, SOut) :-
    paraGAS(Sn1, [_, _, _, LD, _]),
    append(LD, [Document], LD1),
    paraGAS([_, _, _, LD1, _], SOut).





version(Id, Fecha, Content, [Id, Fecha, Content]) :-
    integer(Id),
    date(_, _, _, Fecha),
    string(Content).



getDocumentById([Document|_], Id, DocumentOut) :-
    documentGAS(Document, [Id, _, _, _, _, _, _, _]),
    DocumentOut = Document.
getDocumentById([_|Resto], Id, DocumentOut) :-
    getDocumentById(Resto, Id, DocumentOut).


getVersionById([Version|_], Id, VersionOut) :-
    version(Id, _, _, Version),
    VersionOut = Version.
getVersionById([_|Resto], Id, VersionOut) :-
    getVersionById(Resto, Id, VersionOut).










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

register(Nombre, Password, Date, Sn1, SOut):-
    ((paraGAS(Sn1, [N, F, LU, LD, UA]),
    not(canRegister(Nombre, LU)),
    usuario(Nombre, Password, Date, Usuario),
    append(LU, [Usuario], NuevoUsuario),
    paraGAS(SOut, [N, F, NuevoUsuario, LD, UA]))
    ; Sn1 = Sout).


%ARREGLAR, solo parametros Sn1 y SOut
% login( Nombre, Password, [N, F, LU, LD, UA], [N, F, LU,LD, NUA]):-
%     (
%         (
%             not(paraIsLogin([N, F, LU, LD, UA])),
%             canLogin(Nombre, Password, LU),
%             append(UA, [Nombre, Password, [-1,-1,-1]], NUA)
%         );
%         NUA = UA
%     ).


login(Nombre, Password, Sn1, SOut) :-
    (
        (paraGAS(Sn1, [N, F, LU, LD, UA]),
        not(paraIsLogin(Sn1)),
        canLogin(Nombre, Password, LU),
        usuario(Nombre, Password, [-1,-1,-1], Usuario),
        append(UA, Usuario, UAA),
        paraGAS(SOut, [N, F, LU, LD, UAA])
    ); Sn1 = Sout).

create(Sn1, Fecha, Nombre, Contenido, SOut) :-
    ((paraIsLogin(Sn1),
    paraGAS(Sn1, [N, F, A, LD, UA]),
    date(_, _, _, Fecha),
    usuario(NombreA, _, _, UA),
    length(LD, Id),
    documento(Id, Nombre, Fecha, NombreA, Contenido, Document),
    addDocument(Sn1, Document, SOut),
    paraGAS(SOut, [N, F, A, _, []]) )
    ; Sn1 = SOut).

share(Sn1, IDoc, LPerms, LUsers, SOut) :-
    ((paraIsLogin(Sn1),
    paraGAS(Sn1, [_, _, _, LD, _]),
    getDocumentById(LD, IDoc, Document),
    documentAddPermiso(Document, LPerms, Document1),
    documentAddUsers(Document1, LUsers, Document2),
    paraEditDocument(Sn1, IDoc, Document2, Sn2),
    paraLogOut(Sn2, SOut)
    ); Sn1 = SOut).

add(Sn1, IDoc, Fecha, Contenido, SOut) :-
    ((paraIsLogin(Sn1),
    paraGAS(Sn1, [_, _, _, LD, _]),
    getDocumentById(LD, IDoc, Document),
    documentAddContent(Document, Contenido, Document1),
    documentGAS(Document, [_, _, _, _, Cont, _, _, Versiones]),
    length(Versiones, Id),
    version(Id, Fecha, Cont, Version),
    documentAddVersion(Document1, Version, Document2),
    paraEditDocument(Sn1, IDoc, Document2, Sn2),
    paraLogOut(Sn2, SOut)
    ); Sn1 = SOut).



restoreVersion(Sn1, IDoc, IDVersion, SOut) :-
    ((paraIsLogin(Sn1),
    paraGAS(Sn1, [_, _, _, LD, _]),
    getDocumentById(LD, IDoc, Document),
    documentGAS(Document, [_, _, _, _, ContDoc, Permisos, UsuariosCompartidos, Versiones]),
    getVersionById(Versiones, IDVersion, Version),
    version(IDVersion, _, Cont, Version),
    length(Versiones, Id),
    version(Id, [-1,-1,-1], ContDoc, Version1),
    documentAddVersion(Document, Version1, Document1),
    documentSetContent(Document1, Cont, Document2),
    paraEditDocument(Sn1, IDoc, Document2, Sn2),
    paraLogOut(Sn2, SOut)
    ); Sn1 = SOut).



% Z = [1,2,3], cambiar(1,Z,5,X).

/*

paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1), register("nico", "123424234", Word1, Word2).

paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),              
login("nico", "1234", Word1, Word2).


paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),   
login("nico", "1234", Word1, Word2),
create(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3).



paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),   
login("nico", "1234", Word1, Word2),
create(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3), 
share(Word3, 0, ["T","C","W"], ["u1","u2"], Word4).


paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),   
login("nico", "1234", Word1, Word2),
create(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3),
login("nico", "1234", Word3, Word4),
share(Word4, 0, ["T","C","W"], ["u1","u2"], Word5),
login("nico", "1234", Word5, Word6), 
add(Word6, 0, [1,1,1]," Extension 1", Word7).


 paradigmadocs("Word", [27, 12, 2021], Word), register("nico", "1234", [03,05,2020], Word, Word1),   
login("nico", "1234", Word1, Word2),
create(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3),
login("nico", "1234", Word3, Word4),
share(Word4, 0, ["T","C","W"], ["u1","u2"], Word5),
login("nico", "1234", Word5, Word6), 
add(Word6, 0, [1,1,1]," Extension 1", Word7),
login("nico", "1234", Word7, Word8),
restoreVersion(Word8, 0, 0, Word9).
*/



/* 
PREDICADOS


*/
