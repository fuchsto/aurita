

function PageLocator(propertyToUse, dividingCharacter) {
    this.propertyToUse = propertyToUse;
    this.defaultQS = 1;
    this.dividingCharacter = dividingCharacter;
}
PageLocator.prototype.getLocation = function() {
    return eval(this.propertyToUse);
}
PageLocator.prototype.getHash = function() {
    var url = this.getLocation();
    if(url.indexOf(this.dividingCharacter) > -1) {
        var url_elements = url.split(this.dividingCharacter);
        return url_elements[url_elements.length-1];
    } else {
        return this.defaultQS;
    }
}
PageLocator.prototype.getHref = function() {
    var url = this.getLocation();
    var url_elements = url.split(this.dividingCharacter);
    return url_elements[0];
}
PageLocator.prototype.makeNewLocation = function(new_qs) {
    return this.getHref() + this.dividingCharacter + new_qs;
}

