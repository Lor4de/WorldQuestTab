local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestTab", "esES")

if L then
L["ALIGN_WORLDMAP_BUTTON"] = "Alinear botón del mapa del mundo"
L["ALIGN_WORLDMAP_BUTTON_TT"] = "Coloca el botón junto a los predeterminados."
L["ALWAYS_ALL"] = "Siempre todas las misiones"
L["ALWAYS_ALL_TT"] = "Mostrar siempre todas las misiones de la expansión relacionada con la zona actual."
L["AMOUNT_COLORS"] = "Colores de cantidad"
L["AMOUNT_COLORS_TT"] = "Colorea las cantidades de recompensa en la lista de misiones según el tipo de recompensa."
L["AUTO_EMISARRY"] = "Solo emisario automático"
L["AUTO_EMISARRY_TT"] = "Al hacer clic en un emisario en el tablero de recompensas del mapa del mundo, se habilitará temporalmente el filtro 'Solo emisario'."
L["BLIZZARD"] = "Blizzard"
L["CALLINGS_BOARD"] = "Tablero de Llamadas"
L["CALLINGS_BOARD_TT"] = "Agrega una superposición al mapa para las llamadas de la curia, similar al tablero de emisarios de expansiones anteriores."
L["COMBATLOCK"] = "Deshabilitado durante el combate."
L["CONTAINER_DRAG"] = "Mover"
L["CONTAINER_DRAG_TT"] = "Arrastrar a una ubicación diferente."
L["CURRENT_PROFILE"] = "Perfil actual"
L["CURRENT_PROFILE_TT"] = "Selecciona tu perfil activo."
L["CUSTOM_COLORS"] = "Colores personalizados"
L["DEFAULT_TAB"] = "Pestaña predeterminada"
L["DEFAULT_TAB_TT"] = "Establece WQT como la pestaña predeterminada al iniciar sesión."
L["EMISSARY_COUNTER"] = "Contador de emisarios"
L["EMISSARY_COUNTER_TT"] = "Agrega contadores a las pestañas de emisario que indican tu progreso para cada emisario."
L["EMISSARY_REWARD"] = "Icono de recompensa de emisario"
L["EMISSARY_REWARD_TT"] = "Agrega un icono a las pestañas de emisario que indica el tipo de recompensa que ofrece."
L["EMISSARY_SELECTED_ONLY"] = "Solo emisario seleccionado"
L["EMISSARY_SELECTED_ONLY_TT"] = [=[Solo marca misiones para el emisario actualmente seleccionado. Desactivar esto marcará las misiones para cualquiera de los emisarios activos.
Al hacer clic en las pestañas de emisario, solo se mostrarán las misiones relacionadas con ese emisario específico.]=]
L["FILTER_PINS"] = "Filtrar marcadores del mapa"
L["FILTER_PINS_TT"] = "Aplica filtros a los marcadores en el mapa."
L["FORMAT_GROUP_CREATE"] = "Escribe |cFFFFFFFF%d|r para crear un grupo para esta misión. O escribe su nombre: |cFFFFFFFF%s|r. Considera usar ambos para que los jugadores sin complementos también puedan encontrar tu grupo."
L["FORMAT_GROUP_SEARCH"] = "Escribe |cFFFFFFFF%d|r para buscar un grupo para esta misión. O escribe su nombre: |cFFFFFFFF%s|r."
L["FORMAT_GROUP_TYPO"] = "Parece que has cometido un error tipográfico. Escribe |cFFFFFFFF%d|r o |cFFFFFFFF%s|r."
L["GENERIC_ANIMA"] = "Texturas de Ánima coincidentes"
L["GENERIC_ANIMA_TT"] = "Reemplaza las diferentes texturas de objetos de ánima por unas que coincidan, de forma similar a como lo hacía la azerita. Esto solo afecta a los iconos del mapa y a la lista de misiones."
L["GOLD_PURSES"] = "Bolsas del Corredor de Oro"
L["GOLD_PURSES_TT"] = "Tratar las Bolsas del Corredor de Dragones como recompensas de oro."
L["GROUP_SEARCH_INFO"] = "Blizzard impide que los complementos busquen automáticamente un grupo para la mayoría de las misiones del mundo. Debido a esto, los jugadores tienen que rellenar manualmente el cuadro de búsqueda."
L["INCLUDE_DAILIES"] = "Incluir diarias"
L["INCLUDE_DAILIES_TT"] = "Tratar ciertas misiones diarias como misiones del mundo. Solo afecta a las misiones diarias que el propio Blizzard trata como misiones del mundo."
L["LFG_BUTTONS"] = "Habilitar botones LFG"
L["LFG_BUTTONS_TT"] = "Agrega botones de LFG a las misiones del mundo en el rastreador de objetivos. Habilitar esta configuración puede causar un aumento en el uso de memoria y CPU. |cFFFF5555Se requiere una recarga para que esta configuración surta efecto.|r"
L["LIST_COLOR_TIME"] = "Colores de tiempo"
L["LIST_COLOR_TIME_TT"] = "Agrega un código de color a las horas según la duración restante. Las horas críticas (< 15 min) se colorearán de rojo independientemente."
L["LIST_FULL_TIME"] = "Expandir tiempos"
L["LIST_FULL_TIME_TT"] = "Incluye una escala secundaria para los tiempos, agregando horas a los días y minutos a las horas."
L["LIST_SETTINGS"] = "Configuración de la lista"
L["LOAD_UTILITIES"] = "Cargar utilidades"
L["LOAD_UTILITIES_TT"] = [=[Cargar características de utilidad como recuentos y ordenación por distancia.
|cFFFF5555Se requiere una recarga al deshabilitar esta característica.|r]=]
L["LOAD_UTILITIES_TT_DISABLED"] = "|cFFFF5555Las utilidades de la pestaña de misiones del mundo no están habilitadas en tu lista de complementos.|r"
L["MAP_FILTER_DISABLED"] = "Deshabilitado por filtros del mapa del mundo."
L["MAP_FILTER_DISABLED_BUTTON_INFO"] = "Clic derecho para volver a habilitar este filtro."
L["MAP_FILTER_DISABLED_INFO"] = "Tienes algunos filtros deshabilitados bajo la lupa en la parte superior derecha del mapa del mundo. Esto puede ocultar algunas misiones de la lista y deshabilitar algunas opciones de filtro."
L["MAP_FILTER_DISABLED_TITLE"] = "Algunos filtros del mapa del mundo están deshabilitados."
L["MAP_PINS"] = "Marcadores de mapa"
L["MINI_ICONS"] = "Mini iconos"
L["NEW_PROFILE"] = "Nuevo perfil"
L["NEW_PROFILE_TT"] = "Crear un nuevo perfil basado en la configuración actual."
L["NO_FACTION"] = "Sin facción"
L["NUMBERS_FIRST"] = "%gk"
L["NUMBERS_SECOND"] = "%gm"
L["NUMBERS_THIRD"] = "%gb"
L["PIN_BIGGER"] = "Marcadores más grandes"
L["PIN_BIGGER_TT"] = "Aumenta el tamaño del marcador para una mejor visibilidad."
L["PIN_BLIZZARD_TT"] = "Imita la apariencia del marcador de Blizzard."
L["PIN_CENTER"] = "Tipo de icono principal"
L["PIN_CENTER_TT"] = "Selecciona la apariencia del centro del marcador del mapa."
L["PIN_DISABLE"] = "Deshabilitar cambios"
L["PIN_DISABLE_TT"] = "Evita que WQT realice cambios en los marcadores del mapa."
L["PIN_ELITE_RING"] = "Anillo de élite"
L["PIN_ELITE_RING_TT"] = "Reemplaza el dragón de élite de Blizzard por un anillo con pinchos."
L["PIN_FACTION_TT"] = "Usar el icono de facción."
L["PIN_FADE_ON_PING"] = "Desvanecer marcadores irrelevantes"
L["PIN_FADE_ON_PING_TT"] = "Al pasar el ratón por encima de una misión en la lista, los demás marcadores del mapa se desvanecerán para identificar más fácilmente el relevante."
L["PIN_OPTIONAL_LABEL"] = "Etiqueta opcional"
L["PIN_OPTIONAL_LABEL_TT"] = "Agrega una etiqueta opcional debajo del marcador del mapa."
L["PIN_OPTIONAL_NONE_TT"] = "No mostrar ninguna etiqueta."
L["PIN_OPTIONAL_AMOUNT"] = "Cantidad de recompensa"
L["PIN_OPTIONAL_AMOUNT_TT"] = "Agrega una etiqueta con la primera cantidad de recompensa según el tipo de recompensa (oro, nivel de objeto, reputación, moneda, etc.)."
L["PIN_RARITY_ICON"] = "Icono de rareza de misión"
L["PIN_RARITY_ICON_TT"] = "Agrega un icono de rareza a los marcadores de misiones raras."
L["PIN_REWARD_TT"] = "Usar la textura de la recompensa principal."
L["PIN_REWARD_TYPE"] = "Icono de tipo de recompensa"
L["PIN_REWARD_TYPE_TT"] = "Agrega un icono de tipo de recompensa a los marcadores."
L["PIN_REWARDS"] = "Textura de recompensa"
L["PIN_REWARDS_TT"] = "Muestra la textura de la recompensa como el icono del marcador."
L["PIN_RIMG_TIME_TT"] = "Color del anillo basado en el tiempo restante."
L["PIN_RING_COLOR"] = "Color de recompensa"
L["PIN_RING_COLOR_TT"] = "Color del anillo basado en el tipo de recompensa."
L["PIN_RING_DEFAULT"] = "Por defecto"
L["PIN_RING_DEFAULT_TT"] = "Ningún cambio especial en el anillo del marcador."
L["PIN_RING_HIDE_TT"] = "No mostrar ningún anillo alrededor de los marcadores."
L["PIN_RING_QUALITY_TT"] = "Color del anillo basado en la rareza de la misión."
L["PIN_RING_TIME"] = "Tiempo restante"
L["PIN_RING_TITLE"] = "Tipo de anillo"
L["PIN_RING_TT"] = "Selecciona la apariencia del anillo alrededor de los marcadores del mapa."
L["PIN_SCALE"] = "Escala del marcador de zona"
L["PIN_SCALE_CONTINENT"] = "Escala del marcador de continente"
L["PIN_SCALE_TT"] = "Cambia el tamaño de los marcadores del mapa de zona."
L["PIN_SCALE_CONTINENT_TT"] = "Cambia el tamaño de los marcadores del mapa del continente."
L["PIN_SETTINGS"] = "Configuración de marcadores de mapa"
L["PIN_SHOW_CONTINENT"] = "Marcadores en el continente"
L["PIN_SHOW_CONTINENT_TT"] = "Muestra todas las misiones en los mapas de continente."
L["PIN_TIME"] = "Etiqueta de tiempo restante"
L["PIN_TIME_ICON"] = "Icono de tiempo restante"
L["PIN_TIME_ICON_TT"] = "Agrega un icono para el tiempo restante, basado en los colores del tiempo."
L["PIN_TIME_TT"] = "Agrega una etiqueta de texto corta con la duración restante."
L["PIN_TYPE"] = "Icono de tipo de misión"
L["PIN_TYPE_TT"] = "Agrega un icono de tipo de misión al marcador para tipos de misión especiales."
L["PIN_VISIBILITY_ALL_TT"] = "Permitir marcadores de mapa para todas las misiones."
L["PIN_VISIBILITY_CONTINENT"] = "Marcadores de mapa de continente"
L["PIN_VISIBILITY_CONTINENT_TT"] = "Qué misiones deben mostrar marcadores en los mapas de continente."
L["PIN_VISIBILITY_NONE_TT"] = "No mostrar ningún marcador de mapa."
L["PIN_VISIBILITY_TRACKED"] = "Rastreado"
L["PIN_VISIBILITY_TRACKED_TT"] = "Solo mostrar marcadores de mapa para las misiones que se están rastreando actualmente."
L["PIN_VISIBILITY_ZONE"] = "Marcadores de mapa de zona"
L["PIN_VISIBILITY_ZONE_TT"] = "Qué misiones deben mostrar marcadores en los mapas de zona."
L["PIN_WARBAND_BONUS"] = "Icono de bonificación de Warband"
L["PIN_WARBAND_BONUS_TT"] = "Muestra un icono en la parte superior del marcador si hay una bonificación de Warband disponible."
L["PLACE_MAP_PIN"] = "Marcador compartible"
L["PRECISE_FILTER"] = "Filtro preciso"
L["PRECISE_FILTER_TT"] = "El filtro solo muestra las misiones que coinciden con todas las categorías de filtro, en lugar de solo algunas."
L["PREVIOUS_EXPANSIONS"] = "Expansiones anteriores"
L["PROFILE_NAME"] = "Nombre del perfil"
L["PROFILE_NAME_TT"] = "Cambiar nombre del perfil"
L["PROFILES"] = "Perfiles"
L["QUEST_COUNTER"] = "Contador de registro de misiones"
L["QUEST_COUNTER_INFO"] = [=[Este número es una aproximación ya que el valor de la API oficial no está garantizado que sea correcto.
Algunas misiones podrían estar ocultas pero seguir contando.]=]
L["QUEST_COUNTER_TITLE"] = "Límite del registro de misiones"
L["QUEST_COUNTER_TT"] = "Muestra el número de misiones en tu registro de misiones predeterminado."
L["QUEST_LIST"] = "Lista de misiones"
L["REMOVE_PROFILE"] = "Eliminar perfil"
L["REMOVE_PROFILE_TT"] = "Elimina el perfil actualmente activo."
L["RESET_PROFILE"] = "Restablecer perfil"
L["RESET_PROFILE_TT"] = "Restablece el perfil actualmente activo a la configuración estándar."
L["REWARD_COLORS_AMOUNT"] = "Colores de cantidad de recompensa"
L["REWARD_COLORS_RING"] = "Colores del anillo de recompensa"
L["REWARD_CONDUITS"] = "Conductos"
L["REWARD_NUM_DISPLAY"] = "Número de recompensas"
L["REWARD_NUM_DISPLAY_PIN"] = "Iconos de recompensa"
L["REWARD_NUM_DISPLAY_PIN_TT"] = "Agrega iconos de tipo según las recompensas de la misión, hasta la cantidad elegida."
L["REWARD_NUM_DISPLAY_TT"] = "Cuántas de las recompensas de la misión deben mostrarse."
L["SAVE_SETTINGS"] = "Guardar filtros/ordenar"
L["SAVE_SETTINGS_TT"] = "Guarda la configuración de filtros y ordenación entre sesiones y recargas."
L["SHORTCUT_DISLIKE"] = "<Mayús + Clic derecho para marcar>"
L["SHORTCUT_TRACK"] = "<Mayús + Clic para rastrear>"
L["SHORTCUT_WAYPOINT"] = "<Control + Clic para establecer punto de ruta>"
L["SHOW_FACTION"] = "Mostrar facción"
L["SHOW_FACTION_TT"] = "Muestra el icono de facción en la lista de misiones."
L["SHOW_TYPE"] = "Mostrar tipo"
L["SHOW_TYPE_TT"] = "Muestra el icono de tipo en la lista de misiones."
L["SHOW_WARBAND_BONUS"] = "Mostrar bonificación de Warband"
L["SHOW_WARBAND_BONUS_TT"] = "Muestra el icono de bonificación de Warband en la lista de misiones."
L["SHOW_ZONE"] = "Mostrar zona"
L["SHOW_ZONE_TT"] = "Muestra la etiqueta de zona cuando la lista contiene misiones de varias zonas."
L["TIME"] = "Tiempo"
L["TIME_COLORS"] = "Colores de tiempo"
L["TIME_CRITICAL"] = "15 minutos"
L["TIME_CRITICAL_TT"] = "Tiempos inferiores a 15 minutos."
L["TIME_LONG"] = "1-3 días"
L["TIME_LONG_TT"] = "Tiempos entre 1 y 3 días."
L["TIME_MEDIUM"] = "1 día"
L["TIME_MEDIUM_TT"] = "Tiempos entre 1 y 24 horas."
L["TIME_SHORT"] = "1 hora"
L["TIME_SHORT_TT"] = "Tiempos entre 15 y 60 minutos."
L["TIME_VERYLONG"] = "Más de 3 días"
L["TIME_VERYLONG_TT"] = "Tiempos superiores a 3 días. Normalmente usado para jefes de mundo."
L["TOMTOM_AUTO_ARROW"] = "Punto de ruta al rastrear"
L["TOMTOM_AUTO_ARROW_TT"] = "Rastrear una misión con Mayús + clic, o usando la opción 'Rastrear' en el menú desplegable, creará automáticamente un punto de ruta de TomTom."
L["TOMTOM_CLICK_ARROW"] = "Punto de ruta al hacer clic"
L["TOMTOM_CLICK_ARROW_TT"] = "Crea un punto de ruta y una flecha de TomTom para la última misión del mundo clicada. Elimina el punto de ruta anterior añadido de esta manera."
L["TYPE_EMISSARY"] = "Solo emisario"
L["TYPE_EMISSARY_TT"] = "Muestra solo las misiones del emisario actualmente seleccionado. Este filtro anula todos los demás filtros."
L["TYPE_INVASION"] = "Invasión"
L["UNINTERESTED"] = "Sin interés"
L["UNINTERESTED_TT"] = "Mantener las misiones marcadas como 'sin interés' en la lista."
L["USE_TOMTOM"] = "Permitir TomTom"
L["USE_TOMTOM_TT"] = "Agrega la funcionalidad de TomTom al complemento."
L["TOMTOM_PIN"] = "Marcador TomTom"
L["WHATS_NEW"] = "¿Qué hay de nuevo?"
L["WHATS_NEW_TT"] = "Ver las notas del parche de la pestaña de misiones del mundo."
L["WQT_FULLSCREEN_BUTTON_TT"] = "Clic izquierdo para alternar la lista de misiones del mundo. Clic derecho y arrastrar para cambiar la posición."
L["IGNORES_FILTERS"] = "Ignora filtros"
end