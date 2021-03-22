#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw( usleep gettimeofday );

use Inline CPP => config => libs => '-L/usr/local/lib -lSDL2 -lSDL2_image -lSDL-Wl,-rpath=/usr/local/lib';
#use Inline CPP => config => ccflags => '-Wall -c -std=c++11 -I/usr/local/include';
#use Inline CPP => config => inc => '-I/usr/local/include';
#use Inline CPP => config => cc => '/usr/bin/g++';

use Inline CPP => 'DATA';

my $sdl = Sdl->new;
$sdl->init();
sleep 2;


__DATA__
__CPP__

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <iostream>
#include <map>

const int SCREEN_WIDTH = 800;
const int SCREEN_HEIGHT = 600;
const int NUMBER_OF_IMAGES = 2;

SDL_Renderer *renderer = NULL;
SDL_Window *window;
SDL_Surface* tempSurface;


class Sdl {
  private:

  public:
    
    Sdl() {
    	std::cout << "C++ Constructor for Sdl\n";
    }   
    ~Sdl() {
        std::cout << "C++ Destructor for Sdl\n";
    }

    int init() {
        int x = SDL_Init(SDL_INIT_VIDEO);
        if( x == 0 ) {
            window = SDL_CreateWindow("SDL2 Window",
                                       SDL_WINDOWPOS_CENTERED,
                                       SDL_WINDOWPOS_CENTERED,
                                       SCREEN_WIDTH, SCREEN_HEIGHT,
                                       0);
            renderer = SDL_CreateRenderer( window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC );
        } else {
	    std::cout << "Had a problem creating a window! " << SDL_GetError();
	}
        if( window == NULL ) {
            std::cout << "Window null";
            exit( 0 );
        }
        if( renderer == NULL ) {
            std::cout << "Renderer null";
            exit( 0 );
        }
        return 0;
  }

};

