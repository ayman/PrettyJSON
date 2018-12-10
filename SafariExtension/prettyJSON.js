var aiShamurPrettyJSON = { "raw" : "",
                           "rawHTML" : "",
                           "pretty" : "",
                           "toggled" : false,
                           "loaded" : false };

safari.self.addEventListener("message", handleMessage, false);

window.onfocus = function(event){
    activate(event);
};

document.addEventListener("DOMContentLoaded", function(event) {
    window.aiShamurPrettyJSON.raw = document.body.innerText;
    window.aiShamurPrettyJSON.rawHTML = document.body.innerHTML;
    try {
        var j = JSON.parse(window.aiShamurPrettyJSON.raw);
        window.aiShamurPrettyJSON.pretty = j;
        window.aiShamurPrettyJSON.pretty = JSON.stringify(j, null, 2);
        window.aiShamurPrettyJSON.loaded = true;
    } catch (e) {
        window.aiShamurPrettyJSON.loaded = false;
    }
    if (window.aiShamurPrettyJSON.loaded !== false) {
        var s = syntaxHighlight(window.aiShamurPrettyJSON.pretty);
        s = "<pre class=\"aiShamurPrettyJSON\">" + s + "</pre>";
        window.aiShamurPrettyJSON.pretty = s;
        document.body.innerHTML = window.aiShamurPrettyJSON.pretty;
        window.aiShamurPrettyJSON.toggled = true;
        safari.extension.dispatchMessage("jsonOn");
    } else {
        safari.extension.dispatchMessage("jsonDisabled");
    }
});

function syntaxHighlight(json) {
    if (typeof json != "string") {
        json = JSON.stringify(json, null, 2);
    }
    json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        var cls = "number";
        if (/^"/.test(match)) {
            if (/:$/.test(match)) {
                cls = "key";
            } else {
                cls = "string";
            }
        } else if (/true|false/.test(match)) {
            cls = "boolean";
        } else if (/null/.test(match)) {
            cls = "null";
        }
        return "<span class=\"" + cls + "\">" + match + "</span>";
    });
}

function handleMessage(e) {
    if (e.name == "toggleJSON" && aiShamurPrettyJSON.loaded !== false) {
        if (window.aiShamurPrettyJSON.toggled === true) {
            safari.extension.dispatchMessage("jsonOff");
            document.body.innerHTML = window.aiShamurPrettyJSON.rawHTML;
            window.aiShamurPrettyJSON.toggled = false;
        } else {
            safari.extension.dispatchMessage("jsonOn");
            document.body.innerHTML = window.aiShamurPrettyJSON.pretty;
            window.aiShamurPrettyJSON.toggled = true;
        }
    }
}

function activate(e) {
    if (window.aiShamurPrettyJSON.loaded === false) {
        safari.extension.dispatchMessage("jsonDisabled");
    } else if (window.aiShamurPrettyJSON.toggled === true) {
        safari.extension.dispatchMessage("jsonOn");
    } else {
        safari.extension.dispatchMessage("jsonOff");
    }
}