#! /usr/bin/perl
package TemplateEngine;
use strict;
use warnings;
use utf8;
use HTML::Entities;
use 5.010;

binmode(STDOUT, ":utf8"); #出力をutf8に #Wide character in print対策

sub new {
    my ($class , %data) = @_; #class名とハッシュ値が入る
    my $self = {%data};
    # classとデータを結びつける
    return bless $self, $class;
}

sub render {
    my ($this , $data) = @_;

    #TMP_HTMLとして、テンプレファイルを開く
    my $file_name = $this -> {file}; #newで紐づけたfileを取得
    open TMP_HTML , $file_name or die "Can't open '$file_name': $!";
    my @html = <TMP_HTML>;

    my %hash = %$data; #リファレンスをhashに変換
    
    my $out_html; #out用html
    foreach(@html) {
        if(&comment_delete($_)) {next;} #テンプレートコメントは削除する為次に進む
        unless(&template_if(\$_ , \%hash)) {next;}
        $out_html .= &replace_variable($_,\%hash); #変数置換関数呼び出し #out用htmlに付け足して行く
    }
    close TMP_HTML;
    return $out_html; #置換済みhtml文字列を返す
}

#変数置換関数
#引数:
#1:置換対象文字列
#2:置換後文字列のハッシュリファレンス
#返り値:
#置換後文字列
sub replace_variable {
    my($s , $refa) = @_;
    my %hash = %$refa;
    if(/{%\s*(?<name>\w+)\s*%}/) {
        #htmlエスケープ処理
        my $value = encode_entities($hash{$+{name}} , qw(&<>"'));
        #htmlエスケケープした値で置換
        $s =~ s/{%\s*(?<name>\w+)\s*%}/$value/g;
    }
    return $s;
}

#テンプレートコメント削除関数
#引数:
#1:判断対象文字列
#返り値:
#true or false
sub comment_delete {
    my($s) = @_;
    return $s =~ /{!!.*!!}/;
}

sub template_if {
    my $value = $_[0];
    my $hash = $_[1];
    my %hash = %$hash;
    my $flag =  1; #set true
    if($$value =~ /{if\s*(?<name>\w+)\s*}/) {
        $flag = $hash{$+{name}};
        if($flag) { $$value =~ s/{if\s*\w+\s*}//g;}
    }elsif ($$value =~ /unless\s*(?<name>\w+)\s*}/) {
        $flag = !$hash{$+{name}};
        if($flag) { $$value =~ s/{unless\s*\w+\s*}//g;}
    }
    return $flag;
}


1;
