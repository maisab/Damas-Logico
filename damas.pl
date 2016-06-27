%Regras para exibir o tabuleiro
mostrar(pecaP, ' p ').
mostrar(pecaC, ' c ').
mostrar(invalida,'___').
mostrar(vazia, ' 1 ').

%pecas inimigas
inimigo(pecaP, pecaC).
inimigo(pecaC, pecaP).

%casa valida
casa_valida(vazia).

%peca valida
peca_valida(pecaP).
peca_valida(pecaC).

inicializar :- 
	tabuleiroInicial([[pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida],
	                 [invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP],
	                 [pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida],
	                 [invalida, vazia, invalida, vazia, invalida, vazia, invalida, vazia],
	                 [vazia, invalida, vazia, invalida, vazia, invalida, vazia, invalida],
	                 [invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC],
	                 [pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida],
	                 [invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC]]).

tabuleiroInicial(X) :- mostraTabuleiro(X), movePeca(X, 5, 1, 7, 1, Novo), mostraTabuleiro(Novo).
%movePeca(X, 5, 1, 4, 0, Novo), nl, mostraTabuleiro(Novo).
%jogar(X, M), tabuleiroInicial(M)

%-----------------posicaoValidaJogador---------------------
posicaoValidaJogador(X,Y, DestinoX, DestinoY) :- 
	((X >= 0; X =< 7), DestinoX is X + 1), 							%se a linha está no tabuleiro e o destino é a proxima linha 
	((Y >= 0; Y =< 7), (DestinoY is Y + 1; DestinoY is Y - 1)). 	%se a coluna está no tabuleiro e a casa é alcançavel

%-----------------posicaoValidaComputador---------------------
posicaoValidaComputador(X,Y, DestinoX, DestinoY) :- 
	((X >= 0; X =< 7), DestinoX is X - 1), 							%se a linha está no tabuleiro e o destino é a proxima linha 
	((Y >= 0; Y =< 7), (DestinoY is Y + 1; DestinoY is Y - 1)). 	%se a coluna está no tabuleiro e a casa é alcançavel

%-----------------posicaoValidaParaComerJogador-------------
posicaoValidaComerJogador(T, DestinoX, DestinoY) :- %verifica se pode comer
	I is DestinoX + 1, 
	(J is DestinoY + 1; J is DestinoY - 1 ), 
	encontraPosicao(T, I, J, E), 
	casa_valida(E).

%-----------------posicaoValidaParaComerComputador-------------
posicaoValidaComerComputador(T, DestinoX, DestinoY) :- %verifica se pode comer
	I is DestinoX - 1, 
	(J is DestinoY + 1; J is DestinoY - 1 ), 
	encontraPosicao(T, I, J, E), 
	casa_valida(E).  

%-----------------imprimirTabuleiro -------------
mostraTabuleiro(T) :- 
	write('      0     1     2     3     4     5     6     7	'), nl,
	write('    ______________________________________________'), nl,
    imprimirLinha(0, T),!.
                
imprimirLinha(8,_). 
imprimirLinha(Pos,[Hd|Ht]) :- 
	write(Pos), write(' '), imprimirColuna(Hd),
    PosAux is Pos + 1, nl, imprimirLinha(PosAux,Ht).

imprimirColuna([]).                            
imprimirColuna([Hd|Ht]) :- 
      mostrar(Hd,X), write(' | '),write(X), imprimirColuna(Ht).

%-----------------encontraPosicao -------------
encontraPosicao(T,Linha,Coluna,E) :- encontraLinha(Linha, Coluna, T, E), !.

encontraLinha(0, J, [H|_], E):- encontraColuna(J, H, E). 				%quando encontrar a linha, vai para a coluna
encontraLinha(I, J, [_|T], E):- X is I - 1, encontraLinha(X, J, T, E). 	%decrementa ate chegar na posicao correta

encontraColuna(0, [H|_], H):- !. 										%quando encontrar a coluna, retorna o head
encontraColuna(J, [_|T], E):- X is J - 1, encontraColuna(X, T, E). 		%decrementa ate chegar na posicao correta

%-----------------trocaPosicao ---------------
trocaPosicao(T,X,Y,NovaPeca, NovoTabuleiro) :- 
    trocaLista(X,Y,NovaPeca,T,NovoTabuleiro).
                      
trocaLista(0,Y,NovaPeca,[H|T],[NovoTabuleiro|T]) :- trocaColuna(Y,NovaPeca,H,NovoTabuleiro).
trocaLista(X,Y,NovaPeca,[H|T],[H|NovoTabuleiro]) :- AuxX is X - 1, trocaLista(AuxX,Y,NovaPeca,T,NovoTabuleiro).
                      
trocaColuna(0,NovaPeca,[_|T], [NovaPeca|T]).                      
trocaColuna(Y,NovaPeca,[H|T],[H|NovoTabuleiro]) :- AuxY is Y - 1, trocaColuna(AuxY,NovaPeca,T,NovoTabuleiro).

%-------------movePeca-------------------
movePeca(T, X, Y, DestinoX, DestinoY, NovoTabuleiro) :-
	(DestinoX is X + 1,
	posicaoValidaJogador(X, Y, DestinoX, DestinoY), 
	encontraPosicao(T, X, Y, PAtual), peca_valida(PAtual),
	encontraPosicao(T, DestinoX, DestinoY, C), casa_valida(C),
	trocaPosicao(T, X, Y,vazia, Novo),
	trocaPosicao(Novo, DestinoX, DestinoY, PAtual, NovoTabuleiro));
	write('- Movimento Inválido -').

%-------------movePecaComputador-------------------
movePeca(T, X, Y, DestinoX, DestinoY, NovoTabuleiro) :-
	(DestinoX is X - 1,
	posicaoValidaComputador(X, Y, DestinoX, DestinoY), 
	encontraPosicao(T, X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(T, DestinoX, DestinoY, C), casa_valida(C),
	trocaPosicao(T, X, Y,vazia, Novo),
	trocaPosicao(Novo, DestinoX, DestinoY, PAtual, NovoTabuleiro)),
	write('- Movimento Inválido -').

%-------------comePecaDireitaJogador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, NovoTabuleiro) :-
	(DestinoX is X + 1, DestinoY is Y + 1, 
	posicaoValidaJogador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerJogador(T, DestinoX, DestinoY), 
	encontraPosicao(T, X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(T, DestinoX, DestinoY, PDestino), inimigo(PAtual,PDestino),
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX + 1, NovoY is DestinoY + 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro));
	write('- Movimento Inválido -').

%-------------comePecaEsquerdaJogador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, NovoTabuleiro) :-
	(DestinoX is X + 1, DestinoY is Y - 1, 
	posicaoValidaJogador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerJogador(T, DestinoX, DestinoY), 
	encontraPosicao(T, X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(T, DestinoX, DestinoY, PDestino), inimigo(PAtual,PDestino),
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX + 1, NovoY is DestinoY - 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro));
	write('- Movimento Inválido -').

%-------------comePecaDireitaComputador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, NovoTabuleiro) :-
	(DestinoX is X - 1, DestinoY is Y + 1, 
	posicaoValidaComputador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerComputador(T, DestinoX, DestinoY), 
	encontraPosicao(T, X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(T, DestinoX, DestinoY, PDestino), inimigo(PAtual,PDestino),
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX - 1, NovoY is DestinoY + 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro));
	write('- Movimento Inválido -').

%-------------comePecaEsquerdaComputador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, NovoTabuleiro) :-
	(DestinoX is X - 1, DestinoY is Y - 1, 
	posicaoValidaComputador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerComputador(T, DestinoX, DestinoY), 
	encontraPosicao(T, X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(T, DestinoX, DestinoY, PDestino), inimigo(PAtual,PDestino),
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX - 1, NovoY is DestinoY - 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro));
	write('- Movimento Inválido -').