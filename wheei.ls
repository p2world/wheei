startWith=(l,s)->
    return l.slice(0,s.length)==s

trim=(s)->
    if s
        return (''+s).replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,'')
    else
        return ''

_i = 0

statementStack = []


quicks=
    '-':(body)->
        return "__out+=__e(#{body});"
    '=':(body)->
        return "__out+=__o(#{body});"
    '?':(body)->
        if body
            statementStack.push '?'
            return "if(#{body}){"
        else
            type = statementStack.pop()
            if type != '?'
                throw new Error "unclosed `#type`"
            return '}'
    '??':(body)->
        return if body
        then "}else if(#{body}){"
        else '}else{'
    # ~ arr key,value
    '~':(body)->
        if body
            statementStack.push '~'
            a=/^(.+)\s+((\w+)\s*,\s*)?(\w+)$/.exec(body)
            if !a then throw new Error('~ error')
            [,arr,,key,value]=a
            _i++
            res="
                var __ref#{_i}=#arr;
                if(__ref#{_i})for(var __i#{_i}=0,__l#{_i}=__ref#{_i}.length;__i#{_i}<__l#{_i};__i#{_i}++){
                    var #value=__ref#{_i}[__i#{_i}];
            "
            if key
                res+="var #key=__i#{_i};"

            return res
        else
            type = statementStack.pop()
            if type != '~'
                throw new Error "unclosed `#type`"

            return '}'

quickkeys = [ key for key of quicks].sort (a,b)->
    return b.length - a.length



parseScript=(script)->
    for type in quickkeys
        if startWith(script,type)
            typeFunc = quicks[type]
            return typeFunc(trim(script.slice(type.length)),script)
    return script


parseHtml=(html,conf)->
    html.replace(/\\|'/g,'\\$&')

    if conf.strip
        html=trim(html).replace(/\s*\n\s*/g,'')
    else
        html=html.replace(/\n/g,'\\n')
    
    if html
        return "__out+='" +html + '\';'

complie = (text,conf)->
    _i           = 0
    contextType  = \html
    contextStart = 0
    funcArr      = []
    i            = 0

    while i <= text.length
        c              = text[i]
        s2             = text.slice(i,i+2)

        if s2 == conf.open
            if contextType!='html' then throw new Error('script start error')
            funcArr.push(parseHtml(text.slice(contextStart,i),conf))

            i            = i+2
            contextType  = 'script'
            contextStart = i
            continue
        else if s2 == conf.close
            if contextType!='script' then throw new Error('script end error')

            funcArr.push(parseScript(text.slice(contextStart,i),conf))

            i            = i+2
            contextType  = 'html'
            contextStart = i
            continue

        i++;
    if contextType!='html' then throw new Error('template end error')

    if contextStart != i 
        funcArr.push(parseHtml(text.slice(contextStart,i),conf))

    funcContent = funcArr.join('\n')

    return contentStr = """
        var __out='';
        var __o=wheei.parse;
        var __e=wheei.encode;
        #funcContent
        return __out;
    """

wheei = (text,data,conf)->
    conf = ({} <<< wheei.conf) <<< conf
    funcStr = complie(text,conf)
    func = new Function(conf.argName,funcStr)
    if data?
        return func data
    else
        return func

wheei.conf =
    strip:   false
    argName: 'it'
    open:    '{{'
    close:   '}}'

wheei.parse = ->
    if it?
        if \boolean == typeof it
            return if it then 'true' else ''
        else
            return ''+it
    else
        return ''

wheei.encode = ->
    if \string != typeof it
        it = wheei.parse it
    res=''
    for i,c in it
        switch i
        case '/' then res+='&#47;'
        case '\'' then res+='&#39;'
        case '"' then res+='&#34;'
        case '<' then res+='&lt;'
        case '>' then res+='&gt;'
        case '&' then res+='&amp;'
        default  res+=i
    return res

global?.wheei=wheei
window?.wheei=wheei

return wheei