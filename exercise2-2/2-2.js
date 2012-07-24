var main = function() {
    var twi_client = new Twi_client(json);
    var client_count = new Array();
    client_count = twi_client.count();
    
    var source = document.getElementById('template').innerHTML;
    var template = new Template({
        source: source
    });
    
    //client_countの数だけtemplate.renderを実行する
    for(var i=0;i < client_count.length;i++) {
        document.getElementById('result').innerHTML += template.render({
            rank : "第" + client_count[i]['rank'] + "位",
            client_name: client_count[i]['name'],
            count: " : " + client_count[i]['count'] + "ツイート",
        });
    }
    
};

document.addEventListener('DOMContentLoaded', main);