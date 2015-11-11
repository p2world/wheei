startWith=(l,s)->
    return l.slice(0,s.length)==s

trim=(s)->
    if s
        return (''+s).replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,'')
    else
        return ''

_i = 0

statementStack = []

statementStackPop = ->
    type = statementStack.pop()
    if !type
        throw new Error "unopend `#it`"
    if type != it
        throw new Error "unclosed `#type`"

quicks=
    '-':(body)->
        return "__out+=__e(#{body});"
    '@':(body)->
        return "__out+=__o(arguments.callee.load(#{body}));"
    '#':(body)->
        if body
            re = /^(\w+)(\s+(.*))?$/.exec(body)
            if !re then throw new Error('# error')
            [,funcName,,args] = re
            return """
                function #funcName(#args){
                    var __out='';
            """
        else
            return 'return __out;}'
    '=':(body)->
        return "__out+=__o(#{body});"
    '?':(body)->
        if body
            statementStack.push '?'
            return "if(#{body}){"
        else
            statementStackPop '?'
            return '}'
    '??':(body)->
        if statementStack[*-1] != '?'
            throw new Error '`??` not in `?`'
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
            statementStackPop '~'
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
        html=html.replace(/\s*\n\s*/g,'')
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
        var __o=wheei.safeParse;
        var __e=wheei.safeEncode;
        #funcContent
        return __out;
    """

wheei = (text,data,conf)->
    conf = ({} <<< wheei.conf) <<< conf
    try
        funcStr = complie(text,conf)
    catch e
        e.message = '[wheei complie error] ' + e.message
        e.message += '\n[tpl]:\n'
        e.message += text
        throw e

    try
        func = new Function(conf.argName,funcStr)
    catch e
        e.message = '[wheei new Function error] ' + e.message
        e.message += '\n[tplFunc]:\n'
        e.message += funcStr
        throw e
      

    if data?
        return func data
    else
        return func

wheei.conf =
    strip:   false
    argName: 'it'
    open:    '<%'
    close:   '%>'

safeClass = ->
    this.html=it;

wheei.markSafe = ->
    if it instanceof safeClass
        return it
    else
        return new safeClass(it)

wheei.safeParse = ->
    if it instanceof safeClass
        it = it.html
    return wheei.parse it


wheei.parse = ->
    if it?
        if \boolean == typeof it
            return if it then 'true' else ''
        else
            return ''+it
    else
        return ''



wheei.safeEncode = ->
    if it instanceof safeClass
        return wheei.parse it.html
    else
        return wheei.encode it

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

wheei.tpls = {}



do ->
    # `this` is global
    this.wheei=wheei