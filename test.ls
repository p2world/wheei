 require './jl'


test = (text,arg,res,conf)->
    func = wheei(text,null,conf)

    if res != func(arg)
        console.log(func.toString())
        throw new Error("#text noteq #res");
    else
        console.log("OK: #text")



test """ aaaa """,{},' aaaa '

test """ 

a

     b


 """,{},'ab',{strip:true}

test """{{var a=1,b={};__out+=1;}}""",{},'1'

test """{{=0}}""",{},'0'
test """{{='0'}}""",{},'0'
test """{{=false}}""",{},''
test """{{=true}}""",{},'true'
test """{{=null}}""",{},''
test """{{={} }}""",{},'[object Object]'
test """{{=function(a,b){return a<b;} }}""",{},'function (a,b){return a<b;}'

test """{{-0}}""",{},'0'
test """{{-'/\\'"<>&'}}""",{},'&#47;&#39;&#34;&lt;&gt;&amp;'
test """{{-'0'}}""",{},'0'
test """{{-false}}""",{},''
test """{{-true}}""",{},'true'
test """{{-null}}""",{},''
test """{{-{} }}""",{},'[object Object]'
test """{{-function(a,b){return a<b;} }}""",{},'function (a,b){return a&lt;b;}'

test """b{{if(false){}}aa{{}else if(false){}}cc{{}else{}}dd{{ } }}b""",{},'bddb'


test """b{{?false}}aa{{?}}b""",{},'bb'
test """b{{?true}}aa{{?}}b""",{},'baab'
test """b{{?false}}aa{{??}}cc{{?}}b""",{},'bccb'
test """b{{?true}}aa{{??}}cc{{?}}b""",{},'baab'
test """b{{?false}}aa{{??false}}cc{{??true}}dd{{?}}b""",{},'bddb'

test """{{~[1,2,3] i,v}}{{=i}}{{=v}}{{~}}""",{},'011223'


test '''
{{function list(data){
    var __out='';
}}
    {{~data item}}
        <li>{{-item}}</li>
    {{~}}
{{
    return __out;
}
}}


{{=list(['first','second'])}}
''',{},'<li>first</li><li>second</li>',{strip:true}

try
    test '''
    {{~[1,2,3] k,v}}

    {{?}}
    ''',{},''
    throw new Error 'now is realy error'
catch e
    if e.message == 'unclosed `~`'
        console.log "OK: unclosed check"
    else
        throw e
