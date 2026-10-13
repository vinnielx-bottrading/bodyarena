const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync('dist/app.js','utf8');
const block=source.slice(source.indexOf('function normalCrop'),source.indexOf('function editorPoint'));
const c={Math,Uint8Array};vm.createContext(c);vm.runInContext(block,c);
const w=5,h=5,p=new Uint8ClampedArray(w*h*4);
for(let y=0;y<h;y++)for(let x=0;x<w;x++){let i=(y*w+x)*4;const ring=x>=1&&x<=3&&y>=1&&y<=3&&!(x===2&&y===2);p.set(ring?[40,20,10,255]:[255,255,255,255],i);}
assert.equal(c.removeBackgroundPixels(p,w,h,0,0,10),16);
assert.equal(p[(2*w+2)*4+3],255,'A disconnected white area inside the object stays intact');
assert.equal(p[(1*w+1)*4+3],255,'Foreground stays intact');
assert.equal(c.removeBackgroundPixels(p,w,h,0,0,10),0,'Transparent region is a no-op');
const crop=c.normalCrop({x1:80,y1:70,x2:10,y2:20},100,100);
assert.deepEqual(JSON.parse(JSON.stringify(crop)),{x:10,y:20,w:70,h:50});
console.log('PASS: connected background removal, foreground preservation, reversed crop drag');
