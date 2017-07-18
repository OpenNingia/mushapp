function calcPaCost(symbols, isSuper) {
    var freeSymbols = 2;
    var superFreeSymbols = 3;
    var baseCost = 3;
    var superBaseCost = 3;

    var tagCount = symbols.reduce(function (acc, curr) {
      if (typeof acc[curr] == 'undefined') {
        acc[curr] = 1;
      } else {
        acc[curr] += 1;
      }
      return acc;
    }, {});

    //console.log(JSON.stringify(symbols))
    //console.log("is super:" + isSuper);

    var cost = 0;
    var nsymbols = symbols.length;

    var sforzi_estremi = "sforzo_estremo" in tagCount ? tagCount["sforzo_estremo"] : 0;
    var crolla = "crolla" in tagCount ? tagCount["crolla"] : 0;

    // questi simboli non aggiungono costo al PA
    nsymbols -= sforzi_estremi + crolla

    if ( isSuper ) {
        cost = superBaseCost + (nsymbols-superFreeSymbols);
    } else {
        cost = baseCost + (nsymbols-freeSymbols);
    }

    // cadi al massimo una volta
    if ( crolla > 0 && nsymbols > 0 ) {
        cost -= 1;
    }

    // quanti sforzi estremi vuoi
    if ( sforzi_estremi > 0 ) {
        var discount  = Math.min(nsymbols, sforzi_estremi);
        cost -= discount;
    }

    return Math.max(2, cost);
}

function removeOne(charModel, moveIndex, isSuper) {
    var array = charModel.moves
    if ( isSuper ) {
        array = charModel.superMoves
    }
    if ( moveIndex > -1 ) {
        array.splice(moveIndex, 1)
    }
}
