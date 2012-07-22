#! /usr/bin/perl
package TemplateEngine;
use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;
use HTML::Entities;
use 5.010;

my $file_name;
sub new {
    my ($class , %data) = @_; #class名とハッシュ値が入る
    my $self = {%data};
    $file_name = $data{'file'};
    die "TemplateEngine -> new error! (Please add the hash.Key is file.)" unless defined $file_name;
    # classとデータを結びつける
    return bless $self, $class;
}

sub render {
    my ($class , $data) = @_;

    #TMP_HTMLとして、テンプレファイルを開く
    open TMP_HTML , $file_name or die "Can't open '$file_name': $!";
    my @html = <TMP_HTML>;

    my %hash = %$data;

    #入力データをutf8にエンコード処理する
    foreach(keys %hash) {
        #$hash{$_} = encode('UTF-8', $hash{$_});
        Encode::_utf8_off($hash{$_}); #Cannot decode string with wide characters対策
        $hash{$_} = decode( 'utf8', $hash{$_} );
    }

    foreach(keys %hash) {
        foreach(@html) {
            if(/{%\s*(?<name>\w+)\s*%}/) {
                #実際に表示するようにhtmlエスケープ処理して結合($` , $'は<title> , </title>など)
                my $value = $` . encode('utf8' , encode_entities($hash{$+{name}} , qw(&<>"'))) . $';
                $_ = $value;
            }
        }
    }
    close TMP_HTML;
    return @html; #置換済みhtml文字列を返す
}


1;
