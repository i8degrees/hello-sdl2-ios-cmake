//
//  MIT License
//
//  Copyright (c) 2013 Jeffrey Carpenter. All rights reserved.
//

#include <iostream>
#include <stdbool.h>

#include "SDL.h"
#include "SDL_image.h"
#include "SDL_ttf.h"

#include "platforms.hpp"

static bool gpause = false;

static const int screen_width = 320;
static const int screen_height = 480;

static SDL_Window *win = NULL;
static SDL_Renderer *renderer = NULL;

int main(int argc, char * argv[])
{
  int x = 0, y = 0; // mouse coords
/*
  int dx = 0, dy = 0;
  unsigned char state;
*/
  std::cout << "\n" << "Entry of " << __func__ << "\n";

  if ( SDL_Init ( SDL_INIT_VIDEO ) < 0 )
  {
    printf ( "Error: %s\n", SDL_GetError() );
    exit ( -1 );
  }
  atexit ( SDL_Quit );

  // FIXME: See notes in CMakeLists.txt
  //
  // if ( IMG_Init ( IMG_INIT_PNG ) != IMG_INIT_PNG )
  // {
  //   std::cout << "\n" << IMG_GetError() << "\n";
  //   exit ( -1 );
  // }
  // atexit ( IMG_Quit );

  if ( TTF_Init () == -1 )
  {
    std::cout << "\n" << TTF_GetError() << "\n";
    exit ( -1 );
  }
  atexit ( TTF_Quit );

  #if defined( NOM_PLATFORM_IOS ) // Hide the status bar
    win = SDL_CreateWindow  ( NULL, 0, 0, 0, 0,
                              SDL_WINDOW_SHOWN | SDL_WINDOW_BORDERLESS
                            );
  #elif defined( NOM_PLATFORM_OSX ) // Create a window that mimics iPhone 4s'
                                    // native resolution.
    win = SDL_CreateWindow  ( "SDL2 OS X & iOS app",
                              SDL_WINDOWPOS_UNDEFINED,
                              SDL_WINDOWPOS_UNDEFINED,
                              960,  // width
                              640,  // height
                              SDL_WINDOW_SHOWN
                            );
  #endif

  if ( !win )
  {
    printf ( "Error: %s\n", SDL_GetError() );
    exit ( 1 );
  }

  renderer = SDL_CreateRenderer(win,-1,0);

  bool running = true;
  SDL_Event event;

  SDL_Rect rect;
  rect.x = 0;
  rect.y = 0;
  rect.w = screen_width / 2;
  rect.h = screen_height / 2;

  SDL_Rect rect2;
  rect2.x = 192;
  rect2.y = 128;
  rect2.w = 128;
  rect2.h = 128;

  SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
  SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0xFF );
  SDL_RenderClear(renderer);

  while ( running )
  {
    while ( SDL_PollEvent ( &event ) )
    {
      switch ( event.type )
      {
        default: /* ignore */ break;

        case SDL_QUIT:
        {
          running = false;
          break;
        }

        case SDL_MOUSEBUTTONDOWN:
        {
          switch ( event.button.button )
          {
            case SDL_BUTTON_LEFT:
            {
              x = event.button.x;
              y = event.button.y;
              //state = SDL_GetMouseState(&x, &y);  /* get its location */
              //SDL_GetRelativeMouseState(&dx, &dy);        /* find how much the mouse moved */
              //if ( state & SDL_BUTTON_LMASK ) /* is the mouse (touch) down? */
              //{
              SDL_Rect mouse;
              mouse.x = x;
              mouse.y = y;
              mouse.w = 64;
              mouse.h = 64;

              SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
              SDL_SetRenderDrawColor ( renderer, 0x0, 0xFF, 0x0, 0xFF );
              SDL_RenderFillRect ( renderer, &mouse );
              std::cout << "\nLEFT\n";
              break;
            } // SDL_BUTTON_LEFT

            case SDL_BUTTON_RIGHT:
            {
              std::cout << "\nRIGHT\n";
              break;
            }
          } // event.button.button
        } // MOUSEBUTTON_DOWN
/*

          state = SDL_GetMouseState(&x, &y);
          //SDL_GetRelativeMouseState(&dx, &dy);

          if ( state & SDL_BUTTON_RMASK )
          {
            SDL_Rect mouse2;
            mouse2.x = x;
            mouse2.y = y;
            mouse2.w = 64;
            mouse2.h = 64;

            SDL_SetRenderDrawColor ( renderer, 0x0, 0x0, 0xFF, 0xFF );
            SDL_RenderFillRect ( renderer, &mouse2 );
            std::cout << "\nRight\n";
          }
          break;
        }
*/
      } // event.type
    } // events

    if ( gpause != true )
    {
      SDL_RenderPresent ( renderer );

      SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_ADD);
      SDL_SetRenderDrawColor ( renderer, 0xFF, 0x0, 0xFF, 0xFF );
      SDL_RenderFillRect ( renderer, &rect );

      SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_ADD);
      SDL_SetRenderDrawColor ( renderer, 0xFF, 0x0, 0x0, 0xFF );
      SDL_RenderFillRect ( renderer, &rect2 );
    }
  }

  SDL_DestroyWindow(win);

  std::cout << "\n" << "Exit of " << __func__ << "\n";

  return 0;
}
