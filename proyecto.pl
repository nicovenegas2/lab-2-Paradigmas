date(Dia, Mes, Agno, [Dia, Mes, Agno]):- integer(Dia), integer(Mes),
integer(Agno).


paradigmadocs(Nombre, [Dia, Mes, Agno], [Nombre, Date]) :-
    string(Nombre),
    date(Dia, Mes, Agno,Date).


