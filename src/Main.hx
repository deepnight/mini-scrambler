class Main extends dn.Process {
	var jBody : J;
	var jSource : J;
	var jResult : J;
	public function new() {
		super();
		jBody = new J("body");
		jSource = jBody.find("#source");
		jResult = jBody.find("#result");
		var jRun = new J("button#run");
		var jCopy = new J("button#copy");

		jSource.keydown( _->reset() );
		jSource.change( _->reset() );
		jSource.on( "paste", _->reset() );

		// Scramble list
		jRun.click( ev->{
			var raw = jSource.val();
			var source = raw.split("\n");
			var i = 0;
			var out = [];
			while( i<source.length ) {
				var original = source[i];

				// Scramble word
				var w = original;
				var limit = 50;
				while( similarity(w,original)>=0.8 && limit-->0 )
					w = scramble(original);

				out.push(w);
				i++;
			}
			jResult.val( out.join("\n") );
			notify("Mélangé !");
		});

		// Copy to clipboard
		jCopy.click( ev->{
			var doc = js.Browser.document;
			jResult.select();
			doc.execCommand("copy");
			notify("Résultat copié dans le presse-papier");
		});

		jSource.focus();
		reset();
	}

	function scramble(w:String) {
		var reg = ~/[^a-zÀ-ú]/gi;
		w = reg.replace(w, "");
		w = StringTools.trim(w);
		w = w.toLowerCase();
		if( w.length>0 ) {
			var letters = w.split("");
			dn.Lib.shuffleArray(letters, Std.random);
			w = letters.join("");
		}
		return w;
	}

	function similarity(a:String, b:String) : Float {
		var sames = 0;
		for(i in 0...a.length)
			if( a.charAt(i)==b.charAt(i) )
				sames++;
		return sames/a.length;
	}

	function notify(str:String) {
		var jNotif = jBody.find("#notif");
		jNotif.text(str);
		jNotif.stop(true).hide().slideDown(200).delay(1400).fadeOut(200);
	}

	function reset() {
		jResult.val("");
	}

	override function update() {
		super.update();
	}
}