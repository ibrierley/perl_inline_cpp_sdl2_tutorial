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

package Entity;

sub new {
    my $class = shift;
    my $type = shift;

    my $self = bless {
        alive   => 1,
        x       => 1,
        y       => 2,
        width   => 100,
        height  => 100,
        type    => $type,
        gfx     => new Gfx,
    }, $class;

    $self->gfx->setxy($self->{ x },$self->{ y });

    return $self;
}

sub gfx    { my $self = shift; return $self->{ gfx } };

package main;

my $sdl = Sdl->new;
$sdl->init();

my $player = Entity->new('player');
$player->{ x } = 3;
$player->{ y } = 4;
$player->gfx->setwidth($player->{ width }, $player->{ height });
$player->gfx->setTextureSlot(1);

$sdl->loadImageIntoSlot("Camel1.png", 1);
$sdl->renderClear();
$sdl->updatePosition( $player->gfx );
$sdl->renderPresent();


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


class Gfx {
    public: 
        int x, y, w, h;
        int textureSlot;
        void setxy( int nx, int ny );
        void setwidth( int nw, int nh );
        void setTextureSlot( int slot );
};

void Gfx::setTextureSlot( int slot ) { textureSlot = slot; }
void Gfx::setxy( int nx, int ny ) { x = nx; y = ny; }
void Gfx::setwidth( int nw, int nh ) { w = nw; h = nh; }


class Sdl {
  private:

  public:
    
    Sdl() {
    	std::cout << "C++ Constructor for Sdl\n";
    }   
    ~Sdl() {
        std::cout << "C++ Destructor for Sdl\n";
    }

    SDL_Texture *textureList[ NUMBER_OF_IMAGES ];
    SDL_Rect currentSpritePos;

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

  void loadImageIntoSlot( char *newImage, int slot ) {
        tempSurface = IMG_Load( newImage );
        if( tempSurface == NULL ) {
                std::cout << "Unable to use surface\n";
        } else {
                SDL_Texture *myTextureAddress = SDL_CreateTextureFromSurface( renderer, tempSurface );
                textureList[ slot ] = myTextureAddress;
        }
        if( textureList[ slot ] == NULL ) { std::cout << "Unable to load image \n"; }
        SDL_FreeSurface( tempSurface );
    }

    void renderClear() {
        SDL_SetRenderDrawColor(renderer, 200, 200, 200, 200);
        SDL_RenderClear(renderer);
    }

    void renderPresent() {
        SDL_RenderPresent(renderer);
    }
 	
    void updatePosition( Gfx *gfx ) {
        currentSpritePos.x = gfx->x;
        currentSpritePos.y = gfx->y;
        currentSpritePos.w = gfx->w;
        currentSpritePos.h = gfx->h;
        SDL_RenderCopyEx(renderer, textureList[ gfx->textureSlot ], NULL, &currentSpritePos, 0.2, NULL, SDL_FLIP_NONE);
    }


};

