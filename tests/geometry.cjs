const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync('dist/app.js','utf8');
const block=source.slice(source.indexOf('function spriteGeometry'),source.indexOf('\nconst questions='));
const context={Math,sprite:m=>({naturalWidth:m.width||120,naturalHeight:m.height||160}),state:{round:1,bullets:[]}};
vm.createContext(context);vm.runInContext(block,context);
const close=(a,b)=>assert.ok(Math.abs(a-b)<1e-8,`${a} != ${b}`);
for(const angle of [0,Math.PI/2,Math.PI,-Math.PI/2,.73]){
 const e={x:100,y:200,angle,m:{},cd:0};const tip=context.muzzle(e);
 close(tip.x,100+38.5*Math.cos(angle));close(tip.y,200+38.5*Math.sin(angle));
 context.fire(e,false);const bullet=context.state.bullets.at(-1);close(bullet.x,tip.x);close(bullet.y,tip.y);close(Math.atan2(bullet.vy,bullet.vx),Math.atan2(Math.sin(angle),Math.cos(angle)));
 const count=context.state.bullets.length;context.fire(e,false);assert.equal(context.state.bullets.length,count);
}
// A landscape upload points right before rotation; calibration preserves its aspect ratio.
const m={width:200,height:100,rig:{base:{x:.1,y:.5},tip:{x:.9,y:.5}}};
const e={x:100,y:100,angle:Math.PI/2,m,cd:0};const tip=context.muzzle(e);close(tip.x,100);close(tip.y,128);
const geo=context.spriteGeometry(m);close(geo.w/geo.h,2);
console.log('PASS: calibrated muzzle origins, five rotations, bullet directions, cooldown, landscape image proportions');
for(const stage of [1,2,3]){
 const e={x:250,y:300,angle:.86,m:{},cd:0,stage,visualScale:1.6};
 const tip=context.muzzle(e);const reach=38.5*1.6*(1+stage*.05);
 close(tip.x,250+reach*Math.cos(.86));close(tip.y,300+reach*Math.sin(.86));
 const g=context.spriteGeometry({},stage,1.6);close(g.w,70*1.6*(1+stage*.10));
}
console.log('PASS: scaled/evolved sprite and projectile alignment');
