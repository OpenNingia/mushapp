function saveCharacter(model) {
    if ( model ) {
        console.log('saving...')
        model.timestamp = Date.now();
        dataModel.characterData = JSON.stringify(model)
    }
}
