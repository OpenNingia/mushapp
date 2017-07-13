function calcSkillExp(speed, attack, defence) {
    var freePoints = 7;
    var cost = 20;
    //console.log("calcSkillExp: %1".arg(Math.max(0, (speed+attack+defence-freePoints)*cost)));
    return Math.max(0, (speed+attack+defence-freePoints)*cost);
}

function calcAuraExp(auraLvl, auraPoints) {
    var auraLvlCost = 50;
    var auraPointCost = auraLvlCost/10;
    //console.log("calcAuraExp: %1".arg(Math.max(0, auraLvl*auraLvlCost + auraPoints*auraPointCost)));
    return Math.max(0, auraLvl*auraLvlCost + auraPoints*auraPointCost);
}

function calcMovesExp(moves, superMoves) {
    var freeMoves = 3;
    var freeSuperMoves = 1;
    var moveCost = 10;
    var superMoveCost = 20;

    //console.log("calcMovesExp: %1".arg(Math.max(0, (moves-freeMoves)*moveCost + (superMoves-freeSuperMoves)*superMoveCost)));

    var moveExp = Math.max(0, (moves-freeMoves)*moveCost);
    var superExp = Math.max(0, (superMoves-freeSuperMoves)*superMoveCost);
    return moveExp + superExp;
}

function calcExp(charModel) {
    return calcSkillExp(charModel.speed, charModel.attack, charModel.defence) +
           calcAuraExp (charModel.auraLvl, charModel.auraPoints) +
           calcMovesExp(charModel.moves.length, charModel.superMoves.length);
}
