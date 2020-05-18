module Main exposing (..)

import Browser
import Browser.Dom
import Element
import Element.Input as Input
import Element.Input.Elastic as ElasticInput exposing (TextSize)
import Html exposing (Html)
import Task


type alias Model =
    { text : String
    , textSize : ElasticInput.TextSize
    }


type Msg
    = TextChanged String
    | GotTextSize (Result Browser.Dom.Error TextSize)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { text = ""
      , textSize = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextChanged newText ->
            ( { model | text = newText }, Task.attempt GotTextSize <| ElasticInput.getSize )

        GotTextSize (Ok size) ->
            ( { model | textSize = size }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view { text, textSize } =
    Element.layout [] <|
        ElasticInput.text []
            { onChange = TextChanged
            , text = text
            , size = textSize
            , placeholder = Nothing
            , label = Input.labelHidden ""
            }


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
