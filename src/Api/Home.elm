module Api.Home exposing (index)

import Api.Helpers
    exposing
        ( get
        )
import HttpBuilder exposing (withJsonBody, send, withExpect)
import Http
import Json.Decode as Decode
import Decoders exposing (dataDecoder, categoriesDecoder)
import Types.Category as Category


index : String -> (List Category.Model -> msg) -> (Http.Error -> msg) -> Cmd msg
index apiBaseUrl tagger errorTagger =
    "home"
        |> get apiBaseUrl
        |> withExpect (Http.expectJson (dataDecoder categoriesDecoder))
        |> send (handleGetHomeComplete tagger errorTagger)


handleGetHomeComplete :
    (List Category.Model -> msg)
    -> (Http.Error -> msg)
    -> Result Http.Error (List Category.Model)
    -> msg
handleGetHomeComplete tagger errorTagger result =
    case result of
        Ok categories ->
            tagger categories

        Err error ->
            errorTagger error