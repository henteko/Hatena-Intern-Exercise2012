var Template = function(input) {
    this.tmp_html = input['source']; //自分に変数を設定
};

Template.prototype = {
    render: function(variables) {
        //htmlエスケープ
        for(key in variables) {
            variables[key] = htmlEscape(variables[key]);
        }
        //置換
        var out_html = this.tmp_html.replace(/{%\s*(\w+)\s*%}/g,function(){
            return variables[RegExp.$1];
        });
        //出力
        return out_html;
    }
};

//htmlエスケープ関数
function htmlEscape(string) {
    if(string.replace) { //stringでreplaceメソッドが存在する時のみ実行
        string = string.replace(/&/g,"&amp;");
        string = string.replace(/</g,"&lt;");
        string = string.replace(/>/g,"&gt;");
    }
    return string;
}