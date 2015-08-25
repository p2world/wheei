require('./wheei.js');
var Path=require('path');
var fs=require('fs');

var wheei=global.wheei;

var expressSetting;

var caches={};


function compile(path){
	var tplf;
	if(expressSetting['view cache']){
		tplf=caches[path];
	}
	if(!tplf){
		var tpls;

		try{
			tpls=fs.readFileSync(path,'UTF-8');
		}catch(e){
			e.message = '[wheei load error] ' + e.message;
			throw e;
		}

		tplf=wheei(tpls);

		var dir=Path.dirname(path);

		tplf.load=function(des,options){
			if(des[0]==='/'){
				des=Path.join(expressSetting.views,des.slice(1));
			}else{
				des=Path.join(dir,des);
			}
			return render(des,options);
		};

		if(expressSetting['view cache']){
			caches[path]=tplf;
		}
	}

	return tplf;
}

function render(path, options){
	var tplf;

	try{
		tplf=compile(path);
	}catch(e){
		throw e;
	}
	var html;

	try{
		html=tplf(options);
	}catch(e){
		e.message = '[wheei render error] ' + e.message;
        e.message += '\n[tplFunc]:\n';
        e.message += tplf;

		throw e;
	}

	return html;
}

wheei.load=function(path,data){
	return render(Path.join(expressSetting.views,path),data);
};

wheei.__express=function(path, options, fn){
	expressSetting=options.settings;
	try{
		fn(null,render(path,options));
	}catch(e){
		fn(e);
	}
};




module.exports=wheei;