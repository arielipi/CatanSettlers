:- dynamic(road/3). % road(coord(X,Y), coord(Z,W), Color).
:- dynamic(dummyroad/2). % road(coord(X,Y), coord(Z,W)). is used to mark possible places to build roads
:- dynamic(player/2). % player(Resource-Amount, Color).
:- dynamic(town/2). % town(coord(X,Y), Color).
:- dynamic(city/2). % city(coord(X,Y), Color).
:- dynamic(lastroadbuilt/3). %used to denote to java what was the last road that was built



% File Name - map.pl
% Description - This program builds the model of the Catan map and supports the AI.
% Input - none
% Output - none
% Synopsys - run the java program.  






% resources facts - which resources exist
resource(wood).
resource(clay).
resource(metal).
resource(sheep).
resource(wheat).
resource(desert).

%resource(road, color). old approach not developed
%resource(town, color).
%resource(city, color).


getResourcesByColor(red, Resources):-
	player(Resources,red).

getResourcesByColor(blue, Resources):-
	player(Resources,blue).

getPlayerResources(player(Resources,red), Resources).

getPlayerResources(player(Resources,blue), Resources).

getPlayer(red, player(Resources, red)):-
	player(Resources, red).
getPlayer(blue, player(Resources, blue)):-
	player(Resources, blue).

%coords(X, Y).

%cell([Coords], ResourceType, Oddity).

%player([ResourceType-Number]).
%road(StartCoord, EndCoord, Color).

%%%%%%%%%%%%%%%%%%%%%%%%%%
% map data

% coords
coords(0, 3). coords(0, 5). coords(0, 7).
coords(1, 2). coords(1, 4). coords(1, 6). coords(1, 8).
coords(2, 2). coords(2, 4). coords(2, 6). coords(2, 8).
coords(3, 1). coords(3, 3). coords(3, 5). coords(3, 7). coords(3, 9).
coords(4, 1). coords(4, 3). coords(4, 5). coords(4, 7). coords(4, 9).
coords(5, 0). coords(5, 2). coords(5, 4). coords(5, 6). coords(5, 8). coords(5, 10).
coords(6, 0). coords(6, 2). coords(6, 4). coords(6, 6). coords(6, 8). coords(6, 10).
coords(7, 1). coords(7, 3). coords(7, 5). coords(7, 7). coords(7, 9).
coords(8, 1). coords(8, 3). coords(8, 5). coords(8, 7). coords(8, 9).
coords(9, 2). coords(9, 4). coords(9, 6). coords(9, 8).
coords(10, 2). coords(10, 4). coords(10, 6). coords(10, 8).
coords(11, 3). coords(11, 5). coords(11, 7).
% end coords


% cells
% cell([CoordsList], resource(type), oddity, oddity value).

% first row
cell([coords(0, 3), coords(1, 2), coords(1, 4), coords(2, 2), coords(2, 4), coords(3, 3)], resource(sheep), 10, 3).
cell([coords(0, 5), coords(1, 4), coords(1, 6), coords(2, 4), coords(2, 6), coords(3, 5)], resource(clay), 9, 4).
cell([coords(0, 7), coords(1, 6), coords(1, 8), coords(2, 6), coords(2, 8), coords(3, 7)], resource(clay), 6, 5).
% end first row

% second row
cell([coords(2, 2), coords(3, 1), coords(3, 3), coords(4, 1), coords(4, 3), coords(5, 2)], resource(wood), 5, 4).
cell([coords(2, 4), coords(3, 3), coords(3, 5), coords(4, 3), coords(4, 5), coords(5, 4)], resource(metal), 4, 3).
cell([coords(2, 6), coords(3, 5), coords(3, 7), coords(4, 5), coords(4, 7), coords(5, 6)], resource(desert), 0, 0).
cell([coords(2, 8), coords(3, 7), coords(3, 9), coords(4, 7), coords(4, 9), coords(5, 8)], resource(clay), 5, 4).
% end second row

% third row
cell([coords(4, 1), coords(5, 0), coords(5, 2), coords(6, 0), coords(6, 2), coords(7, 1)], resource(metal), 6, 5).
cell([coords(4, 3), coords(5, 2), coords(5, 4), coords(6, 2), coords(6, 4), coords(7, 3)], resource(wood), 11, 2).
cell([coords(4, 5), coords(5, 4), coords(5, 6), coords(6, 4), coords(6, 6), coords(7, 5)], resource(sheep), 8, 5).
cell([coords(4, 7), coords(5, 6), coords(5, 8), coords(6, 6), coords(6, 8), coords(7, 7)], resource(sheep), 2, 1).
cell([coords(4, 9), coords(5, 8), coords(5, 10), coords(6, 8), coords(6, 10), coords(7, 9)], resource(metal), 3, 2).
% end third row

% fourth row
cell([coords(6, 2), coords(7, 1), coords(7, 3), coords(8, 1), coords(8, 3), coords(9, 2)], resource(sheep), 9, 4).
cell([coords(6, 4), coords(7, 3), coords(7, 5), coords(8, 3), coords(8, 5), coords(9, 4)], resource(wheat), 4, 3).
cell([coords(6, 6), coords(7, 5), coords(7, 7), coords(8, 5), coords(8, 7), coords(9, 6)], resource(wheat), 11, 2).
cell([coords(6, 8), coords(7, 7), coords(7, 9), coords(8, 7), coords(8, 9), coords(9, 8)], resource(wood), 8, 5).
% end fourth row

% fifth row
cell([coords(8, 3), coords(9, 2), coords(9, 4), coords(10, 2), coords(10, 4), coords(11, 3)], resource(wheat), 3, 2).
cell([coords(8, 5), coords(9, 4), coords(9, 6), coords(10, 4), coords(10, 6), coords(11, 5)], resource(wood), 12, 1).
cell([coords(8, 7), coords(9, 6), coords(9, 8), coords(10, 6), coords(10, 8), coords(11, 7)], resource(wheat), 10, 3).
% end fifth row
% end cells

% end map data
%%%%%%%%%%%%%%%%%%%%%%%%%%

% dice predicates

% find win points of player based on color
findPoints(Color, Result):-
	findall(City, city(X,Color), Cities),
	findall(Town, town(X,Color), Towns),
	length(Cities, CitiesLength),
	length(Towns, TownsLength),
	Result is TownsLength + CitiesLength*2.


rollDiceResult(Result):-
	rollDice(Dice),
	rollDice(Dice2),
	Result is Dice + Dice2.

rollDice(Dice):-
	random_between(1, 6, Dice).

updateResourcesDice(7, _, CurrentResources, CurrentResources).

updateResourcesDice(12, Color, CurrentResources, UpdatedResources):-
	getCellsByOddity(12, CellsList), !,
	nth0(0, CellsList, FirstCell),
	updateResource(Color, FirstCell, Resource-Amount),
	updateResources(CurrentResources, Resource-Amount, UpdatedResources).
	
updateResourcesDice(2, Color, CurrentResources, UpdatedResources):-
	getCellsByOddity(2, CellsList), !,
	nth0(0, CellsList, FirstCell),
	updateResource(Color, FirstCell, Resource-Amount),
	updateResources(CurrentResources, Resource-Amount, UpdatedResources).

% since only 2 and 12 have only one cell and 7 doesnt do anything i split it to 4 predicates.
% all the other oddities have 2 cells each.
updateResourcesDice(Oddity, Color, CurrentResources, UpdatedResources):-
	getCellsByOddity(Oddity, CellsList), !,
	nth0(0, CellsList, FirstCell, _),
	nth0(1, CellsList, SecondCell, _),
	updateResource(Color, FirstCell, Resource1-Amount1),
	updateResource(Color, SecondCell, Resource2-Amount2),
	updateResources(CurrentResources, Resource1-Amount1, Resource2-Amount2, UpdatedResources).

% for cases of 2 and 12
updateResources([], _, []).

updateResources([Resource1-AmountResource1 | Tail], Resource1-Amount1, [Resource1-UpdatedAmountResource1| Tail2]):-
	UpdatedAmountResource1 is AmountResource1 + Amount1,
	updateResources(Tail, Resource1-Amount1, Tail2).

updateResources([Resource-Amount | Tail], Resource1-Amount1, [Resource-Amount | Tail2]):-
	updateResources(Tail, Resource1-Amount1, Tail2).


% for all cases
updateResources([], _, _, []).

updateResources([Resource1-AmountResource1 | Tail], Resource1-Amount1, Resource2-Amount2, [Resource1-UpdatedAmountResource1| Tail2]):-
	UpdatedAmountResource1 is AmountResource1 + Amount1,
	updateResources(Tail, Resource1-Amount1, Resource2-Amount2, Tail2).

updateResources([Resource2-AmountResource2 | Tail], Resource1-Amount1, Resource2-Amount2, [Resource2-UpdatedAmountResource2| Tail2]):-
	UpdatedAmountResource2 is AmountResource2 + Amount2,
	updateResources(Tail, Resource1-Amount1, Resource2-Amount2, Tail2).

updateResources([Resource3-Amount3 | Tail], Resource1-Amount1, Resource2-Amount2, [Resource3-Amount3 | Tail2]):-
	updateResources(Tail, Resource1-Amount1, Resource2-Amount2, Tail2).

% get amount of said resource to update based on given color
getAmount(_, [], 0).

getAmount(Color, [coords(Line, Column) | Coords], Amount):-
	town(coords(Line, Column), Color),
	getAmount(Color, Coords, Amount2),
	Amount is 1 + Amount2.

getAmount(Color, [coords(Line, Column) | Coords], Amount):-
	city(coords(Line, Column), Color),
	getAmount(Color, Coords, Amount2),
	Amount is 2 + Amount2.
	
getAmount(Color, [coords(Line, Column) | Coords], Amount):-
	getAmount(Color, Coords, Amount).

updateResource(Color, Coords-Resource, Resource-Amount):-
	getAmount(Color, Coords, Amount).


%%%%%%%%
% cells predicates
%%%%%%%%

% get Coords-Resource of all cells	
getCellsByOddity(Oddity, Result):-
	findall(Coords-Resource, cell(Coords, Resource, Oddity, OddityValue), Result).

%get coords of all cells	
getCellsListByOddity(Oddity, Result):-
	findall(Coords, cell(Coords, Resource, Oddity, OddityValue), Result).

getResource(Coords-Resource, Resource).

% get coords of given coords-resource
getCells(Coords-Resource, Coords).
setResource(resource(Resource), Resource).

% this is not a used predicate, i left it to show a different approach i had to update resources
getResourceOfCell(Oddity, Coords, Resource):-
	% return a list of lists of all cells' coords of oddity Oddity.
	getCellsByOddity(Oddity, CellsCoords),
	% break into two, either one or two cells of oddity Oddity
	nth0(0, CellsCoords, E, _),
	% Coords1 will only hold coords
	getCells(E, Coords1),
	% if Coords (checked position) is in Coords1 then get E (cell) resource, otherwise get R (cell) resource
	member(Coords, Coords1) ->
		getResource(E, Resource2),
		setResource(Resource2, Resource), !
	;
	nth0(1, CellsCoords, _, R),
	getCells(R, Coords2),
	getResource(R, Resource2),
	setResource(Resource2, Resource), !.

averageCells2([], 0, 0).
averageCells2([Coords-Resource-Oddity-OddityValue | Cells], I, Sum):-
	 averageCells2(Cells, I1, Sum2),
	 Sum is Sum2 + OddityValue,
	 I is I1 + 1.

averageCells([],0).
averageCells(Cells, Average):-
	averageCells2(Cells, I, SumOddities),
	Average is SumOddities/I.

getCellsByCoord(X,[],[]).
getCellsByCoord(coords(Line,Column), [Coords-Resource-Oddity-OddityValue | Cells1], [Coords-Resource-Oddity-OddityValue | CellsToBuild]):-
	member(coords(Line,Column), Coords),
	getCellsByCoord(coords(Line,Column), Cells1, CellsToBuild).
	
getCellsByCoord(coords(Line,Column), [Coords-Resource-Oddity-OddityValue | Cells1], CellsToBuild):-
	getCellsByCoord(coords(Line,Column), Cells1, CellsToBuild).

getCellsByCoord(coords(Line,Column), Cells):-
	findall(Coords-Resource-Oddity-OddityValue,cell(Coords,Resource,Oddity, OddityValue),Cells1),
	getCellsByCoord(coords(Line,Column), Cells1, Cells).


%%%%%%%%
% roads predicates
%%%%%%%%


getLastRoad(LastRoad):-
	findall(X-Y,lastroadbuilt(X, Y, Z),LastRoad).

% again this is not used
getAllRoads(Paths):-
	findall(road(X,Y,Z), road(X,Y,Z), Paths).
% again this is not used
getAllRoadsByColor(Color, Paths):-
	findall(road(X,Y,Color), road(X,Y,Color), Paths).

% checks if given coords exist as a road already, unifies ReturnValue accordingly
checkRoadExist(coords(Line1, Column1), coords(Line2, Column2), ReturnValue):-
	not(road(coords(Line1, Column1), coords(Line2, Column2), Color)) ->
		ReturnValue is 0
	;
	ReturnValue is 1. % road taken

% checks if PlayerResources holds enough resources to build a road.
checkRoadResources(PlayerResources, ReturnValue):-
	numberOfWood(PlayerResources, WoodNumber), WoodNumber > 0 ->
	(
		numberOfClay(PlayerResources, ClayNumber), ClayNumber > 0 ->
			ReturnValue is 0
		;
		ReturnValue is 2 % not enough clay
	) 
	;
	ReturnValue is 1. % not enough wood

% checks if one of the ends of desired road is connected to another road and that both ends of desired road are connected.
checkConnectivityRoad(coords(Line1, Column1), coords(Line2, Column2), Color, ReturnValue):-	
	(
	road(coords(Line1, Column1), coords(X,Y), Color),
		(
		dummyroad(coords(Line1, Column1), coords(Line2, Column2))
		;
		dummyroad(coords(Line2, Column2), coords(Line1, Column1))
		)
	;
	road(coords(Line2, Column2), coords(X,Y), Color),
		(
		dummyroad(coords(Line1, Column1), coords(Line2, Column2))
		;
		dummyroad(coords(Line2, Column2), coords(Line1, Column1))
		)
	) -> 
		ReturnValue is 0
	;
	ReturnValue is 1. % no connectivity

% build a road
buildRoad(coords(Line1, Column1), coords(Line2, Column2), Color):-
	assert(road(coords(Line1, Column1), coords(Line2, Column2), Color)),
	assert(road(coords(Line2, Column2), coords(Line1, Column1), Color)),
	retract(dummyroad(coords(Line1, Column1), coords(Line2, Column2))),
	retract(dummyroad(coords(Line2, Column2), coords(Line1, Column1))),
	retract(lastroadbuilt(X,Y,Z)) ->
		assert(lastroadbuilt(coords(Line2, Column2), coords(Line1, Column1), Color))
	;
	assert(lastroadbuilt(coords(Line2, Column2), coords(Line1, Column1), Color)).

getRoadsConnectedToPoint(coords(Line, Column), ReturnValue):-
	findall(coords(Line1, Column2), road(coords(Line, Column), coords(Line1, Column2), Color), RoadsReturnValue),
	findall(coords(Line3, Column4), dummyroad(coords(Line, Column), coords(Line3, Column4)), DummyRoadsReturnValue),
	append(RoadsReturnValue, DummyRoadsReturnValue, ReturnValue).

% this is not used either, it would have been getRoadsConnectedToPoint but the need for color was redundant in the end
% after i added dummyroad.
getPlayerRoadsConnectedToPoint(coords(Line, Column), Color, ReturnValue):-
	findall(coords(Line1, Column2), road(coords(Line, Column), coords(Line1, Column2), Color), ReturnValue).

empty([], []).
%this predicate finds all roads that can be built
findAllPossibleRoads([], _, _, []).
findAllPossibleRoads([coords(Line, Column)| Rest], Color, TakenRoads, PossibleRoads):-
	% brings all the coords possible to build on.
	not(member(coords(Line, Column), TakenRoads)) ->
		findall(coords(Z,W), dummyroad(coords(Line, Column),coords(Z,W)), R),
		% get all roads connected to current coords
		findall(coords(X,Y), road(coords(Line, Column),coords(X,Y), Color), R2),
		findAllPossibleRoads(Rest, Color, [coords(Line, Column) | TakenRoads], PossibleRoads2),
		findAllPossibleRoads(R2, Color, [coords(Line, Column) | TakenRoads], PossibleRoads3),
		append(PossibleRoads2, PossibleRoads3, LL),
		append(LL, R, PossibleRoads4),
		removeDuplicates(PossibleRoads4, PossibleRoads)
	;
	empty([], PossibleRoads).

findAllRoadsAsCoordsByColor(Color, Roads):-
	findall(coords(X,Y), road(coords(X,Y),Z,Color), Paths),
	removeDuplicates(Paths, Roads).


findRoadOtherEnd(coords(Line, Column), [coords(Line2, Column2) | RoadsCoords], coords(Line2, Column2)):-
	dummyroad(coords(Line,Column), coords(Line2, Column2)).
	
findRoadOtherEnd(coords(Line, Column), [coords(Line2, Column2) | RoadsCoords], OtherEnd):-
	findRoadOtherEnd(coords(Line, Column), RoadsCoords, OtherEnd).	
	
	
% this was extracted from stack overflow
% An empty list is a set.
removeDuplicates([], []).

% Put the head in the result,
% remove all occurrences of the head from the tail,
% make a set out of that.
removeDuplicates([H|T], [H|T1]) :- 
    remv(H, T, T2),
    removeDuplicates(T2, T1).

% Removing anything from an empty list yields an empty list.
remv(_, [], []).

% If the head is the element we want to remove,
% do not keep the head and
% remove the element from the tail to get the new list.
remv(X, [X|T], T1) :- remv(X, T, T1).

% If the head is NOT the element we want to remove,
% keep the head and
% remove the element from the tail to get the new tail.
remv(X, [H|T], [H|T1]) :-
    X \= H,
    remv(X, T, T1).
% end stack overflow

%%%%%%%%
% towns/cities predicates
%%%%%%%%

% same comments as in road only regarding town
checkTownExist(coords(Line, Column), Color, ReturnValue):-
	not(town(coords(Line, Column), Color)) ->
		ReturnValue is 0 % town exists
	;
	ReturnValue is 1. % town doesnt exist

checkTownExist(coords(Line, Column), ReturnValue):-
	not(town(coords(Line, Column), WEColor)) ->
	(
		not(city(coords(Line, Column), WEColor2)) ->
			ReturnValue is 0
		;
		ReturnValue is 2 % city exists
	)
	;
	ReturnValue is 1. % town exists

checkTownResources(PlayerResources, ReturnValue):-
	numberOfWood(PlayerResources, WoodNumber), WoodNumber > 0 ->
	(
		numberOfClay(PlayerResources, ClayNumber), ClayNumber > 0 ->
		(
			numberOfSheep(PlayerResources, SheepNumber), SheepNumber > 0 ->
			(
				numberOfWheat(PlayerResources, WheatNumber), WheatNumber > 0 ->
				(
					ReturnValue is 0
				)
				;
				ReturnValue is 4, ! % not enough wheat
			)
			;
			ReturnValue is 3, ! % not enough sheep
		)
		;
		ReturnValue is 2, ! % not enough clay
	)
	;
	ReturnValue is 1, !. % not enough wood

% build a town
buildTown(coords(Line, Column), Color):-
	assert(town(coords(Line, Column), Color)).

% this is not used, it would have been an approach to find if you can build a city
townTakenByColor(coords(Line, Column), Color, ReturnValue):-
	town(coords(Line, Column), Color) ->
		ReturnValue is 0
	;
	ReturnValue is 1. % not own town, or no town

% checks if you can build city
checkCityResources(PlayerResources, ReturnValue):-
	numberOfSheep(PlayerResources, SheepNumber), SheepNumber > 1 ->
	(
		numberOfMetal(PlayerResources, MetalNumber), MetalNumber > 2 ->
			ReturnValue is 0
		;
		ReturnValue is 2 % not enough metal
	) 
	;
	ReturnValue is 1. % not enough sheep

buildCity(coords(Line, Column), Color):-
	assert(city(coords(Line, Column), Color)),
	retract(town(coords(Line, Column), Color)).
	
% this region would have been to count win points but abandoned to the better and more elegant approach in % dice predicates
getAllCities(Result):-
	findall([X-Y],city(X,Y),Result).

getNumberOfCitiesByColor(Color, Number):-
	findall(X,city(X,Color),Result),
	length(Result,Number).

getAllCitiesByColor(Color, Result):-
	findall([X-Color],city(X,Color),Result).
	
getAllTowns(Result):-
	findall([X-Y],town(X,Y),Result).
	
getNumberOfTownsByColor(Color, Number):-
	findall(X,town(X,Color),Result),
	length(Result,Number).

getAllTownsByColor(Color, Result):-
	findall([X-Color],town(X,Color),Result).
% end region

% this was not used after all as well.
getCitiesInCoordsList([], []).
getCitiesInCoordsList([coords(Line, Column) | Tail], [coords(Line, Column) | Tail2]):-
	town(coords(Line, Column), X),
	getCitiesInCoordsList(Tail, Tail2).
	
getCitiesInCoordsList([coords(Line, Column) | Tail], Tail2):-
	getCitiesInCoordsList(Tail, Tail2).

% removes coords that have town on them
removeTowns([], []).
removeTowns([Head|RoadsCoords], NonTowns):-
	town(Head,X),
	removeTowns(RoadsCoords, NonTowns).
removeTowns([Head|RoadsCoords], [Head|NonTowns]):-
	not(town(Head,X)),
	removeTowns(RoadsCoords, NonTowns).

% removes coords that have city on them. but not removes towns
removeCities([], []).
removeCities([Head|CitiesCoords], NonTownsNonCities):-
	city(Head,X),
	removeCities(CitiesCoords, NonTownsNonCities).
removeCities([Head|CitiesCoords], [Head|NonTownsNonCities]):-
	not(city(Head,X)),
	removeCities(CitiesCoords, NonTownsNonCities).

% checks that no Head is town/city
neighborSpotsTownFree([]).
neighborSpotsTownFree([Head | Rest]):-
	not(town(Head,X)),
	not(city(Head,Y)),
	neighborSpotsTownFree(Rest).

% removes coords that dont have enough space from other cities/towns
removeNotEnoughSpace([], []).
removeNotEnoughSpace([coords(Line, Column) | Rest], [coords(Line, Column)| ToReturn]):-
	getRoadsConnectedToPoint(coords(Line, Column), ReturnValue),
	neighborSpotsTownFree(ReturnValue),
	removeNotEnoughSpace(Rest, ToReturn).
	
removeNotEnoughSpace([coords(Line, Column) | Rest], ToReturn):-
	removeNotEnoughSpace(Rest, ToReturn).
	

findAllPossibleTowns(Color, Locations):-
	findAllRoadsAsCoordsByColor(Color, RoadsCoords),
	removeTowns(RoadsCoords, NonTowns),
	removeCities(NonTowns, NonTownsNonCities),
	removeNotEnoughSpace(NonTownsNonCities, Locations).
	
findAllPossibleCities(Color, Locations):-
	findall(coords(Line, Column), town(coords(Line, Column), Color), Locations).
	



%%%%%%%%
% ai predicates
%%%%%%%%

% the notWait approach was abandoned in favor of Technical Possibility, Resource Possibility
% Technical Possibility means if you can according to the rules of the game build something
% Resource Possibility refers to the resources pool a player holds.
% the combination of the two holds in itself the same meaning of wait vs not wait while allowing more freedom in choice (due to them being split).


% the heuristic approach here regards the value of the cells' oddities - if i build a town/city here, how much would i get in the
% future based on these cells' oddities?
notWaitTown(coords(Line,Column), OdditiesAvg):-
	getCellsByCoord(coords(Line,Column), Cells),
	averageCells(Cells, OdditiesAvg2),
	OdditiesAvg is OdditiesAvg2.

waitTown(PlayerResources, coords(Line,Column), OdditiesAvg):-
	notWaitTown(coords(Line,Column), OdditiesAvg2),
	missingTownResources(PlayerResources, MissingResNum),
	OdditiesAvg is OdditiesAvg2 - MissingResNum.


notWaitCity(coords(Line,Column), OdditiesAvg):-
	notWaitTown(coords(Line,Column), OdditiesAvg2),
	OdditiesAvg is OdditiesAvg2 * 2.

waitCity(PlayerResources, coords(Line,Column), OdditiesAvg):-
	notWaitCity(coords(Line,Column), OdditiesAvg2),
	missingCityResources(PlayerResources, MissingResNum),
	OdditiesAvg is OdditiesAvg2 - MissingResNum.



notWaitRoad(X,3).

waitRoad(X, 2).

findAllPossibles(Color, PossibleRoads, PossibleTowns, PossibleCities, ReturnValue):-
	findAllRoadsAsCoordsByColor(Color, RoadsCoords),
	findAllPossibleRoads(RoadsCoords, Color, [], PossibleRoads),
	findAllPossibleTowns(Color, PossibleTowns),
	findAllPossibleCities(Color, PossibleCities),
	(PossibleRoads = [] ->
		PossibleRoadsValue is 0
	;
	PossibleRoadsValue is 1),
	(PossibleTowns = [] ->
		PossibleTownsValue is 0
	;
	PossibleTownsValue is 3),
	(PossibleCities = [] ->
		PossibleCitiesValue is 0
	;
	PossibleCitiesValue is 5),
	ReturnValue is PossibleRoadsValue + PossibleTownsValue + PossibleCitiesValue.

% everything can be built technically
checkResourcePossible(GivenResources, Color, 9, ReturnValue):-
	checkCityResources(GivenResources, ReturnCityValue),
	checkTownResources(GivenResources, ReturnTownValue),
	checkRoadResources(GivenResources, ReturnRoadValue),
	(ReturnCityValue =:= 0 ->
	ReturnCityVal is 5
	;
	ReturnCityVal is 0
	),
	(ReturnTownValue =:= 0 ->
	ReturnTownVal is 3
	;
	ReturnTownVal is 0
	),
	(ReturnRoadValue =:= 0 ->
	ReturnRoadVal is 1
	;
	ReturnRoadVal is 0
	),
	ReturnValue is ReturnRoadVal + ReturnTownVal + ReturnCityVal.

% town and city can be built technically	
checkResourcePossible(GivenResources, Color, 8, ReturnValue):-
	checkCityResources(GivenResources, ReturnCityValue),
	checkTownResources(GivenResources, ReturnTownValue),
	(ReturnCityValue =:= 0 ->
	ReturnCityVal is 5
	;
	ReturnCityVal is 0
	),
	(ReturnTownValue =:= 0 ->
	ReturnTownVal is 3
	;
	ReturnTownVal is 0
	),
	ReturnValue is ReturnTownVal + ReturnCityVal.

% road and city can be built technically	
checkResourcePossible(GivenResources, Color, 6, ReturnValue):-
	checkCityResources(GivenResources, ReturnCityValue),
	checkRoadResources(GivenResources, ReturnRoadValue),
	(ReturnCityValue =:= 0 ->
	ReturnCityVal is 5
	;
	ReturnCityVal is 0
	),
	(ReturnRoadValue =:= 0 ->
	ReturnRoadVal is 1
	;
	ReturnRoadVal is 0
	),
	ReturnValue is ReturnRoadVal + ReturnCityVal.

% city can be built technically
checkResourcePossible(GivenResources, Color, 5, ReturnValue):-
	checkCityResources(GivenResources, ReturnCityValue),
	(ReturnCityValue =:= 0 ->
	ReturnCityVal is 5
	;
	ReturnCityVal is 0
	),
	ReturnValue is ReturnRoadVal + ReturnTownVal + ReturnCityVal.

% town and road can be built technically
checkResourcePossible(GivenResources, Color, 4, ReturnValue):-
	checkTownResources(GivenResources, ReturnTownValue),
	checkRoadResources(GivenResources, ReturnRoadValue),
	(ReturnTownValue =:= 0 ->
	ReturnTownVal is 3
	;
	ReturnTownVal is 0
	),
	(ReturnRoadValue =:= 0 ->
	ReturnRoadVal is 1
	;
	ReturnRoadVal is 0
	),
	ReturnValue is ReturnRoadVal + ReturnTownVal.


% town can be built technically
checkResourcePossible(GivenResources, Color, 3, ReturnValue):-
	checkTownResources(GivenResources, ReturnTownValue),
	(ReturnTownValue =:= 0 ->
	ReturnTownVal is 3
	;
	ReturnTownVal is 0
	),
	ReturnValue is ReturnTownVal.
	
% road can be built technically
checkResourcePossible(GivenResources, Color, 1, ReturnValue):-
	checkRoadResources(GivenResources, ReturnRoadValue),
	(ReturnRoadValue =:= 0 ->
	ReturnRoadVal is 1
	;
	ReturnRoadVal is 0
	),
	ReturnValue is ReturnRoadVal.
	
% nothing can be built technically
checkResourcePossible(_, _, 0, 0).

% since all roads have the same value pick one randomly
getMaxRoad(PossibleRoads, ReturnRoad-Value):-
	length(PossibleRoads, PossibleRoadsLength),
	random_between(1, PossibleRoadsLength, I),
	nth1(I, PossibleRoads, ReturnRoad),
	notWaitRoad(ReturnRoad,Value).

% find max town by town value
maxTown([],nil).
maxTown([Town-Avg|T], Town2-Avg2):-  % with the -> operator, call first
    maxTown(T,Town3-X),
    (Avg > X ->
     Avg = Avg2,
     Town = Town2
     ;
     Avg2 = X,
     Town2 = Town3).
maxTown([Town-X],Town-X).

% this predicate generate values to coords based on cells oddities
generateValues([], []).
generateValues([Coord | Towns], [Coord-CellAvg | Towns2]):-
	notWaitTown(Coord, CellAvg),
	generateValues(Towns, Towns2).
	
getMaxTown(Towns, ReturnTown):-
	generateValues(Towns, TownsWithAvg),
	maxTown(TownsWithAvg, ReturnTown).

% this was abandoned as the whole wait appraoch was abandoned
generateValuesWait([], []).
generateValuesWait([Coord | Towns], [Coord-CellAvg | Towns2]):-
	waitTown(Coord, CellAvg),
	generateValuesWait(Towns, Towns2).

getMaxWaitTown(Towns, ReturnTown):-
	generateValuesWait(Towns, TownsWithAvg),
	maxTown(TownsWithAvg, ReturnTown).

maxCity(nil, nil).
maxCity(City-Avg, City-DAvg):-
	DAvg is Avg * 2.

getMaxCity(Cities, ReturnMaxCity):-
	getMaxTown(Cities, ReturnCity),
	maxCity(ReturnCity, ReturnMaxCity). 

% abandoned
getMaxWaitCity(Cities, ReturnCity-Value2):-
	getMaxWaitTown(Cities, ReturnCity-Value),
	Value2 is Value*2.


%buildAI(Technical Possibility, Resource Possibility, RoadToBuild-RoadValue, TownToBuild-TownValue, CityToBuild-CityValue)
% Technical Possibility - can build technically
% Resource Possibility - does have enough resources
% build AI finds out what to build if at all based on Technical Possibility + Resource Possibility

% everything is in
buildAI(9, 9, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	RoadValue > TownValue ->
	(
		RoadValue > CityValue ->
			% build road
			findAllRoadsAsCoordsByColor(Color, RoadsCoords),
			findRoadOtherEnd(RoadToBuild, RoadsCoords , RoadStart),
			buildRoad(RoadToBuild, RoadStart, Color),
			WhatBuilt is 1
		;
		% build city
		buildCity(CityToBuild, Color),
		WhatBuilt is 3
	)
	;
	TownValue > CityValue ->
		% build town
		buildTown(TownToBuild, Color),
		WhatBuilt is 2
	;
	% build city
	buildCity(CityToBuild, Color),
	WhatBuilt is 3.

% road vs wait town vs city
buildAI(9, 6, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	RoadValue > TownValue ->
	(
		RoadValue > CityValue ->
			% build road
			findAllRoadsAsCoordsByColor(Color, RoadsCoords),
			findRoadOtherEnd(RoadToBuild, RoadsCoords , RoadStart),
			buildRoad(RoadToBuild, RoadStart, Color),
			WhatBuilt is 1
		;
		% build city
		buildCity(CityToBuild, Color),
		WhatBuilt is 3
	)
	;
	TownValue > CityValue ->
		% wait town
		WhatBuilt is 0
	;
	% build city
	buildCity(CityToBuild, Color),
	WhatBuilt is 3.

% wait road vs wait town vs city
buildAI(9, 5, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	RoadValue > TownValue ->
	(
		RoadValue > CityValue ->
			% wait road
			WhatBuilt is 0
		;
		% build city
		buildCity(CityToBuild, Color),
		WhatBuilt is 3
	)
	;
	TownValue > CityValue ->
		% wait town
		WhatBuilt is 0
	;
	% build city
	buildCity(CityToBuild, Color),
	WhatBuilt is 3.
	
% road vs town vs wait city
buildAI(9, 4, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	RoadValue > TownValue ->
	(
		RoadValue > CityValue ->
			% build road
			findAllRoadsAsCoordsByColor(Color, RoadsCoords),
			findRoadOtherEnd(RoadToBuild, RoadsCoords , RoadStart),
			buildRoad(RoadToBuild, RoadStart, Color),
			WhatBuilt is 1
		;
		% wait city
		WhatBuilt is 0
	)
	;
	TownValue > CityValue ->
		% build town
		buildTown(TownToBuild, Color),
		WhatBuilt is 2
	;
	% wait city
	WhatBuilt is 0.
	
% road vs wait town vs wait city
buildAI(9, 1, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	RoadValue > TownValue ->
	(
		RoadValue > CityValue ->
			% build road
			findAllRoadsAsCoordsByColor(Color, RoadsCoords),
			findRoadOtherEnd(RoadToBuild, RoadsCoords , RoadStart),
			buildRoad(RoadToBuild, RoadStart, Color),
			WhatBuilt is 1
		;
		% wait city
		WhatBuilt is 0
	)
	;
	TownValue > CityValue ->
		% wait town
		WhatBuilt is 0
	;
	% wait city
	WhatBuilt is 0.
% rest
buildAI(9, _, _, _, _, _, 0).


% only city and town are legal
buildAI(8, 9, Color,  _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	TownValue > CityValue ->
		% build town
		buildAI(8, 4, Color, _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt)
	;
	% build city
	buildAI(8, 5, Color, _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt).

% only town
buildAI(8, 6, Color,  _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	% build town
	buildAI(8, 4, Color, _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt).
	
% only city
buildAI(8, 5, Color, _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	% build city
	buildCity(CityToBuild, Color),
	WhatBuilt is 3.
% only town
buildAI(8, 4, Color, _, TownToBuild-TownValue, CityToBuild-CityValue, WhatBuilt):-
	% build town
	buildTown(TownToBuild, Color),
	WhatBuilt is 2.
	
% nothing
buildAI(8, _, _, _, _, _, 0).


% only road and city are legal
buildAI(6, 9, Color, RoadToBuild-RoadValue, _, CityToBuild-CityValue, WhatBuilt):-
	buildAI(6, 6, Color, RoadToBuild-RoadValue, _, CityToBuild-CityValue, WhatBuilt).
buildAI(6, 6, Color, RoadToBuild-RoadValue, _, CityToBuild-CityValue, WhatBuilt):-
	RoadValue > CityValue ->
		% build road
		buildAI(6, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt)
	;
	% build city
	buildAI(6, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt).
	
buildAI(6, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt):-
	% build city
	buildAI(5, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt).
	
buildAI(6, 4, Color, RoadToBuild-RoadValue, _, _, WhatBuilt):-
	buildAI(6, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
	
buildAI(6, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt):-
	% build road
	buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
	
buildAI(6, _, _, _, _, _, 0).

% only city is legal
buildAI(5, 9, Color, _, _, CityToBuild-CityValue, WhatBuilt):-
	buildAI(5, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt).
buildAI(5, 8, Color, _, _, CityToBuild-CityValue, WhatBuilt):-
	buildAI(5, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt).
buildAI(5, 6, Color, _, _, CityToBuild-CityValue, WhatBuilt):-
	buildAI(5, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt).
buildAI(5, 5, Color, _, _, CityToBuild-CityValue, WhatBuilt):-
	buildCity(CityToBuild, Color),
	WhatBuilt is 3.
buildAI(5, _, _, _, _, _, 0).

% only town and road are legal
buildAI(4, 9, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, _, WhatBuilt):-
	RoadValue > TownValue ->
		buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt)
	;
	buildAI(3, 3, Color, _, TownToBuild-TownValue, _, WhatBuilt).
	
buildAI(4, 6, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, _, WhatBuilt):-
	buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
buildAI(4, 4, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, _, WhatBuilt):-
	buildAI(4, 9, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, _, WhatBuilt).
buildAI(4, 1, Color, RoadToBuild-RoadValue, TownToBuild-TownValue, _, WhatBuilt):-
	buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
buildAI(4, _, _, _, _, _, 0).

% only town is legal
buildAI(3, 9, Color, _, TownToBuild-TownValue, _, WhatBuilt):-
	buildAI(3, 3, Color, _, TownToBuild-TownValue, _, WhatBuilt).
buildAI(3, 4, Color, _, TownToBuild-TownValue, _, WhatBuilt):-
	buildAI(3, 3, Color, _, TownToBuild-TownValue, _, WhatBuilt).
buildAI(3, 3, Color, _, TownToBuild-TownValue, _, WhatBuilt):-
	% build town
	buildTown(TownToBuild, Color),
	WhatBuilt is 2.
buildAI(3, _, _, _, _, _, 0).

% only road is legal
buildAI(1, 9, Color, RoadToBuild-RoadValue, _, _, WhatBuilt):-
	buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
buildAI(1, 6, Color, RoadToBuild-RoadValue, _, _, WhatBuilt):-
	buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
buildAI(1, 4, Color, RoadToBuild-RoadValue, _, _, WhatBuilt):-
	buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt).
buildAI(1, 1, Color, RoadToBuild-RoadValue, _, _, WhatBuilt):-
	% build road
	findAllRoadsAsCoordsByColor(Color, RoadsCoords),
	findRoadOtherEnd(RoadToBuild, RoadsCoords , RoadStart),
	buildRoad(RoadToBuild, RoadStart, Color),
	WhatBuilt is 1.
% this shouldnt happen, if it does something went horribly wrong
buildAI(TechnicalReturnValue, ResourcesCheckReturnValue, _, _, _, _, WTF):-
	WTF is TechnicalReturnValue * 10 + ResourcesCheckReturnValue.


removeRoadValue(Road-Value, Road).
removeTownValue(Town-Value, Town).
removeCityValue(City-Value, City).



number_of_roads_possible_resource_wise(GivenResources, ReturnValue):-
	numberOfWood(GivenResources, WoodNumber),
	numberOfClay(GivenResources, ClayNumber), !, 
	min_in_list([WoodNumber, ClayNumber], Min),
	Min > 2,
	ReturnValue is Min.

number_of_roads_possible_resource_wise(GivenResources, ReturnValue):-
	ReturnValue is 0.


min_in_list([Min],Min).                 % We've found the minimum

min_in_list([H,K|T],M) :-
    H =< K,                             % H is less than or equal to K
    min_in_list([H|T],M).               % so use H

min_in_list([H,K|T],M) :-
    H > K,                              % H is greater than K
    min_in_list([K|T],M).               % so use K

number_of_towns_possible_resource_wise(GivenResources, ReturnValue):-
	numberOfWood(GivenResources, WoodNumber),
	numberOfClay(GivenResources, ClayNumber), 
	numberOfWheat(GivenResources, WheatNumber), 
	numberOfSheep(GivenResources, SheepNumber),
	min_in_list([WoodNumber, ClayNumber, WheatNumber, SheepNumber], Min),
	Min > 2,
	ReturnValue is Min.

number_of_towns_possible_resource_wise(GivenResources, ReturnValue):-
	ReturnValue is 0.

regularAI(GivenResources, Color, RoadToBuild, TownToBuild, CityToBuild, ValueToRet, ThingToReturn):-
	findAllPossibles(Color, PossibleRoads, PossibleTowns, PossibleCities, TechnicalReturnValue),
	checkResourcePossible(GivenResources, Color, TechnicalReturnValue, ResourcesCheckReturnValue),
	getMaxRoad(PossibleRoads, RoadToBuild),
	getMaxTown(PossibleTowns, TownToBuild),
	getMaxCity(PossibleCities, CityToBuild),
	buildAI(TechnicalReturnValue, ResourcesCheckReturnValue, Color, RoadToBuild, TownToBuild, CityToBuild, ValueToRet),
	(ValueToRet =:= 1 ->
		RoadToBuild = ThingToAudit,
		removeRoadValue(ThingToAudit, ThingToReturn)
	;
	ValueToRet =:= 2 ->
		TownToBuild = ThingToAudit,
		removeTownValue(ThingToAudit, ThingToReturn)
	;
	ValueToRet =:= 3 ->
		CityToBuild = ThingToAudit,
		removeCityValue(ThingToAudit, ThingToReturn)
	;
	ThingToReturn is 0).


% special AI enforces the AI to make a move if it has more than enough resources, regardless of weights of moves.
% these enforcements are only applied to towns and roads



specialAI(GivenResources, Color,  [], TownToBuild, CityToBuild, ValueToRet):-
	number_of_towns_possible_resource_wise(GivenResources, NumberOfTownsPossible), 
	NumberOfTownsPossible > 2 ->
		buildAI(3, 3, Color, RoadToBuild, TownToBuild, CityToBuild, ValueToRet)
	;
	ValueToRet is 0.

specialAI(GivenResources, Color,  RoadToBuild, nil, CityToBuild, ValueToRet):-
	number_of_roads_possible_resource_wise(GivenResources, NumberOfRoadsPossible),
	NumberOfRoadsPossible > 3 ->
		buildAI(1, 1, Color, RoadToBuild, TownToBuild, CityToBuild, ValueToRet)
	;
	ValueToRet is 0.

specialAI(GivenResources, Color,  RoadToBuild, TownToBuild, CityToBuild, ValueToRet):-
	number_of_roads_possible_resource_wise(GivenResources, NumberOfRoadsPossible),
		NumberOfRoadsPossible > 3 ->
		buildAI(1, 1, Color, RoadToBuild, TownToBuild, CityToBuild, ValueToRet)
	;
	number_of_towns_possible_resource_wise(GivenResources, NumberOfTownsPossible),
	NumberOfTownsPossible > 2 ->
		buildAI(3, 3, Color, RoadToBuild, TownToBuild, CityToBuild, ValueToRet)
	;
	ValueToRet is 0.
	
	
	
% ai calls to its regular method, if that returns 0 then it calls special method
aiTurn(GivenResources, Color, ValueToRet, ThingToReturn):-
	regularAI(GivenResources, Color, RoadToBuild, TownToBuild, CityToBuild, RegularValueToRet, RegularThingToReturn),
	(RegularValueToRet =:= 1 ->
		RoadToBuild = ThingToAudit,
		ValueToRet is RegularValueToRet,
		removeRoadValue(ThingToAudit, ThingToReturn)
	;
	RegularValueToRet =:= 2 ->
		TownToBuild = ThingToAudit,
		ValueToRet is RegularValueToRet,
		removeTownValue(ThingToAudit, ThingToReturn)
	;
	RegularValueToRet =:= 3 ->
		CityToBuild = ThingToAudit,
		ValueToRet is RegularValueToRet,
		removeCityValue(ThingToAudit, ThingToReturn)
	;
	RegularValueToRet =:= 0 ->
		(
		specialAI(GivenResources, Color,  RoadToBuild, TownToBuild, CityToBuild, SpecialValueToRet),
		(SpecialValueToRet =:= 1 ->
			RoadToBuild = ThingToAudit,
			ValueToRet is SpecialValueToRet,
			removeRoadValue(ThingToAudit, ThingToReturn)
		;
		SpecialValueToRet =:= 2 ->
			TownToBuild = ThingToAudit,
			ValueToRet is SpecialValueToRet,
			removeRoadValue(ThingToAudit, ThingToReturn)
		;
		ValueToRet is 0,
		ThingToReturn is 0
		))
	;
	ValueToRet is 0,
	ThingToReturn is 0).
	
%%%%%%%%
% game predicates - resources managing predicates
%%%%%%%%

%%%%%%%%
% resources predicates
%%%%%%%%

%%%%%%%%
% resources predicates - update resources
%%%%%%%%

% update resources town cost
updatePlayerTownResources([],[]).
updatePlayerTownResources([resource(wood)-Number | Tail], [resource(wood)-Number2 | Tail2]):-
	Number2 is Number - 1,
	updatePlayerTownResources(Tail, Tail2).
updatePlayerTownResources([resource(sheep)-Number | Tail], [resource(sheep)-Number2 | Tail2]):-
	Number2 is Number - 1,
	updatePlayerTownResources(Tail, Tail2).
updatePlayerTownResources([resource(wheat)-Number | Tail], [resource(wheat)-Number2 | Tail2]):-
	Number2 is Number - 1,
	updatePlayerTownResources(Tail, Tail2).
updatePlayerTownResources([resource(clay)-Number | Tail], [resource(clay)-Number2 | Tail2]):-
	Number2 is Number - 1,
	updatePlayerTownResources(Tail, Tail2).
updatePlayerTownResources([resource(metal)-Number | Tail], [resource(metal)-Number | Tail2]):-
	updatePlayerTownResources(Tail, Tail2).

% update resources road cost
updatePlayerRoadResources([],[]).
updatePlayerRoadResources([resource(wood)-Number | Tail], [resource(wood)-Number2 | Tail2]):-
	Number2 is Number - 1,
	updatePlayerRoadResources(Tail, Tail2).
updatePlayerRoadResources([resource(clay)-Number | Tail], [resource(clay)-Number2 | Tail2]):-
	Number2 is Number - 1,
	updatePlayerRoadResources(Tail, Tail2).
updatePlayerRoadResources([X | Tail], [X | Tail2]):-
	updatePlayerRoadResources(Tail, Tail2).
	
% update resources city cost
updatePlayerCityResources([],[]).
updatePlayerCityResources([resource(sheep)-Number | Tail], [resource(sheep)-Number2 | Tail2]):-
	Number2 is Number - 2,
	updatePlayerCityResources(Tail, Tail2).
updatePlayerCityResources([resource(metal)-Number | Tail], [resource(metal)-Number2 | Tail2]):-
	Number2 is Number - 3,
	updatePlayerCityResources(Tail, Tail2).
updatePlayerCityResources([X | Tail], [X | Tail2]):-
	updatePlayerCityResources(Tail, Tail2).



% get number of resource

numberOfWood([resource(wood)-Number | Tail], Number).
numberOfWood([X-Y | Tail], Number):-
	numberOfWood(Tail, Number).

numberOfClay([resource(clay)-Number | Tail], Number).
numberOfClay([X-Y | Tail], Number):-
	numberOfClay(Tail, Number).

numberOfSheep([resource(sheep)-Number | Tail], Number).
numberOfSheep([X-Y | Tail], Number):-
	numberOfSheep(Tail, Number).

numberOfMetal([resource(metal)-Number | Tail], Number).
numberOfMetal([X-Y | Tail], Number):-
	numberOfMetal(Tail, Number).

numberOfWheat([resource(wheat)-Number | Tail], Number).
numberOfWheat([X-Y | Tail], Number):-
	numberOfWheat(Tail, Number).

% end get number of resource

missingTownWood([resource(wood)-Number | Tail], MissingWood):-
	Number > 0 ->
		MissingWood is 0 
	;
	MissingWood is 1.
	
missingTownWood([X-Y | Tail], Number):-
	missingTownWood(Tail, Number).
	
	
missingTownClay([resource(clay)-Number | Tail], MissingClay):-
	Number > 0 ->
		MissingClay is 0 
	;
	MissingClay is 1.
	
missingTownClay([X-Y | Tail], Number):-
	missingTownClay(Tail, Number).

missingTownSheep([resource(sheep)-Number | Tail], MissingSheep):-
	Number > 0 ->
		MissingSheep is 0 
	;
	MissingSheep is 1.
	
missingTownSheep([X-Y | Tail], Number):-
	missingTownSheep(Tail, Number).

missingTownWheat([resource(wheat)-Number | Tail], MissingWheat):-
	Number > 0 ->
		MissingWheat is 0 
	;
	MissingWheat is 1.
	
missingTownWheat([X-Y | Tail], Number):-
	missingTownWheat(Tail, Number).


missingTownResources(PlayerResources, MissingResNum):-
	missingTownWood(PlayerResources, MissingWood),
	missingTownClay(PlayerResources, MissingClay),
	missingTownSheep(PlayerResources, MissingSheep),
	missingTownWheat(PlayerResources, MissingWheat),
	MissingResNum is MissingWood + MissingClay + MissingSheep + MissingWheat.



missingCityMetal([resource(metal)-Number | Tail], MissingMetal):-
	Number > 2 ->
		MissingMetal is 0
	;
	Number =:= 2 ->
		MissingMetal is 1
	;
	Number =:= 1 ->
		MissingMetal is 2
	;
	MissingMetal is 3.
	
missingCityMetal([X-Y | Tail], Number):-
	missingCityMetal(Tail, Number).

missingCitySheep([resource(sheep)-Number | Tail], MissingSheep):-
	Number > 1 ->
		MissingSheep is 0 
	;
	Number =:= 1 ->
		MissingSheep is 1
	;
	MissingSheep is 2.
	
missingCitySheep([X-Y | Tail], Number):-
	missingCityMetal(Tail, Number).

missingCityResources(PlayerResources, MissingResNum):-
	missingCityMetal(PlayerResources, MissingMetal),
	missingCitySheep(PlayerResources, MissingSheep),
	MissingResNum is MissingSheep + MissingMetal.

%%%%%%%%
% game predicates - setup predicates
%%%%%%%%
setupGame:-
	% first row
	assert(dummyroad(coords(0,3), coords(1,4))),
	assert(dummyroad(coords(1,4), coords(0,3))),
	assert(dummyroad(coords(0,3), coords(1,2))),
	assert(dummyroad(coords(1,2), coords(0,3))),
	
	assert(dummyroad(coords(0,5), coords(1,4))),
	assert(dummyroad(coords(1,4), coords(0,5))),
	assert(dummyroad(coords(0,5), coords(1,6))),
	assert(dummyroad(coords(1,6), coords(0,5))),
	
	assert(dummyroad(coords(0,7), coords(1,6))),
	assert(dummyroad(coords(1,6), coords(0,7))),
	assert(dummyroad(coords(0,7), coords(1,8))),
	assert(dummyroad(coords(1,8), coords(0,7))),
	
	% second row
	assert(dummyroad(coords(1,2), coords(2,2))),
	assert(dummyroad(coords(2,2), coords(1,2))),
	assert(dummyroad(coords(1,4), coords(2,4))),
	assert(dummyroad(coords(2,4), coords(1,4))),
	assert(dummyroad(coords(1,6), coords(2,6))),
	assert(dummyroad(coords(2,6), coords(1,6))),
	assert(dummyroad(coords(1,8), coords(2,8))),
	assert(dummyroad(coords(2,8), coords(1,8))),
	
	% third row
	assert(dummyroad(coords(2,2), coords(3,1))),
	assert(dummyroad(coords(3,1), coords(2,2))),
	assert(dummyroad(coords(2,2), coords(3,3))),
	assert(dummyroad(coords(3,3), coords(2,2))),
	
	assert(dummyroad(coords(2,4), coords(3,3))),
	assert(dummyroad(coords(3,3), coords(2,4))),
	assert(dummyroad(coords(2,4), coords(3,5))),
	assert(dummyroad(coords(3,5), coords(2,4))),
	
	assert(dummyroad(coords(2,6), coords(3,5))),
	assert(dummyroad(coords(3,5), coords(2,6))),
	assert(dummyroad(coords(2,6), coords(3,7))),
	assert(dummyroad(coords(3,7), coords(2,6))),
	
	assert(dummyroad(coords(2,8), coords(3,7))),
	assert(dummyroad(coords(3,7), coords(2,8))),
	assert(dummyroad(coords(2,8), coords(3,9))),
	assert(dummyroad(coords(3,9), coords(2,8))),
	
	% fourth row
	assert(dummyroad(coords(3,1), coords(4,1))),
	assert(dummyroad(coords(4,1), coords(3,1))),
	assert(dummyroad(coords(3,3), coords(4,3))),
	assert(dummyroad(coords(4,3), coords(3,3))),
	assert(dummyroad(coords(3,5), coords(4,5))),
	assert(dummyroad(coords(4,5), coords(3,5))),
	assert(dummyroad(coords(3,7), coords(4,7))),
	assert(dummyroad(coords(4,7), coords(3,7))),
	assert(dummyroad(coords(3,9), coords(4,9))),
	assert(dummyroad(coords(4,9), coords(3,9))),
	
	% fifth row
	assert(dummyroad(coords(4,1), coords(5,0))),
	assert(dummyroad(coords(5,0), coords(4,1))),
	assert(dummyroad(coords(4,1), coords(5,2))),
	assert(dummyroad(coords(5,2), coords(4,1))),
	
	assert(dummyroad(coords(4,3), coords(5,2))),
	assert(dummyroad(coords(5,2), coords(4,3))),
	assert(dummyroad(coords(4,3), coords(5,4))),
	assert(dummyroad(coords(5,4), coords(4,3))),
	
	assert(dummyroad(coords(4,5), coords(5,4))),
	assert(dummyroad(coords(5,4), coords(4,5))),
	assert(dummyroad(coords(4,5), coords(5,6))),
	assert(dummyroad(coords(5,6), coords(4,5))),
	
	assert(dummyroad(coords(4,7), coords(5,6))),
	assert(dummyroad(coords(5,6), coords(4,7))),
	assert(dummyroad(coords(4,7), coords(5,8))),
	assert(dummyroad(coords(5,8), coords(4,7))),
	
	assert(dummyroad(coords(4,9), coords(5,8))),
	assert(dummyroad(coords(5,8), coords(4,9))),
	assert(dummyroad(coords(4,9), coords(5,10))),
	assert(dummyroad(coords(5,10), coords(4,9))),
	
	% sixth row
	assert(dummyroad(coords(5,0), coords(6,0))),
	assert(dummyroad(coords(6,0), coords(5,0))),
	assert(dummyroad(coords(5,2), coords(6,2))),
	assert(dummyroad(coords(6,2), coords(5,2))),
	assert(dummyroad(coords(5,4), coords(6,4))),
	assert(dummyroad(coords(6,4), coords(5,4))),
	assert(dummyroad(coords(5,6), coords(6,6))),
	assert(dummyroad(coords(6,6), coords(5,6))),
	assert(dummyroad(coords(5,8), coords(6,8))),
	assert(dummyroad(coords(6,8), coords(5,8))),
	assert(dummyroad(coords(5,10), coords(6,10))),
	assert(dummyroad(coords(6,10), coords(5,10))),
	
	% seventh row
	assert(dummyroad(coords(6,0), coords(7,1))),
	assert(dummyroad(coords(7,1), coords(6,0))),
	
	assert(dummyroad(coords(6,2), coords(7,1))),
	assert(dummyroad(coords(7,1), coords(6,2))),
	assert(dummyroad(coords(6,2), coords(7,3))),
	assert(dummyroad(coords(7,3), coords(6,2))),
	
	assert(dummyroad(coords(6,4), coords(7,3))),
	assert(dummyroad(coords(7,3), coords(6,4))),
	assert(dummyroad(coords(6,4), coords(7,5))),
	assert(dummyroad(coords(7,5), coords(6,4))),
	
	assert(dummyroad(coords(6,6), coords(7,5))),
	assert(dummyroad(coords(7,5), coords(6,6))),
	assert(dummyroad(coords(6,6), coords(7,7))),
	assert(dummyroad(coords(7,7), coords(6,6))),
	
	assert(dummyroad(coords(6,8), coords(7,7))),
	assert(dummyroad(coords(7,7), coords(6,8))),
	assert(dummyroad(coords(6,8), coords(7,9))),
	assert(dummyroad(coords(7,9), coords(6,8))),
	
	assert(dummyroad(coords(6,10), coords(7,9))),
	assert(dummyroad(coords(7,9), coords(6,10))),
	
	% eighth row
	assert(dummyroad(coords(7,1), coords(8,1))),
	assert(dummyroad(coords(8,1), coords(7,1))),
	assert(dummyroad(coords(7,3), coords(8,3))),
	assert(dummyroad(coords(8,3), coords(7,3))),
	assert(dummyroad(coords(7,5), coords(8,5))),
	assert(dummyroad(coords(8,5), coords(7,5))),
	assert(dummyroad(coords(7,7), coords(8,7))),
	assert(dummyroad(coords(8,7), coords(7,7))),
	assert(dummyroad(coords(7,9), coords(8,9))),
	assert(dummyroad(coords(8,9), coords(7,9))),
	
	% ninth row
	assert(dummyroad(coords(8,1), coords(9,2))),
	assert(dummyroad(coords(9,2), coords(8,1))),
	
	assert(dummyroad(coords(8,3), coords(9,2))),
	assert(dummyroad(coords(9,2), coords(8,3))),
	assert(dummyroad(coords(8,3), coords(9,4))),
	assert(dummyroad(coords(9,4), coords(8,3))),
	
	assert(dummyroad(coords(8,5), coords(9,4))),
	assert(dummyroad(coords(9,4), coords(8,5))),
	assert(dummyroad(coords(8,5), coords(9,6))),
	assert(dummyroad(coords(9,6), coords(8,5))),
	
	assert(dummyroad(coords(8,7), coords(9,6))),
	assert(dummyroad(coords(9,6), coords(8,7))),
	assert(dummyroad(coords(8,7), coords(9,8))),
	assert(dummyroad(coords(9,8), coords(8,7))),
	
	assert(dummyroad(coords(8,9), coords(9,8))),
	assert(dummyroad(coords(9,8), coords(8,9))),
	
	% tenth row
	assert(dummyroad(coords(9,2), coords(10,2))),
	assert(dummyroad(coords(10,2), coords(9,2))),
	assert(dummyroad(coords(9,4), coords(10,4))),
	assert(dummyroad(coords(10,4), coords(9,4))),
	assert(dummyroad(coords(9,6), coords(10,6))),
	assert(dummyroad(coords(10,6), coords(9,6))),
	assert(dummyroad(coords(9,8), coords(10,8))),
	assert(dummyroad(coords(10,8), coords(9,8))),
	
	% eleventh row
	assert(dummyroad(coords(10,2), coords(11,3))),
	assert(dummyroad(coords(11,3), coords(10,2))),
	
	assert(dummyroad(coords(10,4), coords(11,3))),
	assert(dummyroad(coords(11,3), coords(10,4))),
	assert(dummyroad(coords(10,4), coords(11,5))),
	assert(dummyroad(coords(11,5), coords(10,4))),

	assert(dummyroad(coords(10,6), coords(11,5))),
	assert(dummyroad(coords(11,5), coords(10,6))),
	assert(dummyroad(coords(10,6), coords(11,7))),
	assert(dummyroad(coords(11,7), coords(10,6))),

	assert(dummyroad(coords(10,8), coords(11,7))),
	assert(dummyroad(coords(11,7), coords(10,8))).
	
setupPlayers:-
	% red
	assert(town(coords(6,4), red)),
	assert(road(coords(5,4), coords(6,4), red)),
	assert(road(coords(6,4), coords(5,4), red)),
	assert(town(coords(2,4), red)),
	assert(road(coords(2,4), coords(3,3), red)),
	assert(road(coords(3,3), coords(2,4), red)),
	retract(dummyroad(coords(5,4), coords(6,4))),
	retract(dummyroad(coords(6,4), coords(5,4))),
	retract(dummyroad(coords(2,4), coords(3,3))),
	retract(dummyroad(coords(3,3), coords(2,4))),
	
	
	% blue
	assert(town(coords(7,7), blue)),
	assert(road(coords(7,7), coords(6,8), blue)),
	assert(road(coords(6,8), coords(7,7), blue)),
	assert(town(coords(5,8), blue)),
	assert(road(coords(5,8), coords(6,8), blue)),
	assert(road(coords(6,8), coords(5,8), blue)),
	retract(dummyroad(coords(7,7), coords(6,8))),
	retract(dummyroad(coords(6,8), coords(7,7))),
	retract(dummyroad(coords(5,8), coords(6,8))),
	retract(dummyroad(coords(6,8), coords(5,8))).
	

retractAll:-
	retractall(road(X,Y,Z)),
	retractall(dummyroad(A,B,C)),
	retractall(town(D,E)),
	retractall(city(F,G)).