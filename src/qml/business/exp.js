function calcSkillExp(speed, attack, defence) {
    var freePoints = 7;
    var cost = 20;

    var r = Math.max(0, (speed+attack+defence-freePoints)*cost);
    console.log("calcSkillExp: %1".arg(r));
    return r;
}

function calcAuraExp(auraLvl, auraPoints) {

    console.log('aura lvl: %1, aura points: %2'.arg(auraLvl).arg(auraPoints));
    var auraLvlCost = 50;
    var auraPointCost = auraLvlCost/10;

    var r = Math.max(0, auraLvl*auraLvlCost + auraPoints*auraPointCost);
    console.log("calcAuraExp: %1".arg(r));
    return r;
}

function calcMovesExp(moves, superMoves) {
    var freeMoves = 3;
    var freeSuperMoves = 1;
    var moveCost = 10;
    var superMoveCost = 20;    

    var moveExp = Math.max(0, (moves-freeMoves)*moveCost);
    var superExp = Math.max(0, (superMoves-freeSuperMoves)*superMoveCost);

    var r = moveExp + superExp;
    console.log("calcMovesExp: %1".arg(r));
    return r;
}

function calcExp(charModel) {
    var r = calcSkillExp(charModel.speed, charModel.attack, charModel.defence) +
            calcAuraExp (charModel.aura.level, charModel.aura.points) +
            calcMovesExp(charModel.moves.length, charModel.superMoves.length);
    console.log("calcExp: %1".arg(r));
    return r;
}
