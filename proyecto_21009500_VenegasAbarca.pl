date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).



/* 

creacion de predicados para las funciones ya implementadas


date(dia, mes, año, Fecha).

predicados de apoyo
cambiar(Elemento1, Lista, Elemento2, ListaCambiada).

-------- TDA Paradigmadocs --------
paradigmadocs(Nombre, Fecha, paradigmaOut).
paraGAS(paradigma1, paradigma2).
paraIsLogin(paradigma1).
paraLogOut(paradigma1, paradigmaOut).
paraEditDocument(paradigma1, IDoc, Document, paradigmaOut).

-------- TDA Usuario ---------- solo necesitaba el constructor :(
usuario(Nombre, Password, Fecha, Usuario).


-------- TDA Documento --------
documento(ID, Nombre, Fecha, NombreA, Contenido, Document).
documentGAS(Document1, Document2).
documentAddPermiso(Document1, LPerms, DocumentOut).
documentAddUsers(Document1, LUsers, DocumentOut).
documentAddContent(Document1, Contenido, DocumentOut).
documentAddVersion(Document1, Version, DocumentOut).
documentSetContent(Document1, Contenido, DocumentOut).
addDocument(Usuario, Document, UsuarioOut).

-------- TDA Version --------
version(ID, Fecha, Contenido, Version).
getVersionById(Versiones, ID, Version).
getDocumentById(Lista, ID, Document).

canLogin(Usuario, Password, listaUsuarios).
canRegistrer(Nombre, listaUsuarios).


-------- Predicados Principales --------
register(Nombre, Password, Fecha, paradigmaIn, paradigmaOut).
login(Nombre, Password, paradigmaIn, paradigmaOut).
create(paradigmaIn, Fecha, Nombre, Contenido, paradigmaOut).
share(paradigmaIn, IDoc, Permisos, Usuarios, paradigmaOut).
add(paradigmaIn, IDoc, Fecha, Contenido, paradigmaOut).
restoreVersion(paradigmaIn, IDoc, IDVersion, paradigmaOut).


*/


% Hechos

emptyList([]).
permiso("W").
permiso("R").
permiso("C").



% Reglas

% Dom: Int, Int, Int, [Int, Int, Int]
% Meta: crear una fecha
cambiar(E, [E|Cola], NEl, [NEl|Cola]).
cambiar(E, [AE|Cola], NEl, [AE|NC]):-
    cambiar(E, Cola, NEl, NC).





%   Significado salida paradimadocs =[nombre, Fecha creacion, Lista de usuarios, lista de Documentos, usuario activo]
% Dom: String, date, paradigmadocs
% Meta: Crear un paradigmadocs
paradigmaDocs(Nombre, Date, [Nombre, Date, [], [], []]) :-
    string(Nombre),
    date(_, _, _,Date).


% GAS = Getter And Setter
% Dom: List, List
% Meta: poder extraer y setear datos de un paradigma
paraGAS([N, F, LU, LD, UA], [N, F, LU, LD, UA]).

% Dom: paradigmadocs
% Meta: comprobar si un usuario esta logueado en un paradigmadocs
paraIsLogin(Sn1) :-
    paraGAS(Sn1, [_, _, _, _, UA]),
    UA \= [].


% Dom: paradigmadocs, Int, Documento, paradigmadocs
% Meta: remplazar un documento en un paradigmadocs mediante su id
paraEditDocument(Sn1, IDoc, NDoc, SOut) :-
    paraGAS(Sn1, [N, F, LU, LD, UA]),
    getDocumentById(LD, IDoc, Doc),
    cambiar(Doc, LD, NDoc, NLD),
    paraGAS(SOut, [N, F, LU, NLD, UA]).

% Dom: paradigmadocs, paradigmadocs
% Meta: desloguear un usuario de un paradigmadocs
paraLogOut(Sn1, SOut) :-
    paraGAS(Sn1, [N, F, LU, LD, UA]),
    paraGAS(SOut, [N, F, LU, LD, []]).


% Dom: String, String, date, usuario
% Meta: crear un usuario, tambien se puede usar de getter y setter
usuario(Nombre, Password,Date, [Nombre, Password, Date]) :-
    string(Nombre),
    string(Password),
    date(_, _, _, Date).
 




% Dom: Int, String, date, String, String, Documento
% Meta: crear un documento
%                                             [id, nombre, fecha, autor, contenido, lista de permisos, lista de usuarios compartidos, lista de versiones]
documento(Id, Nombre, Date, Autor, Contenido, [Id, Nombre, Date, Autor, Contenido, [], [], []]) :-
    integer(Id),
    string(Nombre),
    date(_, _, _, Date),
    string(Autor),
    string(Contenido).


% Dom: Documento, Documento
% Meta: poder extraer y setear datos de un documento
documentGAS([Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones], [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]).

% Dom: Documento, List, Documento
% Meta: agregar una lista de permisos a un documento
documentAddPermiso(Sn1, Permisos, Sn2) :-
    documentGAS(Sn1, [Id, Nombre, Date, Autor, Contenido, Permiso, UsuariosCompartidos, Versiones]),
    append(Permiso, Permisos, NuevosPermisos),
    documentGAS(Sn2, [Id, Nombre, Date, Autor, Contenido, NuevosPermisos, UsuariosCompartidos, Versiones]).

% Dom: Documento, List, Documento
% Meta: agregar una lista de usuarios compartidos a un documento
documentAddUsers(Sn1, Usuarios, Sn2) :-
    documentGAS(Sn1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    append(UsuariosCompartidos, Usuarios, NuevosUsuarios),
    documentGAS([Id, Nombre, Date, Autor, Contenido, Permisos, NuevosUsuarios, Versiones], Sn2).


% Dom: Documento, String, Documento
% Meta: agregar contenido a un documento
documentAddContent(Doc1, Content, DOut) :-
    documentGAS(Doc1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    string_concat(Contenido, Content, NuevoContenido),
    documentGAS([Id, Nombre, Date, Autor, NuevoContenido, Permisos, UsuariosCompartidos, Versiones], DOut).

% Dom: Documento, version, Documento
% Meta: agregar una version a un documento
documentAddVersion(Doc1, Version, DOut) :-
    documentGAS(Doc1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    append(Versiones, [Version], NuevasVersiones),
    documentGAS([Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, NuevasVersiones], DOut).

% Dom: Documento, String, Documento
% Meta: setear el contenido de un documento
documentSetContent(Doc1, Content, DOut) :-
    documentGAS(Doc1, [Id, Nombre, Date, Autor, Contenido, Permisos, UsuariosCompartidos, Versiones]),
    documentGAS([Id, Nombre, Date, Autor, Content, Permisos, UsuariosCompartidos, Versiones], DOut).

% Dom: paradigmadocs, documento, paradigmadocs
% Meta: agregar un documento a un paradigmadocs
addDocument(Sn1, Document, SOut) :-
    paraGAS(Sn1, [_, _, _, LD, _]),
    append(LD, [Document], LD1),
    paraGAS([_, _, _, LD1, _], SOut).





% Dom: Lista de permisos
% Meta: Comprobar que solo hayan los permisos correctos
checkPermisos([]).
checkPermisos([Permiso|Cola]) :-
    permiso(Permiso),
    checkPermisos(Cola).


% Dom: Int, date, String, Version
% Meta: crear una version
version(Id, Fecha, Content, [Id, Fecha, Content]) :-
    integer(Id),
    date(_, _, _, Fecha),
    string(Content).


% Dom: Lista, Int, Documento
% Meta: obtener un documento por su id
getDocumentById([Document|_], Id, DocumentOut) :-
    documentGAS(Document, [Id, _, _, _, _, _, _, _]),
    DocumentOut = Document.
getDocumentById([_|Resto], Id, DocumentOut) :-
    getDocumentById(Resto, Id, DocumentOut).

% Dom: Lista, Int, Version
% Meta: obtener una version por su id
getVersionById([Version|_], Id, VersionOut) :-
    version(Id, _, _, Version),
    VersionOut = Version.
getVersionById([_|Resto], Id, VersionOut) :-
    getVersionById(Resto, Id, VersionOut).



% Dom: String, String, Lista
% Meta: verificar si un usuario se puede logear
canLogin(Nombre, Password, [[Nombre, Password,_]|_]).
canLogin(Nombre, Password, [[_, _,_]|Resto]) :-
    string(Nombre),
    string(Password),
    canLogin(Nombre, Password, Resto).



% Dom: String, Lista
% Meta: verificar si un usuario se puede logear
canRegister(Nombre, [[Nombre, _,_]|_]).
canRegister(Nombre, [[_, _,_]|Resto]) :-
    string(Nombre),
    canRegister(Nombre, Resto).


% Dom: String, String, date, paradigmas, paradigmas
% Meta: registar un usuario
paradigmaDocsRegister( Sn1, Date, Nombre, Password, SOut):-
    paraGAS(Sn1, [N, F, LU, LD, UA]),
    not(canRegister(Nombre, LU)),
    usuario(Nombre, Password, Date, Usuario),
    append(LU, [Usuario], NuevoUsuario),
    paraGAS(SOut, [N, F, NuevoUsuario, LD, UA]).


% Dom: String, String, paradigmas, paradigmas
% Meta: logear un usuario
paradigmaDocsLogin(Sn1, Nombre, Password, SOut) :-
    not(paraIsLogin(Sn1)),
    paraGAS(Sn1, [N, F, LU, LD, UA]),
    canLogin(Nombre, Password, LU),
    usuario(Nombre, Password, [-1,-1,-1], Usuario),
    append(UA, Usuario, UAA),
    paraGAS(SOut, [N, F, LU, LD, UAA]).


% Dom: paradigmadocs, date, String, String, paradigmas
% Meta: crear un documento y guardarlo en un paradigmadocs
paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido, SOut) :-
    paraIsLogin(Sn1),
    paraGAS(Sn1, [N, F, A, LD, UA]),
    date(_, _, _, Fecha),
    usuario(NombreA, _, _, UA),
    length(LD, Id),
    documento(Id, Nombre, Fecha, NombreA, Contenido, Document),
    addDocument(Sn1, Document, SOut),
    paraGAS(SOut, [N, F, A, _, []]).

% Dom: paradigmadocs, Int, lista, lista, paradigmadocs
% Meta: compartir un documento con otros usuarios
paradigmaDocsShare(Sn1, IDoc, LPerms, LUsers, SOut) :-
    paraIsLogin(Sn1),
    paraGAS(Sn1, [_, _, _, LD, UA]),
    usuario(NombreA, _, _, UA),
    checkPermisos(LPerms),
    getDocumentById(LD, IDoc, Document),
    documentGAS(Document, [_, _, _, Autor, Contenido, _, _, Versiones]),
    Autor == NombreA,
    documentAddPermiso(Document, LPerms, Document1),
    documentAddUsers(Document1, LUsers, Document2),
    paraEditDocument(Sn1, IDoc, Document2, Sn2),
    paraLogOut(Sn2, SOut).


% Dom paradigmadocs, Int, date, String, paradigmadocs
% Meta: añadir contenido a un documento
paradigmaDocsAdd(Sn1, IDoc, Fecha, Contenido, SOut) :-
    paraIsLogin(Sn1),
    paraGAS(Sn1, [_, _, _, LD, _]),
    getDocumentById(LD, IDoc, Document),
    documentAddContent(Document, Contenido, Document1),
    documentGAS(Document, [_, _, _, _, Cont, _, _, Versiones]),
    length(Versiones, Id),
    version(Id, Fecha, Cont, Version),
    documentAddVersion(Document1, Version, Document2),
    paraEditDocument(Sn1, IDoc, Document2, Sn2),
    paraLogOut(Sn2, SOut).


% Dom: paradigmadocs, Int, Int, paradigmadocs
% Meta: restaurar una version de un documento
paradigmaDocsRestoreVersion(Sn1, IDoc, IDVersion, SOut) :-
    paraIsLogin(Sn1),
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
    paraLogOut(Sn2, SOut).



/*

paradigmaDocs("Word", [27, 12, 2021], Word),
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234", Word1),   
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234234234", Word1).

paradigmaDocs("Word", [27, 12, 2021], Word),
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234", Word1),   
paradigmaDocsLogin(Word1, "nico", "1234", Word2).


paradigmaDocs("Word", [27, 12, 2021], Word),
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234", Word1),   
paradigmaDocsLogin(Word1, "nico", "1234", Word2),
paradigmaDocsCreate(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3).



paradigmaDocs("Word", [27, 12, 2021], Word),
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234", Word1),   
paradigmaDocsLogin(Word1, "nico", "1234", Word2),
paradigmaDocsCreate(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3),
paradigmaDocsLogin(Word3, "nico", "1234", Word4),
paradigmaDocsShare(Word4, 0, ["T","C","W"], ["u1","u2"], Word5).


paradigmaDocs("Word", [27, 12, 2021], Word),
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234", Word1),   
paradigmaDocsLogin(Word1, "nico", "1234", Word2),
paradigmaDocsCreate(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3),
paradigmaDocsLogin(Word3, "nico", "1234", Word4),
paradigmaDocsShare(Word4, 0, ["T","C","W"], ["u1","u2"], Word5),
paradigmaDocsLogin(Word5, "nico", "1234", Word6),
paradigmaDocsAdd(Word6, 0, [1,1,1]," Extension 1", Word7).


paradigmaDocs("Word", [27, 12, 2021], Word),
paradigmaDocsRegister(Word, [03,05,2020], "nico", "1234", Word1),   
paradigmaDocsLogin(Word1, "nico", "1234", Word2),
paradigmaDocsCreate(Word2, [4,4,2021], "Primer Documento", "Contenido 1", Word3),
paradigmaDocsLogin(Word3, "nico", "1234", Word4),
paradigmaDocsShare(Word4, 0, ["T","C","W"], ["u1","u2"], Word5),
paradigmaDocsLogin(Word5, "nico", "1234", Word6),
paradigmaDocsAdd(Word6, 0, [1,1,1]," Extension 1", Word7),
paradigmaDocsLogin(Word7, "nico", "1234", Word8),
paradigmaDocsRestoreVersion(Word8, 0, 0, Word9).

*/




