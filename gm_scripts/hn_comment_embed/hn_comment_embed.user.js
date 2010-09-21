// ==UserScript==
// @name           HN Comment Embed
// @namespace      HNE
// @description    Embed HN metadata & comments in any webpage that has been submitted to Hacker News.
// @include	   *
// @exclude        http://news.ycombinator.com*
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js
// @require        http://courses.ischool.berkeley.edu/i290-4/f09/resources/gm_jq_xhr.js
// ==/UserScript==

if (window.top != window.self)  //don't run on frames or iframes. From http://stackoverflow.com/questions/1535404/how-to-exclude-iframe-in-greasemonkey
    return;

version = 10;

$(document).ready(function() {
  searchYC();
});

function searchYC() {
  queryURL = "http://json-automatic.searchyc.com/domains/find?url=" + escape(window.location.href);
  GM_log("Querying searchYC");
  $.getJSON(queryURL, function(data) {
      if (data.length < 1) {
	GM_log("Entry not found on searchYC. Querying HN newest items.");
	$.get("http://news.ycombinator.com/newest", searchHN);
	return;
      }
      
      var foundItem = data[0];  
      createPanel(foundItem.title + ' posted on ' + foundItem.post_date, 'http://news.ycombinator.com/item?id=' + foundItem.id);
    });
}

function searchHN(html) {
  var titleAnchor = $('a[href=' + window.location.href + ']', html);
  var linkAnchor = titleAnchor.parent().parent().next().find('a').get(1);
  if (linkAnchor) {
    var itemURL = $(linkAnchor).attr('href');
    GM_log('Found item ' + itemURL);
    createPanel($(titleAnchor).text(), 'http://news.ycombinator.com/' + itemURL);
    return;
  }
  GM_log('Item not found on HN newest');
}

function toggleElement(elemName) {
  element = $(elemName);
  if (element.style.display == 'none') {
    element.style.display = 'block';http://stackoverflow.com/questions/1535404/how-to-exclude-iframe-in-greasemonkey
    GM_log('return');
    return;
  }
  GM_log('no return');
  element.style.display = 'none';
}

function createPanel(panelTitle, HNurl) {
  
  GM_log("Displaying HN Item: " + panelTitle + " || URL: " + HNurl);
  
  if ($(".HNembed").length > 0) return; // avoid situations where multiple results might be triggered.
  
  GM_addStyle(<><![CDATA[
    #HNembed 	{ position: fixed;
                  clear: both; 
                  width: 700px; 
                  height: 100%; 
                  border-left: 2px solid gray; 
                  padding: 0px; 
                  margin: 0px; 
                  text-align: center; 
                  color: #335500; 
                  background-color: #F6F6EF; 
                  z-index: 999;  
                  right: -700px; 
                  top: 0; }
    #HNsite 	{ width: 100%;
		  height: 178px; }
    #HNheader 	{ background-color: #FF6600;
		  color: #222222;
		  font-family: Verdana;
		  font-size: 10pt;
		  cursor: pointer;
		  height: 20px; 
		  margin: 0; }
    #HNtab	{ background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAB9CAIAAAA3LDRGAAAACXBIWXMAAA6cAAAOxAF19oSBAAAEoUlEQVRoge2ZfUxVZRjAf+fC/VBASQLjy7IIkGoWosYa4IIYG2b+0WZZyUgn1NZsiba5uZWbbQK6NrcUdSTUFuhW5rRRzfwK5UPTS4Z1nUWBkBdQgpD7ye0PuIPk5b7cw42geP4679lzfud5nvd5n+d9z1Fc6/GJaHyDmQZNMlBs5eDFB40EfUjipzT1qAK19gK0W3jrPH/audRBQY0qUJ8TF1T/jtVJfgK1KzlxQxUoRM/JVk63AaTcx5Iw/rAJ1PyloMwo0o8BBGnJiAQwiB6SW7RjKYvuZZaOkhTCZgBEBwjUlIlbtB9fo6VXDpLH6JWTAA/OYlk4aeEsi2BeoEBN7tryKmrNdFiG7jwQxC8vem/RsSyA693UmNl9hVozikhNDgLuOPimlT2NdFnZn0pOrCrQhnOUmZijZ8sT5MSiHWV65LPmr8FPAdAoYqcGZEx5ZHFSeZ09jbRb2JrIyzH4jzBgTPXI4EfyXF5LINRA7iniD4kMl1KWV1FjptM9/XP0JIWqAh3/DY3C0jCyosmKZkkoGlGo5KBP0smMYo5eojaBi7bHztrThJSh7AOIqaDyuirQhnOU/sQt6+AwKZTqm6pAnzexK5me3MHh5oWUmQRq8mB321m/gAC3YnwwFocqiyJmsu0iPXaAXgdlJqJF9Uhu0bP3U2ik0AgQWAqQn6AKtH0x3TaqmrllJVjPM5FsXyxQm8A8GqN4cm0gA4Uy0g9PoJHaF9rJP8vFDi8tGi5dNrbUUXIVl4u18WpB5SY21WLuY0Ewe1NIDfce9MNtXv+WM20Y/NiWxNuPoxtlejyBNtfy/vfY+3k6gr0pPDzb0ys9gYqMhBoofpI1okZ2l3hKSK+mf/Jl9v8apD3gafq8ACUEAzhd4wa9mwTwc7dETZ5HQr9GPuWzYE/FzJ7eRExvIuTidULa+8k/qwqUc4pe9zSZ+0g/xkfXBGryGJWbqDNzKANHPyu/4kYvn2UK1OQx2n2FN8+j06Ao9DnYn8o60SZC7tobj3I4A6DPwatxYoonizzX6f9GYSsy8lDF0PCRw7x3SRWoqpnn5w8N18XzRbMqUPVNtiUNDXNiqTerAgX4D9aQAXG6CNCqAsUHU2ik00K/i04LOy6L94DyJRKgpchIkXHoTsRM7P13f5Lwe2eRBJQeSa+dDgt3HMwLJDeOA2mCs/Lka5DyGF3uZPUJfuxi+MbGu0PNgBTUcLXLFxZdaOfrbJ77kpaXuEfPQRM16jptj520cObOoPE2wOoYDoo6rRyk90OrITqQI01YnZxpw+YUqMldCzUAxM2muIHiBoCFIapAv64G2JVMj50jTcwPojRNoDa1EtKrY9aEF39ln8CK4TIVT0cTDfLZKXsq9v5pkHv1l8hO0R4kT+FvZSTPw6+B0cVtweSL0ZQBlbhs2Rt9AQLdimJKXNanVo0PlKfYjhbQUq9fU8HWurFY5179JS5hHtmyN+pWFI98zdC1+8F/uEH2xTzmF5epS1yli1pMS73tu0rd8Z1qQDM2NQxcWMtf0FdX6lRbBNiOFuiO75T9MZKC8pSxWDFcpswS+RdBw4I9nmrrwwb5F3/Onc9Lg6h9AAAAAElFTkSuQmCC);
		  background-color: #FF6600;
		  border-color: #F6F6EF; 
		  border-style: solid;
		  border-width: 2px 0px 2px 2px;
		  clear:both;
		  color: #222222;
		  cursor: pointer;
		  font-family: Verdana;
		  font-size: 10pt;
		  font-weight: bold;
		  height: 125px !important; 
		  position: fixed;
		  right: 0;
		  text-align: center;
		  text-indent: -100000px;
		  top: 10%;
		  
		  width: 23px !important; 
		  z-index:999; }
    #HNupdate	{ color: yellow;
		  margin-left: 10px;
		  font-weight: bold; }
    #HNtitle	{ width: 100%; }
  ]]></>.toString());

  HNembed = $("<div />").attr({'id' : 'HNembed'});
  HNsite = $("<iframe />").attr({'id' : 'HNsite', 'src' : HNurl});
  HNtab = $("<div>HackerNews</div>").attr({'id' : 'HNtab'});
  
  panelTitle = ">>> <b>Hacker News</b> >>>";
  HNtitle = $("<span>" + panelTitle + "</span>").attr({'id' : 'HNtitle'});
  HNheader = $("<div />").attr({'id' : 'HNheader'});
  HNupdate = $("<span>Update Script</span>").attr({'id' : 'HNupdate'}).hide().click(function() {
    window.location.href="http://share.shmichael.com/hn_comment_embed.user.js?" + (new Date()).getTime() + ".user.js";
  });

  $(window).resize(fixIframeHeight);

  function fixIframeHeight() {
    HNembed.height($(window).height());
    HNsite.height(HNembed.height()-20);  
  }

  function togglePanel() {
    
    openPanel = HNtab.is(":visible");
    GM_log("Panel Toggle. Is it an openning? " + openPanel);
    
    embedPosition = openPanel ? "0px" : "-700px";
    tabPosition = openPanel ? "-25px" : "0px";
    
    if (openPanel) {
      fixIframeHeight();
      HNtab.animate({right: tabPosition}, 150, "linear", function() {
	HNembed.show();
	HNtab.hide();
	HNembed.animate({right: embedPosition},400,"linear");
      });
    }
    else {
      HNembed.animate({right: embedPosition}, 400, "linear", function() {
	HNtab.show();
	HNembed.hide();
	HNtab.animate({right: tabPosition}, 150, "linear");
      });
    }
  }
  
  HNheader.click(togglePanel);
  HNtab.click(togglePanel);
  
  HNheader.append(HNtitle);
  HNheader.append(HNupdate);
  
  HNembed.append(HNheader);
  HNembed.append(HNsite);
  HNembed.hide();
  
  $('body').append(HNtab);
  $('body').append(HNembed);
  
  checkUpdate(HNupdate);
}

function checkUpdate(HNupdate) {
  GM_log('Checking for updated script...');
  GM_xmlhttpRequest({
    method: 'GET',
    url: 'http://share.shmichael.com/hn_comment_embed.version?'+(new Date()).getTime(),
    headers: {
    'User-agent': 'Mozilla/4.0 (compatible) Greasemonkey',
    'Accept': 'application/atom+xml,application/xml,text/xml',
    'Cache-Control': 'no-cache',
    },
    onload: function(responseDetails) {
      GM_log('Most recent version is ' + responseDetails.responseText);
      if (parseInt(responseDetails.responseText) > version) {
	HNupdate.show();
      }
    }
  });
}

function curry (fn) {
    var args = [];
    for (var i=2, len = arguments.length; i <len; ++i) {
        args.push(arguments[i]);
    };
    return function() {
            fn.apply(window, args);
    };
}

/**
 * Function : dump()
 * Arguments: The data - array,hash(associative array),object
 *    The level - OPTIONAL
 * Returns  : The textual representation of the array.
 * This function was inspired by the print_r function of PHP.
 * This will accept some data as the argument and return a
 * text that will be a more readable version of the
 * array/hash/object that is given.
 * Docs: http://www.openjs.com/scripts/others/dump_function_php_print_r.php
 */
function dump(arr,level) {
	var dumped_text = "";
	if(!level) level = 0;
	
	//The padding given at the beginning of the line.
	var level_padding = "";
	for(var j=0;j<level+1;j++) level_padding += "    ";
	
	if(typeof(arr) == 'object') { //Array/Hashes/Objects 
		for(var item in arr) {
			var value = arr[item];
			
			if(typeof(value) == 'object') { //If it is an array,
				dumped_text += level_padding + "'" + item + "' ...\n";
				dumped_text += dump(value,level+1);
			} else {
				dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
			}
		}
	} else { //Stings/Chars/Numbers etc.
		dumped_text = "===>"+arr+"<===("+typeof(arr)+")";
	}
	return dumped_text;
}