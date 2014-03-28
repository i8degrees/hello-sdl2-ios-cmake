//
//  MIT License
//
//  Copyright (c) 2013 Jeffrey Carpenter. All rights reserved.
//

#include <iostream>
#include <stdbool.h>
#include <memory>

#include "SDL.h"

#define USE_SDL2_IMAGE

#if defined( USE_SDL2_IMAGE )
  #include "SDL_image.h"
#endif

#include "SDL_ttf.h"

#include "platforms.hpp"

#if defined( NOM_PLATFORM_IOS )
  // #include <CoreServices/CoreServices.h>
  #include <CoreFoundation/CoreFoundation.h>
#endif

/// Pretty print C macros purely for convenience sake
#define NOM_DUMP(var) \
  ( std::cout << #var << ": " << var << std::endl << std::endl )

#define NOM_LOG_INFO(identifier, message) \
  ( std::cout << #identifier << "_LOG_INFO at: " << message << std::endl << std::endl )

#define NOM_LOG_ERR(identifier, message) \
  ( std::cout << #identifier << "_LOG_ERR at: " << "In file " << __FILE__ << ":" << __LINE__ << std::endl << "Reason: " << message << std::endl << std::endl )

#define NOM_LOG_TRACE(identifier) \
  ( std::cout << #identifier << "_LOG_TRACE at " << __func__ << std::endl << std::endl )

#define NOM_ASSERT(expression) \
  ( assert (expression) )

static bool gpause = false;

static const int screen_width = 960;
static const int screen_height = 640;

static SDL_Window *win = NULL;
static SDL_Renderer *renderer = NULL;

static std::string font_file;
static std::string bmp_file;

const std::string resource_path( const std::string& identifier )
{
  char resources_path [ PATH_MAX ]; // file-system path
  CFBundleRef bundle; // bundle type reference

  // Look for a bundle using its identifier if string passed is not null
  // terminated
  if ( identifier != "\0" )
  {
    CFStringRef identifier_ref; // Apple's string type

    identifier_ref = CFStringCreateWithCString  ( nullptr, identifier.c_str(),
                                                  strlen ( identifier.c_str() )
                                                );

    bundle = CFBundleGetBundleWithIdentifier ( identifier_ref );
  }
  else // Assume that we are looking for the top-level bundle's Resources path
  {
    bundle = CFBundleGetMainBundle();
  }

  CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL ( bundle );

  if ( ! CFURLGetFileSystemRepresentation ( resourcesURL, true, ( unsigned char* ) resources_path, PATH_MAX ) )
  {
    NOM_LOG_ERR ( NOM, "Could not obtain the bundle's Resources path." );

    CFRelease ( resourcesURL );

    return "\0";
  }

  CFRelease ( resourcesURL );

  return resources_path;
}

void ApplySurface(int x, int y, SDL_Texture *tex, SDL_Renderer *rend, SDL_Rect *clip = NULL){
    SDL_Rect pos;
    pos.x = x;
    pos.y = y;
    //Detect if we should use clip width settings or texture width
    if (clip != NULL){
        pos.w = clip->w;
  pos.h = clip->h;
    }
    else {
        SDL_QueryTexture(tex, NULL, NULL, &pos.w, &pos.h);
    }
    SDL_RenderCopy(rend, tex, clip, &pos);
}

int main(int argc, char * argv[])
{
  std::shared_ptr<TTF_Font> ttf_font;
  SDL_Texture* ttf_tex = nullptr;
  SDL_Surface* img = nullptr;

  int x = 0, y = 0; // mouse coords
/*
  int dx = 0, dy = 0;
  unsigned char state;
*/

  std::string path = resource_path("");

  // font_file = path + "/" + "Resources/arial.ttf";
  font_file = path + "/" + "arial.ttf";
  NOM_DUMP( font_file );

  NOM_LOG_TRACE( NOM );

  if ( SDL_Init ( SDL_INIT_VIDEO ) < 0 )
  {
    printf ( "Error: %s\n", SDL_GetError() );
    return NO;
  }
  atexit ( SDL_Quit );

  if ( TTF_Init () == -1 )
  {
    std::cout << "\n" << TTF_GetError() << "\n";
    return NO;
  }
  atexit ( TTF_Quit );

  SDL_Point w_size;
  #if defined( NOM_PLATFORM_IOS ) // Hide the status bar
    win = SDL_CreateWindow  (
                              // NULL, 0, 0, 0, 0,
                             NULL, 0, 0, 0, 0,
                              SDL_WINDOW_SHOWN | SDL_WINDOW_BORDERLESS
                            );

  #elif defined( NOM_PLATFORM_OSX ) // Create a window that mimics iPhone 4s'
                                    // native resolution.
    win = SDL_CreateWindow  ( "SDL2 OS X & iOS app",
                              SDL_WINDOWPOS_UNDEFINED,
                              SDL_WINDOWPOS_UNDEFINED,
                              screen_width,
                              screen_height,
                              SDL_WINDOW_SHOWN
                            );
  #endif

  if ( !win )
  {
    printf ( "Error: %s\n", SDL_GetError() );
    exit ( 1 );
  }

  // iPhone 4s Portrait mode: 640x960
  // iPhone 4s Landscape mode: 960x640
  SDL_GetWindowSize ( win, &w_size.x, &w_size.y );

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

  #if defined( USE_SDL2_IMAGE )
    bmp_file = path + "/" + "board.png";
    NOM_LOG_INFO( NOM, bmp_file );

    if ( IMG_Init ( IMG_INIT_PNG ) != IMG_INIT_PNG )
    {
      NOM_LOG_ERR( NOM, IMG_GetError() );
      return NO;
    }
    atexit ( IMG_Quit );

    img = IMG_Load( bmp_file.c_str() );

    if( img == nullptr )
    {
      NOM_LOG_ERR( NOM, IMG_GetError() );
      return NO;
    }
  #else
    bmp_file = path + "/" + "board.bmp";
    NOM_DUMP( bmp_file );

    img = SDL_LoadBMP( bmp_file.c_str() );

    if( img == nullptr )
    {
      NOM_LOG_ERR( NOM, SDL_GetError() );
      return NO;
    }
  #endif

  ttf_font = std::shared_ptr<TTF_Font> ( TTF_OpenFont ( font_file.c_str(), 48 ), TTF_CloseFont );

  if( ttf_font.get() == nullptr )
  {
    NOM_LOG_ERR( NOM, "Font is null");
    return NO;
  }

  SDL_Color c_white;
  c_white.r = 255;
  c_white.g = 255;
  c_white.b = 255;
  c_white.a = 255;

  SDL_Surface* ttf_surf = TTF_RenderText_Blended( ttf_font.get(), "boobies!", c_white );
  ttf_tex = SDL_CreateTextureFromSurface(renderer, ttf_surf);
  SDL_FreeSurface(ttf_surf);

  SDL_Rect board_bounds;
  board_bounds.x = 0;
  board_bounds.y = 0;
  board_bounds.w = 768;
  board_bounds.h = 448;

  // if ( SDL_RenderSetLogicalSize ( renderer, 640, 960 ) != 0 )
  // {
  //   NOM_LOG_ERR( NOM, SDL_GetError() );
    // return NO;
  // }

  SDL_Texture* bmp_tex = SDL_CreateTextureFromSurface(renderer, img );
  SDL_FreeSurface( img );

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

      ApplySurface( 0, 0, bmp_tex, renderer, &board_bounds );
      // ApplySurface( 0, 0, bmp_tex, renderer, nullptr );

      ApplySurface( 64, 64, ttf_tex, renderer, nullptr );
    }
  }

  SDL_DestroyTexture( ttf_tex );
  SDL_DestroyTexture( bmp_tex );
  SDL_DestroyWindow(win);

  NOM_LOG_TRACE( NOM );

  return YES;
}
