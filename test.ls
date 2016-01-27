require './wheei'


test = (text,arg,res,conf)->
    func = wheei(text,null,conf)
    _res = func(arg)

    if res != _res
        console.log(func.toString())
        throw new Error("#text : #_res noteq #res");
    else
        console.log("OK: #text")


test """<%*
this is a comment
this is a comment
this is a comment
this is a comment
%>""",{},''
test """ aaaa """,{},' aaaa '
test """ \\"\"" \\'\'' """,{},""" \\"\"" \\'\'' """

test """ a

a <%=''%> c

     b


 """,{},'aa  cb',{strip:true}

test """<%var a=1,b={};__out+=1;%>""",{},'1'

test """<%=0%>""",{},'0'
test """<%='0'%>""",{},'0'
test """<%=false%>""",{},''
test """<%=true%>""",{},'true'
test """<%=null%>""",{},''
test """<%={} %>""",{},'[object Object]'
test """<%=function(a,b){return a<b;} %>""",{},'function (a,b){return a<b;}'

test """<%-0%>""",{},'0'
test """<%-'/\\'"<>&'%>""",{},'&#47;&#39;&#34;&lt;&gt;&amp;'
test """<%-'0'%>""",{},'0'
test """<%-false%>""",{},''
test """<%-true%>""",{},'true'
test """<%-null%>""",{},''
test """<%-{} %>""",{},'[object Object]'
test """<%-function(a,b){return a<b;} %>""",{},'function (a,b){return a&lt;b;}'
test """<%$'</script>'%>""",{},"""\"<\\/script>\""""

test """b<%if(false){%>aa<%}else if(false){%>cc<%}else{%>dd<% } %>b""",{},'bddb'

test """<%-it%>""",wheei.markSafe('<'),'<'
test """<%=it%>""",wheei.markSafe('<'),'<'

test """b<%?false%>aa<%?%>b""",{},'bb'
test """b<%?true%>aa<%?%>b""",{},'baab'
test """b<%?false%>aa<%??%>cc<%?%>b""",{},'bccb'
test """b<%?true%>aa<%??%>cc<%?%>b""",{},'baab'
test """b<%?false%>aa<%??false%>cc<%??true%>dd<%?%>b""",{},'bddb'

test """<%~[1,2,3] i,v%><%=i%><%=v%><%~%>""",{},'011223'


test '''
<%function list(data){
    var __out='';
%>
    <%~data item%>
        <li><%-item%></li>
    <%~%>
<%
    return __out;
}
%>
<%=list(['first','second'])%>
''',{},'<li>first</li><li>second</li>',{strip:true}

test '''
<%=list(['first','second'],'aaa')%>
<%#list data , a%>
    <%~data item%>
        <li><%-item%></li>
    <%~%>
    <%=a%>
<%#%>
''',{},'<li>first</li><li>second</li>aaa',{strip:true}

try
    test '''
    <%~[1,2,3] k,v%>

    <%?%>
    ''',{},''
    throw new Error 'ERROR: unclosed check'
catch e
    if ~e.message.indexOf('[wheei complie error] unclosed `~`')
        console.log "OK: unclosed check"
    else
        throw e

try
    test '''

    <%?%>
    ''',{},''
    throw new Error 'ERROR: unopend check'
catch e
    if ~e.message.indexOf('[wheei complie error] unopend `?`')
        console.log "OK: unopend check"
    else
        throw e

try
    test '''

    <%varr a%>
    ''',{},''
    throw new Error 'ERROR: new Function check'
catch e
    if ~e.message.indexOf('[wheei new Function error]')
        console.log "OK: new Function check"
    else
        throw e