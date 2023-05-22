//Queries de Sparql en datasets con contenidos turísticos

const String queryReligioso =
    "SELECT ?uri ?geo_long ?geo_lat ?tipo ?web ?nombre ?sig WHERE {\n"
    "?uri a om:CentroReligioso.\n"
    "?uri geo:long ?geo_long. \n"
    "?uri geo:lat ?geo_lat. \n"
    "OPTIONAL {?uri om:tipoCentroReligioso ?tipo. }\n"
    "?uri om:tieneEnlaceSIG ?sig.\n"
    "OPTIONAL  {?uri schema:url ?web }\n"
    "?uri rdfs:label ?nombre. }";

const String queryMonum=
    "SELECT ?uri ?geo_long  ?geo_lat ?clase ?nombre ?sig WHERE {\n"
        "?uri a mon:Monumento.\n"
        "?uri geo:long ?geo_long.\n"
        "?uri geo:lat ?geo_lat.\n"
        "?uri mon:categoria ?clase.\n"
    "?uri mon:nombre ?nombre.\n"
    "OPTIONAL  {?uri mon:urlSig ?sig. }}";

const String queryMuseos=
    "SELECT ?uri ?web ?geo_lat ?geo_long ?nombre ?sig WHERE {\n"
        "?uri a om:Museo.\n"
        "?uri geo:lat ?geo_lat.\n"
        "?uri geo:long ?geo_long.\n"
        "?uri rdfs:label ?nombre.\n"
        "OPTIONAL  {?uri om:tieneEnlaceSIG ?sig. }\n"
        "OPTIONAL {?uri schema:url ?web.}}";

const String queryRestaurantes =
    "select ?URI ?geo_lat ?geo_long ?nombre ?categoria ?capacidad ?telef ?web where{\n"
        "?URI a om:Restaurante.\n"
        "?URI om:categoriaRestaurante ?categoria.\n"
        "?URI om:capacidadPersonas ?capacidad.\n"
        "?URI rdfs:label ?nombre.\n"
        "?URI geo:lat ?geo_lat.\n"
        "?URI geo:long ?geo_long.\n"
        "OPTIONAL{?URI schema:telephone ?telef. }.\n"
        "OPTIONAL{?URI schema:url ?web. }}";

const String queryBarCafes =
    "SELECT ?URI ?nombre ?geo_lat ?geo_long ?capacidad ?email ?web ?telef where{\n"
    "?URI a om:CafeBar.\n"
    "?URI rdfs:label ?nombre.\n"
    "OPTIONAL{?URI schema:email ?email. }\n"
    "OPTIONAL{?URI schema:telephone ?telef. }\n"
    "OPTIONAL{?URI schema:url ?web. }\n"
    "OPTIONAL{?URI om:capacidadPersonas ?capacidad. }\n"
    "?URI geo:long ?geo_long.\n"
    "?URI geo:lat ?geo_lat.}";

const String queryFarmacias =
    "SELECT ?uri ?geo_long ?geo_lat ?nombre ?sig ?telef ?Horario_de_manana_Opens ?Horario_de_manana_Closes ?Horario_de_tarde_invierno_Opens ?Horario_de_tarde_invierno_Closes ?Horario_de_tarde_verano_Opens ?Horario_de_tarde_verano_Closes ?Horario_Extendido_Opens ?Horario_Extendido_Closes WHERE {\n"
    "?uri a far:Farmacia.\n"
    "?uri far:long ?geo_long.\n"
    "?uri far:lat ?geo_lat.\n"
    "?uri far:nombre ?nombre.\n"
    "OPTIONAL  {?uri far:url ?sig. }\n"
    "OPTIONAL  {?uri far:telefono ?telefono. }\n"
    "OPTIONAL  {?uri far:horMananaOpen ?Horario_de_manana_Opens. }\n"
    "OPTIONAL  {?uri far:horMananaClose ?Horario_de_manana_Closes. }\n"
    "OPTIONAL  {?uri far:horTardeVeranoOpen ?Horario_de_tarde_verano_Opens. }\n"
    "OPTIONAL  {?uri far:horTardeVeranoClose ?Horario_de_tarde_verano_Closes. }\n"
    "OPTIONAL  {?uri far:horTardeInviernoOpen ?Horario_de_tarde_invierno_Opens. }\n"
    "OPTIONAL  {?uri far:horTardeInviernoClose ?Horario_de_tarde_invierno_Closes. }\n"
    "OPTIONAL  {?uri far:horExtendidoOpen ?Horario_Extendido_Opens. }\n"
    "OPTIONAL  {?uri far:horExtendidoClose ?Horario_Extendido_Closes. }}\n";

const String queryCentrosDeportivos =
    "SELECT DISTINCT ?URI ?nombre ?geo_lat ?geo_long ?Horario_Invierno_Opens ?Horario_Invierno_Closes ?Horario_Verano_Opens ?Horario_Verano_Closes where{\n"
        "?URI a om:InstalacionDeportiva.\n"
        "?URI foaf:name ?nombre.\n"
        "?URI geo:long ?geo_long.\n"
        "?URI geo:lat ?geo_lat.\n"
        "?URI schema:openingHoursSpecification ?Horario_Invierno.\n"
        "OPTIONAL {\n"
        "?Horario_Invierno schema:name \"Horario Invierno\"@es.\n"
        "?Horario_Invierno schema:opens ?Horario_Invierno_Opens.\n"
        "?Horario_Invierno schema:closes ?Horario_Invierno_Closes }\n"
        "?URI schema:openingHoursSpecification ?Horario_Verano.\n"
        "OPTIONAL {\n"
        "?Horario_Verano schema:name \"Horario Verano\"@es.\n"
        "?Horario_Verano schema:opens ?Horario_Verano_Opens .\n"
        "?Horario_Verano  schema:closes ?Horario_Verano_Closes }\n"
        "}";

//URL de imágenes decorativas de activadores
List<String> imageUrls = ["https://saltaconmigo.com/blog/wp-content/uploads/2022/02/Iglesias-de-Caceres-San-Francisco-Javier-Salto.jpg",
"https://turismo.caceres.es/sites/default/files/styles/simplecrop__16_9_/public/recurso_poi/TORRE%20BUJACO%206.jpg?itok=PrSN_Cam&sc=ef310b0b439bca790877ebd2c8cb7d27",
  "https://cadenaser.com/resizer/k3lz9Fyj0T9tN3EmFQnFbgf2bc0=/1200x900/filters:format(jpg):quality(70)/cloudfront-eu-central-1.images.arcpublishing.com/prisaradio/C4OYE2XKE5A65BPIARPP5UCASE.jpg",
"https://www.radiointerior.es/wp-content/uploads/2020/12/FARMACIA.jpg",
"https://i.blogs.es/085e00/torre_sande_edificio/1366_2000.jpg",
"http://elgrancafe.es/wp-content/uploads/2019/08/MG_6891.jpg",
"https://upload.wikimedia.org/wikipedia/commons/8/87/Multiusos_Ciudad_de_C%C3%A1ceres.JPG"];