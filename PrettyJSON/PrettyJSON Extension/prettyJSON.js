//
//  prettyJSON.js
//  PrettyJSON for Safari
//
//  Created by David A Shamma on 12/10/18.
//
//  This file is part of the PrettyJSON for Safari distribution.
//  Copyright © 2020 David A. Shamma
//  https://github.com/ayman/PrettyJSON/
//  https://shamur.ai/bin/PrettyJSON/
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

var aiShamurPrettyJSON = { raw: '', rawHTML: '', pretty: '', toggled: false, loaded: false };

safari.self.addEventListener('message', handleMessage, false);

window.onfocus = function (event) {
  activate(event);
};

document.addEventListener('DOMContentLoaded', function (event) {
  if (document.contentType === 'application/json') {
    window.aiShamurPrettyJSON.raw = document.body.innerText;
    window.aiShamurPrettyJSON.rawHTML = document.body.innerHTML;
    try {
      var j = JSON.parse(window.aiShamurPrettyJSON.raw);
      window.aiShamurPrettyJSON.pretty = j;
      window.aiShamurPrettyJSON.pretty = JSON.stringify(j, null, 2);
      // console.log(window.aiShamurPrettyJSON);
      var s = syntaxHighlight(window.aiShamurPrettyJSON.pretty);
      s = '<pre class="aiShamurPrettyJSON">' + s + '</pre>';
      window.aiShamurPrettyJSON.pretty = s;
      document.body.innerHTML = window.aiShamurPrettyJSON.pretty;
      window.aiShamurPrettyJSON.toggled = true;
      window.aiShamurPrettyJSON.loaded = true;
      safari.extension.dispatchMessage('jsonOn');
    } catch (e) {
      window.aiShamurPrettyJSON.loaded = false;
      safari.extension.dispatchMessage('jsonDisabled');
    }
    // console.log(window.aiShamurPrettyJSON);
  }
});

function syntaxHighlight(jsonIn) {
  if (typeof jsonIn != 'string') {
    json = JSON.stringify(json, null, 2);
  } else {
    json = jsonIn;
  }
  json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  return json.replace(
    /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g,
    function (match) {
      var cls = 'aiShamurPrettyNumber';
      if (/^"/.test(match)) {
        if (/:$/.test(match)) {
          cls = 'aiShamurPrettyKey';
        } else {
          cls = 'aiShamurPrettyString';
        }
      } else if (/true|false/.test(match)) {
        cls = 'aiShamurPrettyBoolean';
      } else if (/null/.test(match)) {
        cls = 'aiShamurPrettyNull';
      }
      return '<span class="' + cls + '">' + match + '</span>';
    }
  );
}

function handleMessage(event) {
  if (event.name == 'toggleJSON' && aiShamurPrettyJSON.loaded !== false) {
    if (window.aiShamurPrettyJSON.toggled === true) {
      safari.extension.dispatchMessage('jsonOff');
      document.body.innerHTML = window.aiShamurPrettyJSON.rawHTML;
      window.aiShamurPrettyJSON.toggled = false;
    } else {
      safari.extension.dispatchMessage('jsonOn');
      document.body.innerHTML = window.aiShamurPrettyJSON.pretty;
      window.aiShamurPrettyJSON.toggled = true;
    }
  }
}

function activate(event) {
  if (window.aiShamurPrettyJSON.loaded === false) {
    safari.extension.dispatchMessage('jsonDisabled');
  } else if (window.aiShamurPrettyJSON.toggled === true) {
    safari.extension.dispatchMessage('jsonOn');
  } else {
    safari.extension.dispatchMessage('jsonOff');
  }
}
