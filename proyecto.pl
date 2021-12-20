date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


paradigmadocs(Nombre, Date, [Nombre, Date]) :-
    string(Nombre),
    date(Date).