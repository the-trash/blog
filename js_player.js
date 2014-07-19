```js
clrscr = function(){ process.stdout.write('\u001B[2J\u001B[0;0f') }
log = function(){ console.log.apply(console,arguments) }

devider = function(size){
  str = '';
  for(i = 0; i < size; i++){ str += '*' };
  log(str);
}

d_size = 50;

clrscr();

BasePlayerClass = function(){
  this.state = 'pause';

  this.current_track = null;
  this.current_track_index = null;

  this.play = function(){
    if(this.playList.length){
      num = this.current_track_index || 0;
      tarck = this.playList[num]     || this.playList[0];

      this.current_track_index = num;
      this.current_track = tarck;
      this.state = 'play';
    }
  }

  this.stop = function(){
    this.state = 'pause';
  }

  // PlayList
  this.playList = [];

  this.playListAdd = function(name){
    this.playList.push(name);
  }

  this.playListRm = function(){
    this.playList.pop();
  }

  this.PlayListCLean = function(){
    this.playList = []
  }

  return this;
}

// log(BasePlayerClass);
// log(new BasePlayerClass);

// Create Player
basePlayer = new BasePlayerClass;
// log(basePlayer);

devider(d_size);
log('UseCase 1');
devider(d_size);

basePlayer.play();
log(basePlayer.playList);            // []
log(basePlayer.state);               // pause
log(basePlayer.current_track);       // null
log(basePlayer.current_track_index); // null

// Build a play list
basePlayer.playListAdd('Bob Marley::No women no cry');
basePlayer.playListAdd('The Beatles::Let It Be');

devider(d_size);
log('UseCase 2');
devider(d_size);

log(basePlayer.playList); // [ 'Bob Marley::No women no cry', 'The Beatles::Let It Be' ]

basePlayer.play();
log(basePlayer.state);               // play
log(basePlayer.current_track);       // Bob Marley::No women no cry
log(basePlayer.current_track_index); // 0

devider(d_size);
log('UseCase 3');
devider(d_size);

basePlayer.stop();
log(basePlayer.state);               // pause
log(basePlayer.current_track);       // Bob Marley::No women no cry
log(basePlayer.current_track_index); // 0

devider(d_size);

```
