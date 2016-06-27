tabuleiroInicial(X) :- X =	[[pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida],
		                     [invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP],
		                     [pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida],
		                     [invalida, vazia, invalida, vazia, invalida, vazia, invalida, vazia],
		                     [vazia, invalida, vazia, invalida, vazia, invalida, vazia, invalida],
		                     [invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC],
		                     [pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida],
		                     [invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC]].


%Regras para exibir o tabuleiro
mostrar(pecaP, 'p').
mostrar(pecaC, 'c').
mostrar(invalida,'0').
mostrar(vazia, '1').

%pecas inimigas
inimigo(pecaP, pecaC).
inimigo(pecaC, pecaP).

%casa valida
casa_valida(vazia).

%peca valida
peca_valida(pecaP).
peca_valida(pecaC).

inicializar :- 
	tabuleiroInicial(X), 
	assert(tabuleiro(X)),
	mostraTabuleiro(X),
	jogar(X).

jogar(T) :- trocaPosicao(T, 2, 2, invalida, Novo), write(Novo), nl,  mostraTabuleiro(Novo).

%-----------------posicaoValidaJogador---------------------
posicaoValidaJogador(X,Y, DestinoX, DestinoY) :- 
	((X >= 0; X =< 7), DestinoX is X + 1), %se a linha está no tabuleiro e o destino é a proxima linha 
	((Y >= 0; Y =< 7), (DestinoY is Y + 1; DestinoY is Y - 1)). %se a coluna está no tabuleiro e a casa é alcançavel

%-----------------posicaoValidaComputador---------------------
posicaoValidaComputador(X,Y, DestinoX, DestinoY) :- 
	((X >= 0; X =< 7), DestinoX is X - 1), %se a linha está no tabuleiro e o destino é a proxima linha 
	((Y >= 0; Y =< 7), (DestinoY is Y + 1; DestinoY is Y - 1)). %se a coluna está no tabuleiro e a casa é alcançavel

%-----------------posicaoValidaParaComerJogador-------------
posicaoValidaComerJogador(DestinoX, DestinoY) :- %verifica se pode comer
	I is DestinoX + 1, 
	(J is DestinoY + 1; J is DestinoY - 1 ), 
	encontraPosicao(I, J, E), 
	casa_valida(E).

%-----------------posicaoValidaParaComerComputador-------------
posicaoValidaComerComputador(DestinoX, DestinoY) :- %verifica se pode comer
	I is DestinoX - 1, 
	(J is DestinoY + 1; J is DestinoY - 1 ), 
	encontraPosicao(I, J, E), 
	casa_valida(E).  

%-----------------imprimirTabuleiro -------------
mostraTabuleiro(T) :- 
	write('     0   1   2   3   4   5   6   7	'), nl,
    tabuleiro(T), imprimirLinha(0, T),!.
                
imprimirLinha(8,_). 
imprimirLinha(Pos,[Hd|Ht]) :- 
	write(Pos), write(' '), imprimirColuna(Hd),
    PosAux is Pos + 1, nl, imprimirLinha(PosAux,Ht).

imprimirColuna([]).                            
imprimirColuna([Hd|Ht]) :- 
      mostrar(Hd, X),write(' | '),write(X), imprimirColuna(Ht).

%-----------------encontraPosicao -------------
encontraPosicao(Linha,Coluna,E) :- tabuleiro(X), encontraLinha(Linha, Coluna, X, E), !.

encontraLinha(0, J, [H|_], E):- encontraColuna(J, H, E). %quando encontrar a linha, vai para a coluna
encontraLinha(I, J, [_|T], E):- X is I - 1, encontraLinha(X, J, T, E). %decrementa ate chegar na posicao correta

encontraColuna(0, [H|_], H):- !. %quando encontrar a coluna, retorna o head
encontraColuna(J, [_|T], E):- X is J - 1, encontraColuna(X, T, E). %decrementa ate chegar na posicao correta

%-----------------trocaPosicao ---------------
trocaPosicao(T,X,Y,NovaPeca, NovoTabuleiro) :- 
	tabuleiro(T), retract(tabuleiro(_)),  %remove o tabuleiro atual
    trocaLista(X,Y,NovaPeca,T,NovoTabuleiro),
    assert(tabuleiro(NovoTabuleiro)). %atualiza o tabuleiro
                      
trocaLista(0,Y,NovaPeca,[H|T],[NovoTabuleiro|T]) :- trocaColuna(Y,NovaPeca,H,NovoTabuleiro).
trocaLista(X,Y,NovaPeca,[H|T],[H|NovoTabuleiro]) :- AuxX is X - 1, trocaLista(AuxX,Y,NovaPeca,T,NovoTabuleiro).
                      
trocaColuna(0,NovaPeca,[_|T], [NovaPeca|T]).                      
trocaColuna(Y,NovaPeca,[H|T],[H|NovoTabuleiro]) :- AuxY is Y - 1, trocaColuna(AuxY,NovaPeca,T,NovoTabuleiro).

%-------------movePeca-------------------
movePeca(X, Y, DestinoX, DestinoY) :-
	DestinoX is X + 1, 
	posicaoValidaJogador(X, Y, DestinoX, DestinoY), 
	encontraPosicao(X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(DestinoX, DestinoY, C), casa_valida(C),
	trocaPosicao(X,Y,vazia),
	trocaPosicao(DestinoX, DestinoY, PAtual), mostraTabuleiro.

%-------------movePecaComputador-------------------
movePeca(X, Y, DestinoX, DestinoY) :-
	DestinoX is X - 1,
	posicaoValidaComputador(X, Y, DestinoX, DestinoY), 
	encontraPosicao(X, Y, PAtual), peca_valida(PAtual), 
	encontraPosicao(DestinoX, DestinoY, C), casa_valida(C),
	trocaPosicao(X,Y,vazia),
	trocaPosicao(DestinoX, DestinoY, PAtual), mostraTabuleiro.

%-------------comePecaDireitaJogador------------------- 
comePeca(X, Y, DestinoX, DestinoY) :-
	DestinoX is X + 1, DestinoY is Y + 1, 
	posicaoValidaJogador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerJogador(DestinoX, DestinoY), 
	encontraPosicao(X, Y, PAtual), 
	peca_valida(PAtual), 
	encontraPosicao(DestinoX, DestinoY, PDestino), 
	inimigo(PAtual,PDestino),
	trocaPosicao(X,Y,vazia),
	trocaPosicao(DestinoX,DestinoY,vazia),
	NovoX is DestinoX + 1, NovoY is DestinoY + 1,
	trocaPosicao(NovoX, NovoY, PAtual), mostraTabuleiro.

%-------------comePecaEsquerdaJogador------------------- 
comePeca(X, Y, DestinoX, DestinoY) :-
	DestinoX is X + 1, DestinoY is Y - 1, 
	posicaoValidaJogador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerJogador(DestinoX, DestinoY), 
	encontraPosicao(X, Y, PAtual), 
	peca_valida(PAtual), 
	encontraPosicao(DestinoX, DestinoY, PDestino), 
	inimigo(PAtual,PDestino),
	trocaPosicao(X,Y,vazia),
	trocaPosicao(DestinoX,DestinoY,vazia),
	NovoX is DestinoX + 1, NovoY is DestinoY - 1,
	trocaPosicao(NovoX, NovoY, PAtual), mostraTabuleiro.

%-------------comePecaDireitaComputador------------------- 
comePeca(X, Y, DestinoX, DestinoY) :-
	DestinoX is X - 1, DestinoY is Y + 1, 
	posicaoValidaComputador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerComputador(DestinoX, DestinoY), 
	encontraPosicao(X, Y, PAtual), 
	peca_valida(PAtual), 
	encontraPosicao(DestinoX, DestinoY, PDestino), 
	inimigo(PAtual,PDestino),
	trocaPosicao(X,Y,vazia),
	trocaPosicao(DestinoX,DestinoY,vazia),
	NovoX is DestinoX - 1, NovoY is DestinoY + 1,
	trocaPosicao(NovoX, NovoY, PAtual), mostraTabuleiro.

%-------------comePecaEsquerdaComputador------------------- 
comePeca(X, Y, DestinoX, DestinoY) :-
	DestinoX is X - 1, DestinoY is Y - 1, 
	posicaoValidaComputador(X, Y, DestinoX, DestinoY),
	posicaoValidaComerComputador(DestinoX, DestinoY), 
	encontraPosicao(X, Y, PAtual), 
	peca_valida(PAtual), 
	encontraPosicao(DestinoX, DestinoY, PDestino), 
	inimigo(PAtual,PDestino),
	trocaPosicao(X,Y,vazia),
	trocaPosicao(DestinoX,DestinoY,vazia),
	NovoX is DestinoX - 1, NovoY is DestinoY - 1,
	trocaPosicao(NovoX, NovoY, PAtual), mostraTabuleiro.
