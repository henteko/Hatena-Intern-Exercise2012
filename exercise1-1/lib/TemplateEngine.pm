#! /usr/bin/perl
package TemplateEngine;
use strict;
use warnings;
use utf8;
use HTML::Entities;
use IO::File;
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

    # file open
    my $html_fh = new IO::File $this -> {file} , "r";
    my $html = join "" , $html_fh -> getlines;
    $html_fh -> close;

    my %hash = %$data; #リファレンスをhashに変換

    #入力文字列をhtmlエスケープ
    foreach(keys %hash) {
        $hash{$_} = encode_entities($hash{$_} , qw(&<>"'));
    }
    
    $html =~ s/{%\s*(?<name>\w+)\s*%}/$hash{$+{name}}/g; #置換
    return $html;
}


1;
