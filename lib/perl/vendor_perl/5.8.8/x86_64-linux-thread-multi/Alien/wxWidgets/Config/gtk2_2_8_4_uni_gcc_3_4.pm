package Alien::wxWidgets::Config::gtk2_2_8_4_uni_gcc_3_4;

use strict;

our %VALUES;

{
    no strict 'vars';
    %VALUES = %{
$VAR1 = {
          'defines' => '-D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -D__WXGTK__ ',
          'include_path' => '-I/usr/lib64/wx/include/gtk2-unicode-release-2.8 -I/usr/include/wx-2.8 ',
          'alien_package' => 'Alien::wxWidgets::Config::gtk2_2_8_4_uni_gcc_3_4',
          'version' => '2.008004',
          'alien_base' => 'gtk2_2_8_4_uni_gcc_3_4',
          'link_libraries' => ' -lpthread',
          'c_flags' => '-pthread ',
          '_libraries' => {
                            'richtext' => {
                                            'link' => '-lwx_gtk2u_richtext-2.8',
                                            'dll' => 'libwx_gtk2u_richtext-2.8.so'
                                          },
                            'core' => {
                                        'link' => '-lwx_gtk2u_core-2.8',
                                        'dll' => 'libwx_gtk2u_core-2.8.so'
                                      },
                            'gl' => {
                                      'link' => '-lwx_gtk2u_gl-2.8',
                                      'dll' => 'libwx_gtk2u_gl-2.8.so'
                                    },
                            'net' => {
                                       'link' => '-lwx_baseu_net-2.8',
                                       'dll' => 'libwx_baseu_net-2.8.so'
                                     },
                            'html' => {
                                        'link' => '-lwx_gtk2u_html-2.8',
                                        'dll' => 'libwx_gtk2u_html-2.8.so'
                                      },
                            'media' => {
                                         'link' => '-lwx_gtk2u_media-2.8',
                                         'dll' => 'libwx_gtk2u_media-2.8.so'
                                       },
                            'xml' => {
                                       'link' => '-lwx_baseu_xml-2.8',
                                       'dll' => 'libwx_baseu_xml-2.8.so'
                                     },
                            'xrc' => {
                                       'link' => '-lwx_gtk2u_xrc-2.8',
                                       'dll' => 'libwx_gtk2u_xrc-2.8.so'
                                     },
                            'base' => {
                                        'link' => '-lwx_baseu-2.8',
                                        'dll' => 'libwx_baseu-2.8.so'
                                      },
                            'stc' => {
                                       'link' => '-lwx_gtk2u_stc-2.8',
                                       'dll' => 'libwx_gtk2u_stc-2.8.so'
                                     },
                            'aui' => {
                                       'link' => '-lwx_gtk2u_aui-2.8',
                                       'dll' => 'libwx_gtk2u_aui-2.8.so'
                                     },
                            'gizmos' => {
                                          'link' => '-lwx_gtk2u_gizmos-2.8',
                                          'dll' => 'libwx_gtk2u_gizmos-2.8.so'
                                        },
                            'ogl' => {
                                       'link' => '-lwx_gtk2u_ogl-2.8',
                                       'dll' => 'libwx_gtk2u_ogl-2.8.so'
                                     },
                            'qa' => {
                                      'link' => '-lwx_gtk2u_qa-2.8',
                                      'dll' => 'libwx_gtk2u_qa-2.8.so'
                                    },
                            'adv' => {
                                       'link' => '-lwx_gtk2u_adv-2.8',
                                       'dll' => 'libwx_gtk2u_adv-2.8.so'
                                     },
                            'svg' => {
                                       'link' => '-lwx_gtk2u_svg-2.8',
                                       'dll' => 'libwx_gtk2u_svg-2.8.so'
                                     }
                          },
          'compiler' => 'g++',
          'link_flags' => '',
          'linker' => 'g++ -shared -fPIC  ',
          'config' => {
                        'compiler_version' => '3.4',
                        'compiler_kind' => 'gcc',
                        'mslu' => 0,
                        'toolkit' => 'gtk2',
                        'unicode' => 1,
                        'debug' => 0,
                        'build' => 'multi'
                      },
          'prefix' => '/usr'
        };
    };
}

my $key = substr __PACKAGE__, 1 + rindex __PACKAGE__, ':';

sub values { %VALUES, key => $key }

sub config {
   +{ %{$VALUES{config}},
      package       => __PACKAGE__,
      key           => $key,
      version       => $VALUES{version},
      }
}

1;
