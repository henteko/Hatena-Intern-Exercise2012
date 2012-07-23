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

    #入力文字列をhtmlエスケープ
    foreach(keys %hash) {
        $hash{$_} = encode_entities($hash{$_} , qw(&<>"'));
    }
    
    my $out_html; #out用html
    foreach(@html) {
        if(/{!!.*!!}/) {
            #テンプレートコメントは削除する為省略する
            next;
        }
        s/{%\s*(?<name>\w+)\s*%}/$hash{$+{name}}/g; #置換
        $out_html .= $_; #out用htmlに付け足して行く
    }
    close TMP_HTML;
    return $out_html; #置換済みhtml文字列を返す
}


1;
