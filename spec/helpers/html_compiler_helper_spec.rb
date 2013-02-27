# coding: utf-8
require 'spec_helper'

describe HtmlCompilerHelper do
  describe '#html_compiler' do
    subject { helper.html_compiler(string) }

    context 'hiki docの場合はHTMLになって出力されること' do
      let(:string) { "__hikidoc__\n!header" }
      it { should eq "<h2>header</h2>\n" }
    end

    context 'TEXTの場合はそのまま出力されること' do
      let(:string) { "!header\n" }
      it { should eq "!header<br />" }
    end

    context 'URLを含んだテキストの場合はURLがリンクになること' do
      let(:string) { "http://example.com/" }
      it { should eq "<a href='http://example.com/' target='_blank'>http://example.com/</a>" }
    end
  end

  describe '#comment_html_compiler' do
    subject { helper.comment_html_compiler(string) }

    context 'TEXTの場合はそのまま出力されること' do
      let(:string) { "!header" }
      it { should eq "!header" }
    end

    context 'URLを含んだテキストの場合はURLがリンクになること' do
      let(:string) { "http://example.com/" }
      it { should eq "<a href='http://example.com/' target='_blank'>http://example.com/</a>" }
    end
  end
end
