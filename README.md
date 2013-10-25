# PIGS

PIGS _(Pi Grooveshark)_ is both a server-side and client-side application that leverages the [Grooveshark RubyGem](http://rubygems.org/gems/grooveshark) to create a convenient way to play music on-demand. You can run PIGS on any Unix-like host; I created this project to run on a Raspberry Pi.

## Installation
PIGS requires [Ruby](http://rayhightower.com/blog/2012/12/03/ruby-on-raspberry-pi/) and [Bundler](http://bundler.io/) to run. My Raspbian install didn't come with those out of the box, so you may need to install those first to get eveything up and running.

PIGS also relies on __mplayer__ for audio output, so make sure you have that installed as well:

```sh
sudo aptitude install mplayer
```

Now you are ready to install and run PIGS:

```sh
git clone https://github.com/hodgesmr/PIGS.git ~/PIGS
cd ~/PIGS
bundle install
ruby PIGSServer.rb
```

You may also specify a port as a runtime argument. The default port is [9001](http://www.youtube.com/watch?v=SiMHTK15Pik).

Once PIGS is running, you can either use its web interface (simply point a browser at the PIGS host) or interact with its exposed methods directly.

## API

If you wish to create your own application to interact with PIGS, you can use the exposed API to make HTTP requests. All requests take plain text and respond with JSON.

### Search

Asks PIGS for search results based on a query string. Returns a JSON array of the results, or null.

__Request:__
```javascript
$.ajax({
	url: './search',
	type: 'POST',
	contentType: 'text/plain',
	dataType: 'json',
	data: 'What Does The Fox Say'
});
```
__Response:__
```javascript
[
	{
		"artistID":"1885806",
		"albumName":"Summer Single",
		"artistName":"Ylvis",
		"track":"1",
		"albumID":"9226785",
		"songName":"What Does The Fox Say?",
		"songID":"39727231"
	},
	{
		"artistID":"2787509",
		"albumName":"Instalok",
		"artistName":"Instalok",
		"track":"0",
		"albumID":"9126419",
		"songName":"What Does Teemo Say(Ylvis the Fox Parody)",
		"songID":"39747605"
	},
	{
		"artistID":"2853426",
		"albumName":"parody",
		"artistName":"instalok",
		"track":"0",
		"albumID":"9259327",
		"songName":"what does teemo say (Ylvis-the fox parody)",
		"songID":"39823019"
	},
	{
		"artistID":"2854700",
		"albumName":"What Does The Fox Say (YouTube Version - Karaoke) (Ylvis Cover)",
		"artistName":"Ylvies",
		"track":"1",
		"albumID":"9262773",
		"songName":"The Fox karaoke instrumental ",
		"songID":"39832995"
	},
	{
		"artistID":"1885806",
		"albumName":"UNKNOWN",
		"artistName":"Ylvis",
		"track":"0",
		"albumID":"9233828",
		"songName":"What Does The Fox Say",
		"songID":"39893240"
	}
]
```

### Lucky

Asks PIGS to play a song based on a query string. Returns a JSON object of the song, or null.

__Request:__
```javascript
$.ajax({
	url: './lucky',
	type: 'POST',
	contentType: 'text/plain',
	dataType: 'json',
	data: 'What Does The Fox Say'
});
```
__Response:__
```javascript
{
	"artistID":"1885806",
	"albumName":"Summer Single",
	"artistName":"Ylvis",
	"track":"1",
	"albumID":"9226785",
	"songName":"What Does The Fox Say?",
	"songID":"39727231"
}
```

### Play

Asks PIGS to play a song based on an ID. Returns a JSON encoded success messsage.

__Request:__
```javascript
$.ajax({
	url: './play',
	type: 'POST',
	contentType: 'text/plain',
	dataType: 'json',
	data: '39727231'
});
```
__Response:__
```javascript
{
	"success":true
}
```

### Control

Asks PIGS to execute a playback command. The currently supported commands are `stop`, `pause_unpause`, `volume_down`, and `volume_up`. Returns a JSON encoded success message.

__Request:__
```javascript
$.ajax({
	url: './control',
	type: 'POST',
	contentType: 'text/plain',
	dataType: 'json',
	data: 'stop'
});
```
__Response:__
```javascript
{
	"success":true
}
```

## FAQ

### Does PIGS scale?
No. It's a simple WEBRick servlet. Probably best to only use this in your home for your own convenience.

### Is it secure?
No. You're sending plain text back and forth over HTTP.

### Do I have to run PIGS on a Raspberry Pi?
No. I created this project to run on my Raspberry Pi, but I've also run it on an Ubuntu box and OS X.

### Why do I get a Grooveshark error when trying to run PIGS?
The API is constantly changing. Thankfully, the grooveshark gem is also actively maintained. Try updating the gem. If that doesn't work, feel free to log an issue.
```sh
gem update grooveshark
```

## A Matt Hodges project

This project is maintained by [@hodgesmr](http://twitter.com/hodgesmr)
