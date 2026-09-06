-- ============================================================================
--  AnimeVerse — Datos de ejemplo
--  Ejecutar DESPUES de schema.sql en: Dashboard > SQL Editor > New query
--
--  Inserta 6 generos y 10 animes (la actividad pide un minimo de 5 registros).
--  Los metadatos (año, episodios, estudio, puntuacion, portada) provienen de
--  MyAnimeList via la API publica Jikan. Las sinopsis son redacciones propias.
--
--  Idempotente: usa `on conflict (slug) do update`, asi que re-ejecutarlo
--  actualiza los registros en lugar de duplicarlos.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Generos
-- ---------------------------------------------------------------------------
insert into public.generos (slug, nombre, descripcion, color) values
  ('accion',          'Acción',           'Combates coreografiados, tensión constante y protagonistas que se juegan la vida en cada episodio.',            '#ef4444'),
  ('fantasia',        'Fantasía',         'Mundos con magia, alquimia y criaturas imposibles donde las reglas las escribe la imaginación.',               '#8b5cf6'),
  ('ciencia-ficcion', 'Ciencia Ficción',  'Viajes en el tiempo, el cosmos y preguntas incómodas sobre la tecnología y lo que nos hace humanos.',              '#06b6d4'),
  ('suspenso',        'Suspenso',         'Duelos de inteligencia, secretos que se destapan tarde y finales que obligan a repensar todo lo anterior.',      '#f59e0b'),
  ('drama-historico', 'Drama Histórico',  'Épocas reales reconstruidas con rigor, donde la violencia tiene consecuencias y la redención cuesta cara.',      '#10b981'),
  ('comedia',         'Comedia',          'Situaciones absurdas, familias disfuncionales y humor que funciona incluso cuando la trama se pone seria.',      '#ec4899')
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
  g.nombre                as genero,
  count(a.id)             as animes,
  round(avg(a.puntuacion), 2) as puntuacion_promedio
from public.generos g
left join public.animes a on a.genero_id = g.id
group by g.nombre
order by animes desc, genero;
