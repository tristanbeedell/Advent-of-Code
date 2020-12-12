const canvas = document.getElementById('can')
const c = canvas.getContext('2d');
const out = document.getElementById('output')
let instructions=document.getElementById('input').value.split('\n');

let wpx = 10;
let wpy = -1;
let shipX = 0;
let shipY = 0;
let i = 0

function reset () {
  instructions = document.getElementById('input').value.split('\n');
  wpx = 10;
  wpy = -1;
  shipX = 0;
  shipY = 0;
  i = 0
  print('reset')
}
function stop() {
  document.getElementById('loop').checked = false
  clearInterval(loopInterval);
  reset()
}
function iterate(i) {
  instruction = instructions[i]
  if (!instruction) {print('oops there is no instruction no '+ i); return}
  action = instruction[0].toUpperCase();
  arg = Number(instruction.slice(1));
  if (isNaN(arg)){
    print('instruction no '+(i+1)+': "'+instruction.slice(1)+'" is not a number')
    stop();
    return
  }
  switch (action) {
    case 'N':
      wpy-=arg;
      break;
    case 'S':
      wpy+=arg;
      break;
    case 'E':
      wpx+=arg;
      break;
    case 'W':
      wpx-=arg;
      break;
    case 'L':
      switch (arg) {
        case 90:
          bx = wpx
          by = wpy
          wpx = by
          wpy = -bx
          break;
        case 180:
          wpx *= -1;
          wpy *= -1;
          break;
        case 270:
          bx = wpx
          by = wpy
          wpx = -by
          wpy = bx
          break;
        case 0:
          break;
        default:
          print('tried to rotate '+ arg+ ' degrees. can only rotate in right angles');
          stop()
          return
      }
      break;
    case 'R':
      switch (arg) {
        case 90:
          bx = wpx
          by = wpy
          wpx = -by
          wpy = bx
          break;
        case 180:
          wpx *= -1;
          wpy *= -1;
          break;
        case 270:
          bx = wpx
          by = wpy
          wpx = by
          wpy = -bx
          break;
        case 0:
          break;
        default:
          print('tried to rotate '+ arg+ ' degrees. can only rotate in right angles');
          stop()
          return
      }
      break;
    case 'F':
      shipX += wpx*arg;
      shipY -= wpy*arg;
      break;
    default:
      print('instruction no '+ (i+1) + ': "' + action+'" invald')
      stop()
      return
  }
  
  print('instruction no '+ (i+1) + ': "'+instruction+'" ship at ('+shipX+', '+shipY+') pointing ('+wpx+', '+-wpy+')')
}

function clear() {
  out.innerHTML = ""
}
document.getElementById('clearbutton').onclick = clear;

setInterval(()=>{
  scale = Math.pow(100, document.getElementById('scale').value)
  c.clearRect(0,0,canvas.width,canvas.height);
  c.fillStyle = 'green'
  c.fillRect(canvas.width/2+(shipX)/scale-5, canvas.height/2-(shipY)/scale-5, 10,10);
  c.fillStyle = 'yellow'
  c.fillRect(canvas.width/2+(shipX+wpx)/scale-2, canvas.height/2-(shipY-wpy)/scale-2,4,4);
}, 30)

let loopInterval = setInterval(loop, 1000)

function loop () {
  if (i<instructions.length) {
    iterate(i)
    i++
  } else {
    print('ended at ('+shipX+', '+shipY+') with manhattan distance of '+(Math.abs(shipX)+Math.abs(shipY)))
    reset();
    if (!document.getElementById('loop').checked)
      clearInterval(loopInterval);
  }
}

function setSpeed () {
  clearInterval(loopInterval);
  loopInterval = setInterval(loop, document.getElementById('speed').value)
}

function print(str) {
  out.innerHTML=str+'<br>'+out.innerHTML
}