module Element.Input.Elastic exposing (..)

import Browser.Dom
import Element
import Element.Input as Input
import Html.Attributes
import Task


type alias TextSize =
    Maybe ( Int, Int )


getSize : Task.Task Browser.Dom.Error TextSize
getSize =
    Task.map (\sizer -> Just ( ceiling sizer.element.width, ceiling sizer.element.height ))
        (Browser.Dom.getElement "sizer")


text :
    List (Element.Attribute msg)
    ->
        { onChange : String -> msg
        , text : String
        , size : TextSize
        , placeholder : Maybe (Input.Placeholder msg)
        , label : Input.Label msg
        }
    -> Element.Element msg
text attributes config =
    let
        sizeAttrs =
            case config.size of
                Nothing ->
                    [ style "width" "12px" ]

                Just ( width, height ) ->
                    [ style "width" (String.fromInt width ++ "px")
                    , style "height" (String.fromInt height ++ "px")
                    ]
    in
    Element.column []
        [ Input.text (attributes ++ sizeAttrs)
            { onChange = config.onChange
            , text = config.text
            , placeholder = config.placeholder
            , label = config.label
            }
        , Element.el
            [ Element.htmlAttribute <| Html.Attributes.id "sizer"
            , style "position" "fixed"
            , style "top" "0"
            , style "right" "0"
            , style "overflow" "scroll"
            , style "visibility" "hidden"
            , style "white-space" "pre"
            , style "padding" "12px"
            ]
            (Element.text config.text)
        ]


style name value =
    Element.htmlAttribute <| Html.Attributes.style name value
