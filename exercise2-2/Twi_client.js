var Twi_client = function(_json) {
    this.json = _json; //自分に変数を設定
};

Twi_client.prototype = {
    count: function() {
        var twi_client = new Array();
        for(var i=0;i < this.json.length;i++) {
            //置換
            var text = this.json[i]['source'].replace(/<a href=.+ rel=.+>(.+)<\/a>/g,function() {
                return RegExp.$1;
            });
        
            //既に出ているかの確認
            var flag = false;
            var id = 0;
            for(var j=0;j < twi_client.length;j++) {
                if(twi_client[j]['name'] == text) {
                    flag = true;
                    id = j;
                    break;
                }
            }
        
            //既に出ているかで条件分岐
            if(flag) {
                //既出なのでそのまま増やす
                twi_client[id]['count']++;
            }else {
                //まだ出てないので、作成してpush
                var tmp = {};
                tmp['name'] = text;
                tmp['count'] = 1;
                tmp['rank'] = 1;
                twi_client.push(tmp);
            }
        
        }
    
        //countで連想配列を多い順にソート
        twi_client.sort(function(a, b) {return a["count"] < b["count"] ? 1 : -1;});
        
        //順位の調整
        //同数が続くと、1位,1位,3位といった感じになるようにした
        var rank = 1;
        var tmp_rank = 1;
        for(var i=0;i < twi_client.length-1;i++) {
            twi_client[i]['rank'] = rank;
            if(twi_client[i]['count'] != twi_client[i+1]['count']) {
                rank += tmp_rank;
                tmp_rank = 1;
            }else {
                tmp_rank++;
            }
        }
        twi_client[twi_client.length-1]['rank'] = rank;
        
        
        return twi_client;
    }
};