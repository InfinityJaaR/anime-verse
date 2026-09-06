-- ============================================================================
--  AnimeVerse — Datos de ejemplo
--  Ejecutar DESPUES de schema.sql en: Dashboard > SQL Editor > New query
--
--  Inserta 12 generos y 50 animes (la actividad pide un minimo de 5 registros).
--  Los metadatos (año, episodios, estudio, puntuacion, portada) provienen de
--  MyAnimeList (API publica Jikan) y de AniList. Las sinopsis y los titulos en
--  español son redacciones propias.
--
--  Idempotente: usa `on conflict (slug) do update`, asi que re-ejecutarlo
--  actualiza los registros en lugar de duplicarlos.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Generos
-- ---------------------------------------------------------------------------
insert into public.generos (slug, nombre, descripcion, color) values
  ('accion', 'Acción', 'Combates coreografiados, tensión constante y protagonistas que se juegan la vida en cada episodio.', '#ef4444'),
  ('fantasia', 'Fantasía', 'Mundos con magia, alquimia y criaturas imposibles donde las reglas las escribe la imaginación.', '#8b5cf6'),
  ('ciencia-ficcion', 'Ciencia Ficción', 'Viajes en el tiempo, el cosmos y preguntas incómodas sobre la tecnología y lo que nos hace humanos.', '#06b6d4'),
  ('mecha', 'Mecha', 'Robots pilotados por personas demasiado jóvenes para cargar con lo que se les pide. El género que mejor mezcla espectáculo y trauma.', '#6366f1'),
  ('suspenso', 'Suspenso', 'Duelos de inteligencia, secretos que se destapan tarde y finales que obligan a repensar todo lo anterior.', '#f59e0b'),
  ('terror', 'Terror', 'Atmósferas que aprietan despacio, cuerpos que dejan de ser propios y la certeza de que algo va a salir mal.', '#84cc16'),
  ('drama-historico', 'Drama Histórico', 'Épocas reales reconstruidas con rigor, donde la violencia tiene consecuencias y la redención cuesta cara.', '#10b981'),
  ('deportes', 'Deportes', 'Entrenamiento, derrotas y ese punto concreto del partido en el que se decide todo. Técnica real, no solo gritos.', '#f97316'),
  ('romance', 'Romance', 'Confesiones que tardan demasiado, malentendidos evitables y el trabajo poco glamuroso de sostener una relación.', '#fb7185'),
  ('comedia', 'Comedia', 'Situaciones absurdas, familias disfuncionales y humor que funciona incluso cuando la trama se pone seria.', '#ec4899'),
  ('recuentos-de-la-vida', 'Recuentos de la vida', 'Poca trama y mucha vida: rutinas, comidas compartidas y personajes que cambian sin darse cuenta.', '#2dd4bf'),
  ('musica', 'Música', 'Historias donde tocar es el argumento. Conciertos animados con el cuidado que otros reservan para las peleas.', '#c084fc')
on conflict (slug) do update set
  nombre      = excluded.nombre,
  descripcion = excluded.descripcion,
  color       = excluded.color;

-- ---------------------------------------------------------------------------
-- 2. Animes
--    `genero_id` se resuelve por slug para no depender de IDs generados.
-- ---------------------------------------------------------------------------
insert into public.animes
  (slug, titulo, titulo_japones, sinopsis, imagen_url, anio, episodios, estado, estudio, puntuacion, destacado, tags, genero_id)
values
  (
    'fullmetal-alchemist-brotherhood',
    'Fullmetal Alchemist: Brotherhood',
    '鋼の錬金術師 FULLMETAL ALCHEMIST',
    'Dos hermanos rompen el tabú más grande de la alquimia al intentar resucitar a su madre, y el precio es el cuerpo de uno y el brazo del otro. La búsqueda de la Piedra Filosofal para recuperar lo perdido los arrastra hasta el corazón podrido de un país militarizado. Una obra que trata la ambición, la culpa y el costo real de cada decisión con una coherencia narrativa poco común.',
    'https://cdn.myanimelist.net/images/anime/1208/94745l.jpg',
    2009, 64, 'Finalizado', 'Bones', 9.1, true,
    array['Alquimia', 'Hermandad', 'Militar', 'Obra maestra'],
    (select id from public.generos where slug = 'fantasia')
  ),
  (
    'frieren',
    'Frieren: más allá del final del viaje',
    '葬送のフリーレン',
    'La aventura terminó, el Rey Demonio cayó y los héroes volvieron a casa. Pero Frieren es una elfa y para ella esa década épica fue apenas un parpadeo. Solo cuando sus compañeros humanos empiezan a morir entiende que nunca se molestó en conocerlos. Un relato pausado sobre el duelo, la memoria y lo que significa el tiempo para alguien que tiene demasiado.',
    'https://cdn.myanimelist.net/images/anime/1015/138006l.jpg',
    2023, 28, 'Finalizado', 'Madhouse', 9.3, true,
    array['Elfos', 'Magia', 'Viaje', 'Melancolía'],
    (select id from public.generos where slug = 'fantasia')
  ),
  (
    'steins-gate',
    'Steins;Gate',
    'STEINS;GATE',
    'Un autoproclamado científico loco descubre que su horno de microondas modificado puede enviar mensajes al pasado. El juego se vuelve pesadilla cuando cada cambio mínimo reescribe la realidad y una organización secreta empieza a cerrar el cerco. La primera mitad se toma su tiempo; la segunda cobra cada minuto invertido con intereses.',
    'https://cdn.myanimelist.net/images/anime/1935/127974l.jpg',
    2011, 24, 'Finalizado', 'White Fox', 9.1, true,
    array['Viajes en el tiempo', 'Thriller', 'Akihabara'],
    (select id from public.generos where slug = 'ciencia-ficcion')
  ),
  (
    'cowboy-bebop',
    'Cowboy Bebop',
    'カウボーイビバップ',
    'Cuatro cazarrecompensas comparten una nave destartalada y la incapacidad de dejar atrás su pasado. Entre trabajos mal pagados en un sistema solar colonizado, cada episodio funciona como un corto autónomo con su propio género y su propia banda sonora de jazz. El estándar contra el que todavía se mide el anime adulto.',
    'https://cdn.myanimelist.net/images/anime/4/19644l.jpg',
    1998, 26, 'Finalizado', 'Sunrise', 8.8, false,
    array['Espacio', 'Cazarrecompensas', 'Jazz', 'Neo-noir'],
    (select id from public.generos where slug = 'ciencia-ficcion')
  ),
  (
    'attack-on-titan',
    'Attack on Titan',
    '進撃の巨人',
    'La humanidad sobrevive encerrada tras tres murallas concéntricas porque afuera hay gigantes que devoran personas sin necesitar alimentarse. Cuando una muralla cae, un adolescente jura exterminarlos a todos. Lo que empieza como una historia de supervivencia se convierte, temporada tras temporada, en una disección incómoda del nacionalismo y los ciclos de venganza.',
    'https://cdn.myanimelist.net/images/anime/10/47347l.jpg',
    2013, 25, 'Finalizado', 'Wit Studio', 8.6, true,
    array['Titanes', 'Supervivencia', 'Distopía', 'Militar'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'jujutsu-kaisen',
    'Jujutsu Kaisen',
    '呪術廻戦',
    'Yuji Itadori se traga un dedo momificado para salvar a sus amigos y termina compartiendo cuerpo con el rey de las maldiciones. Condenado a muerte con una prórroga, entra a una escuela de hechiceros donde aprende que las maldiciones nacen de las emociones negativas de la gente común. Animación de MAPPA en su punto más alto.',
    'https://cdn.myanimelist.net/images/anime/1171/109222l.jpg',
    2020, 24, 'Finalizado', 'MAPPA', 8.5, false,
    array['Maldiciones', 'Escuela', 'Sobrenatural', 'Peleas'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'demon-slayer',
    'Demon Slayer: Kimetsu no Yaiba',
    '鬼滅の刃',
    'Tanjiro vuelve a casa y encuentra a su familia masacrada por un demonio; la única sobreviviente es su hermana, ahora convertida en uno de ellos. Se une al Cuerpo de Exterminio de Demonios buscando una cura que quizá no exista. Su fuerza está en la empatía del protagonista, que se niega a odiar incluso a los monstruos que persigue.',
    'https://cdn.myanimelist.net/images/anime/1286/99889l.jpg',
    2019, 26, 'Finalizado', 'ufotable', 8.4, false,
    array['Demonios', 'Era Taisho', 'Espadas', 'Familia'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'death-note',
    'Death Note',
    'デスノート',
    'Un estudiante brillante y aburrido encuentra un cuaderno que mata a quien escriba en él, y decide purgar el mundo de criminales. Del otro lado hay un detective anónimo igual de brillante. La serie es un ajedrez de deducciones donde nadie es del todo el héroe y el verdadero tema es cómo el poder absoluto erosiona a quien lo ejerce.',
    'https://cdn.myanimelist.net/images/anime/1079/138100l.jpg',
    2006, 37, 'Finalizado', 'Madhouse', 8.6, true,
    array['Shinigami', 'Psicológico', 'Detectives', 'Dilema moral'],
    (select id from public.generos where slug = 'suspenso')
  ),
  (
    'vinland-saga',
    'Vinland Saga',
    'ヴィンランド・サガ',
    'Thorfinn crece entre vikingos con un único objetivo: matar al hombre que asesinó a su padre. Pero su venganza lo encadena a ese mismo hombre durante años de saqueos por la Inglaterra del siglo XI. Una historia sobre la guerra que se atreve a preguntar qué queda de una persona cuando por fin cumple aquello que le dio sentido a su vida.',
    'https://cdn.myanimelist.net/images/anime/1500/103005l.jpg',
    2019, 24, 'Finalizado', 'Wit Studio', 8.8, false,
    array['Vikingos', 'Venganza', 'Siglo XI', 'Seinen'],
    (select id from public.generos where slug = 'drama-historico')
  ),
  (
    'spy-x-family',
    'Spy × Family',
    'SPY×FAMILY',
    'El mejor espía de su país necesita una familia falsa para infiltrarse en un colegio de élite. Adopta a una niña que resulta ser telépata y se casa con una mujer que resulta ser asesina a sueldo; ninguno sabe el secreto del otro, salvo la niña, que lo sabe todo y no dice nada. Comedia de enredos ejecutada con una precisión impecable.',
    'https://cdn.myanimelist.net/images/anime/1441/122795l.jpg',
    2022, 12, 'Finalizado', 'Wit Studio, CloverWorks', 8.4, false,
    array['Espías', 'Familia', 'Telepatía', 'Slice of life'],
    (select id from public.generos where slug = 'comedia')
  ),
  (
    'one-punch-man',
    'One-Punch Man',
    'ワンパンマン',
    'Saitama entrenó tanto que puede acabar con cualquier enemigo de un solo golpe, y eso lo dejó profundamente aburrido. La serie usa esa premisa para parodiar el género de superhéroes sin renunciar a tener algunas de las mejores secuencias de animación de la década.',
    'https://cdn.myanimelist.net/images/anime/12/76049l.jpg',
    2015, 12, 'Finalizado', 'Madhouse', 8.5, false,
    array['Superhéroes', 'Parodia', 'Un golpe'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'my-hero-academia',
    'My Hero Academia',
    '僕のヒーローアカデミア',
    'En un mundo donde casi todos nacen con un superpoder, Izuku nace sin ninguno y aun así quiere ser héroe. El héroe número uno le hereda su don y lo mete en la academia más exigente del país. Una relectura optimista del cómic de superhéroes desde la gramática del shonen.',
    'https://cdn.myanimelist.net/images/anime/10/78745l.jpg',
    2016, 13, 'Finalizado', 'Bones', 7.8, false,
    array['Superpoderes', 'Escuela', 'Héroes'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'chainsaw-man',
    'Chainsaw Man',
    'チェンソーマン',
    'Denji vive endeudado, come pan con agua y su único amigo es un demonio con forma de perro y motosierra. Cuando lo traicionan y muere, el demonio lo revive fusionado con él. Sus sueños siguen siendo miserablemente pequeños, y ahí está la gracia: un antihéroe sin ninguna ambición heroica.',
    'https://cdn.myanimelist.net/images/anime/1806/126216l.jpg',
    2022, 12, 'Finalizado', 'MAPPA', 8.4, false,
    array['Demonios', 'Sangriento', 'Antihéroe'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'mob-psycho-100',
    'Mob Psycho 100',
    'モブサイコ100',
    'Mob es el psíquico más poderoso de su ciudad y lo único que quiere es gustarle a una chica. Trabaja para un estafador que finge exorcizar fantasmas y que, contra todo pronóstico, resulta ser un buen mentor. Animación experimental al servicio de una historia sobre crecer sin depender de tu talento.',
    'https://cdn.myanimelist.net/images/anime/8/80356l.jpg',
    2016, 12, 'Finalizado', 'Bones', 8.5, false,
    array['Psíquicos', 'Espíritus', 'Crecer'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'samurai-champloo',
    'Samurai Champloo',
    'サムライチャンプルー',
    'Una camarera contrata a dos espadachines que se odian para que la ayuden a encontrar a un samurái que huele a girasoles. El Japón Edo se mezcla con hip-hop, grafiti y anacronismos deliberados. Del mismo director que Cowboy Bebop, con la misma obsesión por el ritmo y la música.',
    'https://cdn.myanimelist.net/images/anime/1370/135212l.jpg',
    2004, 26, 'Finalizado', 'Manglobe', 8.5, false,
    array['Samuráis', 'Edo', 'Hip-hop', 'Viaje'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'dorohedoro',
    'Dorohedoro',
    'ドロヘドロ',
    'Caiman tiene cabeza de reptil, no recuerda su pasado y busca al hechicero que lo transformó metiéndole la cabeza en la boca a cada mago que encuentra. Un mundo sucio y violento que, sorprendentemente, es también una de las comedias más cálidas del catálogo.',
    'https://cdn.myanimelist.net/images/anime/1230/119278l.jpg',
    2020, 12, 'Finalizado', 'MAPPA', 8.1, false,
    array['Hechiceros', 'Amnesia', 'Grotesco'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'made-in-abyss',
    'Made in Abyss',
    'メイドインアビス',
    'Un pozo de profundidad desconocida guarda reliquias inimaginables y una maldición que castiga a quien intenta subir. Riko baja a buscar a su madre acompañada de un niño robot. El contraste entre su diseño adorable y la crueldad de lo que encuentran es exactamente el punto.',
    'https://cdn.myanimelist.net/images/anime/6/86733l.jpg',
    2017, 13, 'Finalizado', 'Kinema Citrus', 8.6, true,
    array['Exploración', 'Abismo', 'Crueldad'],
    (select id from public.generos where slug = 'fantasia')
  ),
  (
    're-zero',
    'Re:Zero',
    'Re:ゼロから始める異世界生活',
    'Subaru aparece en otro mundo sin poderes ni utilidad, salvo uno: cuando muere, vuelve a un punto anterior conservando la memoria. Nadie le cree y cada reinicio lo desgasta más. Un isekai que trata la muerte repetida como el trauma que sería y no como una mecánica de videojuego.',
    'https://cdn.myanimelist.net/images/anime/1522/128039l.jpg',
    2016, 25, 'Finalizado', 'White Fox', 8.3, false,
    array['Isekai', 'Bucle temporal', 'Psicológico'],
    (select id from public.generos where slug = 'fantasia')
  ),
  (
    'mushoku-tensei',
    'Mushoku Tensei',
    '無職転生 ～異世界行ったら本気だす～',
    'Un hombre que desperdició su vida renace como bebé en un mundo de magia conservando su memoria adulta, y decide no repetir sus errores. La ambientación es de una solidez poco común: economía, política y geografía del mundo tienen reglas que la trama respeta.',
    'https://cdn.myanimelist.net/images/anime/1530/117776l.jpg',
    2021, 11, 'Finalizado', 'Studio Bind', 8.3, false,
    array['Isekai', 'Magia', 'Redención'],
    (select id from public.generos where slug = 'fantasia')
  ),
  (
    'dungeon-meshi',
    'Delicious in Dungeon',
    'ダンジョン飯',
    'Un grupo de aventureros se queda sin fondos para rescatar a su compañera del estómago de un dragón, así que deciden bajar comiéndose a los monstruos del camino. La broma sostiene un worldbuilding riguroso: cada criatura tiene una ecología y una receta.',
    'https://cdn.myanimelist.net/images/anime/1711/142478l.jpg',
    2024, 24, 'Finalizado', 'Trigger', 8.6, false,
    array['Mazmorras', 'Cocina', 'Aventura'],
    (select id from public.generos where slug = 'fantasia')
  ),
  (
    'psycho-pass',
    'Psycho-Pass',
    'サイコパス',
    'Un sistema mide el potencial criminal de cada ciudadano antes de que cometa delito alguno, y la policía ejecuta esa medición. Una novata descubre que los mejores investigadores son los que el sistema ya condenó. Distopía que se toma en serio la pregunta de quién vigila al algoritmo.',
    'https://cdn.myanimelist.net/images/anime/1314/142015l.jpg',
    2012, 22, 'Finalizado', 'Production I.G', 8.3, false,
    array['Distopía', 'Policial', 'Vigilancia'],
    (select id from public.generos where slug = 'ciencia-ficcion')
  ),
  (
    '86-eighty-six',
    '86 Eighty-Six',
    '86―エイティシックス―',
    'Una nación presume de librar una guerra sin bajas humanas. La mentira es que a los pilotos de sus drones les quitaron la condición de personas por su etnia. Una crítica al racismo institucional que no se conforma con señalarlo: examina también la culpa de quien lo denuncia desde la comodidad.',
    'https://cdn.myanimelist.net/images/anime/1987/117507l.jpg',
    2021, 11, 'Finalizado', 'A-1 Pictures', 8.4, false,
    array['Guerra', 'Discriminación', 'Drones'],
    (select id from public.generos where slug = 'ciencia-ficcion')
  ),
  (
    'dr-stone',
    'Dr. Stone',
    'ドクターストーン',
    'Toda la humanidad quedó petrificada durante milenios. Senku despierta y decide reconstruir la civilización entera desde cero, en orden, empezando por el fuego. Divulgación científica disfrazada de aventura, con procesos que de verdad funcionan.',
    'https://cdn.myanimelist.net/images/anime/1613/102576l.jpg',
    2019, 24, 'Finalizado', 'TMS Entertainment', 8.3, false,
    array['Ciencia', 'Postapocalíptico', 'Ingenio'],
    (select id from public.generos where slug = 'ciencia-ficcion')
  ),
  (
    'neon-genesis-evangelion',
    'Neon Genesis Evangelion',
    '新世紀エヴァンゲリオン',
    'Shinji es llamado por el padre que lo abandonó para pilotar un arma biomecánica contra criaturas que nadie entiende. La serie usa el mecha como excusa para hablar de depresión, del miedo al contacto humano y del costo de que te necesiten solo por lo que puedes hacer.',
    'https://cdn.myanimelist.net/images/anime/1314/108941l.jpg',
    1995, 26, 'Finalizado', 'Gainax, Tatsunoko Production', 8.4, true,
    array['Mecha', 'Psicológico', 'Depresión', 'Ángeles'],
    (select id from public.generos where slug = 'mecha')
  ),
  (
    'code-geass',
    'Code Geass',
    'コードギアス 反逆のルルーシュ',
    'Un príncipe exiliado recibe el poder de dar una orden absoluta, obedecida una sola vez por persona, y lo usa para derrocar al imperio de su padre desde las sombras. Ajedrez político donde cada jugada brillante arrastra un costo moral que el protagonista prefiere no contar.',
    'https://cdn.myanimelist.net/images/anime/1032/135088l.jpg',
    2006, 25, 'Finalizado', 'Sunrise', 8.7, true,
    array['Mecha', 'Estrategia', 'Rebelión'],
    (select id from public.generos where slug = 'mecha')
  ),
  (
    'gurren-lagann',
    'Tengen Toppa Gurren Lagann',
    '天元突破グレンラガン',
    'Dos chicos que viven bajo tierra encuentran un robot enterrado y suben a una superficie que no sabían que existía. Cada arco escala hasta lo absurdo con total convicción. Si el mecha es un género sobre superar límites, esta es su versión más literal y más contagiosa.',
    'https://cdn.myanimelist.net/images/anime/4/5123l.jpg',
    2007, 27, 'Finalizado', 'Gainax', 8.7, false,
    array['Mecha', 'Superación', 'Espiral'],
    (select id from public.generos where slug = 'mecha')
  ),
  (
    'monster',
    'Monster',
    'モンスター',
    'Un neurocirujano japonés en Alemania salva a un niño en lugar de a un alcalde, y arruina su carrera. Años después descubre que aquel niño se convirtió en un asesino en serie. Un thriller de cuarenta capítulos sin un solo poder sobrenatural y con la tensión mejor sostenida del medio.',
    'https://cdn.myanimelist.net/images/anime/10/18793l.jpg',
    2004, 74, 'Finalizado', 'Madhouse', 8.9, true,
    array['Thriller', 'Asesino en serie', 'Alemania', 'Moral'],
    (select id from public.generos where slug = 'suspenso')
  ),
  (
    'erased',
    'Erased',
    '僕だけがいない街',
    'Satoru revive involuntariamente los minutos previos a una tragedia hasta que consigue evitarla. Cuando asesinan a su madre, el salto lo devuelve dieciocho años atrás, a la infancia, junto a una compañera que desapareció entonces. Thriller con estructura de misterio y corazón de drama.',
    'https://cdn.myanimelist.net/images/anime/10/77957l.jpg',
    2016, 12, 'Finalizado', 'A-1 Pictures', 8.3, false,
    array['Viaje en el tiempo', 'Misterio', 'Infancia'],
    (select id from public.generos where slug = 'suspenso')
  ),
  (
    'the-promised-neverland',
    'The Promised Neverland',
    '約束のネバーランド',
    'Un orfanato idílico con una única regla: no cruzar la verja. Tres niños superdotados descubren qué hay del otro lado y por qué los adoptan tan puntualmente. La primera temporada es un duelo de ingenio contra una adulta que siempre va un paso adelante.',
    'https://cdn.myanimelist.net/images/anime/1830/118780l.jpg',
    2019, 12, 'Finalizado', 'CloverWorks', 8.5, false,
    array['Orfanato', 'Fuga', 'Ingenio'],
    (select id from public.generos where slug = 'suspenso')
  ),
  (
    'terror-in-resonance',
    'Terror in Resonance',
    '残響のテロル',
    'Dos adolescentes vuelan un edificio en Tokio y desafían a la policía con acertijos. No buscan dinero ni fama: quieren que alguien recuerde algo que el Estado enterró. Corta, melancólica y con una banda sonora de Yoko Kanno que carga la mitad del peso emocional.',
    'https://cdn.myanimelist.net/images/anime/1417/117422l.jpg',
    2014, 11, 'Finalizado', 'MAPPA', 8.1, false,
    array['Terrorismo', 'Acertijos', 'Melancolía'],
    (select id from public.generos where slug = 'suspenso')
  ),
  (
    'haikyuu',
    'Haikyū!!',
    'ハイキュー!!',
    'Hinata mide poco para ser rematador y aun así quiere dominar la red. Termina en el mismo equipo que el armador que lo humilló en la secundaria. El mejor anime deportivo en años: entiende que la tensión no está en ganar, sino en el punto que se está jugando.',
    'https://cdn.myanimelist.net/images/anime/7/76014l.jpg',
    2014, 25, 'Finalizado', 'Production I.G', 8.4, true,
    array['Vóleibol', 'Equipo', 'Superación'],
    (select id from public.generos where slug = 'deportes')
  ),
  (
    'hajime-no-ippo',
    'Hajime no Ippo',
    'はじめの一歩 THE FIGHTING!',
    'Un chico acosado en la escuela entra a un gimnasio de boxeo y descubre que tiene un golpe natural devastador. Más de setenta episodios que respetan la técnica del deporte: cada combate se gana con una estrategia que el espectador puede seguir.',
    'https://cdn.myanimelist.net/images/anime/4/86334l.jpg',
    2000, 75, 'Finalizado', 'Madhouse', 8.8, false,
    array['Boxeo', 'Entrenamiento', 'Constancia'],
    (select id from public.generos where slug = 'deportes')
  ),
  (
    'blue-lock',
    'Blue Lock',
    'ブルーロック',
    'Tras otro fracaso mundialista, la federación japonesa encierra a trescientos delanteros juveniles en una instalación donde solo saldrá uno. La premisa es antideportiva a propósito: pregunta si el egoísmo se puede fabricar y si vale la pena hacerlo.',
    'https://cdn.myanimelist.net/images/anime/1258/126929l.jpg',
    2022, 24, 'Finalizado', '8bit', 8.1, false,
    array['Fútbol', 'Competencia', 'Egoísmo'],
    (select id from public.generos where slug = 'deportes')
  ),
  (
    'your-lie-in-april',
    'Tu mentira en abril',
    '四月は君の嘘',
    'Un niño prodigio del piano dejó de oír su instrumento el día que murió su madre. Una violinista que toca sin respetar la partitura lo arrastra de vuelta al escenario. Las escenas musicales son el mejor argumento de la serie sobre por qué se toca para alguien.',
    'https://cdn.myanimelist.net/images/anime/1405/143284l.jpg',
    2014, 22, 'Finalizado', 'A-1 Pictures', 8.6, false,
    array['Música', 'Duelo', 'Piano'],
    (select id from public.generos where slug = 'romance')
  ),
  (
    'toradora',
    'Toradora!',
    'とらドラ！',
    'Dos estudiantes con fama inmerecida pactan ayudarse a conquistar cada uno al mejor amigo del otro. El resultado es previsible y da igual: la serie acierta en cómo los personajes descubren, con retraso y torpeza, lo que ya sentían.',
    'https://cdn.myanimelist.net/images/anime/13/22128l.jpg',
    2008, 25, 'Finalizado', 'J.C.Staff', 8, false,
    array['Comedia romántica', 'Escuela', 'Malentendidos'],
    (select id from public.generos where slug = 'romance')
  ),
  (
    'fruits-basket',
    'Fruits Basket',
    'フルーツバスケット',
    'Tohru queda huérfana y termina viviendo con una familia cuyos miembros se transforman en animales del zodiaco al abrazar a alguien del sexo opuesto. Bajo la premisa cómica hay un retrato serio del maltrato familiar y de lo que cuesta salir de él.',
    'https://cdn.myanimelist.net/images/anime/1447/99827l.jpg',
    2019, 25, 'Finalizado', 'TMS Entertainment', 8.2, false,
    array['Zodiaco', 'Familia', 'Sanación'],
    (select id from public.generos where slug = 'romance')
  ),
  (
    'horimiya',
    'Horimiya',
    'ホリミヤ',
    'La chica popular y el compañero invisible descubren por accidente que fuera del aula son casi lo contrario de lo que aparentan. En lugar de estirar la tensión romántica, la serie resuelve pronto y dedica el resto a lo difícil: sostener la relación.',
    'https://cdn.myanimelist.net/images/anime/1695/111486l.jpg',
    2021, 13, 'Finalizado', 'CloverWorks', 8.2, false,
    array['Romance', 'Escuela', 'Doble vida'],
    (select id from public.generos where slug = 'romance')
  ),
  (
    'bocchi-the-rock',
    'Bocchi the Rock!',
    'ぼっち・ざ・ろっく！',
    'Hitori aprendió guitarra sola en su cuarto durante años para hacer amigos y le sigue costando pedir un café. Cuando una banda la recluta, su ansiedad social se vuelve el motor cómico. Los conciertos están animados con un cuidado que sorprende en una comedia.',
    'https://cdn.myanimelist.net/images/anime/1448/127956l.jpg',
    2022, 12, 'Finalizado', 'CloverWorks', 8.7, false,
    array['Banda', 'Ansiedad social', 'Guitarra'],
    (select id from public.generos where slug = 'musica')
  ),
  (
    'kaguya-sama',
    'Kaguya-sama: Love is War',
    'かぐや様は告らせたい～天才たちの恋愛頭脳戦～',
    'Los dos mejores estudiantes del consejo estudiantil están enamorados y ninguno confesará primero, porque hacerlo sería perder. Cada episodio es una escalada de estrategias absurdas narrada como si fuera un duelo militar.',
    'https://cdn.myanimelist.net/images/anime/1295/106551l.jpg',
    2019, 12, 'Finalizado', 'A-1 Pictures', 8.4, false,
    array['Comedia romántica', 'Duelo mental', 'Consejo estudiantil'],
    (select id from public.generos where slug = 'comedia')
  ),
  (
    'nichijou',
    'Nichijou',
    '日常',
    'Escenas de la vida cotidiana de unas estudiantes, salvo que una convive con una niña robot y un gato que habla, y que cualquier trivialidad escala a proporciones de catástrofe. Comedia de sincronización milimétrica: el chiste está en el timing de la animación.',
    'https://cdn.myanimelist.net/images/anime/3/75617l.jpg',
    2011, 26, 'Finalizado', 'Kyoto Animation', 8.5, false,
    array['Absurdo', 'Cotidiano', 'Timing'],
    (select id from public.generos where slug = 'comedia')
  ),
  (
    'golden-kamuy',
    'Golden Kamuy',
    'ゴールデンカムイ',
    'Un veterano de la guerra ruso-japonesa y una cazadora ainu buscan un tesoro cuyo mapa está tatuado en la piel de varios presidiarios fugados. Aventura histórica en Hokkaidō que documenta la cultura ainu con una seriedad inusual, y que además es muy graciosa.',
    'https://cdn.myanimelist.net/images/anime/1145/90880l.jpg',
    2018, 12, 'Finalizado', 'Geno Studio', 7.9, false,
    array['Hokkaidō', 'Ainu', 'Tesoro', 'Aventura'],
    (select id from public.generos where slug = 'drama-historico')
  ),
  (
    'hunter-x-hunter',
    'Hunter × Hunter',
    'HUNTER×HUNTER (2011)',
    'Gon busca al padre que lo abandonó y para encontrarlo debe convertirse en Hunter, una licencia que pocos sobreviven a obtener. Lo que arranca como aventura juvenil va endureciéndose hasta convertirse en un estudio sobre la obsesión, con uno de los sistemas de poder mejor construidos del medio.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx11061-y5gsT1hoHuHw.png',
    2011, 148, 'Finalizado', 'MADHOUSE', 8.9, true,
    array['Aventura', 'Nen', 'Examen Hunter', 'Amistad'],
    (select id from public.generos where slug = 'accion')
  ),
  (
    'ghost-in-the-shell-sac',
    'Ghost in the Shell: Stand Alone Complex',
    '攻殻機動隊 STAND ALONE COMPLEX',
    'En un Japón donde el cerebro se conecta directamente a la red, la Sección 9 investiga crímenes que empiezan siendo casos policiales y terminan siendo preguntas filosóficas. El arco del Reidor Risueño es de lo más lúcido que se ha escrito sobre identidad e información en red.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx467-mBTtIoR13qs2.jpg',
    2002, 26, 'Finalizado', 'Production I.G', 8.2, false,
    array['Ciberpunk', 'Policial', 'Identidad'],
    (select id from public.generos where slug = 'ciencia-ficcion')
  ),
  (
    'gundam-suisei-no-majo',
    'Mobile Suit Gundam: La bruja de Mercurio',
    '機動戦士ガンダム 水星の魔女',
    'Suletta llega a una academia corporativa donde los duelos con robots deciden negocios millonarios, y sin querer gana la mano de otra estudiante. Gundam adapta su crítica al complejo militar-industrial al lenguaje de la escuela de élite.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx139274-0NJTOKWHdDew.png',
    2022, 12, 'Finalizado', 'Sunrise', 7.8, false,
    array['Mecha', 'Escuela', 'Corporaciones'],
    (select id from public.generos where slug = 'mecha')
  ),
  (
    'another',
    'Another',
    'アナザー',
    'Una clase carga con una maldición: cada año alguien muere, y todos fingen que una alumna no existe para contenerla. El nuevo estudiante rompe el pacto sin saberlo. Terror escolar clásico que juega limpio con sus pistas y sostiene la atmósfera hasta el final.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx11111-gvvE5bBYsyFo.png',
    2012, 12, 'Finalizado', 'P.A.WORKS', 7.1, false,
    array['Maldición', 'Escuela', 'Misterio'],
    (select id from public.generos where slug = 'terror')
  ),
  (
    'ping-pong-the-animation',
    'Ping Pong the Animation',
    'ピンポン THE ANIMATION',
    'Dos amigos con talentos opuestos se enfrentan al tenis de mesa competitivo. Su animación deliberadamente tosca y su montaje de viñetas incomodan al principio y después resultan inseparables del tema: qué haces cuando descubres que no eres un genio.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20607-fIOxVISIl0HY.jpg',
    2014, 11, 'Finalizado', 'Tatsunoko Production', 8.6, false,
    array['Tenis de mesa', 'Amistad', 'Autor'],
    (select id from public.generos where slug = 'deportes')
  ),
  (
    'march-comes-in-like-a-lion',
    'March Comes in Like a Lion',
    '３月のライオン',
    'Rei es jugador profesional de shogi a los diecisiete y vive solo, arrastrando una depresión que la serie nombra sin adornos. Tres hermanas del barrio lo invitan a cenar una y otra vez. Sobre la depresión y sobre cómo la gente que insiste te salva a plazos.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx21366-0wrYK0kjKeFn.jpg',
    2016, 22, 'Finalizado', 'Shaft', 8.3, false,
    array['Shogi', 'Depresión', 'Familia'],
    (select id from public.generos where slug = 'recuentos-de-la-vida')
  ),
  (
    'barakamon',
    'Barakamon',
    'ばらかもん',
    'Un calígrafo de éxito golpea a un crítico y su padre lo destierra a una isla rural. Allí una niña de seis años se instala en su casa sin pedir permiso. Comedia costumbrista sobre desaprender la técnica para volver a tener algo que decir.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20722-2KAeq72E95dr.png',
    2014, 12, 'Finalizado', 'Kinema Citrus', 8.2, false,
    array['Caligrafía', 'Isla', 'Costumbrista'],
    (select id from public.generos where slug = 'recuentos-de-la-vida')
  ),
  (
    'parasyte',
    'Parasyte: la máxima',
    '寄生獣 セイの格率',
    'Unos parásitos llegan a la Tierra para reemplazar cerebros humanos. El de Shinichi falla y acaba ocupando su mano derecha, obligándolos a convivir. La serie usa esa simbiosis para preguntar qué separa exactamente a un humano de un depredador eficiente.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20623-dUARfggnNDOe.jpg',
    2014, 24, 'Finalizado', 'MADHOUSE', 8.1, false,
    array['Parásitos', 'Simbiosis', 'Terror corporal'],
    (select id from public.generos where slug = 'terror')
  ),
  (
    'carole-tuesday',
    'Carole & Tuesday',
    'キャロル＆チューズデイ',
    'En un Marte colonizado donde la música popular la compone una inteligencia artificial, dos chicas de orígenes opuestos deciden tocar con instrumentos reales. Cada canción está compuesta e interpretada de verdad, y ese detalle sostiene toda la premisa.',
    'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx101281-s1UoXUaYXhxn.jpg',
    2019, 24, 'Finalizado', 'bones', 7.6, false,
    array['Marte', 'Compositoras', 'Industria musical'],
    (select id from public.generos where slug = 'musica')
  )
on conflict (slug) do update set
  titulo         = excluded.titulo,
  titulo_japones = excluded.titulo_japones,
  sinopsis       = excluded.sinopsis,
  imagen_url     = excluded.imagen_url,
  anio           = excluded.anio,
  episodios      = excluded.episodios,
  estado         = excluded.estado,
  estudio        = excluded.estudio,
  puntuacion     = excluded.puntuacion,
  destacado      = excluded.destacado,
  tags           = excluded.tags,
  genero_id      = excluded.genero_id;

-- ---------------------------------------------------------------------------
-- 3. Comprobacion: cuantos animes quedo en cada genero
-- ---------------------------------------------------------------------------
select
  g.nombre                    as genero,
  count(a.id)                 as animes,
  round(avg(a.puntuacion), 2) as puntuacion_promedio
from public.generos g
left join public.animes a on a.genero_id = g.id
group by g.nombre
order by animes desc, genero;
