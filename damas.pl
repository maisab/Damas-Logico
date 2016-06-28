use_module(library(random)).

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

%casa invalida
casa_invalida(invalida).

%peca valida
peca_valida(pecaP).
peca_valida(pecaC).

%peca jogador
peca_jog(pecaP).

%peca computador
peca_comp(pecaC).

inicializar :- 
	tabuleiroInicial([[pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida],
	                 [invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP],
	                 [pecaP, invalida, pecaP, invalida, pecaP, invalida, pecaP, invalida],
	                 [invalida, pecaC, invalida, vazia, invalida, vazia, invalida, vazia],
	                 [vazia, invalida, vazia, invalida, vazia, invalida, vazia, invalida],
	                 [invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC],
	                 [pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida],
	                 [invalida, pecaC, invalida, pecaC, invalida, pecaC, invalida, pecaC]]).

tabuleiroInicial(X) :- jogo(X, 1, 12, 12), write('-Tchau-').

%----------------Vez--------------------------------------------------
% 1 - player
% 2 - computer
%------------------jogo-----------------------------------------------
jogo(T, V, NP, NC) :-

	( ((NP == 0, write(' -- Você Perdeu :( --')); (NC == 0, write(' -- Parabéns Você Venceu!--'))) , jogo([[]], 0, 0, 0) );
	(V == 1,
		 mostraTabuleiro(T), nl,

		 write('Digite a linha da peça atual : '), 			nl, read(I), 
		 write('Digite a coluna da peça atual: '),   		nl, read(J),
		 write('Digite a linha da casa de destino: '), 		nl, read(DX),
		 write('Digite a coluna da casa de destino: '), 	nl, read(DY),

		(posicaoValida(I, J, DX, DY); (nl, write(' -Posições inválidas- '), nl, jogo(T, 1, NP, NC)) ),

		((encontraPosicao(T, I, J, P), peca_jog(P), encontraPosicao(T, DX, DY, E), casa_valida(E), 
			movePeca(T, I, J, DX, DY, P, NovoTabuleiro), nl, nl, write(' -- Turno Computador --'), nl, nl, jogo(NovoTabuleiro, 2, NP, NC));

		  (encontraPosicao(T, I, J, P), peca_jog(P), encontraPosicao(T, DX, DY, E), peca_comp(E), 
			posicaoValidaComer(T, DX, DY), 
				comePeca(T, I, J, DX, DY, P, NovoTabuleiro), nl, nl, write(' -- Turno Computador --'), nl, nl, Pecas is NC -1, jogo(NovoTabuleiro, 2, NP, Pecas));
			
		  (nl, nl, write('-- Jogada Impossivel --'), nl, nl, jogo(T, 1, NP, NC))	%não conseguiu mover nem comer		  

		) 

	); 

	%turno computador
	( random(0, 8, IL), random(0, 8, JC),

		((encontraPosicao(T, IL, JC, P), peca_comp(P), 
		   (ID is IL - 1, JD is JC + 1, ( (encontraPosicao(T, ID, JD, K), casa_valida(K)); 
		   									((encontraPosicao(T, ID, JD, N), peca_jog(N)), 
		   									 	posicaoValidaComer(T, ID, JD) )))); jogo(T,2, NP, NC)),

		%mover direita
		(ID is IL - 1, JD is JC + 1, encontraPosicao(T, ID, JD, E), casa_valida(E),
			movePeca(T, IL, JC, ID, JD, pecaC, NovoTabuleiro), jogo(NovoTabuleiro,1, NP, NC));

		%mover esquerda
		(ID is IL - 1, JD is JC - 1, encontraPosicao(T, ID, JD, E), casa_valida(E),
			movePeca(T, IL, JC, ID, JD, pecaC, NovoTabuleiro), jogo(NovoTabuleiro,1, NP, NC));

		%comer direita
		(ID is IL - 1, JD is JC + 1, encontraPosicao(T, ID, JD, E), peca_jog(E),
			posicaoValidaComer(T, ID, JD), 
			comePeca(T, IL, JC, ID, JD, pecaC, NovoTabuleiro), Pecas is NP -1, jogo(NovoTabuleiro,1, Pecas, NC));

		%comer esquerda
		(ID is IL - 1, JD is JC - 1, encontraPosicao(T, ID, JD, E), peca_jog(E),
			posicaoValidaComer(T,ID, JD), 
			comePeca(T, IL, JC, ID, JD, pecaC, NovoTabuleiro), Pecas is NP -1, jogo(NovoTabuleiro,1, Pecas, NC))

	).

% movePeca(X, 5, 1, 4, 0, Novo), mostraTabuleiro(Novo).
%movePeca(X, 5, 1, 4, 0, Novo), nl, mostraTabuleiro(Novo).
%jogar(X, M), tabuleiroInicial(M)

%-----------------posicaoValida---------------------
posicaoValida(X,Y, DestinoX, DestinoY) :- 
	(X >= 0, DestinoX is X + 1), 	%se a linha está no tabuleiro e o destino é a proxima linha 
	((Y >= 0; Y =< 7), (DestinoY is Y + 1; DestinoY is Y - 1)). 	%se a coluna está no tabuleiro e a casa é alcançavel

%-----------------posicaoValidaParaComerJogador-------------
posicaoValidaComer(T, DestinoX, DestinoY) :- %verifica se pode comer
	I is DestinoX + 1, 
	(J is DestinoY + 1; J is DestinoY - 1), 
	encontraPosicao(T, I, J, E), 
	casa_valida(E).

%-----------------posicaoValidaParaComerComputador-------------
posicaoValidaComer(T, DestinoX, DestinoY) :- %verifica se pode comer
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
movePeca(T, X, Y, DestinoX, DestinoY, PAtual, NovoTabuleiro) :-
	DestinoX is X + 1,
	trocaPosicao(T, X, Y,vazia, Novo),
	trocaPosicao(Novo, DestinoX, DestinoY, PAtual, NovoTabuleiro).

%-------------movePecaComputador-------------------
movePeca(T, X, Y, DestinoX, DestinoY, PAtual, NovoTabuleiro) :-
	DestinoX is X - 1,
	trocaPosicao(T, X, Y,vazia, Novo),
	trocaPosicao(Novo, DestinoX, DestinoY, PAtual, NovoTabuleiro).

%-------------comePecaDireitaJogador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, PAtual, NovoTabuleiro) :-
	DestinoX is X + 1, DestinoY is Y + 1, 
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX + 1, NovoY is DestinoY + 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro).

%-------------comePecaEsquerdaJogador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, PAtual, NovoTabuleiro) :-
	DestinoX is X + 1, DestinoY is Y - 1, 
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX + 1, NovoY is DestinoY - 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro).

%-------------comePecaDireitaComputador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, PAtual, NovoTabuleiro) :-
	DestinoX is X - 1, DestinoY is Y + 1, 
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX - 1, NovoY is DestinoY + 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro).

%-------------comePecaEsquerdaComputador------------------- 
comePeca(T, X, Y, DestinoX, DestinoY, PAtual, NovoTabuleiro) :-
	DestinoX is X - 1, DestinoY is Y - 1, 
	trocaPosicao(T, X, Y, vazia, Novo), 
	trocaPosicao(Novo, DestinoX, DestinoY, vazia, Board),
	NovoX is DestinoX - 1, NovoY is DestinoY - 1,
	trocaPosicao(Board, NovoX, NovoY, PAtual, NovoTabuleiro).