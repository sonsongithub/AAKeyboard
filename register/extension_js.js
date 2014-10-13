var MMExtensionClass = function() {};

MMExtensionClass.prototype = {
	run: function(arguments) {
		var text = window.getSelection().toString();
		arguments.completionFunction({"content": text});
	},
	finalize: function(arguments) {
		document.body.innerHTML = arguments["content"];
	}
};

var ExtensionPreprocessingJS = new MMExtensionClass;