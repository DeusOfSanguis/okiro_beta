/* 
- Product of osgmod.com -
Script create by Nordahl you can find here : https://osgmod.com/gmod-scripts/1402/job-whitelist-system
Profile page of the Creator : https://osgmod.com/profiles/76561198033784269

Gmod Script Market Place : https://osgmod.com/gmod-scripts/page-1

- Do not duplicate or reproduce.
- By buying my scripts you contribute to the creations and the updates
- Dont leak, Lack of recognition fuelled by thanks does not bring food to the table
- Respect my work please

Code Minified with Originahl-Scripts Software : https://osgmod.com/en/help/code-minification-optimisation

The satisfied members who offered the coffee and supported me : https://osgmod.com/coffee
*/

local cfg=nordahl_cfg_1402

local Nordah_Whitelist_Job = Nordah_Whitelist_Job or {}
local Add_Job_In_the_Whiteliste = {}
local Add_JobGroup_In_the_Whiteliste = {}
local ZJOBwhitelist={}

local ztvo=0.02 --More this number is big more the download of data is slow. antivorflow system. Default value is 0.01 (0 = zero second of delay Too much information is sent your crash server if you have a big list)
local wjl=" "..cfg.Ver
local puce="*"
local nord_s_skin="0"
local Nordah_Whitelist_Job_Menu=nil

local function eRight(a)
return cfg.StaffSteamID64[a:SteamID64()] or cfg.Usergroups_Access[a:GetUserGroup()] or cfg.JOB_Access_rank[team.GetName( a:Team() )] or (cfg.Allow_Admin==1 and a:IsAdmin()) or (cfg.Allow_SUPER_Admin==1 and a:IsSuperAdmin())
end

local files=file.Read("nordahlclient_option/language.txt","DATA")
if (!files) then
file.CreateDir("nordahlclient_option")
file.Write("nordahlclient_option/language.txt","2")
Z_Defaut_Languages=2
else
Z_Defaut_Languages=files+0
end
local files=file.Read("nordahlclient_option/nord_s_skin.txt","DATA")
if (!files) then
file.Write("nordahlclient_option/nord_s_skin.txt","0")
nord_s_skin="0"
else
nord_s_skin=files
end

local tra_nom="Nom"
local zadmin3="Rang"
local zmobutan="Clic droit sur le joueur"
local tra_ajt="Ajouter"
local ajouterallj="Ajouter à tous les jobs"
local zaddlisti="Joueurs"
local WhitelistJobSystem="Système de Job Whitelist"
local CategoryJobSystem="Category Whitelist"
local zaddsuppr="Supprimer"
local zaddsupprall="Supprimer de tous les jobs"
local tra_scrp_nordahl_script="Credit"
local tra_scrp_nordahl_credit="Fait par Nordahl"
local tra_scrp_nordahl_note="Aide moi en me donnant votre avis"
local tra_scrprecherche="Rechercher"
local tra_scrprecherched="Retrouver en une seule liste toutes les entrées avec un Steam_ID"
local tra_wlistde="Whitelist de: "
local tra_init="Initialisation"
local tra_receptd="Reception des données"
local tra_susermax="Nombre d'utilisateurs"
local tra_legd="anti-surcharge(Optimisation)"
local tra_metieactuel="Métier actuel"
local tra_publique="Publique"
local tra_acceswhitelist="Accessible seulement sur Whitelist"
local tra_groupferme="Métier fermé pour tout le monde"
local tra_accesvip="Accessible seulement aux Donateurs"
local tra_reinitialiser="Réinitialiser"
local tra_ajdalwdumetier="Ajouter dans la Whitelist du métier"
local tra_ajdalbdumetier="Ajouter dans la Blacklist du métier"
local tra_date="Date"
local tra_ajpar="Ajouté par"
local tra_metier="Métier"
local tra_gestiondesmetier="Gestion des métiers"
local tra_gestiondesmetitreel="Gestion de l'accès des métiers en temps réel"
local tra_listedesjoueurs="La liste des joueurs présents sur le serveur"
local tra_accessi="Accessibilité"
local tra_info_leak="Vous etiez pas admin lorsque vous avez rejoint le serveur. Il vous manque des informations. Veuillez vous reconnecter. Merci."
local tra_regl_stat_job="Regler le Status du Job"
local tra_recherch_job="You need to find a job first."

function languejobwifr(z)
Z_Defaut_Languages=1
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom="Nom"
zadmin3="Rang"
zmobutan="Clic droit sur le joueur"
tra_ajt="Ajouter"
ajouterallj="Ajouter à tous les jobs"
zaddlisti="Joueurs"
WhitelistJobSystem="Système de Job Whitelist"
zaddsuppr="Supprimer"
zaddsupprall="Supprimer de tous les jobs"
tra_scrp_nordahl_script="Credit"
tra_scrp_nordahl_credit="Fait par Nordahl"
tra_scrp_nordahl_note="Aide moi en me donnant votre avis"
tra_scrprecherche="Rechercher"
tra_scrprecherched="Retrouver en une seule liste toutes les entrées avec un Steam_ID"
tra_wlistde="Whitelist de: "
tra_init="Initialisation"
tra_receptd="Reception des données"
tra_susermax="Nombre d'utilisateurs"
tra_legd="anti-surcharge(Optimisation)"
tra_metieactuel="Métier actuel"
tra_publique="Publique"
tra_acceswhitelist="Accessible seulement sur Whitelist"
tra_groupferme="Métier fermé pour tout le monde"
tra_accesvip="Accessible seulement aux Donateurs"
tra_reinitialiser="Réinitialiser"
tra_ajdalwdumetier="Ajouter dans la Whitelist du métier"
tra_ajdalbdumetier="Ajouter dans la Blacklist du métier"
tra_date="Date"
tra_ajpar="Ajouté par"
tra_metier="Métier"
tra_gestiondesmetier="Gestion des métiers"
tra_gestiondesmetitreel="Gestion de l'accès des métiers en temps réel"
tra_listedesjoueurs="La liste des joueurs présents sur le serveur"
tra_accessi="Accessibilité"
tra_info_leak="Vous etiez pas admin lorsque vous avez rejoint le serveur. Il vous manque des informations. Veuillez vous reconnecter. Merci."
tra_regl_stat_job="Regler le Status du Job"
tra_recherch_job="Vous devez un métier en premier"
end
function languejobwien(z)
Z_Defaut_Languages=2
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom="Name"
zadmin3="Rank"
zmobutan="Right Click on the player"
tra_ajt="Add"
ajouterallj="Add in all jobs"
zaddlisti="Players"
WhitelistJobSystem="Whitelist Job System"
zaddsuppr="Delete"
zaddsupprall="Delete from all jobs"
tra_scrp_nordahl_script="Credits"
tra_scrp_nordahl_credit="Made by Nordahl"
tra_scrp_nordahl_note="Help me by giving me your opinion on this script"
tra_scrprecherche="Search"
tra_scrprecherched="With a Steam_ID, find all the entries in a simple list"
tra_wlistde="Whitelist on : "
tra_init="Initialisation"
tra_receptd="Data receipt"
tra_susermax="Number of users"
tra_legd="Anti-Overload (Optimisation)"
tra_metieactuel="Actual Job"
tra_publique="Public"
tra_acceswhitelist="Accessible only with the Whitelist"
tra_groupferme="Job closed for everyone"
tra_accesvip="Accessible only to the donators"
tra_reinitialiser="Reset"
tra_ajdalwdumetier="Add in the Job's Whitelist"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date="Date"
tra_ajpar="Added by"
tra_metier="Job"
tra_gestiondesmetier="Jobs management"
tra_gestiondesmetitreel="Real time job access management"
tra_listedesjoueurs="List of players in the server"
tra_accessi="Accessibility"
tra_info_leak="You did not admin when you joined the server. You are missing information. Please reconnect. Thank you."
tra_regl_stat_job="Set the jobs' status"
tra_recherch_job="You need to find a job first."
end
function languejobwidu(z)
Z_Defaut_Languages=4
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Name"
zadmin3 = "Rank"
zmobutan = "Rechts auf dem Player Klicken Sie auf"
tra_ajt= "Hinzufügen"
ajouterallj = "in allen Jobs hinzufügen"
zaddlisti = "Spieler"
WhitelistJobSystem = "Weiße Liste Job-System"
zaddsuppr = "Löschen"
zaddsupprall = "von allen Jobs löschen"
tra_scrp_nordahl_script = "Credits"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Hilf mir, von mir auf diesem Skript Sie Ihre Meinung sagen"
tra_scrprecherche = "Suchen"
tra_scrprecherched = "Mit einem STEAM_ID, alle Einträge in einer einfachen Liste finden"
tra_wlistde = "Weiße Liste auf:"
tra_init = "Initialisierung"
tra_receptd = "Datenempfang"
tra_susermax = "Anzahl Benutzer"
tra_legd = "Anti-Überlast (Optimierung)"
tra_metieactuel = "Aktueller Job"
tra_publique = "Public"
tra_acceswhitelist = "Erreichbar nur mit der Whitelist"
tra_groupferme = "Job für alle geschlossen"
tra_accesvip = "Erreichbar nur zu den Donatoren"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Fügen Sie in der Hiobs Weiße Liste"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Datum"
tra_ajpar = "hinzugefügt"
tra_metier = "Job"
tra_gestiondesmetier = "Jobs Management"
tra_gestiondesmetitreel = "Echtzeit-Job Access Management"
tra_listedesjoueurs = "Liste der Spieler auf dem Server"
tra_accessi = "Barrierefreiheit"
tra_info_leak = "Sie haben nicht Admin, wenn Sie den Server verbunden. Sie fehlen Informationen. Bitte wieder an. Danke."
tra_regl_stat_job = "den Status der Jobs Set"
end
function languejobwiru(z)
Z_Defaut_Languages=5
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom="имя"
zadmin3="Ранг"
zmobutan="щелкните правой кнопкой мыши на игрока"
tra_ajt="Добавить"
ajouterallj="Все вакансии"
zaddlisti="игроки"
WhitelistJobSystem="Система Белый Список Заданий"
zaddsuppr="удалить"
zaddsupprall="удалить со всех рабочих мест"
tra_scrp_nordahl_script="кредиты"
tra_scrp_nordahl_credit="выступил Нордал"
tra_scrp_nordahl_note="помогите мне, давая мне свое мнение на этот сценарий"
tra_scrprecherche="поиск"
tra_scrprecherched="с Steam_ID, найти все записи в виде простого списка"
tra_wlistde="белый список на : "
tra_init="инициализация"
tra_receptd="получение данных"
tra_susermax="количество пользователей"
tra_legd="Анти-перегрузки (Оптимизация)"
tra_metieactuel="настоящая работа"
tra_publique="общественные"
tra_acceswhitelist="доступно только с белого списка"
tra_groupferme="задание закрыто для всех"
tra_accesvip="доступна только для донаторов"
tra_reinitialiser="сброс"
tra_ajdalwdumetier="Добавить в задания белого списка"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date="Дата"
tra_ajpar="Добавлено"
tra_metier="работа"
tra_gestiondesmetier="вакансии"
tra_gestiondesmetitreel="режиме реального времени доступ к Job управление"
tra_listedesjoueurs="список игроков на сервере"
tra_accessi="доступность"
tra_info_leak="You did not admin when you joined the server. You are missing information. Please reconnect. Thank you."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwies(z)
Z_Defaut_Languages=3
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom="Nombre"
zadmin3="Rango"
zmobutan="haga Clic Derecho sobre el jugador"
tra_ajt="Agregar"
ajouterallj="Agregar en todos los puestos de trabajo"
zaddlisti="Jugadores"
WhitelistJobSystem="Lista Blanca Sistema De Trabajo"
zaddsuppr="Eliminar"
zaddsupprall="Eliminar todos los puestos de trabajo"
tra_scrp_nordahl_script="Créditos"
tra_scrp_nordahl_credit="Hecho por Nordahl"
tra_scrp_nordahl_note="Help me por darme tu opinión sobre esta secuencia de comandos"
tra_scrprecherche="Buscar"
tra_scrprecherched="Con un Steam_ID, encontrar todas las entradas en una lista simple"
tra_wlistde="lista Blanca : "
tra_init="Inicialización"
tra_receptd="recepción de Datos"
tra_susermax="Número de usuarios"
tra_legd="Anti-Sobrecarga (Optimización)"
tra_metieactuel="Trabajo Real"
tra_publique="Público"
tra_acceswhitelist="Accesible sólo con la lista Blanca"
tra_groupferme="Trabajo cerrado para todo el mundo"
tra_accesvip="Accesible sólo para los donadores"
tra_reinitialiser="Reset"
tra_ajdalwdumetier="Agregar en el Trabajo de la lista Blanca"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date="Fecha"
tra_ajpar="Agregado por"
tra_metier="Trabajo"
tra_gestiondesmetier="Puestos de trabajo gestión de"
tra_gestiondesmetitreel="tiempo Real de trabajo de gestión de acceso"
tra_listedesjoueurs="Lista de jugadores en el servidor"
tra_accessi="Accesibilidad"
tra_info_leak="You did not admin when you joined the server. You are missing information. Please reconnect. Thank you."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwiel(z)
Z_Defaut_Languages=6
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Όνομα"
zadmin3 = "Κατάταξη"
zmobutan = "Κάντε δεξί κλικ στη συσκευή αναπαραγωγής"
tra_ajt= "Προσθήκη"
ajouterallj = "Προσθέστε σε όλες τις θέσεις εργασίας"
zaddlisti = "παίκτες"
WhitelistJobSystem = "Σύστημα Λευκή Λίστα εργασίας"
zaddsuppr = "Διαγραφή"
zaddsupprall = "Διαγραφή από όλες τις θέσεις εργασίας"
tra_scrp_nordahl_script = "Credits"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Βοηθήστε με, δίνοντάς μου τη γνώμη σας σχετικά με αυτό το σενάριο"
tra_scrprecherche = "Αναζήτηση"
tra_scrprecherched = "Με Steam_ID, βρείτε όλες τις καταχωρήσεις σε μια απλή λίστα"
tra_wlistde = "Λευκή Λίστα με θέμα:"
tra_init = "αρχικοποίησης"
tra_receptd = "λήψη δεδομένων"
tra_susermax = "Αριθμός χρηστών"
tra_legd = "Anti-υπερφόρτωσης (Βελτιστοποίηση)"
tra_metieactuel = "πραγματική δουλειά"
tra_publique = "Δημόσια"
tra_acceswhitelist = "Πρόσβαση μόνο με τη Λευκή Λίστα"
tra_groupferme = "έκλεισε εργασίας για όλους"
tra_accesvip = "Διαθέσιμη μόνο στους δωρητές"
tra_reinitialiser = "Επαναφορά"
tra_ajdalwdumetier = "Προσθήκη στη Λευκή Λίστα του Ιώβ"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Ημερομηνία"
tra_ajpar = "Προστέθηκε από"
tra_metier = "Job"
tra_gestiondesmetier = "διαχείριση Jobs"
tra_gestiondesmetitreel = "διαχείριση πρόσβαση στην αγορά εργασίας σε πραγματικό χρόνο"
tra_listedesjoueurs = "Λίστα των παικτών στο διακομιστή"
tra_accessi = "Προσβασιμότητα"
tra_info_leak = "Μπορείτε δεν διαχειριστή, όταν εντάχθηκε στο διακομιστή. Μπορείτε λείπουν πληροφορίες. Παρακαλούμε να επανασυνδεθεί. Σας ευχαριστώ."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwipt(z)
Z_Defaut_Languages=7
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Name"
zadmin3 = "Rank"
zmobutan = "Clique direito sobre o jogador"
tra_ajt= "Adicionar"
ajouterallj = "Adicionar em todos os trabalhos"
zaddlisti = "jogadores"
WhitelistJobSystem = "Sistema de trabalho Whitelist"
zaddsuppr = "Excluir"
zaddsupprall = "Excluir todos os trabalhos"
tra_scrp_nordahl_script = "créditos"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Ajuda-me, dando-me a sua opinião sobre este script"
tra_scrprecherche = "Pesquisar"
tra_scrprecherched = "Com uma Steam_ID, encontrar todas as entradas em uma lista simples"
tra_wlistde = "Whitelist em:"
tra_init = "Inicialização"
tra_receptd = "recebimento de dados"
tra_susermax = "Número de usuários"
tra_legd = "Anti-sobrecarga (Optimization)"
tra_metieactuel = "trabalho real"
tra_publique = "Público"
tra_acceswhitelist = "Acessível apenas com o Whitelist"
tra_groupferme = "Job fechado para todos"
tra_accesvip = "acessível apenas para os doadores"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Adicionar na Whitelist do Job"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Data"
tra_ajpar = "Adicionado por"
tra_metier = "Job"
tra_gestiondesmetier = "gestão Jobs"
tra_gestiondesmetitreel = "gerenciamento de acesso de trabalho em tempo real"
tra_listedesjoueurs = "Lista de jogadores no servidor"
tra_accessi = "Acessibilidade"
tra_info_leak = "Você tinha informação não administrador quando você se juntou ao servidor. Está faltando. Por favor volte a ligar. Obrigado."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwipl(z)
Z_Defaut_Languages=8
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Nazwa"
zadmin3 = "Pozycja"
zmobutan = "Kliknij prawym przyciskiem myszy na odtwarzaczu"
tra_ajt= "Dodaj"
ajouterallj = "Dodaj we wszystkich miejscach pracy"
zaddlisti = "Gracze"
WhitelistJobSystem = "Biała system pracy"
zaddsuppr = "Usuń"
zaddsupprall = "Usuń ze wszystkich miejsc pracy"
tra_scrp_nordahl_script = "Kredyty"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Pomóż mi, dając mi swoją opinię na temat tego skryptu"
tra_scrprecherche = "Szukaj"
tra_scrprecherched = "Z Steam_ID, znaleźć wszystkie wpisy w prostej listy"
tra_wlistde = "Biała on:"
tra_init = "Inicjalizacja"
tra_receptd = "odbiór danych"
tra_susermax = "Liczba użytkowników"
tra_legd = "Anti-przeciążeniowe (Optymalizacja)"
tra_metieactuel = "rzeczywistej pracy"
tra_publique = "Publiczne"
tra_acceswhitelist = "Dostępna tylko z Biała"
tra_groupferme = "Praca zamknięte dla wszystkich"
tra_accesvip = "Dostępna tylko dla darczyńców"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Add w Joba białej listy"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Data"
tra_ajpar = "Dodane przez"
tra_metier = "Praca"
tra_gestiondesmetier = "Praca management"
tra_gestiondesmetitreel = "Zarządzanie w czasie rzeczywistym dostęp do zatrudnienia"
tra_listedesjoueurs = "Lista graczy na serwerze"
tra_accessi = "Dostępność"
tra_info_leak = "Ty nie jesteś administratorem, kiedy dołączył do serwera. brakuje informacji. Proszę ponownie. Dziękuję."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwiit(z)
Z_Defaut_Languages=9
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Nome"
zadmin3 = "Rank"
zmobutan = "Fare clic destro sul giocatore"
tra_ajt= "Aggiungi"
ajouterallj = "Aggiungere in tutti i posti di lavoro"
zaddlisti = "Players"
WhitelistJobSystem = "Job System White list"
zaddsuppr = "Cancella"
zaddsupprall = "Elimina da tutti i lavori"
tra_scrp_nordahl_script = "Crediti"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Aiutami dandomi la tua opinione su questo script"
tra_scrprecherche = "Ricerca"
tra_scrprecherched = "Con un Steam_ID, trovare tutte le voci in un elenco semplice"
tra_wlistde = "Whitelist su:"
tra_init = "inizializzazione"
tra_receptd = "la ricezione dei dati"
tra_susermax = "Numero di utenti"
tra_legd = "anti-sovraccarico (Ottimizzazione)"
tra_metieactuel = "Actual lavoro"
tra_publique = "Pubblico"
tra_acceswhitelist = "accessibile solo con la White list"
tra_groupferme = "Job chiuso per tutti"
tra_accesvip = "accessibile solo ai donatori"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Aggiungi a Lista bianca del lavoro"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Data"
tra_ajpar = "Added by"
tra_metier = "Job"
tra_gestiondesmetier = "gestione dei processi"
tra_gestiondesmetitreel = "la gestione degli accessi di lavoro in tempo reale"
tra_listedesjoueurs = "Lista dei giocatori nel server"
tra_accessi = "Accessibilità"
tra_info_leak = "hai informazioni non admin quando ti sei iscritto il server. Ti manca. Si prega di riconnessione. Grazie."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwibg(z)
Z_Defaut_Languages=10
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Име"
zadmin3 = "Място"
zmobutan = "Кликнете с десния бутон на плейъра"
tra_ajt= "Добави"
ajouterallj = "Добавяне на всички работни места"
zaddlisti = "Играчите"
WhitelistJobSystem = "Бял списък Система за работа"
zaddsuppr = "Изтриване"
zaddsupprall = "Изтриване от всички работни места"
tra_scrp_nordahl_script = "Кредити"
tra_scrp_nordahl_credit = "Произведено от Nordahl"
tra_scrp_nordahl_note = "Помогни ми, като ми вашето мнение по този скрипт"
tra_scrprecherche = "Търсене"
tra_scrprecherched = "С Steam_ID, намерите всички записи в един прост списък"
tra_wlistde = "Бял списък на:"
tra_init = "Инициализация"
tra_receptd = "получаване на данни"
tra_susermax = "Брой на потребителите"
tra_legd = "Anti-претоварване (Оптимизиране)"
tra_metieactuel = "Край на работа"
tra_publique = "Public"
tra_acceswhitelist = "Достъпна само с списъка с разрешени адреси"
tra_groupferme = "Job затворен за всички"
tra_accesvip = "достъпни само за дарителите"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Добави в белия списък на Йов"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Дата"
tra_ajpar = "Добавена от"
tra_metier = "Работа"
tra_gestiondesmetier = "Управление на работни места"
tra_gestiondesmetitreel = "в реално време за управление на достъп до работа"
tra_listedesjoueurs = "Списък на играчите в сървъра"
tra_accessi = "Достъпност"
tra_info_leak = "Вие не администратор, когато се присъедини към сървъра. Вие сте липсва информация. Моля, свържете отново. Благодаря ви."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwics(z)
Z_Defaut_Languages=11
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Název"
zadmin3 = "Rank"
zmobutan = "Klikněte pravým tlačítkem myši na přehrávači"
tra_ajt= "Add"
ajouterallj = "Přidat do všech pracovních míst"
zaddlisti = "Hráči"
WhitelistJobSystem = "System Seznam povolených Job"
zaddsuppr = "Delete"
zaddsupprall = "Smazat ze všech pracovních míst"
tra_scrp_nordahl_script = "Credits"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Pomoz mi tím, že mi váš názor na tento skript"
tra_scrprecherche = "Search"
tra_scrprecherched = "S Steam_ID, kde najdete všechny položky v jednoduchém seznamu"
tra_wlistde = "Seznam povolených na"
tra_init = "Inicializace"
tra_receptd = "Data příjem"
tra_susermax = "Počet uživatelů"
tra_legd = "Anti-přetížení (Optimalizace)"
tra_metieactuel = "Skutečná práce"
tra_publique = "Public"
tra_acceswhitelist = "přístupné pouze po zadání Seznam povolených"
tra_groupferme = "uzavřené práce pro každého"
tra_accesvip = "přístupné pouze donátorů"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Přidat do Whitelist úkolu"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Datum"
tra_ajpar = "Přidal"
tra_metier = "Job"
tra_gestiondesmetier = "Správa Jobs"
tra_gestiondesmetitreel = "Správa přístup k zaměstnání v reálném čase"
tra_listedesjoueurs = "Seznam hráčů na serveru"
tra_accessi = "dostupnost"
tra_info_leak = "Vy jste admin, když se připojil k serveru. Zde jsou chybějící informace. Prosím připojte. Děkuji."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwiet(z)
Z_Defaut_Languages=12
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Nimi"
zadmin3 = "Koht"
zmobutan = "Paremklõps mängija"
tra_ajt= "Lisa"
ajouterallj = "Lisa kõik töökohad"
zaddlisti = "Mängijad"
WhitelistJobSystem = "valgesse nimekirja Töö System"
zaddsuppr = "Kustuta"
zaddsupprall = "Kustuta kõik töökohad"
tra_scrp_nordahl_script = "Autorid"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Aita mind, andes mulle oma arvamuse selle skripti"
tra_scrprecherche = "Otsi"
tra_scrprecherched = "Mis Steam_ID, leida kõik kirjed lihtsa nimekirja"
tra_wlistde = "Whitelisti kohta:"
tra_init = "Initialisation"
tra_receptd = "Andmete kättesaamisel"
tra_susermax = "Kasutajate arv"
tra_legd = "Anti-ülekoormus (optimeerimine)"
tra_metieactuel = "Tegelik töö"
tra_publique = "Avalik"
tra_acceswhitelist = "Kasutatav ainult valgesse nimekirja"
tra_groupferme = "Töö suletud kõigile"
tra_accesvip = "Kasutatav ainult annetajad"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Lisada Töö valge nimekiri"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Date"
tra_ajpar = "Lisatud"
tra_metier = "Töö"
tra_gestiondesmetier = "Jobs juhtimine"
tra_gestiondesmetitreel = "Reaalajas juurdepääs tööle juhtimine"
tra_listedesjoueurs = "Nimekiri mängijad server"
tra_accessi = "Hõlbustus"
tra_info_leak = "Sa ei admin kui liitus server. Sa puuduvad andmed. Palun ühendage. Aitäh."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwifi(z)
Z_Defaut_Languages=13
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Nimi"
zadmin3 = "Rank"
zmobutan = "oikealla klikkaa pelaaja"
tra_ajt= "Add"
ajouterallj = "Lisää kaikki työt"
zaddlisti = "Pelaajat"
WhitelistJobSystem = "valkoinen lista Job System"
zaddsuppr = "Poista"
zaddsupprall = "Poista kaikki työt"
tra_scrp_nordahl_script = "Laajuus"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Auta minua antamalla minulle mielipiteenne tästä kirjoitus"
tra_scrprecherche = "Etsi"
tra_scrprecherched = "Kun Steam_ID, löytää kaikki merkinnät pelkkä luettelo"
tra_wlistde = "valkoinen lista on:"
tra_init = "Alustus"
tra_receptd = "Data kuitti"
tra_susermax = "Käyttäjien lukumäärä"
tra_legd = "Anti-ylikuorma (optimointi)"
tra_metieactuel = "Todellinen työ"
tra_publique = "Public"
tra_acceswhitelist = "Esteetön vain valkoinen lista"
tra_groupferme = "Job suljettu kaikille"
tra_accesvip = "Esteetön vain lahjoittajia"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Lisää joukkoon Jobin Whitelist"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Date"
tra_ajpar = "Lisääjä"
tra_metier = "työ"
tra_gestiondesmetier = "Jobs hallinta"
tra_gestiondesmetitreel = "Reaaliaikainen työn saanti hallinta"
tra_listedesjoueurs = "List of pelaajia palvelin"
tra_accessi = "Esteettömyys"
tra_info_leak = "Et admin kun liittynyt palvelimelle. Sinulta puuttuvat tiedot. Muodosta yhteys uudelleen. Kiitos."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwija(z)
Z_Defaut_Languages=14
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "名前"
zadmin3 = "ランク"
zmobutan = "プレイヤー上で右クリックして"
tra_ajt= "追加"
ajouterallj = "すべてのジョブに追加"
zaddlisti = "プレイヤー"
WhitelistJobSystem = "ホワイトリストジョブ・システム"
zaddsuppr = "削除"
zaddsupprall = "すべてのジョブから削除"
tra_scrp_nordahl_script = "クレジット"
tra_scrp_nordahl_credit = "Nordahl製"
tra_scrp_nordahl_note = "このスクリプトに私にあなたの意見を与えることによって、私を助けて"
tra_scrprecherche = "検索"
tra_scrprecherched = "Steam_IDでは、単純なリスト内のすべてのエントリを検索します"
tra_wlistde = "上のホワイトリスト："
tra_init = "初期化"
tra_receptd = "データ受信"
tra_susermax = "ユーザー数"
tra_legd = "アンチ過負荷（最適化）"
tra_metieactuel = "実際の仕事"
tra_publique = "公開"
tra_acceswhitelist ="アクセスしやすいだけでホワイトリスト "
tra_groupferme = "仕事を皆のため閉鎖しました"
tra_accesvip = "のみ寄付者へのバリアフリー"
tra_reinitialiser= "リセット"
tra_ajdalwdumetier ="ジョブのホワイトリストに追加"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "日"
tra_ajpar = "によって追加されました"
tra_metier = "仕事"
tra_gestiondesmetier ="ジョブ管理"
tra_gestiondesmetitreel = "リアルタイムジョブアクセス管理"
tra_listedesjoueurs = "サーバーのプレイヤーの一覧"
tra_accessi = "アクセシビリティ"
tra_info_leak = "サーバーに参加したときは、管理者はなかった。あなたは情報が不足している。再接続してください。ありがとうございます。"
tra_regl_stat_job="Set the jobs' status"
end
function languejobwiko(z)
Z_Defaut_Languages=15
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "이름"
zadmin3 = "순위"
zmobutan = "오른쪽 플레이어를 클릭"
tra_ajt= "추가"
ajouterallj = "모든 작업에 추가"
zaddlisti = "플레이어"
WhitelistJobSystem = "허용 된 사이트 목록 작업 시스템"
zaddsuppr = "삭제"
zaddsupprall = "모든 작업에서 삭제"
tra_scrp_nordahl_script = "학점"
tra_scrp_nordahl_credit = "Nordahl에 의해 만들어"
tra_scrp_nordahl_note = "이 스크립트에 나에게 의견을 제공하여 도와주세요"
tra_scrprecherche = "검색"
tra_scrprecherched = "는 Steam_ID으로, 간단한 목록에있는 모든 항목을 찾을 수 있습니다"
tra_wlistde = "에 대한 화이트리스트"
tra_init = "초기화"
tra_receptd = "데이터 수신"
tra_susermax = "사용자 수"
tra_legd = "안티 - 과부하 (최적화)"
tra_metieactuel = "실제 작업"
tra_publique = '공개'
tra_acceswhitelist = "액세스 전용으로 화이트리스트"
tra_groupferme = "작업이 모두 폐쇄"
tra_accesvip = "만 기부자에 접근"
tra_reinitialiser = "재설정"
tra_ajdalwdumetier = "작업의 화이트리스트에 추가"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "날짜"
tra_ajpar = "작성자"
tra_metier = "작업"
tra_gestiondesmetier = "작업 관리"
tra_gestiondesmetitreel = "실시간 작업 액세스 관리"
tra_listedesjoueurs = "서버에서 선수 목록"
tra_accessi = "접근성"
tra_info_leak = "당신은. 서버에 가입하지 않을 경우 관리. 당신은 누락 된 정보를 다시 연결하십시오 않았다. 감사합니다."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwilv(z)
Z_Defaut_Languages=16
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Nosaukums"
zadmin3 = "Rank"
zmobutan = "Tiesības, noklikšķiniet uz atskaņotāja"
tra_ajt= "Pievienot"
ajouterallj = "Pievienot visās darba vietām"
zaddlisti = "Spēlētāji"
WhitelistJobSystem = "baltais saraksts Job System"
zaddsuppr = "Dzēst"
zaddsupprall = "Dzēst no visām darba vietām"
tra_scrp_nordahl_script = "Kredīti"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Palīdzi man, dodot man savu viedokli par šo programmu"
tra_scrprecherche = "Meklēt"
tra_scrprecherched = "Ar Steam_ID, atrast visus ierakstus vienkāršā sarakstā"
tra_wlistde = "baltais saraksts uz:"
tra_init = "uzsākšana"
tra_receptd = "Datu saņemšana"
tra_susermax = "lietotāju skaits"
tra_legd = "Anti-Pārslodze (optimizācija)"
tra_metieactuel = "Faktiskā Job"
tra_publique = "Public"
tra_acceswhitelist = "Pieejama tikai ar baltais saraksts"
tra_groupferme = "Job slēgta ikvienam"
tra_accesvip = "Pieejama tikai ziedotājiem"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Pievienot in darbs baltajam sarakstam"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Datums"
tra_ajpar = "Pievienots"
tra_metier = "Job"
tra_gestiondesmetier = "Jobs vadība"
tra_gestiondesmetitreel = "Reālā laika darba pieejamība vadība"
tra_listedesjoueurs = "Saraksts Dalībnieku servera"
tra_accessi = "Pieejamība"
tra_info_leak = "Jums nav admin kad tu pievienojies serverim. Jūs trūkstošo informāciju. Lūdzu, pievienojiet. Paldies."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwino(z)
Z_Defaut_Languages=17
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Navn"
zadmin3 = "Rank"
zmobutan = "Høyreklikk på spilleren"
tra_ajt= "Legg til"
ajouterallj = "Legg til i alle jobber"
zaddlisti = "spillere"
WhitelistJobSystem = "Whitelist Job System"
zaddsuppr = "Slett"
zaddsupprall = "Slett fra alle jobber"
tra_scrp_nordahl_script = "Credits"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Hjelp meg ved å gi meg din mening om dette skriptet"
tra_scrprecherche = "Søk"
tra_scrprecherched = "Med en steamid, finne alle oppføringer i en enkel liste"
tra_wlistde = "Whitelist på:"
tra_init = "Initial"
tra_receptd = "Data kvittering"
tra_susermax = "Antall brukere"
tra_legd = "Anti-Load (optimalisering)"
tra_metieactuel = "selve jobben"
tra_publique = "Public"
tra_acceswhitelist = "Tilgjengelig kun med hviteliste"
tra_groupferme = "Job stengt for alle"
tra_accesvip = "Tilgjengelig kun til givere"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Legg til i Jobs Whitelist"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Dato"
tra_ajpar = "Lagt til av"
tra_metier = "Job"
tra_gestiondesmetier = "Jobs management"
tra_gestiondesmetitreel = "Real time jobb access management"
tra_listedesjoueurs = "Liste over spillere i serveren"
tra_accessi = "Tilgjengelighet"
tra_info_leak = "Du har ikke admin når du ble med serveren. Du mangler informasjon. Vennligst koble til igjen. Takk."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwiro(z)
Z_Defaut_Languages=18
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Nume"
zadmin3 = "Locul"
zmobutan = "Click dreapta pe player-ul"
tra_ajt= "Adăugați"
ajouterallj = "Adăugați în toate locurile de muncă"
zaddlisti = "Players"
WhitelistJobSystem = "Sistem de locuri de muncă de listă albă"
zaddsuppr = "Șterge"
zaddsupprall = "Șterge din toate locurile de muncă"
tra_scrp_nordahl_script = "credite"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Ajută-mă dându-mi părerea despre acest script"
tra_scrprecherche = "Căutare"
tra_scrprecherched = "Cu un Steam_ID, găsiți toate intrările dintr-o listă simplă"
tra_wlistde = "lista albă:"
tra_init = "Inițializarea"
tra_receptd = "primirea de date"
tra_susermax = "Numărul de utilizatori"
tra_legd = "Anti-suprasarcină (optimizare)"
tra_metieactuel = "locul de muncă actual"
tra_publique = "Public"
tra_acceswhitelist = "Accesibil numai cu Exceptate"
tra_groupferme = "Iov închis pentru toată lumea"
tra_accesvip = "accesibilă numai donatorilor"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Adauga in Lista albă Job-ului"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Data"
tra_ajpar = "Adăugat de"
tra_metier = "Iov"
tra_gestiondesmetier = "Management Locuri de munca"
tra_gestiondesmetitreel = "managementul accesului de locuri de muncă în timp real"
tra_listedesjoueurs = "Lista de jucători în server"
tra_accessi = "Accesibilitate"
tra_info_leak = "Tu ai informații nu admin când a aderat la server. Vă lipsesc. Vă rugăm să reconectați. Vă mulțumesc."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwisv(z)
Z_Defaut_Languages=19
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Namn"
zadmin3 = "Rank"
zmobutan = "Högerklicka på spelaren"
tra_ajt= "Lägg till"
ajouterallj = "Lägg i alla jobb"
zaddlisti = "Spelare"
WhitelistJobSystem = "vitlista Job System"
zaddsuppr = "Delete"
zaddsupprall = "Ta bort från alla jobb"
tra_scrp_nordahl_script = "Tack"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_note = "Hjälp mig genom att ge mig din åsikt om detta script"
tra_scrprecherche = "Sök"
tra_scrprecherched = "Med en Steam_ID, hitta alla poster i en enkel lista"
tra_wlistde = "vitlista på:"
tra_init = "Initiering"
tra_receptd = "Data kvitto"
tra_susermax = "Antal användare"
tra_legd = "Anti-överbelastning (Optimization)"
tra_metieactuel = "Verklig jobb"
tra_publique = "Public"
tra_acceswhitelist = "Tillgänglig endast med vitlista"
tra_groupferme = "Job stängd för alla"
tra_accesvip = "Tillgänglig endast till donator"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Lägg i Jobs vitlista"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Date"
tra_ajpar = "Inlagd av"
tra_metier = "Job"
tra_gestiondesmetier = "Jobs management"
tra_gestiondesmetitreel = "Realtids tillgång jobbhantering"
tra_listedesjoueurs = "Förteckning över spelare i servern"
tra_accessi = "Handikappstöd"
tra_info_leak = "Du har informationen inte admin när du gick med servern. Du saknar. Försök återansluta. Tack."
tra_regl_stat_job="Set the jobs' status"
end
function languejobwitr(z)
Z_Defaut_Languages=20
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_nom = "Ad"
zadmin3 = "Rank"
zmobutan = "Sağ oyuncu tıklayın"
tra_ajt= "Ekle"
ajouterallj = "Tüm işlerde Ekle"
zaddlisti = "Oyuncular"
WhitelistJobSystem = "Beyaz liste İş Sistemi"
zaddsuppr = "Sil"
zaddsupprall = "bütün işlerden Sil"
tra_scrp_nordahl_script = "Kredi"
tra_scrp_nordahl_credit = "Nordahl tarafından yapılmıştır"
tra_scrp_nordahl_note = "Bu senaryo üzerinde bana Düşüncelerinizi vererek bana yardım"
tra_scrprecherche = "Ara"
tra_scrprecherched = "a Steam_ID ile basit bir listedeki tüm girdileri bulmak"
tra_wlistde = "konulu Beyaz liste:"
tra_init = "Bafllatma"
tra_receptd = "Veri makbuz"
tra_susermax = "kullanıcı sayısı"
tra_legd = "Anti-Aşırı yük (Optimizasyon)"
tra_metieactuel = "Gerçek iş"
tra_publique = "Public"
tra_acceswhitelist = "Erişilebilir yalnızca Beyaz Liste"
tra_groupferme = "İş herkes için kapalı"
tra_accesvip = "sadece bağışçıların Erişilebilir"
tra_reinitialiser = "Reset"
tra_ajdalwdumetier = "Eyüp Beyaz Listede Ekle"
tra_ajdalbdumetier="Add in the Job's Blacklist"
tra_date = "Tarih"
tra_ajpar = "tarafından eklendi"
tra_metier = "İş"
tra_gestiondesmetier = "İşler yönetimi"
tra_gestiondesmetitreel = "Gerçek zamanlı bir iş erişim yönetimi"
tra_listedesjoueurs = "sunucudaki oyuncuların listesi"
tra_accessi = "Erişilebilirlik"
tra_info_leak = "Sen. sunucuyu katıldığında admin. Sen eksik bilgileri yeniden Lütfen etmedi. Teşekkür ederim."
tra_regl_stat_job="Set the jobs' status"
end

if Z_Defaut_Languages==1 then
languejobwifr(1)
elseif Z_Defaut_Languages==2 then
languejobwien(2)
elseif Z_Defaut_Languages==3 then
languejobwies(3)
elseif Z_Defaut_Languages==4 then
languejobwidu(4)
elseif Z_Defaut_Languages==5 then
languejobwiru(5)
elseif Z_Defaut_Languages==6 then
languejobwiel(6)
elseif Z_Defaut_Languages==7 then
languejobwipt(7)
elseif Z_Defaut_Languages==8 then
languejobwipl(8)
elseif Z_Defaut_Languages==9 then
languejobwiit(9)
elseif Z_Defaut_Languages==10 then
languejobwibg(10)
elseif Z_Defaut_Languages==11 then
languejobwics(11)
elseif Z_Defaut_Languages==12 then
languejobwiet(12)
elseif Z_Defaut_Languages==13 then
languejobwifi(13)
elseif Z_Defaut_Languages==14 then
languejobwija(14)
elseif Z_Defaut_Languages==15 then
languejobwiko(15)
elseif Z_Defaut_Languages==16 then
languejobwilv(16)
elseif Z_Defaut_Languages==17 then
languejobwino(17)
elseif Z_Defaut_Languages==18 then
languejobwiro(18)
elseif Z_Defaut_Languages==19 then
languejobwisv(19)
elseif Z_Defaut_Languages==20 then
languejobwitr(20)
else
languejobwien(2)
end

function Nordah_Whitelist_Job.AddCommand( func, name )
local newfunc = function( ply, cmd, args ) 
local target = Nordah_Whitelist_Job.GetPlayer( args[1] )
if name=="wjs_goto" or name=="wjs_bring" then 
else
if not target or not eRight(ply) or(ply==target and name=="wjs_superadmin") then return end 
end
func( ply, cmd, args ) 
end
concommand.Add( name, newfunc )
end

function Nordah_Whitelist_Job.GetPlayer( id )
if id==nil then return end
local ply = Entity( id )
if not IsValid( ply ) or not ply:IsPlayer() then return end
return ply
end
Nordah_Whitelist_Job.Commands = {}
--Nordah_Whitelist_Job.Tabs = {}
function Nordah_Whitelist_Job.RegisterCommand( name, commandname, chatcmd, args, override )
table.insert( Nordah_Whitelist_Job.Commands, { Name = name, CommandName = commandname, ChatCmd = chatcmd, Args = args, ArgOverride = override } )
end

local gradient=Material("gui/gradient.png")
local SetDrawColor=surface.SetDrawColor
local TexturedRect=surface.DrawTexturedRect
local SetMaterial=surface.SetMaterial

local function zradient(r,g,b,a,x,y,w,t)
SetDrawColor(r,g,b,a)
SetMaterial(gradient)TexturedRect(x,y,w,t)
end

function Nordah_Whitelist_Job_Menu( ply, cmd, args )
if zwjlist==nil then print(tra_info_leak) return end
if eRight(ply)==false then print("Whitelist System: You are not Admin") return end
surface.PlaySound("ambient/machines/keyboard1_clicks.wav")
local Menu = vgui.Create("DFrame")
Menu:SetSize(ScrW()/1.5,ScrH()/2)
Menu:Center()
Menu:SetTitle(" ")
Menu:SetDraggable(true)
Menu:ShowCloseButton(false)
Menu:MakePopup()
Menu.Paint=function()
if sysjobwi=="1" then
if nord_s_skin=="1" then
zradient(0,0,0,255,0,0,Menu:GetWide(),Menu:GetTall())
draw.RoundedBox(0,1,1,Menu:GetWide()-2,22,Color(0,0,50,255))
draw.SimpleText(WhitelistJobSystem..wjl..' - by Nordahl', "Trebuchet18", 28, 13, Color(26,138,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
elseif nord_s_skin=="2" then
draw.SimpleText(WhitelistJobSystem..wjl..' - by Nordahl', "Trebuchet24", 28, 12, Color(26,138,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
else
zradient(255,255,255,255,0,0,Menu:GetWide(),Menu:GetTall())
draw.SimpleText(WhitelistJobSystem..wjl..' - by Nordahl', "Trebuchet18", 28, 13, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(5,5,16,16)

elseif sysjobwi=="0" then

if nord_s_skin=="1" then
zradient(200,0,0,255,0,0,Menu:GetWide(),Menu:GetTall())
zradient(0,0,0,255,1,1,Menu:GetWide()-2,Menu:GetTall()-2)
draw.SimpleText(WhitelistJobSystem..wjl.." (OFF)", "Trebuchet18", 28, 13, Color(150,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
elseif nord_s_skin=="2" then
draw.SimpleText(WhitelistJobSystem..wjl.." (OFF)", "Trebuchet18", 28, 13, Color(150,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
else
zradient(200,0,0,255,0,0,Menu:GetWide(),Menu:GetTall())
zradient(255,255,255,255,1,1,Menu:GetWide()-2,Menu:GetTall()-2)
draw.SimpleText(WhitelistJobSystem..wjl.." (OFF)", "Trebuchet18", 28, 13, Color(150,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
surface.SetDrawColor(255,200,200,255) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(5,5,16,16)

end

end
local Text = vgui.Create("DLabel",Menu)
Text:SetText("")
Text:SizeToContents()
Text:SetPos(10,100)
Text:SetSize(800,40)
Text:SetFont("Trebuchet24")
local button=vgui.Create("DButton",Menu)button:SetText("")button:SetSize(16,16)
button.Paint=function()draw.RoundedBox(8,0,0,button:GetWide(),button:GetTall(),Color(0,0,0,0))
end
button:SetPos(Menu:GetWide()-45,5)local zmodcm=vgui.Create("DImage",Menu)zmodcm:SetImage("icon16/Wrench.png")zmodcm:SetSize(16,16)zmodcm:SetPos(Menu:GetWide()-45,5)button.DoClick=function()surface.PlaySound("ambient/machines/keyboard5_clicks.wav")

------
local z4=DermaMenu()
local subMenu,optMenu=z4:AddSubMenu("Languages")
optMenu:SetIcon("icon16/world.png")
local flche=""
if Z_Defaut_Languages==1 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Français",function()file.Write("nordahlclient_option/language.txt","1")languejobwifr()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/fr.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==2 then flche=puce else flche="" end 
subMenu:AddOption(flche.."English",function()file.Write("nordahlclient_option/language.txt","2")languejobwien()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/en.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==3 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Español",function()file.Write("nordahlclient_option/language.txt","3")languejobwies()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/es.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==4 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Deutsch",function()file.Write("nordahlclient_option/language.txt","4")languejobwidu()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/de.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==5 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Russian",function()file.Write("nordahlclient_option/language.txt","5")languejobwiru()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/ru.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==6 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Greek",function()file.Write("nordahlclient_option/language.txt","6")languejobwiel()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/el.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==7 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Portuguese",function()file.Write("nordahlclient_option/language.txt","7")languejobwipt()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/pt.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==8 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Polish",function()file.Write("nordahlclient_option/language.txt","8")languejobwipl()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/pl.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==9 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Italian",function()file.Write("nordahlclient_option/language.txt","9")languejobwiit()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/it.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==10 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Bulgarian",function()file.Write("nordahlclient_option/language.txt","10")languejobwibg()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/bg.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==11 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Czech",function()file.Write("nordahlclient_option/language.txt","11")languejobwics()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/cs.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==12 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Estonian",function()file.Write("nordahlclient_option/language.txt","12")languejobwiet()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/et.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==13 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Finnish",function()file.Write("nordahlclient_option/language.txt","13")languejobwifi()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/fi.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==14 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Japanese",function()file.Write("nordahlclient_option/language.txt","14")languejobwija()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/ja.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==15 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Korean",function()file.Write("nordahlclient_option/language.txt","15")languejobwiko()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/ko.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==16 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Latvian",function()file.Write("nordahlclient_option/language.txt","16")languejobwilv()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/lv.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==17 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Norwegian",function()file.Write("nordahlclient_option/language.txt","17")languejobwino()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/no.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==18 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Romanian",function()file.Write("nordahlclient_option/language.txt","18")languejobwiro()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/ro.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==19 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Swedish",function()file.Write("nordahlclient_option/language.txt","19")languejobwisv()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/sv.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==20 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Turkish",function()file.Write("nordahlclient_option/language.txt","20")languejobwitr()Menu:Close()
Nordah_Whitelist_Job_Menu(ply)end):SetImage("ngui/la/tr.png")
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4:AddSpacer()
local subMenu,optMenu=z4:AddSubMenu("Panel Skin")
optMenu:SetIcon("icon16/color_swatch.png")
subMenu:AddOption("Original Skin",function()LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)file.Write("nordahlclient_option/nord_s_skin.txt","0")nord_s_skin="0" end):SetImage("icon16/color_swatch.png")
subMenu:AddSpacer()
subMenu:AddOption("Skin 1",function()LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)file.Write("nordahlclient_option/nord_s_skin.txt","1")nord_s_skin="1" end):SetImage("icon16/color_swatch.png")
subMenu:AddSpacer()
subMenu:AddOption("Skin 2",function()LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)file.Write("nordahlclient_option/nord_s_skin.txt","2")nord_s_skin="2" end):SetImage("icon16/color_swatch.png")
z4:AddSpacer()
local subMenu,optMenu=z4:AddSubMenu(tra_scrp_nordahl_script)
optMenu:SetIcon("icon16/wand.png")
subMenu:AddOption(tra_scrp_nordahl_credit,function()gui.OpenURL("https://originahl-scripts.com/profiles/76561198033784269") end):SetImage("ngui/nordahl.png")
subMenu:AddSpacer()
subMenu:AddOption(tra_scrp_nordahl_note.." :)",function()gui.OpenURL("https://originahl-scripts.com/gmod-scripts/1402/reviews-page-1") end):SetImage("icon16/star.png")
subMenu:AddSpacer()
subMenu:AddOption("Workshop Content",function()gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=493897275") end)
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4:AddSpacer()
z4:AddOption("Script Description",function()gui.OpenURL("https://originahl-scripts.com/gmod-scripts/1402/description#description") end):SetImage("ngui/originahl-scripts.png")
z4:AddSpacer()
z4:AddOption("Script Wiki",function()gui.OpenURL("https://originahl-scripts.com/gmod-scripts/1402/wiki#wiki") end):SetImage("ngui/originahl-scripts.png")
z4:Open()
z4.Paint=function()draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))end
------
end

local button=vgui.Create("DButton",Menu)
button:SetText("")
button:SetSize(16,16)
button:SetPos(Menu:GetWide()-25,5)
button.Paint=function()draw.RoundedBox(8,0,0,0,0,Color(0,0,0,0))
end
local zmodcm=vgui.Create("DImage",Menu)
zmodcm:SetImage("icon16/cross.png")
zmodcm:SetSize(16,16)
zmodcm:SetPos(Menu:GetWide()-25,5)
button.DoClick=function()
surface.PlaySound("ambient/machines/keyboard5_clicks.wav")
Menu:Close()
end
local button=vgui.Create("DButton",Menu)
button:SetText("")
button:SetSize(16,16)
button:SetPos(Menu:GetWide()-23-21-21,5)
button.Paint=function()draw.RoundedBox(8,0,0,0,0,Color(0,0,0,0))
end
local zmodcm=vgui.Create("DImage",Menu)
zmodcm:SetImage("icon16/arrow_refresh.png")
zmodcm:SetSize(16,16)
zmodcm:SetPos(Menu:GetWide()-23-21-21,5)
button.DoClick=function()
surface.PlaySound("ambient/machines/keyboard5_clicks.wav")
Menu:Close()
Nordah_Whitelist_Job_Menu(ply)
end
if eRight(ply)==false then return end
local xsize = 600
local ysize = 500
local players = {}
local list = vgui.Create( "DPropertySheet", Menu )
local MenuGetWide=Menu:GetWide()-9
local MenuGetTall=Menu:GetTall()-30
list.Paint=function()
zradient(0,0,0,255,0,20,MenuGetWide,MenuGetTall-20)
zradient(26,138,200,255,1,21,MenuGetWide-2,MenuGetTall-22)
end
list:StretchToParent( 4, 24, 4, 4 )
local dpanel = vgui.Create( "DPanel" )
dpanel.InvalidateLayout = function()
if dpanel.List then
dpanel.List:StretchToParent( 0, 35, 0, 0 )
end
end
dpanel.Paint=function()
zradient(0,0,0,255,0,0,MenuGetWide-2,MenuGetTall-22)
end
local listview = vgui.Create( "DListView", dpanel )
listview.Paint=function()
zradient(0,0,0,255,0,0,listview:GetWide(),listview:GetTall())
draw.RoundedBox(8,1,1,listview:GetWide()-5,listview:GetTall()-2,Color(255,255,255,255))
end

local function stringifycash(n)
local c,p="$",","
if n<0 then
c="-"..c
end
n=math.abs(n)..""
local dp=#n
for i=dp-3,1,-3 do
n=n:sub(1,i)..p..n:sub(i+1)
end
return c..n
end

col1 = listview:AddColumn(tra_nom)
col6 = listview:AddColumn("Money")
col4 = listview:AddColumn("Steam_ID")
col2 = listview:AddColumn(tra_metieactuel)
col5 = listview:AddColumn("Distance")
col1:SetMinWidth( 150 )
col4:SetMinWidth( 150 )
col4:SetMaxWidth( 150 )
col2:SetMinWidth( 150 )
col2:SetMaxWidth( 150 )
col5:SetMaxWidth( 150 )
col6:SetMaxWidth( 150 )

local butan=vgui.Create("DButton",dpanel)
butan:SetText("SteamID Converter")
butan:SetPos(5,5)
butan:SetWide(150)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
end
butan.DoClick=function()
gui.OpenURL("https://steamid.io/")
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

dpanel.Butan = butan
dpanel.List = listview
dpanel:InvalidateLayout()
list:AddSheet(zaddlisti, dpanel, "icon16/group.png", false, false,tra_listedesjoueurs)

local Faitlepanno=vgui.Create("DPanel")
Faitlepanno.InvalidateLayout=function()
if Faitlepanno.List then
Faitlepanno.List:StretchToParent(0,35,0,0)
end
end
Faitlepanno.Paint=function()zradient(0,125,194,255,0,0,MenuGetWide-2,MenuGetTall-22)end
local butan=vgui.Create("DButton",Faitlepanno)
butan:SetText("    "..tra_reinitialiser)
butan:SetPos(5,5)
butan:SetWide(100)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/cross.png"))surface.DrawTexturedRect(4,4,16,16)
end

local listtt=vgui.Create("DListView",Faitlepanno)

butan.DoClick=function()
surface.PlaySound(Sound( "buttons/button14.wav" ))
Add_Job_In_the_Whiteliste={}
RunConsoleCommand("MetajolistDe")
listtt:Clear()
LUTJ()

end
function LUTJ()
local lignedeu=tra_publique
for k,v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
if Add_Job_In_the_Whiteliste[v.Name]==nil or Add_Job_In_the_Whiteliste[v.Name]=="0" then
lignedeu=tra_publique
lignetroi="0"
elseif Add_Job_In_the_Whiteliste[v.Name]=="1" then
lignedeu=tra_acceswhitelist
lignetroi="1"
elseif Add_Job_In_the_Whiteliste[v.Name]=="2" then
lignedeu=tra_groupferme
lignetroi="2"
elseif Add_Job_In_the_Whiteliste[v.Name]=="3" then
lignedeu=tra_accesvip
lignetroi="3"
elseif Add_Job_In_the_Whiteliste[v.Name]=="4" then
lignedeu="Blacklist"
lignetroi="4"
end
listtt:AddLine(v.Name,lignedeu,lignetroi)

-- for c,f in pairs(Add_Job_In_the_Whiteliste)do
-- if v.Name==c then
-- if f=="0" then
-- lignedeu=tra_acceswhitelist
-- lignetroi="0"
-- elseif f=="1" then
-- lignedeu=tra_acceswhitelist
-- lignetroi="1"
-- elseif f=="2" then
-- lignedeu=tra_groupferme
-- lignetroi="2"
-- end
-- end
-- end
-- listtt:AddLine(v.Name,lignedeu,lignetroi)
end
end
LUTJ()

local butan=vgui.Create("DButton",Faitlepanno)
butan:SetText("")
butan:SetPos(110,5)
butan:SetWide(250)
butan.Paint=function()
if sysjobwi=="1" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,190,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(210,255,210,255))
surface.SetDrawColor( 255,255,255, 255 ) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(5,4,16,16)
elseif sysjobwi=="0" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(170,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(255,210,210,255))
surface.SetDrawColor( 255,200,200, 255 ) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(5,4,16,16)
end
if sysjobwi=="1" then
draw.SimpleText("Whitelist JOB System ON","Trebuchet18",125+8,11, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
elseif sysjobwi=="0" then
draw.SimpleText("Whitelist JOB System OFF","Trebuchet18",125+8,11, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
end

butan.DoClick=function()
if sysjobwi=="0" then
LocalPlayer():EmitSound("ui/buttonclick.wav",100,200)
RunConsoleCommand("sysjobwhitelist","1")
elseif sysjobwi=="1" then
RunConsoleCommand("sysjobwhitelist","0")
LocalPlayer():EmitSound("ui/buttonclick.wav",100,160)
end
end

local butan=vgui.Create("DButton",Faitlepanno)
butan:SetText("")
butan:SetPos(365,5)
butan:SetWide(200)
butan.Paint=function()
if sysjobwi=="1" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,190,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(210,255,210,255))
surface.SetDrawColor( 255,255,255, 255 ) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(5,4,16,16)
elseif sysjobwi=="0" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(170,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(255,210,210,255))
surface.SetDrawColor( 255,200,200, 255 ) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(5,4,16,16)
end
draw.SimpleText("Global_"..tra_accessi,"Trebuchet18",108,11, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

local function set_G_line(a,b)
RunConsoleCommand("Metajrmalist_G",a,b)
Metajolist_f_G(LocalPlayer(),"Metajolist_f_G",{a})
listtt:Clear()
LUTJ()
end

butan.DoClick=function()
local z4=DermaMenu()
local subMenu,optMenu=z4:AddSubMenu(tra_regl_stat_job)
optMenu:SetIcon("ngui/wljs.png")
subMenu:AddOption("(Global) "..tra_publique,function()set_G_line("0")end):SetImage("icon16/door_open.png")
subMenu:AddSpacer()
subMenu:AddOption("(Global) "..tra_acceswhitelist,function()set_G_line("1")end):SetImage("icon16/report_add.png")
subMenu:AddSpacer()
subMenu:AddOption("(Global) "..tra_accesvip,function()set_G_line("3")end):SetImage("icon16/coins_add.png")
subMenu:AddSpacer()
subMenu:AddOption("(Global) "..tra_groupferme,function()set_G_line("2")end):SetImage("icon16/delete.png")
subMenu:AddSpacer()
subMenu:AddOption("(Global) ".."Blacklist",function()set_G_line("4")end):SetImage("icon16/report_delete.png")
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4.Paint=function()draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))end
z4:Open()
LocalPlayer():EmitSound("ui/buttonclick.wav",100,200)
end

listtt.Paint=function()
draw.RoundedBox(8,0,0,listtt:GetWide(),listtt:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,listtt:GetWide()-2,listtt:GetTall()-2,Color(255,255,255,255))
end
Faitlepanno.List=listtt
local col1=listtt:AddColumn(tra_metier)
local col2=listtt:AddColumn(tra_accessi)
col1:SetMinWidth(300)
col1:SetMaxWidth(300)
col2:SetMinWidth(300)
col2:SetMinWidth(300)
local function setline(a,b)
if b!="0" then
Add_Job_In_the_Whiteliste[a]=b
elseif b=="0" then
Add_Job_In_the_Whiteliste[a]=nil
end
RunConsoleCommand("Metajourmalist",a,b)
listtt:Clear()
LUTJ()
end
listtt.OnRowRightClick=function(panel,id,line)
local z4=DermaMenu()
local subMenu,optMenu=z4:AddSubMenu(tra_regl_stat_job)
optMenu:SetIcon("ngui/wljs.png")
local polici=""
if Add_Job_In_the_Whiteliste[line:GetColumnText(1)]==nil then polici=puce else polici="" end
subMenu:AddOption(polici..tra_publique,function()setline(line:GetColumnText(1),"0")end):SetImage("icon16/door_open.png")
subMenu:AddSpacer()
if Add_Job_In_the_Whiteliste[line:GetColumnText(1)]=="1" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_acceswhitelist,function()setline(line:GetColumnText(1),"1")end):SetImage("icon16/report_add.png")
subMenu:AddSpacer()
if Add_Job_In_the_Whiteliste[line:GetColumnText(1)]=="3" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_accesvip,function()setline(line:GetColumnText(1),"3")end):SetImage("icon16/coins_add.png")
subMenu:AddSpacer()
if Add_Job_In_the_Whiteliste[line:GetColumnText(1)]=="2" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_groupferme,function()setline(line:GetColumnText(1),"2")end):SetImage("icon16/delete.png")
subMenu:AddSpacer()
if Add_Job_In_the_Whiteliste[line:GetColumnText(1)]=="4" then polici=puce else polici="" end
subMenu:AddOption(polici.."Blacklist",function()setline(line:GetColumnText(1),"4")end):SetImage("icon16/report_delete.png")

subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4.Paint=function()draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))end
z4:Open()
end

list:AddSheet(tra_gestiondesmetier,Faitlepanno,"ngui/wljs.png", false, false,tra_gestiondesmetitreel)

local Faitlepangjb=vgui.Create("DPanel")
local list2=vgui.Create("DListView",Faitlepangjb)
function LUTG()
local lignedeu=tra_publique
for k,v in pairs(Add_JobGroup_In_the_Whiteliste) do
if v=="0" then
lignedeu=tra_publique
lignetroi="0"
elseif v=="1" then
lignedeu=tra_acceswhitelist
lignetroi="1"
elseif v=="2" then
lignedeu=tra_groupferme
lignetroi="2"
elseif v=="3" then
lignedeu=tra_accesvip
lignetroi="3"
elseif v=="4" then
lignedeu="Blacklist"
lignetroi="4"
end
list2:AddLine(k,lignedeu,lignetroi)
end
end
LUTG()

Faitlepangjb.InvalidateLayout=function()
if Faitlepangjb.List then
Faitlepangjb.List:StretchToParent(0,35,0,0)
end
end
Faitlepangjb.Paint=function()zradient(229,140,38,255,0,0,MenuGetWide-2,MenuGetTall-22)
end
local butan=vgui.Create("DButton",Faitlepangjb)
butan:SetText("    "..tra_reinitialiser)
butan:SetPos(5,5)
butan:SetWide(100)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/cross.png"))surface.DrawTexturedRect(4,4,16,16)
end

butan.DoClick=function()
surface.PlaySound(Sound( "buttons/button14.wav" ))
Add_JobGroup_In_the_Whiteliste={}
RunConsoleCommand("MetajogrlistDe")
list2:Clear()
LUTG()
end


local butan=vgui.Create("DButton",Faitlepangjb)
butan:SetText("")
butan:SetPos(110,5)
butan:SetWide(250)
butan.Paint=function()
if syscatwi=="1" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,190,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(210,255,210,255))
surface.SetDrawColor( 255,255,255, 255 ) 
surface.SetMaterial(Material("ngui/wlgs.png"))surface.DrawTexturedRect(5,4,16,16)
elseif syscatwi=="0" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(170,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(255,210,210,255))
surface.SetDrawColor( 255,200,200, 255 ) 
surface.SetMaterial(Material("ngui/wlgs.png"))surface.DrawTexturedRect(5,4,16,16)
end
if syscatwi=="1" then
draw.SimpleText("Whitelist Category(Job) System ON","Trebuchet18",125+8,11, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
elseif syscatwi=="0" then
draw.SimpleText("Whitelist Category(Job) System OFF","Trebuchet18",125+8,11, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
end

butan.DoClick=function()
if syscatwi=="0" then
LocalPlayer():EmitSound("ui/buttonclick.wav",100,200)
RunConsoleCommand("syscatwhitelist","1")
elseif syscatwi=="1" then
RunConsoleCommand("syscatwhitelist","0")
LocalPlayer():EmitSound("ui/buttonclick.wav",100,160)
end
end

local function setline(a,b)
if b=="-1" then
Add_JobGroup_In_the_Whiteliste[a]=nil
else
Add_JobGroup_In_the_Whiteliste[a]=b
end
RunConsoleCommand("Metajourmalist2",a,b)
list2:Clear()
LUTG()
end

local butan=vgui.Create("DButton",Faitlepangjb)
butan:SetText("")
butan:SetPos(365,5)
butan:SetWide(200)
butan.Paint=function()
if sysjobwi=="1" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,190,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(210,255,210,255))
surface.SetDrawColor( 255,255,255, 255 ) 
surface.SetMaterial(Material("ngui/wlgs.png"))surface.DrawTexturedRect(5,4,16,16)
elseif sysjobwi=="0" then
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(170,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,17,butan:GetWide()-2,3,Color(255,210,210,255))
surface.SetDrawColor( 255,200,200, 255 ) 
surface.SetMaterial(Material("ngui/wlgs.png"))surface.DrawTexturedRect(5,4,16,16)
end
draw.SimpleText("Category list","Trebuchet18",108,11, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
butan.DoClick=function()
LocalPlayer():EmitSound("ui/buttonclick.wav",100,200)
local z4=DermaMenu()
local subMenu,optMenu=z4:AddSubMenu("List of category of jobs set in darkrp/gamemode/jobrelated.lua")optMenu:SetIcon("ngui/wlgs.png")
local trij={}
for k,v in pairs(RPExtraTeams) do
local c=v.category
if !trij[c] then
trij[c]=true
subMenu:AddOption(c,function()setline(c,"0")end):SetImage("icon16/add.png")
subMenu:AddSpacer()
end
end
z4.Paint=function()draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))end
z4:Open()
end

list2.Paint=function()
draw.RoundedBox(8,0,0,list2:GetWide(),list2:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,list2:GetWide()-2,list2:GetTall()-2,Color(255,255,255,255))
end
Faitlepangjb.List=list2
local col1=list2:AddColumn("GROUPED JOB (Category)")
local col2=list2:AddColumn(tra_accessi)
col1:SetMinWidth(300)col1:SetMaxWidth(300)
col2:SetMinWidth(300)col2:SetMinWidth(300)
list2.OnRowRightClick=function(panel,id,line)
local z4=DermaMenu()
local subMenu,optMenu=z4:AddSubMenu(tra_regl_stat_job)
optMenu:SetIcon("ngui/wlgs.png")
subMenu:AddOption("Delete",function()setline(line:GetColumnText(1),"-1")end):SetImage("icon16/cross.png")
subMenu:AddSpacer()
local polici=""
if Add_JobGroup_In_the_Whiteliste[line:GetColumnText(1)]=="0" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_publique,function()setline(line:GetColumnText(1),"0")end):SetImage("icon16/door_open.png")
subMenu:AddSpacer()
if Add_JobGroup_In_the_Whiteliste[line:GetColumnText(1)]=="1" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_acceswhitelist,function()setline(line:GetColumnText(1),"1")end):SetImage("icon16/report_add.png")
subMenu:AddSpacer()
if Add_JobGroup_In_the_Whiteliste[line:GetColumnText(1)]=="3" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_accesvip,function()setline(line:GetColumnText(1),"3")end):SetImage("icon16/coins_add.png")
subMenu:AddSpacer()
if Add_JobGroup_In_the_Whiteliste[line:GetColumnText(1)]=="2" then polici=puce else polici="" end
subMenu:AddOption(polici..tra_groupferme,function()setline(line:GetColumnText(1),"2")end):SetImage("icon16/delete.png")
subMenu:AddSpacer()
if Add_JobGroup_In_the_Whiteliste[line:GetColumnText(1)]=="4" then polici=puce else polici="" end
subMenu:AddOption(polici.."Blacklist",function()setline(line:GetColumnText(1),"4")end):SetImage("icon16/report_delete.png")
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4.Paint=function()draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(0,0,0,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))end
z4:Open()
end

local textbox1=vgui.Create("DTextEntry",Faitlepangjb)
textbox1:SetPos(570,6)
textbox1:SetWide(200)
textbox1:SetText("Add manually a category")
textbox1.OnEnter=function(a,b,c)
textbox1:SetTextColor(Color(0,175,0,255))
setline(textbox1:GetText(),"0")
end
list:AddSheet("Category job",Faitlepangjb,"ngui/wlgs.png", false, false,tra_gestiondesmetitreel)

local MakePanelF=vgui.Create("DPanel")
MakePanelF.InvalidateLayout=function()
if MakePanelF.List then
MakePanelF.List:StretchToParent(0,35,0,0)
MakePanelF.Box1:SetPos(0,7)
end
end
MakePanelF.Paint=function()
zradient(0,125,194,255,0,0,MenuGetWide-2,MenuGetTall-22)
end
local textbox1=vgui.Create("DTextEntry",MakePanelF)
textbox1:SetWide(150)
textbox1:SetText("STEAM_0:0:00000000")
MakePanelF.Box1=textbox1
local butan=vgui.Create("DButton",MakePanelF)
butan:SetText("   "..tra_scrprecherche.." Players")
butan:SetPos(155,5)
butan:SetWide(150)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/zoom.png"))surface.DrawTexturedRect(4,4,16,16)
end
butan.DoClick=function()
local steamid64=util.SteamIDTo64(textbox1:GetText())
butan.List:Clear()
for k,v in pairs(ZJOBwhitelist)do 
if v[2]==steamid64 then
butan.List:AddLine(steamid64,v[3],v[4],v[5])
end
end
surface.PlaySound(Sound( "buttons/button14.wav" ))
end
local butan2=vgui.Create("DButton",MakePanelF)
butan2:SetText("   "..zaddsupprall)
butan2:SetPos(310,5)
butan2:SetWide(170)
butan2.Paint=function()
draw.RoundedBox(6,0,0,butan2:GetWide(),butan2:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan2:GetWide()-2,butan2:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan2:GetTall()-1-butan2:GetTall()/3,butan2:GetWide()-2,butan2:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/user_delete.png"))surface.DrawTexturedRect(4,4,16,16)
end
butan2.DoClick=function()
RunConsoleCommand("Massremovewhitelist",steamid64)
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local listtrouver=vgui.Create("DListView",MakePanelF)
listtrouver.Paint=function()
draw.RoundedBox(8,0,0,listtrouver:GetWide(),listtrouver:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,listtrouver:GetWide()-2,listtrouver:GetTall()-2,Color(255,255,255,255))
end
MakePanelF.List=listtrouver
butan.List=listtrouver
local col1=listtrouver:AddColumn("Steam ID")
col2=listtrouver:AddColumn(tra_nom)
col3=listtrouver:AddColumn(tra_metier)
col4=listtrouver:AddColumn(tra_date)
col1:SetMinWidth(150)
col1:SetMaxWidth(150)
col3:SetMinWidth(150)
col4:SetMinWidth(100)

listtrouver.OnRowRightClick=function(panel,id,line)
local menu=vgui.Create("DMenu",panel)
menu:AddOption("Steam Profil",function() LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80) gui.OpenURL("http://steamcommunity.com/profiles/"..line:GetColumnText(1))end):SetImage("icon16/link.png")
menu:AddSpacer()
menu:AddOption("Copy SteamID",function()SetClipboardText(util.SteamIDFrom64(line:GetColumnText(1)))LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
menu:AddSpacer()
menu:AddOption(zaddsuppr,function()
listtrouver:RemoveLine(id)
Nordah_Whitelist_Job.RemoveJobWhitelist(line:GetColumnText(1),nil,line:GetColumnText(3))
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu:AddSpacer()
menu:AddOption(zaddsupprall,function()
listtrouver:Clear()
local steamid=line:GetColumnText(1)
RunConsoleCommand("Massremovewhitelist",steamid)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu.Paint=function()
draw.RoundedBox(8,0,0,menu:GetWide(),menu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,menu:GetWide()-2,menu:GetTall()-2,Color(255,255,255,255))
end
menu:Open()
end
list:AddSheet(tra_scrprecherche.." Players",MakePanelF,"icon16/zoom.png", false, false,tra_scrprecherched)


local MakePanelRECH=vgui.Create("DPanel")
MakePanelRECH.InvalidateLayout=function()
if MakePanelRECH.List then
MakePanelRECH.List:StretchToParent(0,65,0,0)
MakePanelRECH.Box1:SetPos(0,7)
end
end
MakePanelRECH.Paint=function()
zradient(0,125,194,255,0,0,MenuGetWide-2,MenuGetTall-22)
end
local textbox1=vgui.Create("DTextEntry",MakePanelRECH)
textbox1:SetWide(150)
textbox1:SetText("Job/Category Name here")
MakePanelRECH.Box1=textbox1
local butan=vgui.Create("DButton",MakePanelRECH)
butan:SetText("   "..tra_scrprecherche.." Job or Category")
butan:SetPos(155,5)
butan:SetWide(150)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/zoom.png"))surface.DrawTexturedRect(4,4,16,16)
end
butan.DoClick=function()
local Met=textbox1:GetText()
butan.List:Clear()
local xst=false
for k,v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
if v.Name==Met then
xst=true
if butanwarning then
butanwarning:Remove()
butanwarning=nil
end
end
end

if xst==false and !butanwarning then
butanwarning=vgui.Create("DButton",MakePanelRECH)
butanwarning:SetText("")
butanwarning:SetPos(0,30)
butanwarning:SetSize(775,30)
butanwarning.Paint=function()--
draw.RoundedBox(6,0,0,butanwarning:GetWide(),butanwarning:GetTall(),Color(150,0,0,200))
draw.RoundedBox(6,1,1,butanwarning:GetWide()-2,butanwarning:GetTall()-2,Color(255,0,0,200))
draw.SimpleText(tra_recherch_job, "Trebuchet24", 387, 13, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
butanwarning.DoClick=function()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end
end





for k,v in pairs(ZJOBwhitelist)do 
if v[4]==Met then
butan.List:AddLine(v[2],v[3],v[1],v[5])
end
end
surface.PlaySound(Sound( "buttons/button14.wav" ))
end
-----
local textbox2=vgui.Create("DTextEntry",MakePanelRECH)
textbox2:SetWide(150)
textbox2:SetText("STEAM_0:0:00000000")
textbox2:SetPos(0,35)
local textbox3=vgui.Create("DTextEntry",MakePanelRECH)
textbox3:SetPos(155,35)
textbox3:SetWide(150)
textbox3:SetText("Name here")

local butanad=vgui.Create("DButton",MakePanelRECH)
butanad:SetText(tra_ajt)
butanad:SetPos(330,35)
butanad:SetWide(100)
butanad.Paint=function()
draw.RoundedBox(6,0,0,butanad:GetWide(),butanad:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butanad:GetWide()-2,butanad:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butanad:GetTall()-1-butanad:GetTall()/3,butanad:GetWide()-2,butanad:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/add.png"))surface.DrawTexturedRect(4,3,16,16)
end
butanad.DoClick=function()
local steamid64=util.SteamIDTo64(textbox2:GetText())
butan.List:AddLine(steamid64,textbox3:GetText(),LocalPlayer():Name(),tostring(os.date()))
--RunConsoleCommand( "wjs_addwhite", pl:EntIndex(), "Full Access" )
RunConsoleCommand( "wjs_addbuto", steamid64,textbox3:GetText(), textbox1:GetText() )
Nordah_Whitelist_Job.AddWhitelist({LocalPlayer():Name(),steamid64,textbox3:GetText(),textbox1:GetText(),tostring( os.date() )})
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local butanc=vgui.Create("DButton",MakePanelRECH)
butanc:SetText("CleanUp")
butanc:SetPos(440,35)
butanc:SetWide(100)
butanc.Paint=function()
draw.RoundedBox(6,0,0,butanc:GetWide(),butanc:GetTall(),Color(255,0,0,255))
draw.RoundedBox(6,1,1,butanc:GetWide()-2,butanc:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butanc:GetTall()-1-butanc:GetTall()/3,butanc:GetWide()-2,butanc:GetTall()/3,Color(255,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/bin.png"))surface.DrawTexturedRect(4,3,16,16)
end
butanc.DoClick=function()
butan.List:Clear()
for c,b in pairs(ZJOBwhitelist)do
if b[4]==textbox1:GetText() then
ZJOBwhitelist[c]=nil
end
end
RunConsoleCommand( "cleanup_joblist",textbox1:GetText())
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

butanwarning=vgui.Create("DButton",MakePanelRECH)
butanwarning:SetText("")
butanwarning:SetPos(0,30)
butanwarning:SetSize(775,30)
butanwarning.Paint=function()--
draw.RoundedBox(6,0,0,butanwarning:GetWide(),butanwarning:GetTall(),Color(150,0,0,150))
draw.RoundedBox(6,1,1,butanwarning:GetWide()-2,butanwarning:GetTall()-2,Color(255,0,0,200))
draw.SimpleText(tra_recherch_job, "Trebuchet24", 387, 13, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
butanwarning.DoClick=function()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end


local listtrouvjo=vgui.Create("DListView",MakePanelRECH)
listtrouvjo.Paint=function()
draw.RoundedBox(8,0,0,listtrouvjo:GetWide(),listtrouvjo:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,listtrouvjo:GetWide()-2,listtrouvjo:GetTall()-2,Color(255,255,255,255))
end
MakePanelRECH.List=listtrouvjo
butan.List=listtrouvjo
local col1=listtrouvjo:AddColumn("Steam ID")
col2=listtrouvjo:AddColumn(tra_nom)
col3=listtrouvjo:AddColumn(tra_ajpar)
col4=listtrouvjo:AddColumn(tra_date)
col1:SetMinWidth(150)
col1:SetMaxWidth(150)
col3:SetMinWidth(150)
col4:SetMinWidth(100)

listtrouvjo.OnRowRightClick=function(panel,id,line)
local menu=vgui.Create("DMenu",panel)
menu:AddOption("Steam Profil",function() LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80) gui.OpenURL("http://steamcommunity.com/profiles/"..line:GetColumnText(1))end):SetImage("icon16/link.png")
menu:AddSpacer()
menu:AddOption("Copy SteamID",function()SetClipboardText(util.SteamIDFrom64(line:GetColumnText(1)))LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
menu:AddSpacer()
menu:AddOption(zaddsuppr,function()
listtrouvjo:RemoveLine(id)
local steamid=line:GetColumnText(1)
Nordah_Whitelist_Job.RemoveJobWhitelist(steamid,nil,textbox1:GetText())
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu:AddSpacer()
menu:AddOption(zaddsupprall,function()
listtrouvjo:RemoveLine(id)
local steamid=line:GetColumnText(1)
RunConsoleCommand("Massremovewhitelist",steamid)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu.Paint=function()
draw.RoundedBox(8,0,0,menu:GetWide(),menu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,menu:GetWide()-2,menu:GetTall()-2,Color(255,255,255,255))
end
menu:Open()
end

list:AddSheet(tra_scrprecherche,MakePanelRECH,"icon16/zoom.png", false, false,tra_scrprecherched)

local MakePanelFullacc=vgui.Create("DPanel")
MakePanelFullacc.InvalidateLayout=function()
if MakePanelFullacc.List then
MakePanelFullacc.List:StretchToParent(0,35,0,0)
MakePanelFullacc.Box1:SetPos(0,7)
MakePanelFullacc.Box2:SetPos(165,7)
end
end
MakePanelFullacc.Paint=function()
zradient(0,194,0,255,0,0,MenuGetWide-2,MenuGetTall-22)end
local textbox1=vgui.Create("DTextEntry",MakePanelFullacc)
textbox1:SetWide(150)
textbox1:SetText("STEAM_0:0:00000000")
MakePanelFullacc.Box1=textbox1
local textbox2=vgui.Create("DTextEntry",MakePanelFullacc)
textbox2:SetWide(150)
textbox2:SetText("Name here")
MakePanelFullacc.Box2=textbox2
local butan=vgui.Create("DButton",MakePanelFullacc)
butan:SetText(tra_ajt)
butan:SetPos(330,5)
butan:SetWide(100)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/add.png"))surface.DrawTexturedRect(4,3,16,16)
end
butan.DoClick=function()
local steamid64=util.SteamIDTo64(textbox1:GetText())
butan.List:AddLine(steamid64,textbox2:GetText(),LocalPlayer():Name(),tostring(os.date()))
RunConsoleCommand( "wjs_addbuto", steamid64,textbox2:GetText(),"Full Access")
Nordah_Whitelist_Job.AddWhitelist({LocalPlayer():Name(),steamid64,textbox2:GetText(),"Full Access",tostring( os.date() )})
surface.PlaySound(Sound( "buttons/button14.wav" ))
end
local listmetongl=vgui.Create("DListView",MakePanelFullacc)
listmetongl.Paint=function()
draw.RoundedBox(8,0,0,listmetongl:GetWide(),listmetongl:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,listmetongl:GetWide()-2,listmetongl:GetTall()-2,Color(255,255,255,255))
end
MakePanelFullacc.List=listmetongl
butan.List=listmetongl
local col1=listmetongl:AddColumn("Steam ID")
col2=listmetongl:AddColumn(tra_nom)
col3=listmetongl:AddColumn(tra_ajpar)
col4=listmetongl:AddColumn(tra_date)
col1:SetMinWidth(150)
col1:SetMaxWidth(150)
col3:SetMinWidth(150)
col4:SetMinWidth(100)

for a,z in pairs(ZJOBwhitelist)do
if( "Full Access"==z[4] )then
listmetongl:AddLine(z[2],z[3],z[1],z[5])
end
end

listmetongl.OnRowRightClick=function(panel,id,line)
local menu=vgui.Create("DMenu",panel)
menu:AddOption("Steam Profil",function() LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80) gui.OpenURL("http://steamcommunity.com/profiles/"..line:GetColumnText(1))end):SetImage("icon16/link.png")
menu:AddSpacer()
menu:AddOption("Copy SteamID",function()SetClipboardText(util.SteamIDFrom64(line:GetColumnText(1)))LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
menu:AddSpacer()
menu:AddOption(zaddsuppr,function()
listmetongl:RemoveLine(id)
local steamid=line:GetColumnText(1)
Nordah_Whitelist_Job.RemoveJobWhitelist(steamid,nil,"Full Access")
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu:AddSpacer()
menu:AddOption(zaddsupprall,function()
listmetongl:RemoveLine(id)
local steamid=line:GetColumnText(1)
RunConsoleCommand("Massremovewhitelist",steamid)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu.Paint=function()
draw.RoundedBox(8,0,0,menu:GetWide(),menu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,menu:GetWide()-2,menu:GetTall()-2,Color(255,255,255,255))
end
menu:Open()
end

list:AddSheet("Full Access",MakePanelFullacc,"icon16/accept.png", false, false,"All in this lsit have an Full Access")
-----

for k,v in pairs(Add_Job_In_the_Whiteliste)do
if v=="1" or v=="3" or v=="4" then

local metieronglet=vgui.Create("DPanel")
metieronglet.InvalidateLayout=function()
if metieronglet.List then
metieronglet.List:StretchToParent(0,35,0,0)
metieronglet.Box1:SetPos(0,7)
metieronglet.Box2:SetPos(165,7)
end
end

metieronglet.Paint=function()
zradient(0,125,194,255,0,0,MenuGetWide-2,MenuGetTall-22)
end
local textbox1=vgui.Create("DTextEntry",metieronglet)
textbox1:SetWide(150)
textbox1:SetText("STEAM_0:0:00000000")
metieronglet.Box1=textbox1
local textbox2=vgui.Create("DTextEntry",metieronglet)
textbox2:SetWide(150)
textbox2:SetText("Name here")
metieronglet.Box2=textbox2
local butan=vgui.Create("DButton",metieronglet)
butan:SetText(tra_ajt)
butan:SetPos(330,5)
butan:SetWide(100)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/add.png"))surface.DrawTexturedRect(4,3,16,16)
end
butan.DoClick=function()
local steamid64=util.SteamIDTo64(textbox1:GetText())
butan.List:AddLine(steamid64,textbox2:GetText(),LocalPlayer():Name(),tostring(os.date()))
--RunConsoleCommand( "wjs_addwhite", pl:EntIndex(), "Full Access" )
RunConsoleCommand( "wjs_addbuto", steamid64,textbox2:GetText(), k )
Nordah_Whitelist_Job.AddWhitelist({LocalPlayer():Name(),steamid64,textbox2:GetText(),k,tostring( os.date() )})
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local butanc=vgui.Create("DButton",metieronglet)
butanc:SetText("CleanUp")
butanc:SetPos(440,5)
butanc:SetWide(100)
butanc.Paint=function()
draw.RoundedBox(6,0,0,butanc:GetWide(),butanc:GetTall(),Color(255,0,0,255))
draw.RoundedBox(6,1,1,butanc:GetWide()-2,butanc:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butanc:GetTall()-1-butanc:GetTall()/3,butanc:GetWide()-2,butanc:GetTall()/3,Color(255,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/bin.png"))surface.DrawTexturedRect(4,3,16,16)
end
butanc.DoClick=function()
butan.List:Clear()
for c,b in pairs(ZJOBwhitelist)do
if b[4]==k then
ZJOBwhitelist[c]=nil
end
end
RunConsoleCommand("cleanup_joblist",k)
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local butanc=vgui.Create("DButton",metieronglet)
butanc:SetText("Disable")
butanc:SetPos(550,5)
butanc:SetWide(100)
butanc.Paint=function()
draw.RoundedBox(6,0,0,butanc:GetWide(),butanc:GetTall(),Color(255,0,0,255))
draw.RoundedBox(6,1,1,butanc:GetWide()-2,butanc:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(2,1,butanc:GetTall()-1-butanc:GetTall()/3,butanc:GetWide()-2,butanc:GetTall()/3,Color(255,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/cross.png"))surface.DrawTexturedRect(4,3,16,16)
end
butanc.DoClick=function()
RunConsoleCommand("Metajourmalist",k,"0")
Menu:Close()
timer.Simple(0.1,function()Nordah_Whitelist_Job_Menu(ply)end)
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local listmetongl=vgui.Create("DListView",metieronglet)
listmetongl.Paint=function()
draw.RoundedBox(8,0,0,listmetongl:GetWide(),listmetongl:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,listmetongl:GetWide()-2,listmetongl:GetTall()-2,Color(255,255,255,255))
end
metieronglet.List=listmetongl
butan.List=listmetongl
local col1=listmetongl:AddColumn("Steam ID")
col2=listmetongl:AddColumn(tra_nom)
col3=listmetongl:AddColumn(tra_ajpar)
col4=listmetongl:AddColumn(tra_date)
col1:SetMinWidth(150)
col1:SetMaxWidth(150)
col3:SetMinWidth(150)
col4:SetMinWidth(100)

for a,z in pairs(ZJOBwhitelist)do
if( k==z[4] )then
listmetongl:AddLine(z[2],z[3],z[1],z[5])
end
end

listmetongl.OnRowRightClick=function(panel,id,line)
local menu=vgui.Create("DMenu",panel)
menu:AddOption("Steam Profil",function() LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80) gui.OpenURL("http://steamcommunity.com/profiles/"..line:GetColumnText(1))end):SetImage("icon16/link.png")
menu:AddSpacer()
menu:AddOption("Copy SteamID",function()SetClipboardText(util.SteamIDFrom64(line:GetColumnText(1)))LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
menu:AddSpacer()
menu:AddOption(zaddsuppr,function()
listmetongl:RemoveLine(id)
local steamid=line:GetColumnText(1)
Nordah_Whitelist_Job.RemoveJobWhitelist(steamid,nil,k)
surface.PlaySound(Sound("buttons/button14.wav"))
end):SetImage("icon16/user_delete.png")
menu:AddSpacer()
menu:AddOption(zaddsupprall,function()
listmetongl:RemoveLine(id)
local steamid=line:GetColumnText(1)
RunConsoleCommand("Massremovewhitelist",steamid)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu.Paint=function()
draw.RoundedBox(8,0,0,menu:GetWide(),menu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,menu:GetWide()-2,menu:GetTall()-2,Color(255,255,255,255))
end
menu:Open()
end
local nm_co=tra_wlistde
local petitpict="icon16/report.png"
if v=="1" then
petitpict="icon16/report.png"
elseif v=="3" then
petitpict="icon16/coins.png"
elseif v=="4" then
petitpict="icon16/report_delete.png"
nm_co="Blacklist"
end
list:AddSheet("Job: "..k,metieronglet,petitpict, false, false,nm_co.." '"..k.."'" )
end
end
---

for k,v in pairs(Add_JobGroup_In_the_Whiteliste)do
local metieronglet=vgui.Create("DPanel")
metieronglet.InvalidateLayout=function()
if metieronglet.List then
metieronglet.List:StretchToParent(0,35,0,0)
metieronglet.Box1:SetPos(0,7)
metieronglet.Box2:SetPos(165,7)
end
end

metieronglet.Paint=function()
zradient(229,140,38,255,0,0,MenuGetWide-2,MenuGetTall-22)
end
local textbox1=vgui.Create("DTextEntry",metieronglet)
textbox1:SetWide(150)
textbox1:SetText("STEAM_0:0:00000000")
metieronglet.Box1=textbox1
local textbox2=vgui.Create("DTextEntry",metieronglet)
textbox2:SetWide(150)
textbox2:SetText("Name here")
metieronglet.Box2=textbox2
local butan=vgui.Create("DButton",metieronglet)
butan:SetText(tra_ajt)
butan:SetPos(330,5)
butan:SetWide(100)
butan.Paint=function()
draw.RoundedBox(6,0,0,butan:GetWide(),butan:GetTall(),Color(0,0,0,255))
draw.RoundedBox(6,1,1,butan:GetWide()-2,butan:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butan:GetTall()-1-butan:GetTall()/3,butan:GetWide()-2,butan:GetTall()/3,Color(210,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/add.png"))surface.DrawTexturedRect(4,3,16,16)
end
butan.DoClick=function()
local steamid64=util.SteamIDTo64(textbox1:GetText())
butan.List:AddLine(steamid64,textbox2:GetText(),LocalPlayer():Name(),tostring(os.date()))
--RunConsoleCommand( "wjs_addwhite", pl:EntIndex(), "Full Access" )
RunConsoleCommand( "wjs_addbuto", steamid64,textbox2:GetText(), k )
Nordah_Whitelist_Job.AddWhitelist({LocalPlayer():Name(),steamid64,textbox2:GetText(),k,tostring( os.date() )})
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local butanc=vgui.Create("DButton",metieronglet)
butanc:SetText("CleanUp")
butanc:SetPos(440,5)
butanc:SetWide(100)
butanc.Paint=function()
draw.RoundedBox(6,0,0,butanc:GetWide(),butanc:GetTall(),Color(255,0,0,255))
draw.RoundedBox(6,1,1,butanc:GetWide()-2,butanc:GetTall()-2,Color(255,255,255,255))
draw.RoundedBox(4,1,butanc:GetTall()-1-butanc:GetTall()/3,butanc:GetWide()-2,butanc:GetTall()/3,Color(255,210,210,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("icon16/bin.png"))surface.DrawTexturedRect(4,3,16,16)
end
butanc.DoClick=function()
butan.List:Clear()
for c,b in pairs(ZJOBwhitelist)do
if b[4]==k then
ZJOBwhitelist[c]=nil
end
end
RunConsoleCommand("cleanup_joblist",k)
surface.PlaySound(Sound( "buttons/button14.wav" ))
end

local listmetongl=vgui.Create("DListView",metieronglet)
listmetongl.Paint=function()
draw.RoundedBox(8,0,0,listmetongl:GetWide(),listmetongl:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,listmetongl:GetWide()-2,listmetongl:GetTall()-2,Color(255,255,255,255))
end
metieronglet.List=listmetongl
butan.List=listmetongl
local col1=listmetongl:AddColumn("Steam ID")
col2=listmetongl:AddColumn(tra_nom)
col3=listmetongl:AddColumn(tra_ajpar)
col4=listmetongl:AddColumn(tra_date)
col1:SetMinWidth(150)
col1:SetMaxWidth(150)
col3:SetMinWidth(150)
col4:SetMinWidth(100)

for a,z in pairs(ZJOBwhitelist)do
if( k==z[4] )then
listmetongl:AddLine(z[2],z[3],z[1],z[5])
end
end

listmetongl.OnRowRightClick=function(panel,id,line)
local menu=vgui.Create("DMenu",panel)
menu:AddOption("Steam Profil",function() LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80) gui.OpenURL("http://steamcommunity.com/profiles/"..line:GetColumnText(1))end):SetImage("icon16/link.png")
menu:AddSpacer()
menu:AddOption("Copy SteamID",function()SetClipboardText(util.SteamIDFrom64(line:GetColumnText(1)))LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
menu:AddSpacer()
menu:AddOption(zaddsuppr,function()
listmetongl:RemoveLine(id)
local steamid=line:GetColumnText(1)
Nordah_Whitelist_Job.RemoveJobWhitelist(steamid,nil,k)
surface.PlaySound(Sound("buttons/button14.wav"))
end):SetImage("icon16/user_delete.png")
menu:AddSpacer()
menu:AddOption(zaddsupprall,function()
listmetongl:RemoveLine(id)
local steamid=line:GetColumnText(1)
RunConsoleCommand("Massremovewhitelist",steamid)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
surface.PlaySound(Sound( "buttons/button14.wav" ))
end):SetImage("icon16/user_delete.png")
menu.Paint=function()
draw.RoundedBox(8,0,0,menu:GetWide(),menu:GetTall(),Color(0,0,0,255))
draw.RoundedBox(8,1,1,menu:GetWide()-2,menu:GetTall()-2,Color(255,255,255,255))
end
menu:Open()
end
local nm_co=tra_wlistde
local petitpict="icon16/report.png"
if v=="1" then
petitpict="icon16/report.png"
elseif v=="3" then
petitpict="icon16/coins.png"
elseif v=="4" then
petitpict="icon16/report_delete.png"
nm_co="Blacklist"
end
list:AddSheet("Category: "..k,metieronglet,petitpict, false, false,nm_co.." '"..k.."'" )

end

for k,v in pairs( player.GetAll() ) do
local pos = v:GetPos()
local lgr = LocalPlayer():GetPos():Distance( pos )
local lgr=lgr/10
local lgr2=255-lgr
local lgr3=math.Round(lgr/5)
local mon=stringifycash(v:getDarkRPVar("money")or 0)
listview:AddLine( v:Name(),mon,v:SteamID(),team.GetAllTeams()[v:Team()].Name,lgr3)
table.insert( players, v )
end
listview.OnRowRightClick = function( pnl, id, line )
local menu = vgui.Create( "DMenu", panel )
local pl = players[id]
local steamid64=pl:SteamID64()
for k,v in pairs( Nordah_Whitelist_Job.Commands ) do
if not v.Args then
else
menu:AddSpacer()
menu.Paint=function()draw.RoundedBox(4,0,0,menu:GetWide(),menu:GetTall(),Color(84,132,240,255))draw.RoundedBox(4,1,1,menu:GetWide()-2,menu:GetTall()-2,Color(255,255,255,255))end

local submenu,optMenu = menu:AddSubMenu(tra_ajdalwdumetier)
if v.CommandName=="wjs_addwhite" then
optMenu:SetIcon("ngui/wljs.png")
end

local trij={}
for k,v2 in pairs(RPExtraTeams) do
local c=v2.category
local c2=v2.name
if !trij[c] then
trij[c]={}
end
if trij[c] then
for az,d in pairs( v.Args ) do
if c2==d.Value then
table.insert(trij[c],{Value=d.Value,Name=d.Name})
end
end
end
end

for m,p in pairs(trij) do
local submenu2,optMenu2 = submenu:AddSubMenu(m)
if v.CommandName=="wjs_addwhite" then
optMenu2:SetIcon("ngui/wljs.png")submenu:AddSpacer()
submenu.Paint=function()draw.RoundedBox(4,0,0,submenu:GetWide(),submenu:GetTall(),Color(84,132,240,255))draw.RoundedBox(4,1,1,submenu:GetWide()-2,submenu:GetTall()-2,Color(255,255,255,255))end
end

for c,d in pairs(p) do
local arg = d.Value
local Name=d.Name
if Add_Job_In_the_Whiteliste[Name] then
if Add_Job_In_the_Whiteliste[Name]!="2" and Add_Job_In_the_Whiteliste[Name]!="4" then
submenu2:AddSpacer()
submenu2:AddOption(Name,function()
if IsValid( pl ) then
if type( arg ) == "table" then
if not v.Clientside then
local newtbl = {}
for k,v in pairs( arg ) do
table.insert( newtbl, tostring( v ) )
end
print("newtbl : ", v.CommandName, pl:EntIndex(), unpack( newtbl ) )
RunConsoleCommand( v.CommandName, pl:EntIndex(), unpack( newtbl ) )
end
else
if not v.Clientside then
RunConsoleCommand( v.CommandName, pl:EntIndex(), arg )
print("arg : ", v.CommandName, pl:EntIndex(), arg )
end
end
surface.PlaySound( Sound( "buttons/button14.wav" ) )
end
end):SetIcon("icon16/add.png")
end
end
submenu2.Paint=function()draw.RoundedBox(4,0,0,submenu2:GetWide(),submenu2:GetTall(),Color(84,132,240,255))draw.RoundedBox(4,1,1,submenu2:GetWide()-2,submenu2:GetTall()-2,Color(255,255,255,255))end
end
end

local submenu,optMenu=menu:AddSubMenu("Add in the category whitelist")
if v.CommandName=="wjs_addwhite" then
optMenu:SetIcon("ngui/wlgs.png")
end

for c,d in pairs( Add_JobGroup_In_the_Whiteliste ) do
submenu:AddSpacer()
submenu:AddOption(c,function()
if IsValid( pl ) then
RunConsoleCommand("wjs_addwhite2", pl:EntIndex(), c )
surface.PlaySound( Sound( "buttons/button14.wav" ) )
end
end):SetIcon("icon16/add.png")

end

menu:AddOption( "Full Access", function()
if IsValid( pl ) then
if type( arg ) == "table" then
if not v.Clientside then
local newtbl = {}
for k,v in pairs( arg ) do
table.insert( newtbl, tostring( v ) )
end
jswl_chat(LocalPlayer(),"jswl_chat",{pl:EntIndex(),1,"Full Access"})
RunConsoleCommand( "wjs_addwhite", pl:EntIndex(), unpack( newtbl ) )
end
else
if not v.Clientside then

jswl_chat(LocalPlayer(),"jswl_chat",{pl:EntIndex(),1,"Full Access"})
RunConsoleCommand( "wjs_addwhite", pl:EntIndex(), "Full Access" )
end
end
surface.PlaySound( Sound( "buttons/button14.wav" ) )
end
end):SetIcon("icon16/add.png")
menu:AddSpacer()

local submenu,optMenu = menu:AddSubMenu(tra_ajdalbdumetier)
if v.CommandName=="wjs_addwhite" then
optMenu:SetIcon("icon16/cross.png")
end
for c,d in pairs( v.Args ) do
local arg = d.Value
if Add_Job_In_the_Whiteliste[d.Name] then
if Add_Job_In_the_Whiteliste[d.Name]=="4" then
submenu:AddSpacer()
submenu:AddOption( d.Name, function()
if IsValid( pl ) then
if type( arg ) == "table" then
if not v.Clientside then
local newtbl = {}
for k,v in pairs( arg ) do
table.insert( newtbl, tostring( v ) )
end
print("newtbl : ", v.CommandName, pl:EntIndex(), unpack( newtbl ) )
RunConsoleCommand( v.CommandName, pl:EntIndex(), unpack( newtbl ) )
end
else
if not v.Clientside then
RunConsoleCommand( v.CommandName, pl:EntIndex(), arg )
print("arg : ", v.CommandName, pl:EntIndex(), arg )
end
end
surface.PlaySound( Sound( "buttons/button14.wav" ) )
end
end):SetIcon("icon16/add.png")
end
end
end
menu:AddSpacer()
menu:AddOption("Copy SteamID",function()SetClipboardText(line:GetColumnText(3))LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
menu:AddSpacer()
menu:AddOption(zaddsupprall,function()
if IsValid( pl ) then
jswl_chat(LocalPlayer(),"jswl_chat",{pl:EntIndex(),3,"nil"})
RunConsoleCommand("Massremovewhitelist",steamid64)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid64 then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
end
end):SetImage("icon16/bin.png")
menu:AddSpacer()

end
end
menu:Open()
end
end
concommand.Add("whitelist_systemjob", Nordah_Whitelist_Job_Menu )
concommand.Add("whitelist_menu", Nordah_Whitelist_Job_Menu )
concommand.Add("whitelist", Nordah_Whitelist_Job_Menu )

function Nordah_Whitelist_Job.Print( tbl )end
function ntsysjobwi(a,b,c)sysjobwi=tostring(c[1]) end
concommand.Add("ntsysjobwi",ntsysjobwi)
function ntsyscatwi(a,b,c)syscatwi=tostring(c[1]) end
concommand.Add("ntsyscatwi",ntsyscatwi)

ZJOBwhitelist={}
net.Receive("SynchAddJobwhitelist",function(len)
local pl=net.ReadString()
local id=net.ReadString()
local rs=net.ReadString()
local met=net.ReadString()
local date=net.ReadString()
local remove=tobool(net.ReadBit())
if remove then
for k,v in pairs(ZJOBwhitelist)do 
if v[2]==id and v[3]==met then
Nordah_Whitelist_Job.RemoveJobWhitelist(id,true,met)
table.remove(ZJOBwhitelist,k)
return
end
end
else
Nordah_Whitelist_Job.AddWhitelist({pl,id,rs,met,date},true)
end
end)
net.Receive("NSynchAddJob",function(len)
if zwjlist==nil then zwjlist=0 end
zwjlist=zwjlist+1
local meti=net.ReadString()
local val=net.ReadString()
if val=="0" then val=nil end
Add_Job_In_the_Whiteliste[meti]=val
end)
net.Receive("NSynchAddJob2",function(len)
if zwjlist==nil then zwjlist=0 end
zwjlist=zwjlist+1
local meti=net.ReadString()
local val=net.ReadString()
if val=="-1" then
Add_JobGroup_In_the_Whiteliste[meti]=nil
else
Add_JobGroup_In_the_Whiteliste[meti]=val
end
end)
net.Receive("SynchAllJobWhitelisted",function(len)
if zwusers==nil then zwusers=0 end
zwusers=zwusers+1
Nordah_Whitelist_Job.AddWhitelist({net.ReadString(),net.ReadString(),net.ReadString(),net.ReadString(),net.ReadString()},true)
end)

local function Metajolistcl(a)
Add_Job_In_the_Whiteliste={}
end
concommand.Add("Metajolistcl",Metajolistcl)
local function Metajogrlistcl(a)
Add_Job_In_the_Whiteliste={}
end
concommand.Add("Metajogrlistcl",Metajogrlistcl)

function Metajolist_f_G(a,b,c)
local j_nu=tostring(c[1])
Add_Job_In_the_Whiteliste={}
for k,v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
if "Citizen"!=v.Name then
if j_nu==nil or "0" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
elseif j_nu=="1" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
elseif j_nu=="2" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
elseif j_nu=="3" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
end
end
end
end
concommand.Add("Metajolist_f_G",Metajolist_f_G)

function Nordah_Whitelist_Job.whitelistexist(steamid)
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid then
return false 
end
end
end
function Nordah_Whitelist_Job.AddWhitelist(tbl,override)
if Nordah_Whitelist_Job.whitelistexist(tbl[2])then return end
table.insert(ZJOBwhitelist,tbl)
if override then return end
end
function Nordah_Whitelist_Job.RemoveJobWhitelist(steamid,override,job)
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid and v[4]==job then
table.remove(ZJOBwhitelist,k)
if override then return end
RunConsoleCommand("wjs_remove_whitelist",steamid,job)
return
end
end
end

local args={}
timer.Simple(15,function()
for k,v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
table.insert(args,{Name=v.Name,Value=v.Name})
end
end)
Nordah_Whitelist_Job.RegisterCommand(f2panadwl,"wjs_addwhite","Add In WhiteList",args,true)


local function whitelist_update(a,b,c)
if c[1]==nil then print("This is not the right command, Nordahl. ^^") return end
if zwjlist==nil then zwjlist=0 end
if zwclist==nil then zwclist=0 end
if zwusers==nil then zwusers=0 end
local numline=tonumber(c[1])
local numline2=tonumber(c[2])
sysjobwi=tostring(c[3])
syscatwi=tostring(c[4])

local zloairme=CurTime()
if loadbar then loadbar:Remove() end
loadbar=vgui.Create("DFrame")
loadbar:SetPos(0,0)
loadbar:SetSize(ScrW(),ScrH())
loadbar:SetTitle("")
loadbar:SetDraggable(false)
loadbar:ShowCloseButton(false)
loadbar.Think=function()
if zwusers>=numline then
zwusers=numline
end
if zwjlist>=numline2 then
zwjlist=numline2
end
if (zwusers>=numline and zwjlist>=numline2) then
loadbar:Remove()
end
end
local scrW=ScrW()-185
local scrH=ScrH()-100
loadbar.Paint=function()
draw.RoundedBox(4,(scrW)-176,(scrH)-1,352,92,Color(0,117,223,255))
draw.RoundedBox(4,(scrW)-175,(scrH),350,90,Color(255,255,255,255))
draw.SimpleText(WhitelistJobSystem..": "..tra_init, "Trebuchet18",scrW,(scrH)+9, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
draw.SimpleText("Jobs: "..zwjlist.."/"..numline2, "Trebuchet18",scrW,(scrH)+25, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
draw.SimpleText(tra_susermax..": "..zwusers.."/"..numline, "Trebuchet18",scrW,(scrH)+40, Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
draw.RoundedBox(4,(scrW)-151,(scrH)+69-20,302,12,Color(0,117,223,255))
draw.RoundedBox(4,(scrW)-150,(scrH)+70-20,300,10,Color(0,0,50,255))
draw.RoundedBox(2,(scrW)-150,(scrH)+70-20,(300/numline2)*zwjlist,10,Color(0,117,223,255))
draw.RoundedBox(2,(scrW)-150,(scrH)+76-20,(300/numline2)*zwjlist,4,Color(0,125,194,255))
surface.SetDrawColor( 255,255,255, 255 )
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect((scrW)-170,(scrH)+67-20,16,16)
draw.RoundedBox(4,(scrW)-151,(scrH)+69,302,12,Color(0,117,223,255))
draw.RoundedBox(4,(scrW)-150,(scrH)+70,300,10,Color(0,0,50,255))
draw.RoundedBox(2,(scrW)-150,(scrH)+70,(300/numline)*zwusers,10,Color(0,117,223,255))
draw.RoundedBox(2,(scrW)-150,(scrH)+76,(300/numline)*zwusers,4,Color(0,125,194,255))
surface.SetDrawColor( 255,255,255, 255 )
surface.SetMaterial(Material("icon16/report.png"))surface.DrawTexturedRect((scrW)-170,(scrH)+67,16,16)
end
end
concommand.Add("whitelist_update",whitelist_update)

function PlychangeAllowed(ply,job)
local SteamID64=ply:SteamID64()
local Job=job
for k,v in pairs(ZJOBwhitelist)do
if v[2]==SteamID64 then
if Job==v[4] or v[4]=="Full Access" then
return true
end
end
end
if Add_Job_In_the_Whiteliste[Job]=="3" then
for _,c in ipairs(nordahl_cfg_1402.ULX_DONATOR_RANK)do if c==ply:GetUserGroup() then return true end end
end
return false
end
concommand.Add("PlychangeAllowed",PlychangeAllowed)

local function nord_context(ent)
local ent,SteamID,SteamID64,EntIndex=ent,ent:SteamID(),ent:SteamID64(),ent:EntIndex()
jco_menu = vgui.Create("DFrame")
jco_menu:SetSize(200,24)
jco_menu:SetPos(ScrW()/2+150,ScrH()/2-150)
jco_menu:SetTitle(" ")
jco_menu:SetDraggable(true)
jco_menu:ShowCloseButton(false)
jco_menu:MakePopup()
jco_menu.Paint=function()
if !IsValid(ent) then
jco_menu:Remove()
jco_menu=nil
return end
end
local jo_but=vgui.Create("DButton",jco_menu)
jo_but:SetText("")
jo_but:SetSize(200,24)
jo_but:SetPos(0,0)
jo_but.Paint=function()
draw.RoundedBox(4,0,0,jo_but:GetWide(),jo_but:GetTall(),Color(26,138,200,255))
draw.RoundedBox(4,1,1,jo_but:GetWide()-2,jo_but:GetTall()-2,Color(255,255,255,255))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("ngui/wljs.png"))surface.DrawTexturedRect(4,4,16,16)
draw.SimpleText(WhitelistJobSystem..wjl, "Trebuchet18", 28, 12, Color(26,138,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
jo_but.DoClick=function()surface.PlaySound("ambient/machines/keyboard5_clicks.wav")
if jco_menu then
jco_menu:Remove()
jco_menu=nil
end
local z4=DermaMenu()
local subMenu,optMenu=z4:AddSubMenu(tra_ajdalwdumetier)
optMenu:SetIcon("ngui/wljs.png")
for k,v in pairs( Nordah_Whitelist_Job.Commands ) do
if not v.Args then
else

local trij={}
for k,v2 in pairs(RPExtraTeams) do
local c=v2.category
local c2=v2.name
if !trij[c] then
trij[c]={}
end
if trij[c] then
for az,d in pairs( v.Args ) do
if c2==d.Value then
table.insert(trij[c],{Value=d.Value,Name=d.Name})
end
end
end
end

for m,p in pairs(trij) do
local submenu2,optMenu2 = subMenu:AddSubMenu(m)
if v.CommandName=="wjs_addwhite" then
optMenu2:SetIcon("ngui/wljs.png")subMenu:AddSpacer()
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(84,132,240,255))draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
end

for c,d in pairs(p) do
local arg = d.Value
local jnom=d.Name
if Add_Job_In_the_Whiteliste[jnom] then
if Add_Job_In_the_Whiteliste[jnom]!="2" and Add_Job_In_the_Whiteliste[jnom]!="4" then
submenu2:AddSpacer()
submenu2:AddOption(jnom,function()surface.PlaySound( Sound( "buttons/button14.wav" ) )
RunConsoleCommand("wjs_addwhite",EntIndex,arg)end):SetImage("icon16/add.png")
submenu2:AddSpacer()
end
end
submenu2.Paint=function()draw.RoundedBox(4,0,0,submenu2:GetWide(),submenu2:GetTall(),Color(84,132,240,255))draw.RoundedBox(4,1,1,submenu2:GetWide()-2,submenu2:GetTall()-2,Color(255,255,255,255))end
end
end

end
end
subMenu.Paint=function()
draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(26,138,200,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))
end

z4:AddSpacer()
local subMenu,optMenu=z4:AddSubMenu("Add in Job Category")
optMenu:SetIcon("ngui/wlgs.png")

for c,d in pairs( Add_JobGroup_In_the_Whiteliste ) do
subMenu:AddSpacer()
subMenu:AddOption(c,function()
RunConsoleCommand("wjs_addwhite2", EntIndex, c )
surface.PlaySound( Sound( "buttons/button14.wav" ) )
end):SetImage("icon16/add.png")
end
subMenu.Paint=function()
draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(26,138,200,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))
end

z4:AddSpacer()
z4:AddOption("Add in Full Access List",function()
jswl_chat(LocalPlayer(),"jswl_chat",{EntIndex,1,"Full Access"})
RunConsoleCommand("wjs_addwhite",EntIndex,"Full Access")end):SetImage("icon16/add.png")
z4:AddSpacer()
z4:AddOption(zaddsupprall,function()
jswl_chat(LocalPlayer(),"jswl_chat",{EntIndex,3,"nil"})
RunConsoleCommand("Massremovewhitelist",SteamID64)
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==SteamID64 then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
testencore()
return
end
end
end
testencore()
end):SetImage("icon16/cross.png")
z4:AddSpacer()
local subMenu,optMenu=z4:AddSubMenu("Delete from one job")
optMenu:SetIcon("icon16/cross.png")
for k,v in pairs(ZJOBwhitelist)do 
if v[2]==SteamID64 then
subMenu:AddOption(v[4],function()
table.remove(ZJOBwhitelist,k)
surface.PlaySound(Sound( "buttons/button14.wav" ))
jswl_chat(a,b,{EntIndex,2,v[4]})
RunConsoleCommand("wjs_remove_whitelist",SteamID64,v[4])
end):SetImage("icon16/cross.png")
subMenu:AddSpacer()
end
end
subMenu.Paint=function()
draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(26,138,200,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))
end
z4:AddSpacer()
surface.PlaySound(Sound( "buttons/button14.wav" ))
local subMenu,optMenu=z4:AddSubMenu("Copy SteamID")
optMenu:SetIcon("icon16/application_double.png")
subMenu:AddOption("Copy SteamID64      : "..SteamID64,function()SetClipboardText(SteamID64)LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
subMenu:AddSpacer()
subMenu:AddOption("Copy SteamID normal : "..SteamID,function()SetClipboardText(SteamID)LocalPlayer():EmitSound("ui/buttonrollover.wav",45,80)end):SetImage("icon16/application_double.png")
subMenu.Paint=function()
draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(26,138,200,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))
end
z4:AddSpacer()
z4:AddOption(WhitelistJobSystem..wjl.." (Menu Shortcut)",function()RunConsoleCommand("whitelist_systemjob")end):SetImage("ngui/wljs.png")
z4:AddSpacer()
z4.Paint=function()
draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(26,138,200,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))
end
z4:Open()
end
end

function jswl_nord_context(a,b,c)
nord_context(LocalPlayer())
end
concommand.Add("jswl_nord_context",jswl_nord_context)


local z4=nil
hook.Add( "OnContextMenuOpen","nordahl_contextmenu_whjs_1",function(a,b,c)
if eRight(LocalPlayer())==true then
local etr=LocalPlayer():GetEyeTrace()
local ent=etr.Entity
if IsValid(ent) then
if ent:IsPlayer()==true then
nord_context(ent)
end
else
print("Press 'Context Menu' when you look the player to see the action you can do with the whitelistjob system")
end
else
if  cfg.chat_msg_warn==1 then
chat.AddText(Color(45,148,255),WhitelistJobSystem..wjl.." [System] ",Color(255,255,255),"You are not Admin, please configure your administration System or add your steamid in the config file. Thank you.")
chat.AddText(Color(45,148,255),"Nordahl")
end
end
end)

hook.Add( "OnContextMenuClose","nordahl_contextmenu_whjs_0",function(a,b,c)
if jco_menu then
jco_menu:Remove()
jco_menu=nil
end
end)

local tab_c={
[1]={Color(45,148,225),"Added in"},
[2]={Color(255,0,0),"Removed from"},
[3]={Color(255,0,0),"Was removed from all jobs whitelist"},
}

function jswl_chat(a,b,c)
local ent=Entity(c[1])
local num=tonumber(c[2])
local tab=tab_c[num]
local nom=""
if IsValid(ent)then
nom=ent:Nick()
end
local cpalet=tab[1]
local txt=tab[2]
if b=="jswl_chat" then
if num!=3 then
chat.AddText(cpalet,WhitelistJobSystem..wjl.." [System] ",Color(255,242,207),nom.." ",Color(255,255,255),txt.." : ",cpalet,c[3])
else
chat.AddText(cpalet,WhitelistJobSystem..wjl.." [System] ",Color(255,242,207),nom.." ",Color(255,255,255),txt)
end
else
if num!=3 then
chat.AddText(cpalet,CategoryJobSystem..wjl.." [System] ",Color(255,242,207),nom.." ",Color(229,140,38),txt.." : ",cpalet,c[3])
else
chat.AddText(cpalet,CategoryJobSystem..wjl.." [System] ",Color(255,242,207),nom.." ",Color(229,140,38),txt)
end
end
end
concommand.Add("jswl_chat",jswl_chat)
concommand.Add("jswl_chat2",jswl_chat)

function jswl_chat3(a,b,c)
local str=c[1]
chat.AddText(Color(26,138,200),"Nordahl whitelist job  [System] : ",Color(255,255,255),str)
end
concommand.Add("jswl_chat3",jswl_chat3)

function jswl_m_chat(a,b,c)
local nom=c[1]
local num=tonumber(c[2])
local tab=tab_c[num]
local cpalet=tab[1]
local txt=tab[2]
if num!=3 then
chat.AddText(cpalet,WhitelistJobSystem..wjl.." [System] ",Color(255,242,207),nom.." ",Color(255,255,255),txt.." : ",cpalet,c[3])
else
chat.AddText(cpalet,WhitelistJobSystem..wjl.." [System] ",Color(255,242,207),nom.." ",Color(255,255,255),txt)
end
end
concommand.Add("jswl_m_chat",jswl_m_chat)