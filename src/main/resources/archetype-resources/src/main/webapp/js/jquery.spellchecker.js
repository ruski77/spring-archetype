/*
 * jquery.spellchecker.js - a simple jQuery Spell Checker
 * Copyright (c) 2009 Richard Willis
 * MIT license  : http://www.opensource.org/licenses/mit-license.php
 * Project      : http://jquery-spellchecker.googlecode.com
 * Contact      : willis.rh@gmail.com
 */

(function(JQuery){

	JQuery.fn.extend({
		
		spellchecker : function(options, callback){
			return this.each(function(){
				var obj = JQuery(this).data('spellchecker');
				if (obj && String === options.constructor && obj[options]) {
					obj[options](callback);
				} else if (obj) {
					obj.init();
				} else {
					JQuery(this).data('spellchecker', new SpellChecker(this, (Object === options.constructor ? options : null)));
					(String === options.constructor) && JQuery(this).data('spellchecker')[options](callback);
				}
			});
		}
	});

	var SpellChecker = function(domObj, options) {
		this.options = JQuery.extend({
			url: 'checkspelling.php',	// default spellcheck url
			lang: 'en',			// default language 
			engine: 'pspell',		// pspell or google
			addToDictionary: false,		// display option to add word to dictionary (pspell only)
			wordlist: {
				action: 'after',	// which jquery dom insert action
				element: domObj		// which object to apply above method
			},
			suggestBoxPosition: 'below',	// position of suggest box; above or below the highlighted word
			innerDocument: false		// if you want the badwords highlighted in the html then set to true
		}, options || {});
		this.$domObj = JQuery(domObj);
		this.elements = {};
		this.init();
	};

	SpellChecker.prototype = {

		init : function(){
			var self = this;
			this.createElements();
			this.$domObj.addClass('spellcheck-container');
			// hide the suggest box on document click
			JQuery(document).bind('click', function(e){
				(!JQuery(e.target).hasClass('spellcheck-word-highlight') && 
				!JQuery(e.target).parents().filter('.spellcheck-suggestbox').length) &&
				self.hideBox();
			});
		},

		// checks a chunk of text for bad words, then either shows the words below the original element (if texarea) or highlights the bad words
		check : function(callback){

			var self = this, node = this.$domObj.get(0).nodeName, 
			tagExp = '<[^>]+>', 
			puncExp = '^[^a-zA-Z\\u00A1-\\uFFFF]|[^a-zA-Z\\u00A1-\\uFFFF]+[^a-zA-Z\\u00A1-\\uFFFF]|[^a-zA-Z\\u00A1-\\uFFFF]$|\\n|\\t|\\s{2,}';

			if (node == 'TEXTAREA' || node == 'INPUT') {
				this.type = 'textarea';
				var text = JQuery.trim(
					this.$domObj.val()
					.replace(new RegExp(tagExp, 'g'), '')	// strip html tags
					.replace(new RegExp(puncExp, 'g'), ' ') // strip punctuation
				);
			} else {
				this.type = 'html';
				var text = JQuery.trim(
					this.$domObj.text()
					.replace(new RegExp(puncExp, 'g'), " ") // strip punctuation
				);
			}
			this.postJson(this.options.url, {
				text: encodeURIComponent(text).replace(/%20/g, '+')
			}, function(json){
				self.type == 'html' && self.options.innerDocument ? 
				self.highlightWords(json, callback) : 
				self.buildBadwordsBox(json, callback); 
			});
		},

		highlightWords : function(json, callback) {
			if (!json.length) { callback.call(this.$domObj, true); return; }

			var self = this, html = this.$domObj.html();
			
			JQuery.each(json, function(key, replaceWord){
				html = html.replace(
					new RegExp('([^a-zA-Z\\u00A1-\\uFFFF])('+replaceWord+')([^a-zA-Z\\u00A1-\\uFFFF])', 'g'),
					'$1<span class="spellcheck-word-highlight">$2</span>$3'
				);
			});
			this.$domObj.html(html).find('.spellcheck-word-highlight').each(function(){
				self.elements.highlightWords.push(
					JQuery(this).click(function(){
						self.suggest(this);
					})
				);
			});
			(callback) && callback();
		},

		buildBadwordsBox : function(json, callback){
			if (!json.length) { callback.call(this.$domObj, true); return; }

			var self = this, words = [];

			// insert badwords list into dom
			JQuery(this.options.wordlist.element)[this.options.wordlist.action](this.elements.$badwords);

			// empty the badwords container
			this.elements.$badwords.empty()

			// append incorrectly spelt words
			JQuery.each(json, function(key, badword) {
				if (JQuery.inArray(badword, words) === -1) {
					self.elements.highlightWords.push(
						JQuery('<span class="spellcheck-word-highlight">'+badword+'</span>')
						.click(function(){ self.suggest(this); })
						.appendTo(self.elements.$badwords)
						.after('<span class="spellcheck-sep">,</span> ')
					);
					words.push(badword);
				}
			});
			JQuery('.spellcheck-sep:last', self.elements.$badwords).addClass('spellcheck-sep-last');
			(callback) && callback();
		},

		// gets a list of suggested words, appends to the suggestbox and shows the suggestbox
		suggest : function(word){

			var self = this, $word = JQuery(word), offset = $word.offset();
			this.$curWord = $word;

			if (this.options.innerDocument) {
				this.elements.$suggestBox = this.elements.$body.find('.spellcheck-suggestbox');
				this.elements.$suggestWords = this.elements.$body.find('.spellcheck-suggestbox-words');
				this.elements.$suggestFoot = this.elements.$body.find('.spellcheck-suggestbox-foot');
			}

			this.elements.$suggestFoot.hide();
			this.elements.$suggestBox
			.stop().hide()
			.css({
				opacity: 1,
				width: "auto",
				left: offset.left + "px",
				top: 
					(this.options.suggestBoxPosition == "above" ?
					(offset.top - ($word.outerHeight() + 10)) + "px" :
					(offset.top + $word.outerHeight()) + "px")
			}).fadeIn(200);
			
			this.elements.$suggestWords.html('<em>Loading..</em>');

			this.postJson(this.options.url, {
				suggest: encodeURIComponent(JQuery.trim($word.text()))
			}, function(json){
				self.buildSuggestBox(json, offset);
			});
		},

		buildSuggestBox : function(json, offset){

			var self = this, $word = this.$curWord;

			this.elements.$suggestWords.empty();

			// build suggest word list
			for(var i=0; i < (json.length < 5 ? json.length : 5); i++) {
				this.elements.$suggestWords.append(
					JQuery('<a href="#">'+json[i]+'</a>')
					.addClass((!i?'first':''))
					.click(function(){ return false; })
					.mousedown(function(e){
						e.preventDefault();
						self.replace(this.innerHTML);
						self.hideBox();
					})
				);
			}								

			// no word suggestions
			(!i) && this.elements.$suggestWords.append('<em>(no suggestions)</em>');

			// get browser viewport height
			var viewportHeight = window.innerHeight ? window.innerHeight : JQuery(window).height();
			
			this.elements.$suggestFoot.show();
						
			// position the suggest box
			self.elements.$suggestBox
			.css({
				top :	(this.options.suggestBoxPosition == 'above') ||
					(offset.top + $word.outerHeight() + this.elements.$suggestBox.outerHeight() > viewportHeight + 10) ?
					(offset.top - (this.elements.$suggestBox.height()+5)) + "px" : 
					(offset.top + $word.outerHeight() + "px"),
				width : 'auto',
				left :	(this.elements.$suggestBox.outerWidth() + offset.left > JQuery('body').width() ? 
					(offset.left - this.elements.$suggestBox.width()) + $word.outerWidth() + 'px' : 
					offset.left + 'px')
			});
			
		},

		// hides the suggest box	
		hideBox : function(callback) {
			this.elements.$suggestBox.fadeOut(250, function(){
				(callback) && callback();
			});				
		},
	
		// replace incorrectly spelt word with suggestion
		replace : function(replace) {
			switch(this.type) {
				case 'textarea': this.replaceTextbox(replace); break;
				case 'html': this.replaceHtml(replace); break;
			}
		},

		// replaces a word string in a chunk of text
		replaceWord : function(text, replace){
			return text
				.replace(
					new RegExp("([^a-zA-Z\\u00A1-\\uFFFF]?)("+this.$curWord.text()+")([^a-zA-Z\\u00A1-\\uFFFF]?)", "g"),
					'$1'+replace+'$3'
				)
				.replace(
					new RegExp("^("+this.$curWord.text()+")([^a-zA-Z\\u00A1-\\uFFFF])", "g"),
					replace+'$2'
				)
				.replace(
					new RegExp("([^a-zA-Z\\u00A1-\\uFFFF])("+this.$curWord.text()+")$", "g"),
					'$1'+replace
				);
		},

		// replace word in a textarea
		replaceTextbox : function(replace){
			this.removeBadword(this.$curWord);
			this.$domObj.val(
				this.replaceWord(this.$domObj.val(), replace)
			);
		},

		// replace word in an HTML container
		replaceHtml : function(replace){
			var words = this.$domObj.find('.spellcheck-word-highlight:contains('+this.$curWord.text()+')')
			if (words.length) {
				words.after(replace).remove();
			} else {
				JQuery(this.$domObj).html(
					this.replaceWord(JQuery(this.$domObj).html(), replace)
				);
				this.removeBadword(this.$curWord);
			}
		},
		
		// remove spelling formatting from word to ignore in original element
		ignore : function() {
			if (this.type == 'textarea') {
				this.removeBadword(this.$curWord);
			} else {
				this.$curWord.after(this.$curWord.html()).remove();
			}
		},
		
		// remove spelling formatting from all words to ignore in original element
		ignoreAll : function() {
			var self = this;
			if (this.type == 'textarea') {
				this.removeBadword(this.$curWord);
			} else {
				JQuery('.spellcheck-word-highlight', this.$domObj).each(function(){
					(new RegExp(self.$curWord.text(), 'i').test(this.innerHTML)) && 
					JQuery(this).after(this.innerHTML).remove(); // remove anchor
				});
			}
		},

		removeBadword : function($domObj){
			($domObj.next().hasClass('spellcheck-sep')) && $domObj.next().remove();
			$domObj.remove();
			if (!JQuery('.spellcheck-sep', this.elements.$badwords).length){
				this.elements.$badwords.remove();
			} else {
				JQuery('.spellcheck-sep:last', this.elements.$badwords).addClass('spellcheck-sep-last');
			}
		},
		
		// add word to personal dictionary (pspell only)
		addToDictionary : function() {
			var self= this;
			this.hideBox(function(){
				confirm('Are you sure you want to add the word "'+self.$curWord.text()+'" to the dictionary?') &&
				self.postJson(self.options.url, { addtodictionary: self.$curWord.text() }, function(){
					self.ignoreAll();
					self.check();
				});			
			});
		},
		
		// remove spell check formatting
		remove : function(destroy) {
			destroy = destroy || true;
			JQuery.each(this.elements.highlightWords, function(val){
				this.after(this.innerHTML).remove()
			});
			this.elements.$badwords.remove();
                        this.elements.$suggestBox.remove();
			JQuery(this.domObj).removeClass('spellcheck-container');
			(destroy) && JQuery(this.domObj).data('spellchecker', null);
		},
		
		// sends post request, return JSON object
		postJson : function(url, data, callback){
			var xhr = JQuery.ajax({
				type : 'POST',
				url : url,
				data : JQuery.extend(data, {
					engine: this.options.engine, 
					lang: this.options.lang
				}),
				dataType : 'json',
				cache : false,
				error : function(XHR, status, error) {
					alert('Sorry, there was an error processing the request.');
				},
				success : function(json){
					(callback) && callback(json);
				}
			});
			return xhr;
		},

		// create the spellchecker elements, prepend to body
		createElements : function(){
			var self = this;

			this.elements.$body = this.options.innerDocument ? this.$domObj.parents().filter('html:first').find("body") : JQuery('body');
			this.elements.highlightWords = [];
			this.elements.$suggestWords = this.elements.$suggestWords ||
				JQuery('<div></div>').addClass('spellcheck-suggestbox-words');
			this.elements.$ignoreWord = this.elements.$ignoreWord ||
				JQuery('<a href="#">Ignore Word</a>')
				.click(function(e){
					e.preventDefault();
					self.ignore();
					self.hideBox();
				});
			this.elements.$ignoreAllWords = this.elements.$ignoreAllWords ||
				JQuery('<a href="#">Ignore all</a>')
				.click(function(e){
					e.preventDefault();
					self.ignoreAll();
					self.hideBox();
				});
			this.elements.$ignoreWordsForever = this.elements.$ignoreWordsForever ||
				JQuery('<a href="#" title="ignore word forever (add to dictionary)">Ignore forever</a>')
				.click(function(e){
					e.preventDefault();
					self.addToDictionary();
					self.hideBox();
				});
			this.elements.$suggestFoot = this.elements.$suggestFoot ||
				JQuery('<div></div>').addClass('spellcheck-suggestbox-foot')
				.append(this.elements.$ignoreWord)
				.append(this.elements.$ignoreAllWords)
				.append(this.options.engine == "pspell" && self.options.addToDictionary ? this.elements.$ignoreWordsForever : false);
			this.elements.$badwords = this.elements.$badwords ||
				JQuery('<div></div>').addClass('spellcheck-badwords');
			this.elements.$suggestBox = this.elements.$suggestBox ||
				JQuery('<div></div>').addClass('spellcheck-suggestbox')
				.append(this.elements.$suggestWords)
				.append(this.elements.$suggestFoot)
				.prependTo(this.elements.$body);
		}
	};	

})(jQuery);
