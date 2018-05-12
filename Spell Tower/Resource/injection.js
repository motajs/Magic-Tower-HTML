// JS Bridge
var originalHttp = utils.prototype.http;
utils.prototype.http = function(method, path, data, successCallback, errorCallback, c) {
    console.log(path);
    console.log(path.indexOf("/games/"));
    if (path.indexOf("/games/") != 0) {
        return originalHttp(method, path, data, successCallback, errorCallback, c);
    }
    
    var jsonData = {};
    if (data) {
        data.forEach((value, key) => {
            jsonData[key] = value;
        });
    }
    
    var callBody = {
        "method": "httpRequest",
        "parameters": {
            "path": path,
            "method": method,
            "data": jsonData
        }
    }
    
    window.location.href = "bridge://methodCall/" + encodeURI(JSON.stringify(callBody));
    window.callback = parameters => {
        var parametersData = JSON.parse(parameters);
        var success = parametersData["success"];
        var data = parametersData["data"];
        var error = parametersData["error"];
        if (success) {
            if (successCallback) successCallback(data);
        } else {
            if (errorCallback) errorCallback(error);
        }
    }
}

// upload & download
window.jsinterface = {};
window.jsinterface.download = function (filename, content) {
    var callBody = {
        "method": "download",
        "parameters": {
            "filename": filename,
            "content": content
        }
    }
    
    window.location.href = "bridge://methodCall/" + encodeURI(JSON.stringify(callBody));
}

window.jsinterface.readFile = function () {
    var callBody = {
        "method": "upload",
        "parameters": {
        }
    }
    
    window.location.href = "bridge://methodCall/" + encodeURI(JSON.stringify(callBody));
    window.callback = parameters => {
        var parametersData = JSON.parse(parameters);
        var success = parametersData["success"];
        var content = parametersData["content"];
        if (success) {
            utils.prototype.readFileContent(content);
        }
    }
}

// 音乐自动播放
core.musicStatus.startDirectly = true;
core.musicStatus.bgmStatus = true;
core.setLocalStorage("bgmStatus", true);
core.playBgm(core.bgms[0]);
